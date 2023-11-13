//
//  Question.swift
//  Harry Potter Trivia
//
//  Created by Tiago Pinheiro on 13/11/2023.
//

import Foundation

struct Question: Codable {
    let id: Int
    let question: String
    var answers: [String: Bool] = [:]
    let book: Int
    let hint: String
    
    enum QuestionsKeys: String, CodingKey {
        case id
        case question
        case answer
        case wrong
        case book
        case hint
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: QuestionsKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        question = try container.decode(String.self, forKey: .question)
        
        book = try container.decode(Int.self, forKey: .book)
        hint = try container.decode(String.self, forKey: .hint)
        
        let correctAnswer = try container.decode(String.self, forKey: .answer)
        answers[correctAnswer] = true
        
        let wrongAnswers = try container.decode([String].self, forKey: .wrong)
        
        for answer in wrongAnswers {
            answers[answer] = false
        }
    }
    
    init(
        id: Int,
        question: String,
        answers: [String: Bool] = [:],
        book: Int,
        hint: String
    ) {
        self.id = id
        self.question = question
        self.answers = answers
        self.book = book
        self.hint = hint
    }
}
