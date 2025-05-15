//
//  ResultsView.swift
//  Hush Alert
//
//  Created by Muhammad Sabihul Hasan on 15/05/25.
//

import SwiftUI

struct ResultsView: View {
    let probabilities: [String: Double]
    let onDone: () -> Void             // pops ListeningView

    private var sorted: [(label: String, value: Double)] {
        probabilities
            .map { (label: $0.key, value: $0.value) }
            .sorted { $0.value > $1.value }
    }

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color(hex: "#FEF9CF").ignoresSafeArea()

            VStack {
                Text("Learn why your\nbaby is crying")
                    .font(.system(size: 37, weight: .bold))
                    .foregroundColor(Color(hex: "#78D3F0"))
                    .multilineTextAlignment(.center)
                    .padding(.top, 28)

                Spacer(minLength: 16)

                ForEach(sorted, id: \.label) { item in
                    ProgressBarRow(
                        percentage: item.value,
                        leftText  : item.value
                          .formatted(.percent.precision(.fractionLength(0))),
                        rightText : item.label
                    )
                }
                .padding(.horizontal, 35)
                .padding(.vertical, 6)

                Spacer()

                Image("baby-single")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 170)
                    .padding(.bottom, 40)
            }
        }
        .onAppear { print("🟢 ResultsView.onAppear – showing bars") }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    print("✅ Done tapped – returning to Home")
                    dismiss()   // pop ResultsView
                    onDone()    // pop ListeningView
                }
            }
        }
    }
}

// MARK: – Row: percent | bar | label+emoji
private struct ProgressBarRow: View {
    var percentage: Double   // 0…1
    var leftText : String
    var rightText: String

    var body: some View {
        HStack {
            Text(leftText)
                .font(.system(size: 18, weight: .bold))
                .frame(width: 48, alignment: .leading)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.3))
                        .frame(height: 30)

                    Capsule()
                        .fill(Color(hex: "#8dd5ed"))
                        .frame(width: geo.size.width * percentage,
                               height: 30)
                }
            }
            .frame(height: 30)

            Text(rightText)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(hex: "#8dd5ed"))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    ResultsView(
        probabilities: ["Sleep": 0.24, "Hungry": 0.28, "Burp": 0.12,
                        "Diaper rash": 0.10, "Heat": 0.16, "Cold": 0.10]
    ) { }
}
