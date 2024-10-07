//
//  ContentView.swift
//  Project4SwiftUIBasics
//
//  Created by David Perez on 10/5/24.
//

import SwiftUI

struct ContentView: View {
    @State var data = ["🤖", "😃", "😅", "😇", "👻", "👹", "👾", "😍", "🫨", "🤖", "😃", "😅", "😇", "👻", "👹", "👾", "😍", "😃", "🫨", "😃"]
    let columns = [GridItem(), GridItem(), GridItem()]
    
    @State var revealCount = 0
    @State var revealStates = [Bool](repeating: false, count: 20)
    @State var matchedCards = [Bool](repeating: false, count: 20) // Track matched cards
    @State var revealedIndices = [Int]() // Track the indices of revealed cards
    
    var body: some View {
        VStack {
            HStack {
                Menu{
                    Button("3 Pairs", action: {
                        data = ["🤖", "😅", "😅", "👹", "🤖", "👹"]
                        revealStates = [Bool](repeating: false, count: 6)
                        matchedCards = [Bool](repeating: false, count: 6)
                    })
                    Button("6 Pairs", action: {
                        data = ["😀", "😎", "🤪", "🤓", "🤓", "😎", "🤪", "😍", "🥶", "🥶", "😍", "😀"]
                        revealStates = [Bool](repeating: false, count: 12)
                        matchedCards = [Bool](repeating: false, count: 12)
                    })
                    Button("10 Pairs", action: {
                        data = ["🤖", "😃", "😅", "😇", "👻", "👹", "👾", "😍", "🫨", "🤖", "😃", "😅", "😇", "👻", "👹", "👾", "😍", "😃", "🫨", "😃"]
                        revealStates = [Bool](repeating: false, count: 20)
                        matchedCards = [Bool](repeating: false, count: 20)
                    })
                } label: {
                    Text("Choose Size")
                        .padding(15)
                        .background(Color.orange)
                        .cornerRadius(50)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button(action: resetGame, label: {
                    Text("Reset Game")
                        .padding(15)
                        .background(Color.green)
                        .cornerRadius(50)
                        .foregroundColor(.white)
                })
            }
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(data.indices, id: \.self) { index in
                        CardView(revealState: $revealStates[index], revealCount: $revealCount, emoji: data[index], isMatched: matchedCards[index])

                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onChange(of: revealCount) { newValue in
                if newValue == 2 {
                    checkMatch()
                }
                
                if allCardsRevealed() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        resetGame()
                    }
                }
            }
        }
        .padding()
    }
    
    func checkMatch() {
        // Get the indices of the two revealed cards
        revealedIndices = revealStates.enumerated().compactMap { index, isRevealed in
            isRevealed && !matchedCards[index] ? index : nil
        }
        
        if revealedIndices.count == 2 {
            // Compare emojis of the two revealed cards
            let firstCard = data[revealedIndices[0]]
            let secondCard = data[revealedIndices[1]]
            
            if firstCard == secondCard {
                // Cards match, mark them as matched
                matchedCards[revealedIndices[0]] = true
                matchedCards[revealedIndices[1]] = true
            } else {
                // Cards do not match, reset their states after a short delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    revealStates[revealedIndices[0]] = false
                    revealStates[revealedIndices[1]] = false
                }
            }
            
            // Reset reveal count and clear revealed indices
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                revealCount = 0
                revealedIndices.removeAll()
            }
        }
    }
    
    func allCardsRevealed() -> Bool {
        // Check if all the cards are matched
        return matchedCards.allSatisfy { $0 }
    }
    
    func resetGame() {
        revealCount = 0
        revealStates = [Bool](repeating: false, count: data.count)
        matchedCards = [Bool](repeating: false, count: data.count)
        revealedIndices.removeAll()
    }
}

#Preview {
    ContentView()
}
