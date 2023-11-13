//
//  ClipManager.swift
//  Harry Potter Trivia
//
//  Created by Tiago Pinheiro on 13/11/2023.
//

import Foundation
import AVKit

enum FadeType {
    case fadeIn
    case fadeOut
}

class ClipManager {
    static let shared: ClipManager = ClipManager()
    
    private var backGroundClip: AVAudioPlayer?
    private var fxClip: AVAudioPlayer?
    
    func playIntro() throws {
        guard let sound = Bundle.main.path(forResource: "magic-in-the-air", ofType: "mp3") else { return }
        
        backGroundClip = try AVAudioPlayer(contentsOf: URL(filePath: sound))
        backGroundClip?.numberOfLoops = -1
        backGroundClip?.play()
    }
    
    func playSoundtrack() throws {
        let songs: Set<String> = [
            "let-the-mystery-unfold",
            "spellcraft",
            "hiding-place-in-the-forest",
            "deep-in-the-dell"
        ]
        
        guard let sound = Bundle.main.path(forResource: songs.randomElement(), ofType: "mp3") else { return }
        
        backGroundClip = try AVAudioPlayer(contentsOf: URL(filePath: sound))
        backGroundClip?.volume = 0.1
        backGroundClip?.numberOfLoops = -1
        backGroundClip?.play()
    }
    
    func playFlipSound() throws {
        guard let sound = Bundle.main.path(forResource: "page-flip", ofType: "mp3") else { return }
        
        fxClip = try AVAudioPlayer(contentsOf: URL(filePath: sound))
        fxClip?.play()
    }
    
    func playWrongSound() throws {
        guard let sound = Bundle.main.path(forResource: "negative-beeps", ofType: "mp3") else { return }
        
        fxClip = try AVAudioPlayer(contentsOf: URL(filePath: sound))
        fxClip?.play()
    }
    
    func playCorrectSound() throws {
        guard let sound = Bundle.main.path(forResource: "magic-wand", ofType: "mp3") else { return }
        
        fxClip = try AVAudioPlayer(contentsOf: URL(filePath: sound))
        fxClip?.play()
    }
    
    func fadeClip(with fadeType: FadeType) throws {
        switch fadeType {
        case .fadeIn:
            backGroundClip?.setVolume(1, fadeDuration: 2)
        case .fadeOut:
            backGroundClip?.setVolume(0, fadeDuration: 2)
        }
        
    }
}
