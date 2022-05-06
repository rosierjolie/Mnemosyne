//
//  AchievementModalView.swift
//  Mnemosyne
//
//  Created by Jerry Turcios on 10/18/20.
//

import SwiftUI

// TODO: Implement this modal

struct AchievementModalView: View {
    var achievement: Achievement
    var closeModal: () -> Void

    var body: some View {
        VStack {
            Image(achievement.imageString)
                .resizable()
                .frame(width: 100, height: 100)
            Text(achievement.title)
                .font(.footnote)
                .fontWeight(.semibold)
                .padding(.bottom, 2)
            Text(achievement.description)
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.bottom)
            Button("Close", action: {})
                .padding(.bottom, 8)
        }
        .padding([.horizontal, .top], 40)
        .padding(.bottom, 8)
        .background(Color(.systemGray6))
        .cornerRadius(20)
        .padding()
    }
}

#if DEBUG
struct AchievementModalViewPreviews: PreviewProvider {
    static var previews: some View {
        AchievementModalView(
            achievement: Achievement(
                title: "Rookie",
                description: "Applied to first job.",
                imageString: "Rookie",
                completed: false
            ),
            closeModal: {}
        )
    }
}
#endif
