//
//  NSBezierPath+CGPath.swift
//  OGCircularBar
//
//  Created by Oskar Groth on 2017-04-15.
//  Copyright © 2017 Oskar Groth. All rights reserved.
//

import Foundation
import AppKit

extension NSBezierPath {
    
    internal var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            switch type {
            case .moveToBezierPathElement: path.move(to: points[0])
            case .lineToBezierPathElement: path.addLine(to: points[0])
            case .curveToBezierPathElement: path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePathBezierPathElement: path.closeSubpath()
            }
        }
        return path
    }
    
}
