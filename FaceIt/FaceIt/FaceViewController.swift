//
//  ViewController.swift
//  FaceIt
//
//  Created by lanou on 16/6/4.
//  Copyright © 2016年 an. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    
    var expression: FacialExpression = FacialExpression(eyes: .Open, eyeBrows: .Relaxed, mouth: .Smile){
        didSet{
            updateUI()
        }
    }

    @IBOutlet var faceView: FaceView!{
        didSet {
           
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: faceView,
                action: "changeScale:"
                )
            )
            let happierSwipeGestureRecoginizer = UISwipeGestureRecognizer(target: self, action:"increaseHappiness")
            happierSwipeGestureRecoginizer.direction = .Up
            faceView.addGestureRecognizer(happierSwipeGestureRecoginizer)
            let sadderSwipeGestureRecoginizer = UISwipeGestureRecognizer(target: self, action:"decreaseHappiness")
            sadderSwipeGestureRecoginizer.direction = .Down
            faceView.addGestureRecognizer(sadderSwipeGestureRecoginizer)
            updateUI()
        }
    }

    func increaseHappiness()
    {
        expression.mouth = expression.mouth.happierMouth()
    }
    func decreaseHappiness()
    {
        expression.mouth = expression.mouth.sadderMouth()
    }
    
    @IBAction func toggleEyes(sender: UITapGestureRecognizer) {
        
        if sender.state == .Ended {
            switch expression.eyes {
            case .Open: expression.eyes = .Closed
            case .Closed: expression.eyes = .Open
            case .Squinting: break
            }
        }
        
    }
    
    private let mouthCurvatures = [FacialExpression.Mouth.Frown: -1.0, .Grin: 0.5, .Smile:1.0, .Smirk: -0.5, .Neutral: 0.0]
    private let eyeBrowTilts = [FacialExpression.EyeBrows.Relaxed:-0.5, .Normal:0.0, .Furrowed: 0.5]
    
    private func updateUI(){
     
        if faceView != nil{
            switch expression.eyes{
            case .Open: faceView.eyesOpen = true
            case .Closed: faceView.eyesOpen = false
            case .Squinting: faceView.eyesOpen = false
            }
            faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
            faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

