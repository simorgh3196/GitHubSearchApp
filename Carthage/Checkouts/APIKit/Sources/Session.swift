import Foundation
import Result

private var taskRequestKey = 0

/// `Session` manages tasks for HTTP/HTTPS requests.
public class Session {
    /// The adapter that connects `Session` instance and lower level backend.
    public let adapter: SessionAdapterType

    /// The default callback queue for `sendRequest(_:handler:)`.
    public let callbackQueue: CallbackQueue

    /// Returns `Session` instance that is initialized with `adapter`.
    /// - parameter adapter: The adapter that connects lower level backend with Session interface.
    /// - parameter callbackQueue: The default callback queue for `sendRequest(_:handler:)`.
    public init(adapter: SessionAdapterType, callbackQueue: CallbackQueue = .Main) {
        self.adapter = adapter
        self.callbackQueue = callbackQueue
    }

    // Shared session for class methods
    private static let privateSharedSession: Session = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let adapter = NSURLSessionAdapter(configuration: configuration)
        return Session(adapter: adapter)
    }()

    /// The shared `Session` instance for class methods, `Session.sendRequest(_:handler:)` and `Session.cancelRequest(_:passingTest:)`.
    public class var sharedSession: Session {
        return privateSharedSession
    }

    /// Calls `sendRequest(_:handler:)` of `sharedSession`.
    /// - parameter request: The request to be sent.
    /// - parameter callbackQueue: The queue where the handler runs. If this parameters is `nil`, default `callbackQueue` of `Session` will be used.
    /// - parameter handler: The closure that receives result of the request.
    /// - returns: The new session task.
    public class func sendRequest<Request: RequestType>(request: Request, callbackQueue: CallbackQueue? = nil, handler: (Result<Request.Response, SessionTaskError>) -> Void = {r in}) -> SessionTaskType? {
        return sharedSession.sendRequest(request, callbackQueue: callbackQueue, handler: handler)
    }

    /// Calls `cancelRequest(_:passingTest:)` of `sharedSession`.
    public class func cancelRequest<Request: RequestType>(requestType: Request.Type, passingTest test: Request -> Bool = { r in true }) {
        sharedSession.cancelRequest(requestType, passingTest: test)
    }

    /// Sends a request and receives the result as the argument of `handler` closure. This method takes
    /// a type parameter `Request` that conforms to `RequestType` protocol. The result of passed request is
    /// expressed as `Result<Request.Response, SessionTaskError>`. Since the response type
    /// `Request.Response` is inferred from `Request` type parameter, the it changes depending on the request type.
    /// - parameter request: The request to be sent.
    /// - parameter callbackQueue: The queue where the handler runs. If this parameters is `nil`, default `callbackQueue` of `Session` will be used.
    /// - parameter handler: The closure that receives result of the request.
    /// - returns: The new session task.
    public func sendRequest<Request: RequestType>(request: Request, callbackQueue: CallbackQueue? = nil, handler: (Result<Request.Response, SessionTaskError>) -> Void = {r in}) -> SessionTaskType? {
        let callbackQueue = callbackQueue ?? self.callbackQueue

        let URLRequest: NSURLRequest
        do {
            URLRequest = try request.buildURLRequest()
        } catch {
            callbackQueue.execute {
                handler(.Failure(.RequestError(error)))
            }
            return nil
        }

        let task = adapter.createTaskWithURLRequest(URLRequest) { data, URLResponse, error in
            let result: Result<Request.Response, SessionTaskError>

            switch (data, URLResponse, error) {
            case (_, _, let error?):
                result = .Failure(.ConnectionError(error))

            case (let data?, let URLResponse as NSHTTPURLResponse, _):
                do {
                    result = .Success(try request.parseData(data, URLResponse: URLResponse))
                } catch {
                    result = .Failure(.ResponseError(error))
                }

            default:
                result = .Failure(.ResponseError(ResponseError.NonHTTPURLResponse(URLResponse)))
            }

            callbackQueue.execute {
                handler(result)
            }
        }

        setRequest(request, forTask: task)
        task.resume()

        return task
    }

    /// Cancels requests that passes the test.
    /// - parameter requestType: The request type to cancel.
    /// - parameter test: The test closure that determines if a request should be cancelled or not.
    public func cancelRequest<Request: RequestType>(requestType: Request.Type, passingTest test: Request -> Bool = { r in true }) {
        adapter.getTasksWithHandler { [weak self] tasks in
            return tasks
                .filter { task in
                    if let request = self?.requestForTask(task) as Request? {
                        return test(request)
                    } else {
                        return false
                    }
                }
                .forEach { $0.cancel() }
        }
    }

    private func setRequest<Request: RequestType>(request: Request, forTask task: SessionTaskType) {
        objc_setAssociatedObject(task, &taskRequestKey, Box(request), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    private func requestForTask<Request: RequestType>(task: SessionTaskType) -> Request? {
        return (objc_getAssociatedObject(task, &taskRequestKey) as? Box<Request>)?.value
    }
}
