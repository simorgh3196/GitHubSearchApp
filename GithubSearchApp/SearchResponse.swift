//
//  SearchResponse.swift
//  GithubSearchApp
//
//  Created by 早川智也 on 2016/06/10.
//  Copyright © 2016年 simorgh. All rights reserved.
//

import Foundation
import Himotoki


struct SearchResponse<Item: Decodable>: Decodable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [Item]
    
    init(totalCount: Int = 0, incompleteResults: Bool = false, items: [Item] = []) {
        self.totalCount = totalCount
        self.incompleteResults = incompleteResults
        self.items = items
    }
    
    static func decode(e: Extractor) throws -> SearchResponse {
        return try SearchResponse(
            totalCount        : e <| "total_count",
            incompleteResults : e <| "incomplete_results",
            items             : e <|| "items")
    }
}
