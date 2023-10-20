//
//  ContributorWidget.swift
//  RepoWatcherWidgetExtension
//
//  Created by Joel Storr on 19.10.23.
//

import SwiftUI
import WidgetKit


struct ContributorProvider: TimelineProvider {
    func placeholder(in context: Context) -> ContributorEntry {
        ContributorEntry(date: .now, repo: MockData.repoOne)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ContributorEntry) -> Void) {
        let entry = ContributorEntry(date: .now, repo: MockData.repoOne)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ContributorEntry>) -> Void) {
        
        Task{
            
            do{
                let nextUpdate = Date().addingTimeInterval(43200) //12 hours in seconds
                let repoToShow = RepoURL.swiftNews
                
                // Get the Repo
                var repo = try await NetworkManager.shared.getRepo(atUrl: repoToShow)
                let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                repo.avatarData = avatarImageData ?? Data()
                
                // Get Contributors
                let contributors = try await NetworkManager.shared.getContributors(atUrl: repoToShow + "/contributors")
                
                
                // Filter to top 4
                var topFour = Array(contributors.prefix(4))
                
                //Download top 4 avatars
                for i in topFour.indices{
                    let avatarData = await NetworkManager.shared.downloadImageData(from: topFour[i].avatarUrl)
                    topFour[i].avatarData = avatarData ?? Data()
                }
                
                
                repo.contributors = topFour
                
                let entry = ContributorEntry(date: .now, repo: repo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            }catch{
                print("❌ Error - \(error.localizedDescription)")
            }
            
        }
        
    }
}


struct ContributorEntry: TimelineEntry{
    var date: Date
    let repo: Repository
}




struct ContributorEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: ContributorEntry
   
    var body: some View {
        VStack{
            RepoMediumView(repo: entry.repo)
            ContributorMediumView(repo: entry.repo)
        }
    }
}


struct ContributorEntryWidget: Widget {
    let kind: String = "ContributorEntryWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ContributorProvider()) { entry in
            if #available(iOS 17.0, *) {
                ContributorEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                ContributorEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Repo Watcher")
        .description("This widget show you update stats to you favorite repos.")
        .supportedFamilies([ .systemLarge])
    }
}

#Preview(as: .systemMedium) {
    ContributorEntryWidget()
} timeline: {
    ContributorEntry(date: .now, repo: MockData.repoOne)
}
