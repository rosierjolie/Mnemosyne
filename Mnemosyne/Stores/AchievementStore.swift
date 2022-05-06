//
//  AchievementStore.swift
//  Mnemosyne
//
//  Created by Jerry Turcios on 10/17/20.
//

import Foundation

class AchievementStore: ObservableObject {
    // MARK: - Properties

    @Published var appliedJobsCount = 0
    @Published var sharedAppCount = 0
    @Published var hasRecievedOffer = false

    // TODO: Implement the share functionality once the app is deployed

    @Published var achievements: [Achievement] = [
        .init(title: "Rookie", description: "Applied to first job.", imageString: "Rookie", completed: false),
        .init(title: "I plead the fifth", description: "Applied to 5 jobs.", imageString: "TheFifth", completed: false),
        .init(title: "Twenty", description: "Applied to 10 jobs.", imageString: "Twenty", completed: false),
        .init(title: "Hundred", description: "Applied to 100 jobs.", imageString: "Hundred", completed: false),
        .init(title: "Don't stop me now", description: "Applied to 200 jobs.", imageString: "DontStopMeNow", completed: false),
        .init(title: "Victory", description: "Recieved a job offer.", imageString: "Victory", completed: false),
//        .init(title: "I bring good news", description: "Shared the app 10 times.", imageString: "GoodNews", completed: false)
    ]

    // MARK: - Methods

    func incrementAppliedJobsCount() {
        appliedJobsCount += 1

        switch appliedJobsCount {
        case 1:
            achievements[0].completed = true
        case 5:
            achievements[1].completed = true
        case 20:
            achievements[2].completed = true
        case 100:
            achievements[3].completed = true
        case 200:
            achievements[4].completed = true
        default:
            break
        }

        saveAchievements()
    }

    func incrementSharedAppCount() {
        sharedAppCount += 1
        saveAchievements()
    }

    func toggleRecievedOfferAchievement() {
        achievements[5].completed = true
        saveAchievements()
    }

    // MARK: - Local storage

    func saveAchievements() {
        let achievementsMetadata: [String: Any] = [
            "appliedJobsCount": appliedJobsCount,
            "sharedAppCount": sharedAppCount,
            "hasRecievedOffer": hasRecievedOffer,
        ]

        do {
            let data = try JSONEncoder().encode(achievements)

            UserDefaults.standard.set(achievementsMetadata, forKey: Key.achievementsMetadata)
            UserDefaults.standard.set(data, forKey: Key.achievements)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func loadAchievements() {
        guard let savedAchievements = UserDefaults.standard.object(forKey: Key.achievements) as? Data else { return }
        guard let achievementsMetadata = UserDefaults.standard.object(forKey: Key.achievementsMetadata) as? [String: Any] else { return }

        guard let appliedJobsCount = achievementsMetadata["appliedJobsCount"] as? Int else { return }
        guard let sharedAppCount = achievementsMetadata["sharedAppCount"] as? Int else { return }
        guard let hasRecievedOffer = achievementsMetadata["hasRecievedOffer"] as? Bool else { return }

        do {
            achievements = try JSONDecoder().decode([Achievement].self, from: savedAchievements)

            self.appliedJobsCount = appliedJobsCount
            self.sharedAppCount = sharedAppCount
            self.hasRecievedOffer = hasRecievedOffer
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
