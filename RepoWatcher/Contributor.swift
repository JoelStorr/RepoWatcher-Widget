//
//  Contributor.swift
//  RepoWatcher
//
//  Created by Joel Storr on 19.10.23.
//

import Foundation

struct Contributor: Identifiable {
    let id = UUID()
    let login: String
    let avatarUrl: String
    let contributions: Int
    let avatarData: Data
}


extension Contributor {
    struct CodingData: Decodable{
        let login: String
        let avatarUrl: String
        let contributions: Int
        
        var contributor: Contributor{
           Contributor(login: login, avatarUrl: avatarUrl, contributions: contributions, avatarData: Data())
        }
    }
    
}
