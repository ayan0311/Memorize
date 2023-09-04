//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Ayan Sarkar on 17/08/23.
//

import Foundation

class EmojiMemoryGame : ObservableObject {
    
    var emojis: [String]
    var numberOfPairs : Int
    var themeColor: String
    var themeName: String
    var gameOver : Bool{
        model.gameOver
    }
    
    init(emojis: [String], numberOfCards: Int, themeColor: String, themeName: String) {
        self.emojis = emojis
        if numberOfCards % 2 != 0 {
            self.numberOfPairs = (numberOfCards+1)/2
        } else {
            self.numberOfPairs = numberOfCards/2

        }
        self.themeColor = themeColor
        self.themeName = themeName
        model.createNewGame(numberOfPairOfcards: numberOfPairs) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    @Published var model = EmojiCardCore(cards: Array<EmojiCardCore<String>.Card>())
    
    
    var cards : [EmojiCardCore<String>.Card] {
        model.cards
    }
    
    func chooseCard(card: EmojiCardCore<String>.Card) {
        model.choose(card: card)
    }
    
    func startGame() {
        model.startGame()
    }
    
    func resetGame() {
        model.resetGame()
    }
    
    
}
