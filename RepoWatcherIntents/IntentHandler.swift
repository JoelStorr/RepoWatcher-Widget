//
//  IntentHandler.swift
//  RepoWatcherIntents
//
//  Created by Joel Storr on 23.10.23.
//

import Intents

class IntentHandler: INExtension {

    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        return self
    }
}

extension IntentHandler: SelectSingleRepoIntentHandling {
    func provideRepoOptionsCollection(for intent: SelectSingleRepoIntent) async throws -> INObjectCollection<NSString> {
        guard let repos = UserDefaults.shared.value(forKey: UserDefaults.repoKey) as? [String] else {
            throw UserDefaultsError.retrival
        }

        return INObjectCollection(items: repos as [NSString])
    }

    func defaultRepo(for intent: SelectSingleRepoIntent) -> String? {
        return "sallen0400/swift-news"
    }
}

extension IntentHandler: SelectTwoReposIntentHandling {

    func provideTopRepoOptionsCollection(
        for intent: SelectTwoReposIntent
    ) async throws -> INObjectCollection<NSString> {
        guard let repos = UserDefaults.shared.value(forKey: UserDefaults.repoKey) as? [String] else {
            throw UserDefaultsError.retrival
        }
        return INObjectCollection(items: repos as [NSString])
    }

    func provideBottomRepoOptionsCollection(
        for intent: SelectTwoReposIntent
    ) async throws -> INObjectCollection<NSString> {
        guard let repos = UserDefaults.shared.value(forKey: UserDefaults.repoKey) as? [String] else {
            throw UserDefaultsError.retrival
        }
        return INObjectCollection(items: repos as [NSString])
    }

    func defaultTopRepo(for intent: SelectTwoReposIntent) -> String? {
        return "sallen0400/swift-news"
    }

    func defaultBottomRepo(for intent: SelectTwoReposIntent) -> String? {
        return "sallen0400/swift-news"
    }
}
