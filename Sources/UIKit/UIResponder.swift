//
//  UIResponder.swift
//  TestAPI
//
//  Created by Manuel Deneu on 31/03/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

import Foundation


open class UIResponder : NSObject/*, UIResponderStandardEditActions */
{
    private var _next : UIResponder? = nil
    
    open var next: UIResponder? { get {return _next }}
}
