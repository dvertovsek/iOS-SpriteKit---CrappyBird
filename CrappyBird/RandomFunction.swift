//
//  RandomFunction.swift
//  CrappyBird
//
//  Created by FOI on 15/06/16.
//  Copyright © 2016 Darijan Vertovsek. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat{
    
    public static func random() -> CGFloat{
        
        return CGFloat(Float(arc4random())/0xFFFFFFFF)
    }
    
    public static func random(min min : CGFloat, max: CGFloat) -> CGFloat{
        
        return CGFloat.random() * (max - min) + min
    }

}
