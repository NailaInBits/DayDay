//
//  ProfileBg.swift
//  DayDay
//
//  Created by Vincent Liu on 3/11/17.
//  Copyright © 2017 DayDay. All rights reserved.
//

import UIKit

class ProfileBg: UIView {
    
    var c1 = UIColor(red:0.99, green:0.45, blue:0.42, alpha:1.0)
    var c2 = UIColor(red:1.00, green:0.76, blue:0.63, alpha:1.0)


    override func draw(_ rect: CGRect) {
        
        //2 - get the current context
        let context = UIGraphicsGetCurrentContext()
        let colors = [c1.cgColor, c2.cgColor]
        
        //3 - set up the color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        //4 - set up the color stops
        let colorLocations:[CGFloat] = [0.0, 1.0]
        
        //5 - create the gradient
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)
        
        //6 - draw the gradient
        let startPoint = CGPoint(x: 0, y: 0)
        let endPoint = CGPoint(x:0, y:self.bounds.height)
        context!.drawLinearGradient(gradient!,
                                    start: startPoint,
                                    end: endPoint,
                                    options: CGGradientDrawingOptions(rawValue: 0))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 25
        self.clipsToBounds = true
    }
}
