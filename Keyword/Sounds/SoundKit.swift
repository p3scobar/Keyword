//
//  SoundKit.swift
//  Keyword
//
//  Created by Hackr on 11/24/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit
import AudioToolbox

struct SoundKit {
    
    enum SoundType: String {
        case tab = "tab01"
        case pay
        case select = "select01"
        case thud
        case paymentSend
        case menuButton
    }
    
    static let shared = SoundKit()
    
    private var sounds = [SystemSoundID]()
    
    private init() {
        sounds = [
            self.soundID(for: .tab)
        ]
    }
    
    static func playSound(type: SoundType) {
        shared.playSound(type: type)
    }
    
    func soundID(for type: SoundType) -> SystemSoundID {
        var soundID: SystemSoundID = 0
        
        guard let url = Bundle.main.url(forResource: type.rawValue, withExtension: "m4a") else { return soundID }
        AudioServicesCreateSystemSoundID((url as NSURL), &soundID)
        
        return soundID
    }
    
    func playSound(type: SoundType) {
        guard UIApplication.shared.applicationState == .active else { return }
        
        let id = soundID(for: type)
        AudioServicesPlaySystemSound(id)
    }
}
