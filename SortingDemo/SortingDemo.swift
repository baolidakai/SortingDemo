//
//  SortingDemo.swift
//  SortingDemo
//
//  Created by Bowen Deng on 4/21/16.
//  Copyright © 2016 Bowen Deng. All rights reserved.
//

import UIKit

class SortingDemo: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    */
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2.0)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [0.0, 0.0, 1.0, 1.0]
        let color = CGColorCreate(colorSpace, components)
        CGContextSetStrokeColorWithColor(context, color)
        CGContextMoveToPoint(context, 30, 30)
        CGContextAddLineToPoint(context, 300, 400)
        CGContextStrokePath(context)
    }
}