//
//  ContributorMediumView.swift
//  RepoWatcherWidgetExtension
//
//  Created by Joel Storr on 19.10.23.
//

import SwiftUI
import WidgetKit

struct ContributorMediumView: View {

    let repo: Repository
    var body: some View {
        VStack {
            HStack {
                Text("Top Contributors")
                    .font(.caption).bold()
                    .foregroundStyle(Color.secondary)

                Spacer()
            }
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible()), count: 2),
                    alignment: .leading,
                    spacing: 20
                ) {
                    ForEach(repo.contributors) { contributor in
                        HStack {
                            Image(uiImage: UIImage(data: contributor.avatarData) ?? UIImage(resource: .avatar))
                                .resizable()
                                .frame(width: 44, height: 44)
                                .clipShape(Circle())

                            VStack(alignment: .leading) {
                                Text("\(contributor.login)")
                                    .font(.caption)
                                    .minimumScaleFactor(0.7)
                                Text("\(contributor.contributions)")
                                    .font(.caption2)
                                    .foregroundStyle(Color.secondary)
                            }
                        }
                    }
                }
            if repo.contributors.count < 3 {
                Spacer()
            }
        }
        .padding()
    }
}

#Preview {
    ContributorMediumView(repo: MockData.repoOne)
        .previewContext(WidgetPreviewContext(family: .systemMedium))
}
