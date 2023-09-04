//
//  UtilityButtonStyle.swift
//  Memorize
//
//  Created by Ayan Sarkar on 30/08/23.
//

import SwiftUI

struct UtilityButtonStyle : ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
    }
    
}
