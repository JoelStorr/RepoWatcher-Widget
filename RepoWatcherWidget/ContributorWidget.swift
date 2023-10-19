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
        ContributorEntry(date: .now)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ContributorEntry) -> Void) {
        let entry = ContributorEntry(date: .now)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ContributorEntry>) -> Void) {
        let nextUpdate = Date().addingTimeInterval(43200) //12 hours in seconds
        let entry = ContributorEntry(date: .now)
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}


struct ContributorEntry: TimelineEntry{
    var date: Date
}




struct ContributorEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: ContributorEntry
   
 

    var body: some View {
        Text(entry.date.formatted())
       
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
    ContributorEntry(date: .now)
   
}
