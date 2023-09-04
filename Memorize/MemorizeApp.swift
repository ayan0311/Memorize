//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Ayan Sarkar on 16/08/23.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var store = ThemeStore(named: "Default")
    
    var body: some Scene {
        WindowGroup {
            ThemeManager()
                .environmentObject(store)
        }
    }
}
