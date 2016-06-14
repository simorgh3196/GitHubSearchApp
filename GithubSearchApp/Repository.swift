//
//  Repository.swift
//  GithubSearchApp
//
//  Created by 早川智也 on 2016/06/10.
//  Copyright © 2016年 simorgh. All rights reserved.
//

import Foundation
import Himotoki


struct Repository: Decodable {
    let id: Int
    let name: String
    let fullName: String
    let owner: Owner
    let privateRepo: Bool
    let htmlUrl: String
    let descriptionRepo: String?
    let fork: Bool
    let url: String
    let createdAt: String
    let updatedAt: String
    let pushedAt: String?
    let homepage: String?
    let size: Int
    let stargazersCount: Int
    let watchersCount: Int
    let language: String?
    let forksCount: Int
    let openIssuesCount: Int
    let masterBranch: String?
    let defaultBranch: String?
    let score: Double
    
    
    static func decode(e: Extractor) throws -> Repository {
        
        let DateTransformer = Transformer<String, String?> { dateString throws -> String? in
            if let formatedDate = DateFormatter.instance
                .stringToString("yyyy-MM-dd'T'HH:mm:ssZZZZZ", "yyyy/MM/dd", string: dateString) {
                return formatedDate
            }
            return nil
        }
        
        return try Repository(
            id              : e <| "id",
            name            : e <| "name",
            fullName        : e <| "full_name",
            owner           : e <| "owner",
            privateRepo     : e <| "private",
            htmlUrl         : e <| "html_url",
            descriptionRepo : e <|? "description",
            fork            : e <| "fork",
            url             : e <| "url",
            createdAt       : try DateTransformer.apply(e <| "created_at")!,
            updatedAt       : try DateTransformer.apply(e <| "updated_at")!,
            pushedAt        : try DateTransformer.apply(e <| "pushed_at"),
            homepage        : e <|? "homepage",
            size            : e <| "size",
            stargazersCount : e <| "stargazers_count",
            watchersCount   : e <| "watchers_count",
            language        : e <|? "language",
            forksCount      : e <| "forks_count",
            openIssuesCount : e <| "open_issues_count",
            masterBranch    : e <|? "master_branch",
            defaultBranch   : e <|? "default_branch",
            score           : e <| "score")
    }
    
}
