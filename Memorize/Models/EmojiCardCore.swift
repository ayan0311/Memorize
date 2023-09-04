//
//  EmojiCardGame.swift
//  Memorize
//
//  Created by Ayan Sarkar on 17/08/23.
//

import Foundation

struct EmojiCardCore<CardContent> where CardContent: Equatable {
    
    private(set) var cards: [Card]
    private(set) var score = 0
    var gameOver = false
    private(set) var highestScore = 0{
        didSet {
            saveToUserDefaults()
        }
    }
    private(set) var indexOfTheOneAndOnlyOneUpCard : Int?
    
    private func saveToUserDefaults() {
        UserDefaults.standard.set(highestScore, forKey: "HighScore")
    }
    
    mutating private func restoreFromUserDefaults() {
         highestScore = UserDefaults.standard.integer(forKey: "HighScore")
    }
    
    mutating func createNewGame(numberOfPairOfcards: Int, createCardContent: (Int) -> CardContent) {
        cards = Array<Card>()
        score = 0
        for pairIndex in 0..<numberOfPairOfcards {
            let content = createCardContent(pairIndex)
            cards.append(Card(id: pairIndex*2, content: content))
            cards.append(Card(id: pairIndex*2+1, content: content))
        }
        restoreFromUserDefaults()
    }
    
    // MARK: - Intent Functions
    
    mutating func startGame() {
        cards.shuffle()
    }
    
    mutating func gameOverReset() {
        gameOver = true
        resetGame()
    }
    
    mutating func resetGame() {
        for i in cards.indices {
            cards[i].isMatched = false
            cards[i].isFaceUp = false
        }
        gameOver = false
    }
    
    mutating func choose(card: Card) {
        if let chosenCardIndex = cards.index(matching: card) {//index func as an extension to Collections is defined under UtilityExtensions
            cards[chosenCardIndex].isFaceUp = true
            if indexOfTheOneAndOnlyOneUpCard != nil {
                if cards[indexOfTheOneAndOnlyOneUpCard!].content == cards[chosenCardIndex].content{
                    cards[indexOfTheOneAndOnlyOneUpCard!].isMatched = true
                    cards[chosenCardIndex].isMatched = true
                    updateScore(with: indexOfTheOneAndOnlyOneUpCard!, and: chosenCardIndex)
                    checkForEnd()
                }
                indexOfTheOneAndOnlyOneUpCard = nil
            } else {
                for i in cards.indices {
                    if cards[i].isFaceUp {
                        cards[i].isFaceUp = false
                    }
                }
                indexOfTheOneAndOnlyOneUpCard = chosenCardIndex
                cards[chosenCardIndex].isFaceUp = true
            }
        }
    }
    
    // MARK: - Score Functions
    
    mutating private func updateScore(with index1 : Int, and index2: Int) {
        let difficulty = cards.count
        let cardOne = cards[index1]
        let cardTwo = cards[index2]
        if cardOne.hasEarnedBonus && cardTwo.hasEarnedBonus{
            score = score + Int((cardOne.bonusRemaining + cardTwo.bonusRemaining)*Double(difficulty))
        } else if cardOne.hasEarnedBonus || cardTwo.hasEarnedBonus{
            score = score + Int(cardOne.bonusRemaining * Double(difficulty))
            score = score + Int(cardTwo.bonusRemaining * Double(difficulty))
        } else {
            score += 1
        }
    }
    
    mutating private func highScoreWasAchieved(with score : Int) -> Bool {
        if score > highestScore {
            return true
        }
        return false
    }
    
    // MARK: - Check for End
    
    mutating private func checkForEnd() {
        if cards.allSatisfy({$0.isMatched}) {
            gameOver = true
        }
        if highScoreWasAchieved(with: score){
            highestScore = score
        }
    }
    
    // MARK: - Card
    
    struct Card: Identifiable {
        var id: Int
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                }else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched = false
        var content : CardContent
        
        var bonusTimeLimit: TimeInterval = 6
        var pastFaceUpTime : TimeInterval = 0
        var lastFaceUpDate : Date?
        
        var faceUpTime : TimeInterval {
            if let lastFaceUpDate = lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        var bonusTimeRemaining : TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        var isUsingBonusTime : Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        var bonusRemaining : TimeInterval {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit :  0
        }
        
        var hasEarnedBonus : Bool {
            isMatched && bonusRemaining > 0
        }
        
        
        mutating func startUsingBonusTime() {
            if isUsingBonusTime && lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
    }
}
