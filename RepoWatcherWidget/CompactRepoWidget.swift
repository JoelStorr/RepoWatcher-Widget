//
//  RepoWatcherWidget.swift
//  RepoWatcherWidget
//
//  Created by Joel Storr on 16.10.23.
//

import WidgetKit
import SwiftUI

struct ComapctRepoProvider: TimelineProvider {
    func placeholder(in context: Context) -> CompactRepoEntry {
        CompactRepoEntry(date: Date(), repo: MockData.repoOne, bottomRepo: MockData.repoTwo)
    }

    func getSnapshot(in context: Context, completion: @escaping (CompactRepoEntry) -> ()) {
        let entry = CompactRepoEntry(date: Date(), repo: MockData.repoOne, bottomRepo: MockData.repoTwo)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        Task{
            let nextUpdate = Date().addingTimeInterval(43200) //12 hours in seconds
            
            do{
                //Get Top Repo
                var repo = try await NetworkManager.shared.getRepo(atUrl: RepoURL.swiftNews)
                let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                repo.avatarData = avatarImageData ?? Data()
                
                //Get Bottom repo if in large widget
                var bottomRepo: Repository?
                if context.family == .systemLarge{
                    //Get Bottom Repo
                    bottomRepo = try await NetworkManager.shared.getRepo(atUrl: RepoURL.google)
                    let avatarImageData = await NetworkManager.shared.downloadImageData(from: bottomRepo!.owner.avatarUrl)
                    bottomRepo!.avatarData = avatarImageData ?? Data()
                }
                
                //Create Entry & Timeline
                let entry = CompactRepoEntry(date: .now, repo: repo, bottomRepo: bottomRepo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            }catch{
                print("❌ Error - \(error.localizedDescription)")
            }
        }
    }
}

struct CompactRepoEntry: TimelineEntry {
    let date: Date
    let repo: Repository
    let bottomRepo: Repository?
}

struct CompactRepoEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: CompactRepoEntry
   
    var body: some View {
            
        switch family{
        case.systemMedium:
            RepoMediumView(repo: entry.repo)
            
        case .systemLarge:
            VStack(spacing: 36){
                RepoMediumView(repo: entry.repo)
                if let bottomRepo = entry.bottomRepo{
                    RepoMediumView(repo: bottomRepo)
                }
            }

        case .systemExtraLarge, .systemSmall, .accessoryCircular, .accessoryRectangular, .accessoryInline:
            EmptyView()
        @unknown default:
            EmptyView()
        }
    }
}

struct CompactRepoWidget: Widget {
    let kind: String = "CompactRepoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ComapctRepoProvider()) { entry in
            if #available(iOS 17.0, *) {
                CompactRepoEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                CompactRepoEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Repo Watcher")
        .description("This widget show you update stats to you favorite repos.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}


#Preview(as: .systemMedium) {
    CompactRepoWidget()
} timeline: {
    CompactRepoEntry(date: .now, repo: MockData.repoOne, bottomRepo: MockData.repoTwo)
   
}



