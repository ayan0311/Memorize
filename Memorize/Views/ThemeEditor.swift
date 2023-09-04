//
//  ThemeEditor.swift
//  Memorize
//
//  Created by Ayan Sarkar on 28/08/23.
//

import SwiftUI

struct ThemeEditor: View {
    
    @EnvironmentObject var store : ThemeStore

    var chosenThemeIndex : Int
    @State var emojis : String = ""
    private let colors = ["Blue", "Brown", "Green", "Ice", "Mint", "Orange", "Pink", "Red", "Violet", "Yellow"]
    private let cardNumbers = [8, 14, 16, 18, 20, 24, 26, 28, 30]
   
    
    // MARK: - Main Body
    
    var body: some View {
        Form {
            nameSection
            addEmojis
            removeEmojis
            colorPicker
            numberOfCardsPicker
        }
        .navigationTitle("Edit \(store.themes[chosenThemeIndex].name)")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Name Section
    
    var nameSection: some View {
        Section("Name") {
            TextField("Name", text: $store.themes[chosenThemeIndex].name)
        }
    }
    
 // MARK: - Adding and removing Emojis
    
    var addEmojis: some View {
        Section("Add Emojis") {
            TextField("New Emojis", text: $emojis)
                .onChange(of: emojis) { newValue in
                    addNewEmojis(newValue)
                }
        }
    }
    
    private func addNewEmojis(_ emojis : String) {
        store.themes[chosenThemeIndex].emojis = (store.themes[chosenThemeIndex].emojis + emojis).filter{$0.isEmoji}.removingDuplicateCharacters
    }
    
    var removeEmojis: some View {
        Section {
            @State var emojis = store.themes[chosenThemeIndex].emojis.removingDuplicateCharacters.map{String($0)}
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            if store.themes[chosenThemeIndex].emojis.count > (store.themes[chosenThemeIndex].numberOfCards/2){
                                withAnimation {
                                    store.themes[chosenThemeIndex].emojis.removeAll(where: {String($0) == emoji})
                                }
                            }
                            }
                }
            }
        } header: {
            Text("Remove Emojis")
        } footer: {
            Text("Tap on an emoji to remove it. There needs to be atleast \(store.themes[chosenThemeIndex].numberOfCards/2) emojis")
        }
    }
    
    // MARK: - Pickers: Number of cards & Color

    var colorPicker: some View {
        Section("") {
            Picker("Theme Color", selection: $store.themes[chosenThemeIndex].colorString) {
                ForEach(colors, id: \.self){ color in
                    HStack{
                        Circle().foregroundColor(Color(color))
                        Text(color)
                    }
                }
            }
        }
    }

    var numberOfCardsPicker: some View {
        Section{
            Picker("Number of cards", selection: $store.themes[chosenThemeIndex].numberOfCards) {
                ForEach(cardNumbers.filter{ $0 < (store.themes[chosenThemeIndex].emojis.count * 2) }, id: \.self){ number in
                    Text("\(number)")
                }
            }
        } header: {
            
        } footer: {
            Text("Higher the number of cards, more the difficulty, more the points earned. You can play with upto 30 cards. Increase the number of emojis to play with more number of cards.")
        }
        
    }
    
    // MARK: - Intent Functions
}









// MARK: - ThemeEditorPreview
//
//struct ThemeEditorPreview : PreviewProvider {
//    static var theme = Theme(emojis: "⚽️🏀🏈⚾️🥎🎾🏐🏉🥏🎱🪀🏓🏸🏒🏑🥍🏏🪃🥅⛳️🥍🏏🪃🥅⛳️🪁🛝🤿", name: "Default", colorString: "Red", numberOfCards: 20, id: 1)
//    
//    static var previews: some View {
//        ThemeEditor(theme: $theme)
//    }
//}

