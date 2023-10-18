//
//  RepoWatcherWidget.swift
//  RepoWatcherWidget
//
//  Created by Joel Storr on 16.10.23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> RepoEntry {
        RepoEntry(date: Date(), repo: Repository.placeholder, avatarImageData: Data())
    }

    func getSnapshot(in context: Context, completion: @escaping (RepoEntry) -> ()) {
        let entry = RepoEntry(date: Date(), repo: Repository.placeholder, avatarImageData: Data())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        Task{
            let nextUpdate = Date().addingTimeInterval(43200) //12 hours in seconds
            
            do{
                let repo = try await NetworkManager.shared.getRepo(atUrl: RepoURL.swiftNews)
                let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                let entry = RepoEntry(date: .now, repo: repo, avatarImageData: avatarImageData ?? Data())
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            }catch{
                print("❌ Error - \(error.localizedDescription)")
            }
        }
    }
}

struct RepoEntry: TimelineEntry {
    let date: Date
    let repo: Repository
    let avatarImageData: Data
}

struct RepoWatcherWidgetEntryView : View {
    var entry: RepoEntry
    let formatter = ISO8601DateFormatter()
    var daysSinceLastActivity: Int {
        calculateDaysSinceLastActivity(from: entry.repo.pushedAt)
    }

    var body: some View {
        HStack{
            VStack(alignment:.leading){
                HStack{
                    Image(uiImage: UIImage(data: entry.avatarImageData) ?? UIImage(resource: .avatar))
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    Text(entry.repo.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                }
                .padding(.bottom, 6)
                HStack{
                    StateLabel(value: entry.repo.watchers, systemImageName: "star.fill")
                    StateLabel(value: entry.repo.forks, systemImageName: "tuningfork")
                    if entry.repo.hasIssues{
                        StateLabel(value: entry.repo.openIssues, systemImageName: "exclamationmark.triangle.fill")
                    }
                }
            }
            Spacer()
            VStack{
                Text("\(daysSinceLastActivity)")
                    .fontWeight(.bold)
                    .font(.system(size: 70))
                    .frame(width: 90)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .foregroundStyle(daysSinceLastActivity > 50 ? Color.pink : Color.green)
                
                Text("days ago")
                    .font(.caption2)
                    .foregroundStyle(Color.secondary)
            }
        }
        .padding()
    }
    
    
    func calculateDaysSinceLastActivity(from dateString: String) -> Int {
        let lastActivityData = formatter.date(from: dateString) ?? .now
        let daysSinceLastActivity = Calendar.current.dateComponents([.day], from: lastActivityData, to: .now).day ?? 0
        return daysSinceLastActivity
    }
    
}

struct RepoWatcherWidget: Widget {
    let kind: String = "RepoWatcherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                RepoWatcherWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                RepoWatcherWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Repo Watcher")
        .description("This widget show you update stats to you favorite repos.")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    RepoWatcherWidget()
} timeline: {
    RepoEntry(date: .now, repo: Repository.placeholder, avatarImageData: Data())
   
}


fileprivate struct StateLabel: View {
    
    let value : Int
    let systemImageName: String
    
    var body: some View {
        Label{
            Text("\(value)")
                .font(.footnote)
        } icon: {
            Image(systemName: systemImageName)
                .foregroundStyle(Color.green)
        }
        .fontWeight(.medium)
    }
}
