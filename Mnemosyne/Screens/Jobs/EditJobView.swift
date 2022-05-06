//
//  EditJobView.swift
//  Mnemosyne
//
//  Created by Jerry Turcios on 9/10/20.
//

import SwiftUI

struct EditJobView: View {
    // MARK: - Properties

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var achievementStore: AchievementStore
    @EnvironmentObject var jobStore: JobStore

    @State private var titleText = ""
    @State private var companyText = ""
    @State private var dateApplied = Date()
    @State private var contactText = ""
    @State private var status = 0

    // Alert visibility boolean values
    @State private var statusPickerVisible = false
    @State private var errorAlertVisible = false

    var job: Job

    var statusOptions: [Status] = [.applied, .offer, .onSite, .phoneScreen, .rejected]

    // MARK: - Methods

    private func configureView() {
        titleText = job.title
        companyText = job.company
        dateApplied = job.dateApplied
        contactText = job.contact ?? ""

        switch job.status {
        case .applied:
            status = 0
        case .offer:
            status = 1
        case .onSite:
            status = 2
        case .phoneScreen:
            status = 3
        case .rejected:
            status = 4
        }
    }

    private func cancelButtonTapped() {
        presentationMode.wrappedValue.dismiss()
    }

    private func doneButtonTapped() {
        if titleText.isEmpty || companyText.isEmpty {
            errorAlertVisible = true
        } else {
            let updatedJob = Job(
                id: job.id,
                title: titleText,
                company: companyText,
                dateApplied: dateApplied,
                notes: job.notes,
                contact: contactText,
                favorite: job.favorite,
                status: statusOptions[status]
            )

            if updatedJob.status == .offer {
                achievementStore.toggleRecievedOfferAchievement()
            }

            jobStore.editJob(with: updatedJob)
            presentationMode.wrappedValue.dismiss()
        }
    }

    private func toggleStatusPicker() {
        withAnimation {
            statusPickerVisible.toggle()
        }
    }

    // MARK: - Body

    private var errorAlert: Alert {
        Alert(
            title: Text("Error"),
            message: Text("A job title and company name is needed to add a new job. Please enter them and try again."),
            dismissButton: .default(Text("Okay"))
        )
    }

    private var navigationBarItems: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel", action: cancelButtonTapped)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done", action: doneButtonTapped)
            }
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $titleText)
                    TextField("Company", text: $companyText)
                    TextField("Phone number or email", text: $contactText)
                }
                Section {
                    DatePicker("Date", selection: $dateApplied, displayedComponents: .date)
                    Button(action: toggleStatusPicker) {
                        HStack {
                            Text("Status")
                                .foregroundColor(.primary)
                            Spacer()
                            Text(statusOptions[status].rawValue)
                                .foregroundColor(.secondary)
                        }
                    }
                    if statusPickerVisible {
                        Picker("Status", selection: $status) {
                            ForEach(0..<statusOptions.count) { index in
                                Text(statusOptions[index].rawValue)
                                    .tag(index)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                    }
                }
            }
            .alert(isPresented: $errorAlertVisible) { errorAlert }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Edit job")
            .toolbar { navigationBarItems }
        }
        .onAppear(perform: configureView)
    }
}

#if DEBUG
struct EditJobViewPreviews: PreviewProvider {
    static var previews: some View {
        EditJobView(
            job: Job(
                title: "Software Engineer",
                company: "Apple",
                dateApplied: Date(),
                favorite: false,
                status: .applied
            )
        )
    }
}
#endif
