//
//  UserDefaults+Ext.swift
//  RepoWatcher
//
//  Created by Joel Storr on 22.10.23.
//

import Foundation


extension UserDefaults{
    static var shared: UserDefaults{
        UserDefaults(suiteName: "group.com.joelstorr.RepoWatcher")!
    }
    
    static let repoKey = "repos"
}


enum UserDefaultsError: Error {
    case retrival
}
