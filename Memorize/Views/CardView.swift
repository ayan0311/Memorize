//
//  CardView.swift
//  Memorize
//
//  Created by Ayan Sarkar on 18/08/23.
//

import SwiftUI

struct CardView : View {
    let card: EmojiCardCore<String>.Card
    var colorString : String
    var themeColor : Color
    @State var animatedBonusRemaining : Double = 0
    
    init(card: EmojiCardCore<String>.Card, colorString: String) {
        self.card = card
        self.colorString = colorString
        self.themeColor = Color(colorString)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                if card.isUsingBonusTime {
                    TimePie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animatedBonusRemaining)*360-90))
                        .opacity(0.7)
                        .onAppear{
                            animatedBonusRemaining = card.bonusRemaining
                            withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                animatedBonusRemaining = 0
                            }
                        }
                } else {
                    TimePie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-card.bonusRemaining)*360-90))
                        .opacity(0.6)
                }
                
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: card.isMatched)
                    .font(.system(size: sizeThatFits(in: geometry.size) * 0.7))
            }
            .cardify(isFaceUp: card.isFaceUp, isMatched: card.isMatched, color: themeColor)
        }
    }
    
    
    private func sizeThatFits(in size: CGSize) -> CGFloat {
        min(size.width, size.height)
    }
}









//
//
//
//
//struct previewOfCard : PreviewProvider {
//    static var card = EmojiCardCore<String>.Card(id: 2, isFaceUp: true, content: "X")
//
//    static var previews: some View {
//        CardView(card: card)
//    }
//}

