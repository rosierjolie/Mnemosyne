//
//  JobsGraphItemView.swift
//  Mnemosyne
//
//  Created by Jerry Turcios on 10/17/20.
//

import SwiftUI

struct JobsGraphItemView: View {
    // MARK: - Properties

    @EnvironmentObject var jobStore: JobStore
    var status: Status

    private var statusColor: Color {
        switch status {
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

    private var statusCount: Int {
        jobStore.getNumberOfJobs(for: status)
    }


    private var statusTitle: String {
        status.rawValue == "Phone Screen" ? "Phone" : status.rawValue
    }

    // MARK: - Body

    var body: some View {
        VStack {
            Text("\(statusCount)")
                .fontWeight(.bold)
            RoundedRectangle(cornerRadius: 5)
                .fill(statusColor)
                .frame(width: 20, height: CGFloat(statusCount))
            Text(statusTitle)
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(1)
        }
    }
}

// MARK: - Previews

#if DEBUG
struct JobsGraphItemViewPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            JobsGraphItemView(status: .phoneScreen)
                .previewLayout(.sizeThatFits)
                .padding()
            JobsGraphItemView(status: .phoneScreen)
                .preferredColorScheme(.dark)
                .environment(\.sizeCategory, .accessibilityMedium)
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}
#endif
