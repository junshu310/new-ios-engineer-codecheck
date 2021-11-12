//
//  StructModel.swift
//  iOSEngineerCodeCheck
//
//  Created by 佐藤駿樹 on 2021/11/12.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

struct RepositoryData {
    static let items = "items"
    
    struct Items {
        
        static let fullName = "full_name"
        static let lang = "language"
        static let stars = "stargazers_count"
        static let watchers = "wachers_count"
        static let forks = "forks_count"
        static let issues = "open_issues_count"
        
        static let owner = "owner"
        
        struct Owner {
            static let avatarUrl = "avatar_url"
        }
    }
}
