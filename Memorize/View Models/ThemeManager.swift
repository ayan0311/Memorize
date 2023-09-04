//
//  ThemeManager.swift
//  Memorize
//
//  Created by Ayan Sarkar on 28/08/23.
//

import SwiftUI

struct ThemeManager: View {
    @EnvironmentObject var store : ThemeStore
    @Environment(\.editMode) var editMode
    @State var editingTheme = false
    @State var showingNewThemeSheet = false
    @State private var themeToEdit: Theme?

    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(store.filteredThemes) { theme in
                        NavigationLink (destination: GameView(game: createNewGame(with: theme))) {
                            VStack(alignment: .leading) {
                                Text(theme.name)
                                    .font(.headline)
                                    .foregroundColor(Color(theme.colorString))
                                Text(theme.emojis)
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button {
                                    themeToEdit = theme
                                    editingTheme = true
                                } label: {
                                    Label("Edit", systemImage: "slider.vertical.3")
                                }
                                .tint(.mint)
                            }
                            .navigationDestination(isPresented: $editingTheme){
                                if let theme = themeToEdit {
                                    ThemeEditor(chosenThemeIndex: store.themes.index(matching: theme) ?? 0)
                                }
                            }
                        }
                    }
                    .onDelete { indexSet in
                        store.themes.remove(atOffsets: indexSet)
                    }
                    .onMove { indexSet, newOffSet in
                        store.themes.move(fromOffsets: indexSet, toOffset: newOffSet)
                    }
                } header: {
                    Text("Themes (Tap to play, swipe right to edit)")
                }
            }
            .searchable(text: $store.searchText, prompt: "Search Themes")
            .sheet(isPresented: $showingNewThemeSheet){
                ThemeCreator()
                    .wrappedInNavigationView()
            }
            .listStyle(.plain)
            .navigationTitle("Memorize")
            .toolbar {
                ToolbarItem { EditButton() }
                ToolbarItem {
                    Button {
                        showingNewThemeSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    private func createNewGame(with theme: Theme) -> EmojiMemoryGame {
        EmojiMemoryGame(emojis: theme.emojis.map{String($0)},
                        numberOfCards: theme.numberOfCards,
                        themeColor: theme.colorString,
                        themeName: theme.name)
    }
    

} //end of Struct





 //MARK: - PreviewProvider

//struct ThemeManagerPreview: PreviewProvider {
//    @StateObject static var store = ThemeStore(named: "Default")
//
//    static var previews: some View {
//        ThemeManager()
//            .environmentObject(store)
//    }
//
//}

