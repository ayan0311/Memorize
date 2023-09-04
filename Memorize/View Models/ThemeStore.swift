//
//  ThemeStore.swift
//  Memorize
//
//  Created by Ayan Sarkar on 24/08/23.
//

import Foundation
import SwiftUI

struct Theme : Identifiable, Codable, Hashable {
    var emojis : String
    var name : String
    var colorString: String
    var numberOfCards : Int
    var id : Int

    
     init(emojis: String, name: String, colorString: String, numberOfCards: Int, id: Int) {
        self.emojis = emojis
        self.name = name
        self.colorString = colorString
        self.numberOfCards = numberOfCards
        self.id = id
    }
}

class ThemeStore : ObservableObject {
    var name: String
    @Published var themes = [Theme]() {
        didSet {
            saveToUserDefaults()
        }
    }
    @Published var searchText = ""
    
    var filteredThemes: [Theme] {
            guard !searchText.isEmpty else { return themes }

            return themes.filter { theme in
                theme.name.lowercased().contains(searchText.lowercased())
            }
        }
    
    init(named name: String) {
        self.name = name
        restoreFromUserDefaults()
        if themes.isEmpty {
            addTheme(emojis: "🚗🚕🚙🚌🚎🏎️🚓🚑🚒🚐🛻🚚🚛🚜🛵🏍️🛺🚔🚍🚘🚖🚠🚟🚃🚋🚞🚡🚂", name: "Vehicles", colorString: "Red", numberOfCards: 20)
            addTheme(emojis: "🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷🐽🐸🐵🙈🙉🙊🐒🐔🐧🐦🐤🐣🐥🪿", name: "Animals", colorString: "Green", numberOfCards: 20)
            addTheme(emojis: "🥯🍞🥖🥨🧀🥐🫚🍠🥔🧅🫑🌽🥕🫒🧄🌶️🥒🥬🥦🫛🌭🍔🍔🍕🫓🥪🥙🧆", name: "Food", colorString: "Orange", numberOfCards: 20)
            addTheme(emojis: "⚽️🏀🏈⚾️🥎🎾🏐🏉🥏🎱🪀🏓🏸🏒🏑🥍🏏🪃🥅⛳️🥍🏏🪃🥅⛳️🪁🛝🤿", name: "Sports", colorString: "Yellow", numberOfCards: 20)
            addTheme(emojis: "🍏🍎🍐🍊🍋🍌🍉🍇🍓🫐🍈🍒🍑🥭🍍🥥🥝🍅🥒🥑", name: "Fruits", colorString: "Mint", numberOfCards: 16)
            addTheme(emojis: "⌚️📱💻⌨️🖥️🖨️🖲️🕹️💽💾📼📷📸📹🎥☎️📺📻⏰⏲️⏱️🧭", name: "Devices", colorString: "Brown", numberOfCards: 16)
        }
    }
    
    private func saveToUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(themes), forKey: "themes")
    }
    
    private func restoreFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: "themes"){
            if let decodedThemes = try? JSONDecoder().decode([Theme].self, from: jsonData){
                self.themes = decodedThemes
            }
        }
    }

// MARK: - Indent Functions
    
    func theme(at index: Int) -> Theme {
        let safeIndex = min(max(index, 0), themes.count-1)
        return themes[safeIndex]
    }
    
    func removeTheme(at index: Int) {
        if themes.count > 1 && themes.indices.contains(index) {
            themes.remove(at: index)
        }
    }
    
    func addTheme(emojis: String, name: String, colorString: String, numberOfCards: Int) {
        let uniqueID = (themes.max(by: { $0.id < $1.id })?.id ?? 0) + 1
        let newTheme = Theme(emojis: emojis, name: name, colorString: colorString, numberOfCards: numberOfCards, id: uniqueID)
        themes.append(newTheme)
    }
}
