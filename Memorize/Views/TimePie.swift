//
//  TimePie.swift
//  Memorize
//
//  Created by Ayan Sarkar on 20/08/23.
//

import SwiftUI

struct TimePie : Shape, Animatable {
    
    var startAngle: Angle
    var endAngle: Angle
    let clockwise = false
    
    var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(startAngle.radians, endAngle.radians)
        }
        set {
            startAngle = Angle.radians(newValue.first)
            endAngle = Angle.radians(newValue.second)
        }
    }
    
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = (min(rect.width, rect.height) / 2 ) * 0.9
        
        let start = CGPoint(
            x: center.x + radius * CGFloat( cos(startAngle.radians) ),
            y: center.y + radius * CGFloat( sin(startAngle.radians) )
        )
        
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: !clockwise)
        p.addLine(to: center)
        
        return p
    }
    
}
