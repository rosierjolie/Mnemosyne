//
//  JobStoreTests.swift
//  MnemosyneTests
//
//  Created by Jerry Turcios on 9/15/20.
//

@testable import Mnemosyne
import XCTest

class JobStoreTests: XCTestCase {
    // MARK: - Static properties

    static var job1 = Job(title: "Software Engineer", company: "Apple", dateApplied: Date(), favorite: true, status: .applied)
    static var job2 = Job(title: "iOS Engineer", company: "Hinge", dateApplied: Date(), favorite: true, status: .offer)
    static var job3 = Job(title: "Product Manager", company: "Amazon", dateApplied: Date(), favorite: false, status: .rejected)

    static var previousJobFromStorage = [Job]()

    // MARK: - Overriden methods

    /// The overriden setUp method is used to store any previous locally stored jobs to a variable before the tests run.
    /// Since the tests will call methods which have calls to the saveJobs and loadJobs function, the code in setUp
    /// reassures that previously stored data for testing is left alone.
    override class func setUp() {
        guard let savedData = UserDefaults.standard.object(forKey: Key.jobs) as? Data else { return }

        do {
            previousJobFromStorage = try JSONDecoder().decode([Job].self, from: savedData)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    /// The overriden tearDown method is used to return the value for previousJobFromStorage back to local storage
    /// once the test suite is finished.
    override class func tearDown() {
        do {
            let data = try JSONEncoder().encode(previousJobFromStorage)
            UserDefaults.standard.set(data, forKey: Key.jobs)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    // MARK: - Test methods

    func testCreateJobMethod() {
        let jobStore = JobStore()

        XCTAssertTrue(jobStore.jobs.isEmpty)

        jobStore.createJob(with: JobStoreTests.job1)
        jobStore.createJob(with: JobStoreTests.job2)
        jobStore.createJob(with: JobStoreTests.job3)

        XCTAssertEqual(jobStore.jobs.count, 3)
    }

    func testDeleteJobMethod() {
        let jobStore = JobStore()
        var deletedJobFound = false

        jobStore.createJob(with: JobStoreTests.job1)
        jobStore.createJob(with: JobStoreTests.job2)
        jobStore.createJob(with: JobStoreTests.job3)

        // Important function call to test
        jobStore.deleteJob(for: JobStoreTests.job2.id)

        XCTAssertEqual(jobStore.jobs.count, 2)

        for job in jobStore.jobs {
            if job.id == JobStoreTests.job2.id {
                deletedJobFound = true
            }
        }

        XCTAssertFalse(deletedJobFound, "The deleted job was found; thus the method failed")
    }

    func testDeleteJobsMethod() {
        let jobStore = JobStore()

        // Adds jobs to the job store and checks that the job count is correct
        jobStore.createJob(with: JobStoreTests.job1)
        jobStore.createJob(with: JobStoreTests.job2)
        jobStore.createJob(with: JobStoreTests.job3)
        XCTAssertEqual(jobStore.jobs.count, 3)

        // Deletes jobs from the job store and checks if the jobs array is empty
        jobStore.deleteJobs()
        XCTAssertTrue(jobStore.jobs.isEmpty)
    }

    func testEditJobMethod() {
        let jobStore = JobStore()
        jobStore.createJob(with: JobStoreTests.job1)

        // Edit some of the details for job1
        JobStoreTests.job1.title = "Hardware Engineer"
        JobStoreTests.job1.company = "Apple, Inc."
        JobStoreTests.job1.status = .onSite

        jobStore.editJob(with: JobStoreTests.job1)

        for job in jobStore.jobs {
            if job.id == JobStoreTests.job1.id {
                // Checks if updated properties have been properly changed
                XCTAssertEqual(job.title, "Hardware Engineer")
                XCTAssertEqual(job.company, "Apple, Inc.")
                XCTAssertEqual(job.status, .onSite)

                // Checks if unmodified properties remain the same
                guard let contact = job.contact else { return }
                guard let notes = job.notes else { return }
                XCTAssertEqual(contact, "")
                XCTAssertEqual(notes, "")
                XCTAssertTrue(job.favorite)
            }
        }

        // Resets job1 properties back to previous values
        JobStoreTests.job1 = Job(title: "Software Engineer", company: "Apple", dateApplied: Date(), favorite: true, status: .applied)
    }

    func testEditJobNotesMethod() {
        let jobStore = JobStore()

        jobStore.createJob(with: JobStoreTests.job1)
        jobStore.editJobNotes(with: "Hello, World!", for: JobStoreTests.job1.id)

        for job in jobStore.jobs {
            if job.id == JobStoreTests.job1.id {
                guard let notes = job.notes else { return }
                XCTAssertEqual(notes, "Hello, World!")
            }
        }

        // Resets job1 properties back to preview values
        jobStore.editJobNotes(with: "", for: JobStoreTests.job1.id)
    }

    func testToggleFavoriteMethod() {
        let jobStore = JobStore()
        jobStore.createJob(with: JobStoreTests.job1)

        // Assert job1 is favorited since it was initialized as true
        XCTAssertTrue(JobStoreTests.job1.favorite)

        jobStore.toggleFavorite(for: JobStoreTests.job1.id)

        for job in jobStore.jobs {
            if job.id == JobStoreTests.job1.id {
                XCTAssertFalse(job.favorite)
            }
        }
    }

    func testGetNumberOfJobsForStatus() {
        let jobStore = JobStore()

        jobStore.createJob(with: JobStoreTests.job2)
        jobStore.createJob(with: JobStoreTests.job3)

        // Checks if all status cases yield the right count
        XCTAssertEqual(jobStore.getNumberOfJobs(for: .applied), 0)
        XCTAssertEqual(jobStore.getNumberOfJobs(for: .phoneScreen), 0)
        XCTAssertEqual(jobStore.getNumberOfJobs(for: .onSite), 0)
        XCTAssertEqual(jobStore.getNumberOfJobs(for: .offer), 1)
        XCTAssertEqual(jobStore.getNumberOfJobs(for: .rejected), 1)
    }
}
