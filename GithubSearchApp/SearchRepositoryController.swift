//
//  SearchRepositoryController.swift
//  GithubSearchApp
//
//  Created by 早川智也 on 2016/06/09.
//  Copyright © 2016年 simorgh. All rights reserved.
//

import UIKit
import APIKit


// MARK: - SearchRepositoryController -

final class SearchRepositoryController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortSegmentControl: UISegmentedControl!
    @IBOutlet weak var orderSegmentControl: UISegmentedControl!
    @IBOutlet weak var noResultView: UIView!
    
    private var searchRepos: SearchResponse<Repository>!
    private var textField: NavigationSearchTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareItems()
        
        prepareNavigationTextField()
        prepareSegmentControls()
        prepareTableView()
    }
        
    private func prepareItems() {
        searchRepos = SearchResponse<Repository>()
    }
    
    private func prepareNavigationTextField() {
        
        guard let naviBar = navigationController?.navigationBar else { return }
        let frame = CGRect(x: 10, y: 7, width: naviBar.frame.width - 20, height: 30)
        textField = NavigationSearchTextField(frame: frame)
        
        NSNotificationCenter
            .defaultCenter()
            .addObserver(self,
                         selector: #selector(textFieldTextDidChange(_:)),
                         name: UITextFieldTextDidChangeNotification,
                         object: textField)
        naviBar.addSubview(textField)
    }
    
    private func prepareSegmentControls() {
        
        sortSegmentControl.addTarget(self,
                                     action: #selector(didChangeSegmentedControl(_:)),
                                     forControlEvents: .ValueChanged)
        orderSegmentControl.addTarget(self,
                                      action: #selector(didChangeSegmentedControl(_:)),
                                      forControlEvents: .ValueChanged)
    }
    
    private func prepareTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        tableView.registerNib(UINib(nibName: "RepoCell", bundle: nil), forCellReuseIdentifier: "RepoCell")
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private dynamic func didChangeSegmentedControl(sender: UISegmentedControl) {
        sendSearchRequest()
    }
    
    private func sendSearchRequest() {
        
        guard let text = textField.text where !text.isEmpty else { return }
        let sort = GitHubAPI.SearchSortType(rawValue: self.sortSegmentControl.selectedSegmentIndex)
        let order = GitHubAPI.OrderType(rawValue: self.orderSegmentControl.selectedSegmentIndex)
        let request = GitHubAPI.SearchRepositoriesRequest(query: text, sort: sort, order: order)
        
        print(request)
        Session.sendRequest(request) { [weak self]  result in
            switch result {
            case .Success(let repositories):
                self?.searchRepos = repositories
                self?.tableView.reloadData()
                
            case .Failure(let error):
                let errorMessage: String
                switch error {
                case .ResponseError(let error as GitHubError):
                    errorMessage = error.message
                    
                default:
                    errorMessage = "Unknown error occurred"
                }
                
                let alert = UIAlertController(title: "Error",
                                              message: errorMessage,
                                              preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self?.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    private dynamic func textFieldTextDidChange(sender: NSNotification) {
        
        guard let textField = sender.object as? UITextField
            , let text = textField.text
            where textField == textField else { return }
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { [weak self] in
            if text == self?.textField.text {
                self?.sendSearchRequest()
            }
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

}


// MARK: - :UITableViewDataSource -

extension SearchRepositoryController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noResultView.hidden = !searchRepos.items.isEmpty
        return searchRepos.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RepoCell") as! RepoCell
        cell.updateCell(searchRepos.items[indexPath.row])

        return cell
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if searchRepos.items.isEmpty {
            return nil
        }
        
        let view = SearchRepositoryFooterView()
        view.label.text = "\(searchRepos.totalCount) Repositories"
        
        return SearchRepositoryFooterView()
    }
    
}


// MARK: - :UITableViewDelegate -

extension SearchRepositoryController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        view.endEditing(true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if searchRepos.items.isEmpty {
            return 0
        }
        return 50
    }
}


// MARK: - :UIScrollViewDelegate -

extension SearchRepositoryController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
