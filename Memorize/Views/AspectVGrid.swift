//
//  AspectVGrid.swift
//  Memorize
//
//  Created by Ayan Sarkar on 17/08/23.
//

import SwiftUI

struct AspectVGrid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    var items : [Item]
    var aspectRatio : Double
    var content : (Item) -> ItemView
    
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                let width = getWidth(itemCount: items.count, size: geometry.size, ItemAspectRatio: aspectRatio)
            LazyVGrid(columns: makeGridItems(with: width)) {
                    ForEach(items) { item in
                        content(item).aspectRatio(aspectRatio, contentMode: .fit)
                    }
                }
                Spacer(minLength: 0)
            }
        }
    }
    
    private func makeGridItems(with width: CGFloat) -> [GridItem] {
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = 0
        return [gridItem]
    }
    
    private func getWidth(itemCount : Int, size : CGSize, ItemAspectRatio : CGFloat) -> CGFloat{
        var rowCount = itemCount
        var coloumnCount = 1
        
        repeat{
            let itemWidth = size.width / CGFloat(coloumnCount)
            let itemHeight = itemWidth / ItemAspectRatio
            if CGFloat(rowCount) * itemHeight < size.height {
                break
            }
            coloumnCount += 1
            rowCount = Int(ceil(Double(itemCount / coloumnCount)))
            
        } while coloumnCount < itemCount
        
        if coloumnCount > itemCount {
            coloumnCount = itemCount
        }
        return floor(size.width / CGFloat(coloumnCount))
    }
}




















//struct previewForAspectVGrid : PreviewProvider {
//    @ObservedObject static var game = EmojiMemoryGame(emojis: ["✈️", "🚗", "🚀", "⛴", "🚜", "🚛", "🚒", "🛺", "🚑", "🏎", "🚤", "🚁", "⛵️", "🛰", "🚲", "🚙", "🚠", "🚢", "🚂"], numberOfCards: 20)
//    static var previews: some View {
//        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
//            Text(card.content)
//                .cardify(isFaceUp: false, isMatched: false)
//        }
//    }
//}
