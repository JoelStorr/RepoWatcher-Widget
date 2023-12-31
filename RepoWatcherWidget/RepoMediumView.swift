//
//  RepoMediumView.swift
//  RepoWatcher
//
//  Created by Joel Storr on 18.10.23.
//

import SwiftUI
import WidgetKit

struct RepoMediumView: View {

    let repo: Repository

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(uiImage: UIImage(data: repo.avatarData) ?? UIImage(resource: .avatar))
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    Text(repo.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                }
                .padding(.bottom, 6)
                HStack {
                    StateLabel(value: repo.watchers, systemImageName: "star.fill")
                    StateLabel(value: repo.forks, systemImageName: "tuningfork")
                    if repo.hasIssues {
                        StateLabel(value: repo.openIssues, systemImageName: "exclamationmark.triangle.fill")
                    }
                }
            }
            Spacer()
            VStack {
                Text("\(repo.daysSinceLastActivity)")
                    .fontWeight(.bold)
                    .font(.system(size: 70))
                    .frame(width: 90)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .foregroundStyle(repo.daysSinceLastActivity > 50 ? Color.pink : Color.green)

                Text("days ago")
                    .font(.caption2)
                    .foregroundStyle(Color.secondary)
            }
        }
        .padding()
    }
}

struct RepoMediumView_Previews: PreviewProvider {
    static var previews: some View {
        RepoMediumView(repo: MockData.repoOne)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

// swiftlint:disable:next private_over_fileprivate
fileprivate struct StateLabel: View {

    let value: Int
    let systemImageName: String

    var body: some View {
        Label {
            Text("\(value)")
                .font(.footnote)
        } icon: {
            Image(systemName: systemImageName)
                .foregroundStyle(Color.green)
        }
        .fontWeight(.medium)
    }
}
