//
//  UIWindow.swift
//  TestAPI
//
//  Created by Manuel Deneu on 31/03/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

import Foundation


open class UIWindow : UIView
{
    // will go private
    var _windowImpl : UnsafeMutablePointer<GtkWidget>? = nil
    
    
    
    
    init()
    {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0) )
    }
    
    public func prepare() -> Bool
    {
        _windowImpl = gtk_window_new(GTK_WINDOW_TOPLEVEL)
        
        return _windowImpl != nil
    }
    
    @available(iOS 4.0, *)
    open var rootViewController: UIViewController? = nil // default is nil
}
