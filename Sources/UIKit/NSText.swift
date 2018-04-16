//
//  NSText.swift
//  NUXKit
//
//  Created by Manuel Deneu on 16/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

import Foundation

/* Values for NSTextAlignment */
@available(iOS 6.0, *)
public enum NSTextAlignment : Int {
    
    
    case left // Visually left aligned
    
    
    case center // Visually centered
    
    case right // Visually right aligned
    
    /* !TARGET_OS_IPHONE */
    // Visually right aligned
    // Visually centered
    
    case justified // Fully-justified. The last line in a paragraph is natural-aligned.
    
    case natural // Indicates the default alignment for script
}

