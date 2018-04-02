//
//  UIButton.swift
//  TestAPI
//
//  Created by Manuel Deneu on 02/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

import Foundation


open class UIButton : UIControl/*, NSCoding */
{
    
    var _titles : [UInt : String? ] = [ UIControlState.normal.rawValue : "Button"]
    
    open func setTitle(_ title: String?, for state: UIControlState) // default is nil. title is assumed to be single line
    {
        print("Button set title to \(String(describing: title))")
        _titles[state.rawValue] = title
        
        prepare()
    }
    
    open func title(for state: UIControlState) -> String? // these getters only take a single state value
    {
        
        if let t = _titles[state.rawValue]
        {
            return t
        }
        return nil
    }
    
    public override func prepare() -> Bool
    {
        if( _impl == nil)
        {
            _impl = gtk_button_new()
            
            let ptr = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
            
            g_signal_connect_with_data(_impl, "clicked", { (widget, data) in
                
                if let data = data
                {
                    let this = Unmanaged<UIButton>.fromOpaque(data).takeUnretainedValue()
                    
                    this.invokeAction(controlEvent: .touchUpInside)
                }
                
            }, ptr, nil, GConnectFlags(rawValue: 0))
            
            //return true
        }
        print("Button prepare")
        
        
        if let normalTitle = _titles[UIControlState.normal.rawValue]
        {
            gtk_button_set_label(toGtkButton( _impl), normalTitle )
        }
        
        
        
        /*
        g_signal_connect_with_data(_impl, "clicked", { (data) in
            
            if let data = data
            {
                let this = Unmanaged<UIButton>.fromOpaque(data).takeUnretainedValue()
                
                this.invokeAction(controlEvent: .touchUpInside)
            }
            
        }, ptr, nil, GConnectFlags(rawValue: 0))
         */
        assert(_impl != nil)
        return _impl != nil
    }
}
