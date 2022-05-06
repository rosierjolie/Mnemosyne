//
//  AchievementsView.swift
//  Mnemosyne
//
//  Created by Jerry Turcios on 10/17/20.
//

import SwiftUI

struct AchievementsView: View {
    // MARK: - Properties

    @EnvironmentObject var achievementStore: AchievementStore

    // MARK: - Methods

    private func configureView() {
        achievementStore.loadAchievements()
    }

    // MARK: - Body

    private var columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 30) {
            ForEach(achievementStore.achievements) { achievement in
                VStack {
                    Image(achievement.imageString)
                        .resizable()
                        .frame(width: 100, height: 100)
                    Text(achievement.title)
                        .font(.footnote)
                        .fontWeight(.semibold)
                }
                .opacity(achievement.completed ? 1 : 0.2)
            }
        }
        .onAppear(perform: configureView)
        .padding(.horizontal)
    }
}

// MARK: - Previews

#if DEBUG
struct AchievementsViewPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            AchievementsView()
                .previewLayout(.sizeThatFits)
                .environmentObject(AchievementStore())
                .padding(.vertical)
            AchievementsView()
                .preferredColorScheme(.dark)
                .environment(\.sizeCategory, .accessibilityMedium)
                .environmentObject(AchievementStore())
                .previewLayout(.sizeThatFits)
                .padding(.vertical)
        }
    }
}
#endif
