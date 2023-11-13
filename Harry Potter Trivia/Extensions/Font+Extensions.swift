//
//  Font+Extensions.swift
//  Harry Potter Trivia
//
//  Created by Tiago Pinheiro on 09/11/2023.
//

import Foundation
import SwiftUI

extension Font {
    static func hpFont(size: CGFloat) -> Font {
        .custom(Constants.hpFont, size: size)
    }
}
