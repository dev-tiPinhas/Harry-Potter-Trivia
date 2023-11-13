//
//  ContentView.swift
//  Harry Potter Trivia
//
//  Created by Tiago Pinheiro on 09/11/2023.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @EnvironmentObject private var store: Store
    @EnvironmentObject private var gameViewModel: GameViewModel
    
    @State private var scalePlayButton: Bool = false
    @State private var moveBackgroundImage: Bool = false
    @State private var animateViewsIn: Bool = false
    
    @State private var showInstructions: Bool = false
    @State private var showSettings: Bool = false
    @State private var playGame: Bool = false
    
    let clipManager: ClipManager = ClipManager.shared
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(.hogwarts)
                    .resizable()
                    .frame(width: geo.size.width * 3, height: geo.size.height)
                    .padding(.top, 3)
                    .offset(x: moveBackgroundImage ? geo.size.width / 1.1 : -geo.size.width / 1.1)
                    .onAppear {
                        withAnimation(.linear(duration: 60).repeatForever()) {
                            moveBackgroundImage.toggle()
                        }
                    }
                
                VStack {
                    VStack {
                        if animateViewsIn {
                            VStack {
                                Image(systemName: "bolt.fill")
                                    .font(.largeTitle)
                                    .imageScale(.large)
                                
                                Text("HP")
                                    .font(Font.hpFont(size: 70))
                                    .padding(.bottom, -50)
                                
                                Text("Trivia")
                                    .font(Font.hpFont(size: 60))
                            }
                            .padding(.top, 70)
                            .transition(.move(edge: .top))
                        }
                    }
                    .animation(.easeOut(duration: 0.7).delay(2), value: animateViewsIn)
                    
                    Spacer()
                    VStack {
                        if animateViewsIn {
                            VStack {
                                Text("Recent Scores")
                                    .font(.title2)
                                
                                ForEach(gameViewModel.recentScores, id: \.self) { score in
                                    Text("\(score)")
                                }
                            }
                            .font(.title3)
                            .padding(.horizontal)
                            .foregroundStyle(.white)
                            .background(.black.opacity(0.7))
                            .cornerRadius(15)
                            .transition(.opacity)
                        }
                    }
                    .animation(.linear(duration: 1).delay(4), value: animateViewsIn)
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        VStack {
                            if animateViewsIn {
                                Button {
                                    showInstructions.toggle()
                                } label: {
                                    Image(systemName: "info.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundStyle(.white)
                                        .shadow(radius: 5)
                                }
                                .transition(.offset(x: -geo.size.width / 4))
                                .sheet(isPresented: $showInstructions) {
                                    Instructions()
                                }
                            }
                        }
                        .animation(.easeOut(duration: 0.7).delay(2.7), value: animateViewsIn)
                        
                        Spacer()
                        
                        VStack {
                            if animateViewsIn {
                                Button {
                                    fadeBackgroundClip(with: .fadeOut)
                                    filterQuestions()
                                    gameViewModel.startGame()
                                    playGame.toggle()
                                } label: {
                                    Text("Play")
                                        .font(.largeTitle)
                                        .foregroundStyle(.white)
                                        .padding(.vertical, 7)
                                        .padding(.horizontal, 50)
                                        .background(store.books.contains(.active) ? .brown : .gray)
                                        .cornerRadius(7)
                                        .shadow(radius: 7)
                                }
                                .scaleEffect(scalePlayButton ? 1.2 : 1)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 1.3).repeatForever()) {
                                        scalePlayButton.toggle()
                                    }
                                }
                                .transition(.offset(y: geo.size.height / 3))
                                .fullScreenCover(
                                    isPresented: $playGame,
                                    onDismiss: {
                                        fadeBackgroundClip(with: .fadeIn)
                                    }
                                ) {
                                    GamePlay(clipManager: clipManager)
                                        .environmentObject(gameViewModel)
                                }
                                .disabled(store.books.contains(.active) ? false : true)
                            }
                        }
                        .animation(.easeOut(duration: 0.7).delay(2), value: animateViewsIn)
                        
                        Spacer()
                        
                        VStack {
                            if animateViewsIn {
                                Button {
                                    showSettings.toggle()
                                } label: {
                                    Image(systemName: "gearshape.fill")
                                        .font(.largeTitle)
                                        .foregroundStyle(.white)
                                        .shadow(radius: 5)
                                }
                                .transition(.offset(x: geo.size.width / 4))
                                .sheet(isPresented: $showSettings) {
                                    Settings()
                                        .environmentObject(store)
                                }
                            }
                        }
                        .animation(.easeOut(duration: 0.7).delay(2.7), value: animateViewsIn)
                                
                        Spacer()
                    }
                    .frame(width: geo.size.width)
                    
                    VStack {
                        if animateViewsIn {
                            if store.books.contains(.active) == false {
                                Text("No questions available. Go to settings. ⬆️")
                                    .multilineTextAlignment(.center)
                                    .transition(.opacity)
                            }
                        }
                    }
                    .animation(.easeInOut.delay(3), value: animateViewsIn)
                    
                    Spacer()
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        .onAppear {
            animateViewsIn = true
            updateBackgroundClip()
        }
    }
}

extension ContentView {
    private func updateBackgroundClip() {
        do {
            try clipManager.playIntro()
        } catch {
            print("Audio with Error: \(error)")
        }
    }
    
    private func fadeBackgroundClip(with fadeType: FadeType) {
        do {
            try clipManager.fadeClip(with: fadeType)
        } catch {
            print("Audio with Error")
        }
    }
    
    private func filterQuestions() {
        var books: [Int] = []
        
        for (index, status) in store.books.enumerated() {
            if status == .active {
                books.append(index+1)
            }
        }
        
        // Fitler questions for the active books
        gameViewModel.filterQuestions(for: books)
        // Generate a new question
        gameViewModel.newQuestion()
    }
}

#Preview {
    ContentView()
        .environmentObject(Store())
        .environmentObject(GameViewModel())
        .preferredColorScheme(.dark)
}
