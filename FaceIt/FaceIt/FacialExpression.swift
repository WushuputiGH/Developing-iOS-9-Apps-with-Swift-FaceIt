//
//  FacialExpression.swift
//  FaceIt
//
//  Created by lanou on 16/6/5.
//  Copyright © 2016年 an. All rights reserved.
//

import Foundation

struct FacialExpression {
  
    enum Eyes: Int {
        case Open
        case Closed
        case Squinting
    }
    
    enum EyeBrows: Int{
        case Relaxed
        case Normal
        case Furrowed
        
        func moreRelaxredBrow() -> EyeBrows
        {
            return EyeBrows(rawValue: rawValue - 1) ?? .Relaxed
        }
        func moreFurrowedx() -> EyeBrows{
            return EyeBrows(rawValue: rawValue - 1) ?? .Furrowed
        }
    }
    
    enum Mouth: Int {
        case Frown
        case Smirk
        case Neutral
        case Grin
        case Smile
        
        func sadderMouth() -> Mouth{
            return Mouth(rawValue: rawValue - 1) ?? .Frown
        }
        func happierMouth() -> Mouth{
            return Mouth(rawValue: rawValue + 1) ?? .Smile
        }
    }
    
    var eyes: Eyes
    var eyeBrows: EyeBrows
    var mouth: Mouth
    
}
