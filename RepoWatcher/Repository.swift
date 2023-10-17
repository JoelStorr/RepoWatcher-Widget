//
//  File.swift
//  RepoWatcher
//
//  Created by Joel Storr on 17.10.23.
//

import Foundation


struct Repository: Decodable{
    let name: String
    let owner: Owner
    let hasIssues: Bool
    let forks: Int
    let watchers: Int
    let openIssues: Int
    let pushedAt: String
    
}


struct Owner: Decodable {
    let avatarUrl: String
}
