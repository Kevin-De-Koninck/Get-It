//
//  OGCircularBar.swift
//  OGCircularBar
//
//  Created by Oskar Groth on 2017-02-19.
//  Copyright © 2017 Oskar Groth. All rights reserved.
//

import Cocoa

public class OGCircularBarView: NSView, Sequence {
    
    public var bars: [CircularBarLayer] = []
    public var circleBars: [CircularBarLayer] = []
    var center: CGPoint {
        get {
            return NSMakePoint(floor(bounds.width/2), floor(bounds.height/2))
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        wantsLayer = true
    }
    
    public func addBar(startAngle: CGFloat, endAngle: CGFloat, progress: CGFloat, radius: CGFloat, width: CGFloat, color: NSColor, animationDuration: CGFloat, glowOpacity: Float, glowRadius: CGFloat) {
        let barLayer = CircularBarLayer(center: center, radius: radius, width: width, startAngle: startAngle, endAngle: endAngle, color: color)
        barLayer.shadowColor = color.cgColor
        barLayer.shadowRadius = glowRadius
        barLayer.shadowOpacity = glowOpacity
        barLayer.shadowOffset = NSSize.zero
        
        layer?.addSublayer(barLayer)
        bars.append(barLayer)
        if animationDuration > 0 {
            barLayer.animateProgress(progress, duration: animationDuration)
        } else {
            barLayer.progress = progress
        }
    }
    
    public func addBarBackground(startAngle: CGFloat, endAngle: CGFloat, radius: CGFloat, width: CGFloat, color: NSColor) {
        let barLayer = CircularBarLayer(center: center, radius: radius, width: width, startAngle: startAngle, endAngle: endAngle, color: color)
        barLayer.progress = 1
        layer?.addSublayer(barLayer)
    }

    
    public subscript(index: Int) -> CircularBarLayer {
        return bars[index]
    }
    
    public func makeIterator() -> IndexingIterator<[CircularBarLayer]> {
        return bars.makeIterator()
    }
    
}

open class CircularBarLayer: CAShapeLayer, CALayerDelegate, CAAnimationDelegate {
    
    var completion: ((Void) -> Void)?

    open var progress: CGFloat? {
        get {
            return strokeEnd
        }
        set {
            strokeEnd = (newValue ?? 0)
        }
    }
    
    public init(center: CGPoint, radius: CGFloat, width: CGFloat, startAngle: CGFloat, endAngle: CGFloat, color: NSColor) {
        super.init()
        let bezier = NSBezierPath()
        bezier.appendArc(withCenter: NSZeroPoint, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: startAngle > endAngle)
        bezier.transform(using: AffineTransform(translationByX: center.x, byY: center.y))
        delegate = self as CALayerDelegate
        path = bezier.cgPath
        fillColor = NSColor.clear.cgColor
        strokeColor = color.cgColor
        lineWidth = width
        lineCap = kCALineCapRound
        strokeStart = 0
        strokeEnd = 0
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    open func animateProgress(_ progress: CGFloat, duration: CGFloat, completion: ((Void) -> Void)? = nil) {
        removeAllAnimations()
        let progress = progress
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = strokeEnd
        animation.toValue = progress
        animation.duration = CFTimeInterval(duration)
        animation.delegate = self as CAAnimationDelegate
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        strokeEnd = progress
        add(animation, forKey: "strokeEnd")
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            completion?()
        }
    }
}

