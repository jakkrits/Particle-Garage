//
//  Device.swift
//  iParticle
//
//  Created by JakkritS on 3/1/2559 BE.
//  Copyright © 2559 AppIllustrator. All rights reserved.
//

import Foundation

class Device {
    static let Photon = "Particle Photon"
    static let Electron = "Particle Electron"
        
    enum Pin: String {
        case A0, A1, A2, A3, A4, A5, DAC, WKP, RX, TX, D0, D1, D2, D3, D4, D5, D6, D7, RST
    }
    
    enum DigitalWrite: String {
        case ON, OFF
    }
    
    init() {
        
    }
}