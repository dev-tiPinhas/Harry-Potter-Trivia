//
//  SampleQuestion.swift
//  Harry Potter Trivia
//
//  Created by Tiago Pinheiro on 13/11/2023.
//

import Foundation

struct SampleQuestion {
    static var previewQuestion: Question {
        do {
            guard let url = Bundle.main.url(forResource: "trivia", withExtension: "json") else { return SampleQuestion.fallbackQuestion }
            
            let firstElement = try JSONDecoder().decode([Question].self, from: Data(contentsOf: url)).first
            return firstElement ?? SampleQuestion.fallbackQuestion
        } catch {
            print("Error decoding sample question: \(error)")
            return SampleQuestion.fallbackQuestion
        }
    }
    
    static var fallbackQuestion: Question = Question(id: 0, question: "", book: 0, hint: "")
}
