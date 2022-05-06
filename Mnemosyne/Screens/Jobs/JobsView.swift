//
//  JobsView.swift
//  Mnemosyne
//
//  Created by Jerry Turcios on 9/6/20.
//

import SwiftUI

struct JobsView: View {
    // MARK: - Properties

    @AppStorage("sortingIndex") private var selectedFilterOption = 0
    @EnvironmentObject var jobStore: JobStore
    @State private var jobSearchText = ""
    @State private var addJobScreenVisible = false

    private var sortingOptions: [Sort] = [.title, .company, .recentlyApplied]

    private var filteredJobs: [Job] {
        jobStore.jobs.filter({
            jobSearchText.isEmpty ? true :
                $0.title.lowercased().contains(jobSearchText.lowercased()) ||
                $0.company.lowercased().contains(jobSearchText.lowercased()) ||
                $0.status.rawValue.lowercased().contains(jobSearchText.lowercased())
        })
    }

    // MARK: - Methods

    private func addButtonTapped() {
        addJobScreenVisible = true
    }

    private func configureView() {
        jobStore.sortJobs(by: sortingOptions[selectedFilterOption])
    }

    private func handleSortingOptionChange<V>(_ value: V) {
        withAnimation {
            jobStore.sortJobs(by: sortingOptions[selectedFilterOption])
        }
    }

    // MARK: - Body

    private var navigationBarItems: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarLeading) {
                Menu {
                    Picker("Filter options", selection: $selectedFilterOption) {
                        ForEach(sortingOptions.indices) { index in
                            Text(sortingOptions[index].rawValue)
                                .tag(index)
                        }
                    }
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .font(.title3)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: addButtonTapped) {
                    Image(systemName: "plus")
                }
            }
        }
    }

    private var scrollableContent: some View {
        ScrollView {
            SearchBarView(searchText: $jobSearchText)
                .padding(.horizontal)
                .padding(.top, 12)
                .padding(.bottom, 4)
            Divider()
            LazyVStack {
                ForEach(filteredJobs) { job in
                    NavigationLink(destination: JobDetailView(job: job)) {
                        JobListItemView(job: job)
                    }
                    Divider()
                }
            }
        }
    }

    var body: some View {
        NavigationView {
            Group {
                if jobStore.jobs.isEmpty {
                    Text("Add a job by pressing the + button")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    scrollableContent
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Jobs")
            .fullScreenCover(isPresented: $addJobScreenVisible) { AddJobView() }
            .toolbar { navigationBarItems }
            JobDetailView(job: nil)
        }
        .onAppear(perform: configureView)
        .onChange(of: selectedFilterOption, perform: handleSortingOptionChange)
        .tabItem {
            Image(systemName: "briefcase")
            Text("Jobs")
        }
    }
}

// MARK: - Previews

#if DEBUG
struct JobsViewPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            JobsView()
                .previewDevice("iPhone SE (1st generation)")
            JobsView()
                .preferredColorScheme(.dark)
                .environment(\.sizeCategory, .accessibilityMedium)
                .previewDevice("iPhone SE (1st generation)")
        }
        .environmentObject(JobStore())
    }
}
#endif
