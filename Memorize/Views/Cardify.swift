//
//  Cardify.swift
//  Memorize
//
//  Created by Ayan Sarkar on 17/08/23.
//

import SwiftUI

struct Cardify : Animatable, ViewModifier {
    var isMatched : Bool
    var rotation: Double
    var color: Color
    
    init(isFaceUp: Bool, isMatched: Bool, color: Color) {
        self.isMatched = isMatched
        self.color = color
        rotation = isFaceUp ? 0 : 180
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 10)
            if rotation < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
            } else {
                shape.fill()
                    .opacity(isMatched ? 0 : 1)
                    .animation(Animation.linear(duration: 1), value: isMatched)
            }
            content.opacity(rotation < 90 ? 1 : 0)
        }
        .foregroundColor(color)
        .rotation3DEffect(Angle(degrees: rotation), axis: (x: 0, y: 1, z: 0))
    }
}

extension View {
    func cardify(isFaceUp: Bool, isMatched: Bool, color: Color) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp, isMatched: isMatched, color: color))
    }
}


