//
//  SingleRepoWidget.swift
//  RepoWatcherWidgetExtension
//
//  Created by Joel Storr on 19.10.23.
//

import SwiftUI
import WidgetKit


struct SingleRepoProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> SingleRepoEntry {
        SingleRepoEntry(date: .now, repo: MockData.repoOne)
    }
    
    
    func getSnapshot(in context: Context, completion: @escaping (SingleRepoEntry) -> Void) {
        let entry = SingleRepoEntry(date: .now, repo: MockData.repoOne)
        completion(entry)
    }
    
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SingleRepoEntry>) -> Void) {
        
        Task{
            do{
                let nextUpdate = Date().addingTimeInterval(43200) //12 hours in seconds
                let repoToShow = RepoURL.swiftNews
                
                // Get the Repo
                var repo = try await NetworkManager.shared.getRepo(atUrl: repoToShow)
                let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                repo.avatarData = avatarImageData ?? Data()
                
                
                if context.family == .systemLarge{
                    // Get Contributors
                    let contributors = try await NetworkManager.shared.getContributors(
                        atUrl: repoToShow + "/contributors"
                    )
                    
                    // Filter to top 4
                    var topFour = Array(contributors.prefix(4))
                    
                    //Download top 4 avatars
                    for i in topFour.indices{
                        let avatarData = await NetworkManager.shared.downloadImageData(from: topFour[i].avatarUrl)
                        topFour[i].avatarData = avatarData ?? Data()
                    }
                    repo.contributors = topFour

                }
                
                let entry = SingleRepoEntry(date: .now, repo: repo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            }catch{
                print("❌ Error - \(error.localizedDescription)")
            }
        }
    }
}


struct SingleRepoEntry: TimelineEntry{
    var date: Date
    let repo: Repository
}


struct SingleRepoEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: SingleRepoEntry
   
    var body: some View {
        
        switch family{
        case .systemMedium:
            RepoMediumView(repo: entry.repo)
        case .systemLarge:
            VStack{
                RepoMediumView(repo: entry.repo)
                ContributorMediumView(repo: entry.repo)
            }
        
        case .accessoryInline, .systemSmall, .systemExtraLarge, .accessoryCircular, .accessoryRectangular:
            EmptyView()
        @unknown default:
            EmptyView()
        }
        
        
    }
}


struct SingleRepoEntryWidget: Widget {
    let kind: String = "SingleRepoEntryWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SingleRepoProvider()) { entry in
            if #available(iOS 17.0, *) {
                SingleRepoEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                SingleRepoEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Single Repo")
        .description("Track a single Repository")
        .supportedFamilies([ .systemMedium, .systemLarge])
    }
}


#Preview(as: .systemMedium) {
    SingleRepoEntryWidget()
} timeline: {
    SingleRepoEntry(date: .now, repo: MockData.repoOne)
}
