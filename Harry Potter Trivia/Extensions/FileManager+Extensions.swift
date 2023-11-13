//
//  FileManager+Extensions.swift
//  Harry Potter Trivia
//
//  Created by Tiago Pinheiro on 13/11/2023.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first
    }
}
