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
    
    open var next: UIResponder? { get {return nil }}
    
    
    
    open var canBecomeFirstResponder: Bool  // default is NO
        {
        get { return false }
    }
    
    // default is NO
    
    open func becomeFirstResponder() -> Bool
    {
        /*
        if let nextResp = _next
        {
            if( nextResp.canResignFirstResponder == false)
            {
                return false
            }
        }
        // Here _next is ok to Resign First Responder
        
        //_next = ?
        */
        return false
    }
    
    open var canResignFirstResponder: Bool // default is YES
    {
        get { return true }
    }
    
    // default is YES
    
    open func resignFirstResponder() -> Bool
    {
        return true
    }
}
