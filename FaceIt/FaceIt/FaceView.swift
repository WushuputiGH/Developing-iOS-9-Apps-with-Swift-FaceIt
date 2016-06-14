//
//  FaceView.swift
//  FaceIt
//
//  Created by lanou on 16/6/4.
//  Copyright © 2016年 an. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView
{
   
    @IBInspectable
    var scale: CGFloat = 0.9 { didSet { setNeedsDisplay() } }
    
    // mouthCurvature 用来设置微笑的曲率
    @IBInspectable
    var mouthCurvature: Double = 0.8 { didSet { setNeedsDisplay() } }
    
    // 用来判读眼睛睁开还是闭合
    @IBInspectable
    var eyesOpen:Bool = true { didSet { setNeedsDisplay() } }
    
    //
    @IBInspectable
    var eyeBrowTilt: Double = -0.5 { didSet { setNeedsDisplay() } }
    @IBInspectable
    
    var color:UIColor = UIColor.blueColor() { didSet { setNeedsDisplay() } }
    @IBInspectable
    var lineWidth: CGFloat  = 5.0 { didSet { setNeedsDisplay() } }
    
    func changeScale(recodnizer: UIPinchGestureRecognizer) {
        switch recodnizer.state {
        case .Changed, .Ended:
            scale *= recodnizer.scale
            recodnizer.scale = 1.0
        default:
            break
        }
    }
    
    
    
    //  计算属性
    private var skullRadiue: CGFloat{
        /*
        get{
            return min(bounds.size.width, bounds.size.height)/2
        }
        如果只有getter方法, 可以不写get{}
        */
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    private var skullCenter: CGPoint{
        return CGPointMake(bounds.midX, bounds.midY)
    }
    
    // 设置眼睛与头部大小的约束
    private struct Ratios{
        static let SkullRadiuToEyeOffset: CGFloat = 3
        static let SkullRadiuToEyeRadius: CGFloat = 10
        static let SkullRadiuToMouthWidth: CGFloat  = 1
        static let SkullRadiuToMouthHeight: CGFloat = 3
        static let SkullRadiuToMouthOffset: CGFloat = 3
        static let SkullRadiuToBrowOffset: CGFloat = 5
    }
    private enum Eye
    {
        case Left
        case Right
    }
    
    private func pathForCircleCenteredAtPoint(midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath
    {
        let path = UIBezierPath(
            arcCenter: midPoint,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2*M_PI),
            clockwise: false
        )
        path.lineWidth = lineWidth
        return path
    }
 
    private func getEyeCenter(eye: Eye) -> CGPoint
    {
        let eyeOffset = skullRadiue / Ratios.SkullRadiuToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        switch eye {
        case .Left: eyeCenter.x -= eyeOffset
        case .Right: eyeCenter.x += eyeOffset
        }
        return eyeCenter
    }
    
    private func pathForEye(eye: Eye) -> UIBezierPath
    {
        let eyeRadius = skullRadiue / Ratios.SkullRadiuToEyeRadius
        let eyeCenter = getEyeCenter(eye)
        if eyesOpen{
             return pathForCircleCenteredAtPoint(eyeCenter, withRadius: eyeRadius)
        }
        else{
            
            let start = CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y)
            let end = CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y)
            let path = UIBezierPath()
            path.moveToPoint(start)
            path.addLineToPoint(end)
            path.lineWidth = lineWidth
            return path;
        }
       
        
    }
    
    private func pathForMouth() -> UIBezierPath
    {
        let mouthWidth = skullRadiue / Ratios.SkullRadiuToMouthWidth
        let mouthHeight = skullRadiue / Ratios.SkullRadiuToMouthHeight
        let mouthOffet = skullRadiue / Ratios.SkullRadiuToMouthOffset
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth/2, y: skullCenter.y + mouthOffet, width: mouthWidth, height: mouthHeight)
        
        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width / 3 , y: mouthRect.minY + smileOffset)
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    private func pathForBrow(eye: Eye) -> UIBezierPath
    {
        var tilt = eyeBrowTilt;
        switch eye{
        case .Left: tilt *= -1.0;
        case .Right: break
        }
        var browCenter = getEyeCenter(eye)
        browCenter.y -= skullRadiue / Ratios.SkullRadiuToBrowOffset
        let eyeRadius = skullRadiue / Ratios.SkullRadiuToEyeRadius
        let tiltOffset = CGFloat(max(-1, min(tilt, 1))) * eyeRadius / 2
        let browStart = CGPoint(x: browCenter.x - eyeRadius, y: browCenter.y - tiltOffset)
        let browEnd = CGPoint(x: browCenter.x + eyeRadius, y: browCenter.y + tiltOffset)
        let path = UIBezierPath()
        path.moveToPoint(browStart)
        path.addLineToPoint(browEnd)
        path.lineWidth = lineWidth
        return path
    }
    
    override func drawRect(rect: CGRect)
    {
        color.set()
        pathForCircleCenteredAtPoint(skullCenter, withRadius: skullRadiue).stroke()
        pathForEye(.Left).stroke()
        pathForEye(.Right).stroke()
        pathForMouth().stroke()
        pathForBrow(.Left).stroke()
        pathForBrow(.Right).stroke()
        
        /*
        let width = bounds.size.width
        let height = bounds.size.height
        
        let skullRadiue = min(width, height) / 2
//        let skullCenter = convertPoint(center, fromView: superview)
        let skullCenter = CGPointMake(bounds.midX, bounds.midY);
        
        
        let skull = UIBezierPath(arcCenter: skullCenter, radius: skullRadiue, startAngle: 0.0, endAngle: CGFloat(2*M_PI), clockwise: false)
        */
    }


}
