//
//  UIColor.swift
//  TestAPI
//
//  Created by Manuel Deneu on 02/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

import Foundation


@objc open class UIColor : NSObject /*, NSSecureCoding , NSCopying*/
{
    var red   = CGFloat(0.0)
    var green = CGFloat(0.0)
    var blue  = CGFloat(0.0)
    var alpha = CGFloat(0.0)
    
    public init(white: CGFloat, alpha: CGFloat)
    {
        self.red   = white
        self.green = white
        self.blue  = white
        self.alpha = alpha
    }
    
    //public init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)
    
    @objc public init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    {
        self.red   = red
        self.green = green
        self.blue  = blue
        self.alpha = alpha
    }
    
    open class var black: UIColor { get { return UIColor(white: 0.0, alpha: 1.0)}} // 0.0 white
    
    open class var darkGray: UIColor { get { return UIColor(white: 0.333, alpha: 1.0)}} // 0.333 white
    
    open class var lightGray: UIColor { get { return UIColor(white: 0.667, alpha: 1.0)}} // 0.667 white
    
    open class var white: UIColor { get { return UIColor(white: 1.0, alpha: 1.0)}} // 1.0 white
    
    open class var gray: UIColor { get { return UIColor(white: 0.5, alpha: 1.0)}} // 0.5 white
    
    open class var red: UIColor { get { return UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)} } // 1.0, 0.0, 0.0 RGB
    
    open class var green: UIColor { get { return UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)} }  // 0.0, 1.0, 0.0 RGB
    
    open class var blue: UIColor { get { return UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)} }  // 0.0, 0.0, 1.0 RGB
    
    open class var cyan: UIColor { get { return UIColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 1.0)} }  // 0.0, 1.0, 1.0 RGB
    
    open class var yellow: UIColor { get { return UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)} } // 1.0, 1.0, 0.0 RGB
    
    open class var magenta: UIColor { get { return UIColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 1.0)} } // 1.0, 0.0, 1.0 RGB
    
    open class var orange: UIColor { get { return UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)} } // 1.0, 0.5, 0.0 RGB
    
    open class var purple: UIColor { get { return UIColor(red: 0.5, green: 0.0, blue: 0.5, alpha: 1.0)} } // 0.5, 0.0, 0.5 RGB
    
    open class var brown: UIColor { get { return UIColor(red: 0.6, green: 0.0, blue: 0.4, alpha: 1.0)} } // 0.6, 0.4, 0.2 RGB
    
    open class var clear: UIColor { get { return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)} } // 0.0 white, 0.0 alpha
    
    
    // 0.0 white
    // 0.333 white
    // 0.667 white
    // 1.0 white
    // 0.5 white
    // 1.0, 0.0, 0.0 RGB
    // 0.0, 1.0, 0.0 RGB
    // 0.0, 0.0, 1.0 RGB
    // 0.0, 1.0, 1.0 RGB
    // 1.0, 1.0, 0.0 RGB
    // 1.0, 0.0, 1.0 RGB
    // 1.0, 0.5, 0.0 RGB
    // 0.5, 0.0, 0.5 RGB
    // 0.6, 0.4, 0.2 RGB
    // 0.0 white, 0.0 alpha
 
    
}
