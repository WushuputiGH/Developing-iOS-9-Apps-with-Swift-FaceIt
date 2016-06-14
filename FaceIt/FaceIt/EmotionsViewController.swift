//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by lanou on 16/6/5.
//  Copyright © 2016年 an. All rights reserved.
//

import UIKit

class EmotionsViewController: UIViewController {

    
    private let emotionalFaces: Dictionary <String, FacialExpression> = [
        "angry": FacialExpression(eyes: .Open, eyeBrows: .Relaxed, mouth: .Neutral),
        "happy": FacialExpression(eyes: .Closed, eyeBrows: .Relaxed, mouth: .Smile),
        "worried": FacialExpression(eyes: .Open, eyeBrows: .Furrowed, mouth: .Frown),
        "mischievious": FacialExpression(eyes: .Open, eyeBrows: .Relaxed, mouth: .Smile),
    
    ]
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destioationvc = segue.destinationViewController
        if let navigation = destioationvc as? UINavigationController{
            destioationvc = navigation.visibleViewController ?? destioationvc
        }
        if let facevc = destioationvc as? FaceViewController{
            if let indentifier = segue.identifier{
                if let expression = emotionalFaces[indentifier]{
                    facevc.expression = expression
                    if let sendingButton = sender as? UIButton{
                        facevc.navigationItem.title = sendingButton.currentTitle
                    }
                }
            
            }
        }
        
    }

}
