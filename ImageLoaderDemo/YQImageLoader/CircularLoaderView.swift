//
//  CircularLoaderView.swift
//  ImageLoaderDemo
//
//  Created by wangyaqing on 15/6/30.
//  Copyright (c) 2015年 billwang1990.github.io. All rights reserved.
//

import UIKit
import QuartzCore

public class CircularLoaderView: UIView {
    
    class func radiusForPoint(point:CGPoint) -> Float {
        return sqrtf(Float(point.x*point.x) + Float(point.y*point.y))
    }
    
    class func distanceBetweenTwoPoint(point1: CGPoint, point2: CGPoint) -> Float {
        return radiusForPoint(CGPointMake(point1.x-point2.x, point1.y-point2.y))
    }

    let circlePathLayer : CAShapeLayer! = CAShapeLayer()
    let circleRadius : CGFloat = 20
    private var _progress : CGFloat = 0
    var progress : CGFloat {
        get {
            return _progress
        }
        
        set {
            _progress = newValue
            
            if (newValue > 1) {
                _progress = 1
            }
            if (newValue < 0) {
                _progress = 0
            }

            circlePathLayer.strokeEnd = _progress
        }
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        circlePathLayer.frame = bounds
        circlePathLayer.path = circlePath().CGPath
    }
    
    public override func tintColorDidChange() {
        super.tintColorDidChange()
        circlePathLayer.strokeColor = tintColor.CGColor
    }
    
    private func config(){
        self.circlePathLayer.frame = bounds;
        self.circlePathLayer.lineWidth = 2;
        self.circlePathLayer.fillColor = UIColor.clearColor().CGColor
        self.circlePathLayer.strokeColor = UIColor.blackColor().CGColor
        self.circlePathLayer.strokeStart = 0
        self.circlePathLayer.strokeEnd = _progress

        layer.addSublayer(self.circlePathLayer)
        backgroundColor = UIColor.whiteColor()
    }
    
    private func circleFrame() -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: 2*circleRadius, height: 2*circleRadius)
        circleFrame.origin.x = CGRectGetMidX(circlePathLayer.bounds) - CGRectGetMidX(circleFrame)
        circleFrame.origin.y = CGRectGetMidY(circlePathLayer.bounds) - CGRectGetMidY(circleFrame)
        return circleFrame
    }
    
    private func circlePath() -> UIBezierPath{
        return UIBezierPath(ovalInRect: circleFrame())
    }
    
    public func reveal()
    {
        backgroundColor = UIColor.clearColor()
        circlePathLayer.removeAnimationForKey("strokeEnd")
        circlePathLayer.removeFromSuperlayer()
        superview?.layer.mask = circlePathLayer
        
        var circleFrame = CGRect(x: 0, y: 0, width: 2*circleRadius, height: 2*circleRadius)
        circleFrame.origin.x = CGRectGetMidX(circlePathLayer.bounds) - CGRectGetMidX(circleFrame)
        circleFrame.origin.y = CGRectGetMidY(circlePathLayer.bounds) - CGRectGetMidY(circleFrame)
        
        var finalRadius = CGFloat(CircularLoaderView.distanceBetweenTwoPoint(CGPointZero, point2: CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))))
        var radius = finalRadius - circleRadius
        var outerRect = CGRectInset(circleFrame, -radius, -radius)
        
        var toPath = UIBezierPath(ovalInRect: outerRect)
        var fromPath = circlePathLayer.path
    
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        circlePathLayer.path = toPath.CGPath
        CATransaction.commit()
        
        var pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = fromPath
        pathAnimation.toValue = toPath.CGPath
        pathAnimation.delegate = self
        circlePathLayer.addAnimation(pathAnimation, forKey: "strokeWidth")
    }

    public override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
         superview?.layer.mask = nil
        circlePathLayer.removeAllAnimations()
        self.removeFromSuperview()
    }

}
