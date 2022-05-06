//
//  JobListItemView.swift
//  Mnemosyne
//
//  Created by Jerry Turcios on 9/6/20.
//

import SwiftUI

struct JobListItemView: View {
    // MARK: - Properties

    @EnvironmentObject var jobStore: JobStore
    @State private var trashAlertVisible = false
    var job: Job

    private var statusColor: Color {
        switch job.status {
        case .applied:
            return Color.green
        case .offer:
            return Color.blue
        case .onSite:
            return Color.purple
        case .phoneScreen:
            return Color.orange
        case .rejected:
            return Color.red
        }
    }

    // MARK: - Methods

    private func heartButtonTapped() {
        jobStore.toggleFavorite(for: job.id)
    }

    private func trashButtonTapped() {
        trashAlertVisible = true
    }

    private func deleteJobFromList() {
        withAnimation {
            jobStore.deleteJob(for: job.id)
        }
    }

    // MARK: - Body

    @ViewBuilder
    var actionGroup: some View {
        Button(action: heartButtonTapped) {
            Image(systemName: job.favorite ? "heart.fill" : "heart")
                .font(.title3)
        }
        .padding(.trailing, 8)
        Button(action: trashButtonTapped) {
            Image(systemName: "trash")
                .font(.title3)
        }
    }

    var trashAlert: Alert {
        Alert(
            title: Text("Warning"),
            message: Text("Are you sure you want to delete the \(job.title) job at \(job.company) from your list?"),
            primaryButton: .destructive(Text("Delete"), action: deleteJobFromList),
            secondaryButton: .cancel(Text("Cancel"))
        )
    }

    var body: some View {
        HStack {
            // TODO: Look into using Crunchbase API to provide images
            VStack(alignment: .leading) {
                Text(job.title)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Text(job.company)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(job.status.rawValue)
                    .font(.subheadline)
                    .foregroundColor(statusColor)
            }
            Spacer()
            actionGroup
        }
        .alert(isPresented: $trashAlertVisible) { trashAlert }
        .padding(.horizontal)
    }
}

// MARK: - Previews

#if DEBUG
struct JobListItemViewPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            JobListItemView(
                job: Job(
                    title: "Software Engineer",
                    company: "Apple",
                    dateApplied: Date(),
                    favorite: false,
                    status: .applied
                )
            )
            .previewLayout(.sizeThatFits)
            .padding(.vertical)
            JobListItemView(
                job: Job(
                    title: "Product Manager",
                    company: "Affinity, Inc.",
                    dateApplied: Date(),
                    favorite: true,
                    status: .applied
                )
            )
            .preferredColorScheme(.dark)
            .environment(\.sizeCategory, .accessibilityMedium)
            .previewLayout(.sizeThatFits)
            .padding(.vertical)
        }
    }
}
#endif
