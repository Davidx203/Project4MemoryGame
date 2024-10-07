//
//  CardView.swift
//  Project4SwiftUIBasics
//
//  Created by David Perez on 10/6/24.
//
import SwiftUI

struct CardView: View {
    @Binding var revealState: Bool
    @Binding var revealCount: Int
    var emoji: String
    var isMatched: Bool
    
    var body: some View {
        Button(action: {
            // Only allow reveal if less than 3 cards are revealed
            if revealCount < 3 && !revealState {
                revealState = true
                revealCount += 1
                print("Reveal Count: \(revealCount)")
            }
        }, label: {
            Rectangle()
                .frame(height: 200)
                .foregroundColor(revealState || isMatched ? .white : .blue) // 2. Change color to white if matched
                .cornerRadius(20)
                .overlay(
                    Text((revealState && !isMatched) ? emoji : "")
                        .foregroundColor(.black)
                        .font(.title)
                )
        })
    }
}
#Preview {
    CardView(revealState: .constant(false), revealCount: .constant(0), emoji: "", isMatched: false)
}
