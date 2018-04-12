//
//  UIScreen.swift
//  TestAPI
//
//  Created by Manuel Deneu on 02/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

import Foundation

open class UIScreen : NSObject/*, UITraitEnvironment*/
{
    static let _sharedInstance = UIScreen()
    open class var main: UIScreen // the device's internal screen
        { get
            {
                let s = _sharedInstance
                
                gdk_init(nil, nil)
                
                var geometry = GdkRectangle ();
                
                let defaultDisplay = gdk_display_get_default()
                let monitor = gdk_display_get_primary_monitor(defaultDisplay)
                
                withUnsafeMutablePointer(to: &geometry, { (ptr: UnsafeMutablePointer<GdkRectangle>) -> Void in
                    //var voidPtr: UnsafePointer<Void> = unsafeBitCast(ptr, UnsafePointer<Void>.self)
                    gdk_monitor_get_geometry(monitor, ptr)
                    
                })

                s._bounds.origin = CGPoint()
                s._bounds.size.width  = 400 //CGFloat( geometry.width)
                s._bounds.size.height = 800 //CGFloat(  geometry.height )
                return s
            }
        
        }
    
    private var _bounds = CGRect()
    open var bounds: CGRect // Bounds of entire screen in points
        { get { return _bounds }}
}
