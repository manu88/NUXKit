//
//  UIImage.swift
//  NUXKit
//
//  Created by Manuel Deneu on 17/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

import Foundation

@available(iOS 2.0, *)
open class UIImage : NSObject, NSSecureCoding
{
    public static var supportsSecureCoding: Bool
    {
        get { return true }
    }
    
    public func encode(with aCoder: NSCoder) {
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
    
    }
    
    
    
    public /*not inherited*/ init?(named name: String) // load from main bundle
    {
        super.init()
        
    }
}
