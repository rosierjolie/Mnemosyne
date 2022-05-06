//
//  SearchBarView.swift
//  Mnemosyne
//
//  Created by Jerry Turcios on 9/7/20.
//

import SwiftUI

struct SearchBarView: View {
    // MARK: - Properties

    @Binding var searchText: String
    @State private var editing = false

    // MARK: - Methods

    private func cancelButtonTapped() {
        editing = false
        searchText = ""
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    private func textFieldTapped() {
        editing = true
    }

    // MARK: - Body

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search", text: $searchText)
                    .onTapGesture(perform: textFieldTapped)
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            if editing {
                Button("Cancel", action: cancelButtonTapped)
                    .transition(.move(edge: .trailing))
                    .animation(.default)
            }
        }
    }
}

// MARK: - Previews

#if DEBUG
struct SearchBarViewPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchBarView(searchText: .constant("Apple"))
                .previewLayout(.sizeThatFits)
                .padding()
            SearchBarView(searchText: .constant("Apple"))
                .preferredColorScheme(.dark)
                .environment(\.sizeCategory, .accessibilityMedium)
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}
#endif
