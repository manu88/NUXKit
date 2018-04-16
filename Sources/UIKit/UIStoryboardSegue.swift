//
//  UIStoryboardSegue.swift
//  NUXKit
//
//  Created by Manuel Deneu on 16/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

import Foundation


open class UIStoryboardSegue : NSObject
{
    public init(identifier: String?, source: UIViewController, destination: UIViewController)
    {
        super.init()
        
        _source = source
        _identifier = identifier
        _dest = destination
    }
    
    fileprivate var _identifier : String? = nil
    fileprivate var _source : UIViewController!
    fileprivate var _dest : UIViewController!
    
    
    open var identifier: String?
    { get
        {
        return _identifier
        }
    }
    
    open var source: UIViewController
    {
        get
        {
            return _source
        }
    }
    
    open var destination: UIViewController
    {
        get
        {
            return _dest
        }
        
    }
    
}
