//
//  GameViewModel.swift
//  Harry Potter Trivia
//
//  Created by Tiago Pinheiro on 13/11/2023.
//

import Foundation
import SwiftUI

@MainActor
class GameViewModel: ObservableObject {
    @Published var gameScore = 0
    @Published var questionScore = 5
    @Published var recentScores = [0, 0, 0]
    
    private var allQuestions: [Question] = []
    private var answeredQuestions: [Int] = []
    private let savePath = FileManager.documentsDirectory?.appending(path: "SavedScores")
    
    var filteredQuestions: [Question] = []
    var currentQuestion: Question = SampleQuestion.previewQuestion
    var answers: [String] = []
    var correctAnswer: String {
        currentQuestion.answers.first(where: {$0.value == true } )?.key ?? ""
    }
    
    init() {
        decodeQuestions()
    }
    
    func startGame() {
        gameScore = 0
        questionScore = 5
        answeredQuestions.removeAll()
    }
    
    private func decodeQuestions() {
        if let url = Bundle.main.url(forResource: "trivia", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                allQuestions = try decoder.decode([Question].self, from: data)
                filteredQuestions = allQuestions
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
    }
    
    func filterQuestions(for books: [Int]) {
        filteredQuestions = allQuestions.filter { books.contains($0.book) }
    }
    
    func newQuestion() {
        if filteredQuestions.isEmpty {
            return
        }
        
        // If the count is the same it means the user has answered to all of them, we need to reset it
        if answeredQuestions.count == filteredQuestions.count {
            answeredQuestions = []
        }
        
        guard var potentialQuestion = filteredQuestions.randomElement() else { return }
        
        // Make sure we didn't answer this one already
        while answeredQuestions.contains(potentialQuestion.id) {
            guard let newPotentialQuestion = filteredQuestions.randomElement() else { return }
            potentialQuestion = newPotentialQuestion
        }
        
        currentQuestion = potentialQuestion
        
        answers = []
        
        for answer in currentQuestion.answers.keys {
            answers.append(answer)
        }
        
        answers.shuffle()
        
        questionScore = 5
    }
    
    func correct() {
        answeredQuestions.append(currentQuestion.id)
        
        withAnimation {
            gameScore += questionScore
        }
    }
    
    func endGame() {
        recentScores[2] = recentScores[1]
        recentScores[1] = recentScores[0]
        recentScores[0] = gameScore
        
        saveScores()
    }
    
    // MARK: Persistence
    
    func loadScores() {
        do {
            guard let savePath else { return }
            
            let data = try Data(contentsOf: savePath)
            recentScores = try JSONDecoder().decode([Int].self, from: data)
        } catch {
            recentScores = [0, 0, 0]
        }
    }
    
    private func saveScores() {
        do {
            guard let savePath else { return }
            
            let data = try JSONEncoder().encode(recentScores)
            try data.write(to: savePath)
        } catch {
            print("Unable to save data: \(error)")
        }
    }
}
