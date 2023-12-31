//
//  SingleRepoWidget.swift
//  RepoWatcherWidgetExtension
//
//  Created by Joel Storr on 19.10.23.
//

import SwiftUI
import WidgetKit

struct SingleRepoProvider: IntentTimelineProvider {

    func placeholder(in context: Context) -> SingleRepoEntry {
        SingleRepoEntry(date: .now, repo: MockData.repoOne)
    }

    func getSnapshot(
        for configuration: SelectSingleRepoIntent,
        in context: Context,
        completion: @escaping (SingleRepoEntry) -> Void
    ) {
        let entry = SingleRepoEntry(date: .now, repo: MockData.repoOne)
        completion(entry)
    }

    func getTimeline(
        for configuration: SelectSingleRepoIntent,
        in context: Context,
        completion: @escaping (Timeline<SingleRepoEntry>) -> Void
    ) {
        Task {
            do {
                let nextUpdate = Date().addingTimeInterval(43200) // 12 hours in seconds
                let repoToShow = RepoURL.prefix + configuration.repo!

                // Get the Repo
                var repo = try await NetworkManager.shared.getRepo(atUrl: repoToShow)
                let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                repo.avatarData = avatarImageData ?? Data()

                if context.family == .systemLarge {
                    // Get Contributors
                    let contributors = try await NetworkManager.shared.getContributors(
                        atUrl: repoToShow + "/contributors"
                    )

                    // Filter to top 4
                    var topFour = Array(contributors.prefix(4))

                    // Download top 4 avatars
                    for index in topFour.indices {
                        let avatarData = await NetworkManager.shared.downloadImageData(
                            from: topFour[index].avatarUrl
                        )
                        topFour[index].avatarData = avatarData ?? Data()
                    }
                    repo.contributors = topFour
                }

                let entry = SingleRepoEntry(date: .now, repo: repo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                print("❌ Error - \(error.localizedDescription)")
            }
        }
    }
}

struct SingleRepoEntry: TimelineEntry {
    var date: Date
    let repo: Repository
}

struct SingleRepoEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: SingleRepoEntry

    var body: some View {

        switch family {
        case .systemMedium:
            RepoMediumView(repo: entry.repo)
        case .systemLarge:
            VStack {
                RepoMediumView(repo: entry.repo)
                ContributorMediumView(repo: entry.repo)
            }
        case .accessoryInline:
            Text("\(entry.repo.name) - \(entry.repo.daysSinceLastActivity)")
        case .accessoryCircular:
            VStack {
                Text("\(entry.repo.daysSinceLastActivity)")
                    .font(.headline)
                Text("days")
                    .font(.caption)
            }
        case .accessoryRectangular:
            Text("Rectengular")
        case .systemSmall, .systemExtraLarge:
            EmptyView()
        @unknown default:
            EmptyView()
        }
    }
}

struct SingleRepoEntryWidget: Widget {
    let kind: String = "SingleRepoEntryWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: SelectSingleRepoIntent.self,
            provider: SingleRepoProvider()
        ) { entry in
            SingleRepoEntryView(entry: entry)
        }
        .configurationDisplayName("Single Repo")
        .description("Track a single Repository")
        .supportedFamilies([
            .systemMedium,
            .systemLarge,
            .accessoryInline,
            .accessoryCircular,
            .accessoryRectangular
        ])
    }
}

#Preview(as: .systemMedium) {
    SingleRepoEntryWidget()
} timeline: {
    SingleRepoEntry(date: .now, repo: MockData.repoOne)
}
