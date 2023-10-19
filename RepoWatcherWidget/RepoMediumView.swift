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
    let formatter = ISO8601DateFormatter()
    var daysSinceLastActivity: Int {
        calculateDaysSinceLastActivity(from: repo.pushedAt)
    }

    var body: some View {
        HStack{
            VStack(alignment:.leading){
                HStack{
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
                HStack{
                    StateLabel(value: repo.watchers, systemImageName: "star.fill")
                    StateLabel(value: repo.forks, systemImageName: "tuningfork")
                    if repo.hasIssues{
                        StateLabel(value: repo.openIssues, systemImageName: "exclamationmark.triangle.fill")
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

struct RepoMediumView_Previews: PreviewProvider {
    static var previews: some View{
        RepoMediumView(repo: MockData.repoOne)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
           
            
    }
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
