//
//  ProfileView.swift
//  Mnemosyne
//
//  Created by Jerry Turcios on 9/6/20.
//

import SwiftUI

struct ProfileView: View {
    // MARK: - Properties

    @EnvironmentObject var jobStore: JobStore
    @State private var deleteJobsAlertVisible = false

    // MARK: - Methods

    private func trashButtonTapped() {
        deleteJobsAlertVisible = true
    }

    private func deleteButtonTapped() {
        withAnimation {
            jobStore.deleteJobs()
        }
    }

    // MARK: - Body

    private var deleteJobsAlert: Alert {
        Alert(
            title: Text("Warning"),
            message: Text("Are you sure you want to delete all jobs? This action is permanent."),
            primaryButton: .destructive(Text("Delete"), action: deleteButtonTapped),
            secondaryButton: .cancel(Text("Cancel"))
        )
    }

    private var navigationBarItems: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: trashButtonTapped) {
                Image(systemName: "trash")
                    .renderingMode(.original)
            }
            .disabled(jobStore.jobs.isEmpty)
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    HStack {
                        Text("Job overview")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding([.leading, .vertical])
                    JobsGraphView()
                        .padding(.bottom, 20)
                    HStack {
                        Text("Achievements")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding([.leading, .vertical])
                    AchievementsView()
                }
            }
            .alert(isPresented: $deleteJobsAlertVisible) { deleteJobsAlert }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Profile")
            .toolbar { navigationBarItems }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .tabItem {
            Image(systemName: "person")
            Text("Profile")
        }
    }
}

// MARK: - Previews

#if DEBUG
struct ProfileViewPreviews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .previewDevice("iPhone SE (1st generation)")
    }
}
#endif
