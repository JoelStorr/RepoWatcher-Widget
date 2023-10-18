//
//  MockData.swift
//  RepoWatcherWidgetExtension
//
//  Created by Joel Storr on 18.10.23.
//

import Foundation


struct MockData {
    static let repoOne = Repository(name: "Repo 1", owner: Owner(avatarUrl: ""), hasIssues: true, forks: 65, watchers: 123, openIssues: 55, pushedAt: "2023-08-09T18:19:30Z", avatarData: Data())
    static let repoTwo = Repository(name: "Repo 2", owner: Owner(avatarUrl: ""), hasIssues: false, forks: 144, watchers: 169, openIssues: 20, pushedAt: "2023-10-09T18:19:30Z", avatarData: Data())
}
