//
//  BackgroundImage.swift
//  Harry Potter Trivia
//
//  Created by Tiago Pinheiro on 09/11/2023.
//

import SwiftUI

struct BackgroundImage: View {
    var body: some View {
        Image(.parchment)
            .resizable()
            .ignoresSafeArea()
            .background(.black)
    }
}

#Preview {
    BackgroundImage()
}
