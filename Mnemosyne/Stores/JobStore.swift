//
//  JobStore.swift
//  Mnemosyne
//
//  Created by Jerry Turcios on 9/7/20.
//

import SwiftUI

enum Sort: String {
    case title = "Title name"
    case company = "Company name"
    case recentlyApplied = "Recently applied"
}

class JobStore: ObservableObject {
    // MARK: - Properties

    @Published var jobs = [Job]()
    @Published var sorting = Sort.title

    // MARK: - Methods

    func createJob(with job: Job) {
        jobs.insert(job, at: 0)
        sortJobs(by: sorting)
        saveJobs()
    }

    func deleteJob(for id: UUID) {
        for (index, job) in jobs.enumerated() {
            if id == job.id {
                jobs.remove(at: index)
                saveJobs()
            }
        }
    }

    func deleteJobs() {
        jobs = []
        saveJobs()
    }

    func editJob(with updatedJob: Job) {
        for (index, job) in jobs.enumerated() {
            if updatedJob.id == job.id {
                jobs[index] = updatedJob
                sortJobs(by: sorting)
                saveJobs()
            }
        }
    }

    func editJobNotes(with notes: String, for id: UUID) {
        for (index, job) in jobs.enumerated() {
            if id == job.id {
                jobs[index].notes = notes
                saveJobs()
            }
        }
    }

    func toggleFavorite(for id: UUID) {
        for (index, job) in jobs.enumerated() {
            if id == job.id {
                jobs[index].favorite.toggle()
                saveJobs()
            }
        }
    }

    func getNumberOfJobs(for status: Status) -> Int {
        var count = 0

        for job in jobs {
            if status == job.status {
                count += 1
            }
        }

        return count
    }

    func sortJobs(by sort: Sort) {
        switch sort {
        case .title:
            jobs.sort(by: { $0.title.lowercased() < $1.title.lowercased() })
            sorting = .title
        case .company:
            jobs.sort(by: { $0.company.lowercased() < $1.company.lowercased() })
            sorting = .company
        case .recentlyApplied:
            jobs.sort(by: { $0.dateApplied > $1.dateApplied })
            sorting = .recentlyApplied
        }
    }

    // MARK: - Local storage

    func saveJobs() {
        do {
            let data = try JSONEncoder().encode(jobs)
            UserDefaults.standard.set(data, forKey: Key.jobs)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func loadJobs() {
        guard let savedData = UserDefaults.standard.object(forKey: Key.jobs) as? Data else { return }

        do {
            jobs = try JSONDecoder().decode([Job].self, from: savedData)
            sortJobs(by: sorting)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
