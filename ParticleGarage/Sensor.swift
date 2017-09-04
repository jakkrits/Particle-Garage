//
//  Sensors.swift
//  iParticle
//
//  Created by JakkritS on 3/11/2559 BE.
//  Copyright © 2559 AppIllustrator. All rights reserved.
//

import Foundation

protocol SensorEnable {
    func turnOn(context: SensorContext)
}

protocol SensorContext {
    func turnOn(LED: LEDSensor)
    func turnOn(RGB: RGBSensor)
}

enum Sensor: CustomStringConvertible {
    
    enum SensorName: String {
        case Led, RGB, RGBRing, Buzzer, Keypad4x4, LCD16x2
    }
    
    case Name(SensorName)
    case Light(Bool, UInt8, UInt8, UInt8)
    
    var description: String {
        switch self {
        case .Name(let sensorName):
            return sensorName.rawValue
        case .Light(let turnOn, let red, let green, let blue):
            return "Turned on = \(turnOn): Red = \(red), Green = \(green), Blue = \(blue)"
        }
    }
    
    init(LEDOn: Bool) {
        self = .Name(.Led)
        self = .Light(true, 255, 255, 255)
    }
    
    init(RGBOn: Bool) {
        self = .Name(.RGB)
        self = .Light(true, 255, 255, 255)
    }
}

struct LEDSensor: SensorEnable {
    func turnOn(context: SensorContext) {
        context.turnOn(self)
    }
}

struct RGBSensor: SensorEnable {
    func turnOn(context: SensorContext) {
        context.turnOn(self)
    }
}

