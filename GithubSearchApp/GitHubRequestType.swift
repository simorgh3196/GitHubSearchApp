//
//  GitHubRequestType.swift
//  GithubSearchApp
//
//  Created by 早川智也 on 2016/06/09.
//  Copyright © 2016年 simorgh. All rights reserved.
//

import Foundation
import APIKit
import Himotoki


// MARK: - GitHubRequestType -

protocol GitHubRequestType: RequestType {
}

extension GitHubRequestType {
    var baseURL: NSURL {
        return NSURL(string: "https://api.github.com")!
    }
}

extension GitHubRequestType where Response: Decodable {
    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) throws -> Response {
        return try decodeValue(object)
    }
}

extension GitHubRequestType {
    func interceptObject(object: AnyObject, URLResponse: NSHTTPURLResponse) throws -> AnyObject {
        switch URLResponse.statusCode {
        case 200 ..< 300    : return object
        case 400, 403, 422  : throw GitHubError(object: object)
        default             : throw ResponseError.UnacceptableStatusCode(URLResponse.statusCode)
        }
    }
}


// MARK: - GitHubError -

struct GitHubError: ErrorType {
    let message: String
    
    init(object: AnyObject) {
        message = object["message"] as? String ?? "Unknown error occurred"
    }
}
