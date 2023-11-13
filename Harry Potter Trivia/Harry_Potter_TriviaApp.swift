//
//  Harry_Potter_TriviaApp.swift
//  Harry Potter Trivia
//
//  Created by Tiago Pinheiro on 09/11/2023.
//

import SwiftUI

@main
struct Harry_Potter_TriviaApp: App {
    @StateObject private var store = Store()
    @StateObject private var gameViewModel = GameViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(gameViewModel)
                .task {
                    await store.loadProducts()
                    gameViewModel.loadScores()
                    store.loadStatus()
                }
        }
    }
}
