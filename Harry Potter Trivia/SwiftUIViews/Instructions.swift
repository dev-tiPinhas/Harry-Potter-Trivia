//
//  Instructions.swift
//  Harry Potter Trivia
//
//  Created by Tiago Pinheiro on 09/11/2023.
//

import SwiftUI

struct Instructions: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            BackgroundImage()
            
            VStack {
                Image(.appiconwithradius)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .padding(.top)
                
                ScrollView {
                    Text("How To Play")
                        .font(.largeTitle)
                        .padding()
                    
                    VStack(alignment: .leading) {
                        Text("Welcome to Harry Potter Trivia! In this game you will be asked random questions from Harry Potter books and you must guess the right answer or you will lose point! 😱")
                            .padding([.horizontal, .bottom])
                        
                        Text("Each question is worth 5 points, but if you guess a wrong answer, you lose 1 point.")
                            .padding([.horizontal, .bottom])
                        
                        Text("If you are struggling with a question, there is an option to reveal a hint or reveal the book that answers the question. But beware! Using these also minuses 1 point each.")
                            .padding([.horizontal, .bottom])
                        
                        Text("When you select a correct answer, you will be awarded all the points left for that question and they will be added to your total score")
                            .padding([.horizontal, .bottom])
                    }
                    .font(.title3)
                    
                    Text("Good Luck!")
                        .font(.title)
                }
                .foregroundStyle(.black)
                
                Button("Done") {
                    dismiss()
                }
                .doneButton()
            }
        }
    }
}

#Preview {
    Instructions()
}
