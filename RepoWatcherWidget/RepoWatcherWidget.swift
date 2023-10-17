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
        RepoEntry(date: Date(), repo: Repository.placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (RepoEntry) -> ()) {
        let entry = RepoEntry(date: Date(), repo: Repository.placeholder)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [RepoEntry] = []

        //TODO: Rewrite Timeline

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct RepoEntry: TimelineEntry {
    let date: Date
    let repo: Repository
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
                   Circle()
                        .frame(width: 50, height: 50)
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
                    StateLabel(value: entry.repo.openIssues, systemImageName: "exclamationmark.triangle.fill")
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
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    RepoWatcherWidget()
} timeline: {
    RepoEntry(date: .now, repo: Repository.placeholder)
   
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
