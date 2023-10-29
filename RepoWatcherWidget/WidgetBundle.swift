//
//  WidgetBundle.swift
//  RepoWatcherWidgetExtension
//
//  Created by Joel Storr on 19.10.23.
//

import SwiftUI
import WidgetKit

@main
struct RepoWatcherWidgets: WidgetBundle {
    var body: some Widget {
        SingleRepoEntryWidget()
        DoubleRepoWidget()
    }
}
