//
//  AddJobView.swift
//  Mnemosyne
//
//  Created by Jerry Turcios on 9/6/20.
//

import SwiftUI

struct AddJobView: View {
    // MARK: - Properties

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var achievementStore: AchievementStore
    @EnvironmentObject var jobStore: JobStore

    @State private var titleText = ""
    @State private var companyText = ""
    @State private var dateApplied = Date()
    @State private var notesText = ""
    @State private var contactText = ""
    @State private var favorited = false
    @State private var status = 0

    // Alert visibility boolean values
    @State private var statusPickerVisible = false
    @State private var errorAlertVisible = false

    private var statusOptions: [Status] = [.applied, .offer, .onSite, .phoneScreen, .rejected]

    // MARK: - Methods

    private func cancelButtonTapped() {
        presentationMode.wrappedValue.dismiss()
    }

    private func doneButtonTapped() {
        if titleText.isEmpty || companyText.isEmpty {
            errorAlertVisible = true
        } else {
            let job = Job(
                title: titleText,
                company: companyText,
                dateApplied: dateApplied,
                notes: notesText,
                contact: contactText,
                favorite: favorited,
                status: statusOptions[status]
            )

            jobStore.createJob(with: job)
            achievementStore.incrementAppliedJobsCount()
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
                    Toggle("Favorite", isOn: $favorited)
                }
                Section(header: Text("Notes")) {
                    ZStack {
                        TextEditor(text: $notesText)
                        Text(notesText)
                            .opacity(0)
                            .padding(.all, 8)
                    }
                }
            }
            .alert(isPresented: $errorAlertVisible) { errorAlert }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Add job")
            .toolbar { navigationBarItems }
        }
    }
}

// MARK: - Previews

#if DEBUG
struct AddJobViewPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            AddJobView()
                .previewDevice("iPhone SE (1st generation)")
            AddJobView()
                .preferredColorScheme(.dark)
                .environment(\.sizeCategory, .accessibilityMedium)
                .previewDevice("iPhone SE (1st generation)")
        }
    }
}
#endif
