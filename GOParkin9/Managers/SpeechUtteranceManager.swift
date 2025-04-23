//
//  SpeechUtteranceManager.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 25/03/25.
//

import Foundation
import AVFoundation

class SpeechUtteranceManager {
    private let synthesizer = AVSpeechSynthesizer()
    
    func speak(text: String, identifier: String = "com.apple.speech.synthesis.voice.Nicky") {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(identifier: identifier)
        synthesizer.speak(utterance)
    }
    
    func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
}
