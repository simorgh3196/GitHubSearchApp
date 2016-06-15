//
//  Owner.swift
//  GithubSearchApp
//
//  Created by 早川智也 on 2016/06/10.
//  Copyright © 2016年 simorgh. All rights reserved.
//

import Foundation
import Himotoki


// MARK: - Owner - 

struct Owner: Decodable {
    let login: String
    let id: Int
    let avatarUrl: String
    let gravatarId: String
    let url: String
    let receivedEventsUrl: String
    let type: String
    
    
    static func decode(e: Extractor) throws -> Owner {
        return try Owner(
            login             : e <| "login",
            id                : e <| "id",
            avatarUrl         : e <| "avatar_url",
            gravatarId        : e <| "gravatar_id",
            url               : e <| "url",
            receivedEventsUrl : e <| "received_events_url",
            type              : e <| "type")
    }
}
