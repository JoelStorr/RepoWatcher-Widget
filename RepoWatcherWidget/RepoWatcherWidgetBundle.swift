//
//  RepoWatcherWidgetBundle.swift
//  RepoWatcherWidget
//
//  Created by Joel Storr on 16.10.23.
//

import WidgetKit
import SwiftUI


struct RepoWatcherWidgetBundle: WidgetBundle {
    var body: some Widget {
        DoubleRepoWidget()
        SingleRepoEntryWidget()
    }
}
