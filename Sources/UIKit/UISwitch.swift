//
//  UISwitch.swift
//  TestAPI
//
//  Created by Manuel Deneu on 04/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

import Foundation


class UISwitch : UIControl
{
    override func prepare() -> Bool {
        
        if (_impl == nil)
        {
            _impl = gtk_switch_new()
            g_object_ref(_impl)
            
            let ptr = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
            
            g_signal_connect_with_data2(_impl, "notify::active", { (widget, specs, data) in
                
                if let data = data
                {
                    let this = Unmanaged<UISwitch>.fromOpaque(data).takeUnretainedValue()
                    assert(widget == this._impl)
                    this.invokeAction(controlEvent: .valueChanged)
                }
                
            }, ptr, nil, GConnectFlags(rawValue: 0))
            
        }
        
        return true
    }
    
    
    open var isOn: Bool
    {
        get
        {
            return gtk_switch_get_active( toGtkSwitch(_impl) ) == 1
        }
    }
}
