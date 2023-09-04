//
//  ContentView.swift
//  Memorize
//
//  Created by Ayan Sarkar on 16/08/23.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var game : EmojiMemoryGame  //viewModel for this view.
    @State private var dealt = Set<Int>()
    @Namespace private var cardDeal
    @State private var showStartButton = true
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack{
                gameBody
                    .opacity(game.gameOver ? 0 : 1)
                if game.gameOver {
                    scoreCard
                }
            }
            VStack(spacing: 5){
                deck
                startButton.opacity(showStartButton ? 1 : 0)
            }
        }
        .onDisappear{
            game.resetGame()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(game.themeName)
    }
    
    // MARK: - Main view body parts
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: CardConstants.aspectRatio) { card in
            Group{
                if(isUndealt(card)){
                    Color.clear
                }else {
                    CardView(card: card, colorString: game.themeColor)
                        .matchedGeometryEffect(id: card.id, in: cardDeal)
                        .padding(5)
                        .zIndex(zIndexOf(card))
                        .onTapGesture {
                            withAnimation {
                                if card.isMatched == false {
                                    game.chooseCard(card: card)
                                }
                            }
                        }
                }
            }
        }
    }
    
    var deck : some View {
        ZStack(alignment: .center){
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card, colorString: game.themeColor)
                    .zIndex(zIndexOf(card))
                    .matchedGeometryEffect(id: card.id, in: cardDeal)
            }
            //            Text("Tap")
            //                .opacity(showTap ? 1 : 0)
            //                .foregroundColor(.black)
            //                .padding()
        }
        .frame(width: CardConstants.deckWidth, height: CardConstants.deckHeight)
    }
    
    var scoreCard : some View {
        VStack {
            Text("Your Score : \(game.model.score)")
                .font(.system(.title))
            Text("High Score : \(game.model.highestScore)")
                .font(.system(.title2))
            restartButton
        }
    }
    
    //MARK: Buttons
    
    var startButton : some View {
        Button {
            game.startGame()
            showStartButton = false
            for card in game.cards {
                withAnimation(dealAnimation(for: card)){
                    deal(card)
                }
            }
        }label: {
            HStack {
                Text("Start Game")
            }
        }
        .buttonStyle(UtilityButtonStyle())
    }
    
    var restartButton : some View {
        Button {
            withAnimation {
                game.resetGame()
                dealt = []
                showStartButton = true
            }
        }label: {
            HStack {
                Text("Restart Game")
                Image(systemName: "arrow.clockwise")
            }
        }
        .buttonStyle(UtilityButtonStyle())
    }
    
    
    // MARK: - Card Dealing Functions
    
    private func isUndealt(_ card: EmojiCardCore<String>.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func deal(_ card: EmojiCardCore<String>.Card) {
        dealt.insert(card.id)
    }
    
    private func dealAnimation(for card: EmojiCardCore<String>.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.index(matching: card) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zIndexOf(_ card: EmojiCardCore<String>.Card) -> Double {
        -Double(game.cards.index(matching: card) ?? 0)
    }
    
    // MARK: - Card Drawing Constants
    
    private struct CardConstants {
        static var totalDealDuration = 2.0
        static var dealDuration = 0.5
        static var aspectRatio : CGFloat = 2/3
        static var deckHeight : CGFloat = 100
        static var deckWidth : CGFloat = deckHeight * aspectRatio
    }
    
}


















//
//struct previews : PreviewProvider {
//    static var game = EmojiMemoryGame(emojis: ["✈️", "🚗", "🚀", "⛴", "🚜", "🚛", "🚒", "🛺", "🚑", "🏎", "🚤", "🚁", "⛵️", "🛰", "🚲", "🚙", "🚠", "🚢", "🚂"], numberOfCards: 20, themeColor: "Red", themeName: "Test")
//    static var previews: some View {
//        GameView(game: game)
//    }
//}




