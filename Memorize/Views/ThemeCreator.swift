//
//  ThemeCreator.swift
//  Memorize
//
//  Created by Ayan Sarkar on 29/08/23.
//

import SwiftUI

struct ThemeCreator: View {
    
    @Environment(\.dismiss) var dismiss
    @FocusState private var minEmojiNotAdded: Bool
    @FocusState private var selectNameField: Bool
    
    @EnvironmentObject var store: ThemeStore
    @State private var draftName = "New"
    @State private var draftEmojis = ""
    @State private var draftColorString = "Red"
    @State private var draftNumberOfCards = 8
    @State private var finalEmojisToAdd = ""
    private let colors = ["Blue", "Brown", "Green", "Ice", "Mint", "Orange", "Pink", "Red", "Violet", "Yellow"]
    private let cardNumbers = [8, 14, 16, 18, 20, 24, 26, 28, 30]
    
    var body: some View {
        Form {
            nameSection
            addEmojis
            removeEmojis
            colorPicker
            numberOfCardsPicker
        }
        .onAppear{
            selectNameField = true
        }
        .navigationTitle("Edit \(draftName)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem {
                Button{
                    if finalEmojisToAdd.count > (draftNumberOfCards/2) {
                        store.addTheme(emojis: finalEmojisToAdd, name: draftName, colorString: draftColorString, numberOfCards: draftNumberOfCards)
                        dismiss()
                    } else {
                        notEnoughEmojisAlert = true
                    }
                } label: {
                    Text("Done")
                }
            }
        }
        .alert("Not enough Emojis!", isPresented: $notEnoughEmojisAlert) {
            Button("Ok") {minEmojiNotAdded.toggle()}
        } message: {
            Text("You need to add \(findNumberOfEmojisToAdd()) more emojis to play with \(draftNumberOfCards) cards.")
        }

    }
    
    // MARK: - Name Section
    
    var nameSection: some View {
        Section("Name") {
            TextField("Name", text: $draftName)
                .focused($selectNameField)
        }
    }
    
    // MARK: - Adding and Removing Emojis
    
    var addEmojis: some View {
        Section{
            TextField("New Emojis", text: $draftEmojis)
                .focused($minEmojiNotAdded)
                .onChange(of: draftEmojis) { newValue in
                    addNewEmojis(newValue)
                }
        } header: {
            Text("Add Emojis")
        } footer: {
            Text("You need to add atleast \(draftNumberOfCards/2) emojis.")
        }
    }
    
    private func addNewEmojis(_ emojis : String) {
        finalEmojisToAdd = (finalEmojisToAdd + emojis).filter{$0.isEmoji}.removingDuplicateCharacters
    }

    var removeEmojis: some View {
        Section {
            @State var emojis = draftEmojis.removingDuplicateCharacters.map{String($0)}
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                draftEmojis.removeAll(where: {String($0) == emoji})
                            }
                        }
                }
            }
        } header: {
            Text("Remove Emojis")
        } footer: {
            Text("Tap on an emoji to remove it.")
        }
    }

    // MARK: - Pickers: Color & Number of Cards
    
    var colorPicker: some View {
        Section("") {
            Picker("Theme Color", selection: $draftColorString) {
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
            Picker("Number of cards", selection: $draftNumberOfCards) {
                ForEach(cardNumbers, id: \.self){ number in
                    Text("\(number)")
                }
            }
        } header: {
            
        } footer: {
            Text("Higher the number of cards, more the difficulty, more the points earned")
        }
        
    }

    
    // MARK: - Alerts & its Functions
    
    @State private var notEnoughEmojisAlert = false

    private func findNumberOfEmojisToAdd() -> Int {
        (draftNumberOfCards / 2) - draftEmojis.count
    }

}

