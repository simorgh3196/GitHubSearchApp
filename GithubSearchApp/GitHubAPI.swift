//
//  GitHubAPI.swift
//  GithubSearchApp
//
//  Created by 早川智也 on 2016/06/09.
//  Copyright © 2016年 simorgh. All rights reserved.
//

import Foundation
import APIKit
import Himotoki


// MARK: - GitHubAPI -

final class GitHubAPI {
    
    // MARK: SearchSortType
    
    enum SearchSortType: Int {
        case match
        case stars
        case forks
        case updated
        
        private var param: String {
            switch self {
            case match   : return ""
            case stars   : return "stars"
            case forks   : return "forks"
            case updated : return "updated"
            }
        }
    }
    
    
    // MARK: OrderType
    
    enum OrderType: Int {
        case desc
        case asc
        
        private var param: String {
            switch self {
            case desc : return "desc"
            case asc  : return "asc"
            }
        }
    }
    
    
    // MARK: SearchRepositoriesRequest
    
    struct SearchRepositoriesRequest: GitHubRequestType {
        typealias Response = SearchResponse<Repository>
        
        let query: String
        let sort: SearchSortType
        let order: OrderType
        
        var method: HTTPMethod {
            return .GET
        }
        
        var path: String {
            return "/search/repositories"
        }
        
        var parameters: AnyObject? {
            switch sort {
            case .match:
                return ["q": query, "order": order.param]
            default:
                return ["q": query, "order": order.param, "sort": sort.param]
            }
        }
        
        
        init(query: String, sort: SearchSortType? = nil, order: OrderType? = nil) {
            self.query = query
            self.sort = sort ?? .match
            self.order = order ?? .desc
        }
    }

}
