//
//  JobsGraphView.swift
//  Mnemosyne
//
//  Created by Jerry Turcios on 10/17/20.
//

import SwiftUI

struct JobsGraphView: View {
    private var columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(Status.allCases, id: \.self) { status in
                JobsGraphItemView(status: status)
            }
        }
        .padding(.horizontal)
    }
}

#if DEBUG
struct JobsGraphViewPreviews: PreviewProvider {
    static var previews: some View {
        JobsGraphView()
            .previewLayout(.sizeThatFits)
    }
}
#endif
