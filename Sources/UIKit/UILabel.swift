//
//  UILabel.swift
//  TestAPI
//
//  Created by Manuel Deneu on 02/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

import Foundation

class UILabel : UIView
{
    private var _text : String? = nil
    
    open var text: String? // default is nil
    {
        set
        {
            _text = newValue
            
            _ = prepare()
        }
        get
        {
            return _text
        }
    }
    override func prepare() -> Bool {
        if( _impl == nil)
        {
            _impl = gtk_label_new( "" /*"Test"*/)
            g_object_ref(_impl)
        }
        
        if let t = text
        {
            gtk_label_set_text(toGtkLabel( _impl), t)
        }
        
        return true
    }
}
