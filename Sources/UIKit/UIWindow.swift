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
    
    
    
    
    /*
    init()
    {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0) )
    }
 */
    
    public override func prepare() -> Bool
    {
        if( _impl == nil)
        {
            _impl = gtk_window_new(GTK_WINDOW_TOPLEVEL)
            gtk_container_set_border_width (toGtkContainer(_impl) , 10);
            gtk_window_set_title (toGtkWindow (_impl), "Test UIKit");
            
            gtk_window_set_default_size( toGtkWindow (_impl), gint(frame.size.width), gint( frame.size.height) )
        }
        return _impl != nil
    }
    

    @available(iOS 4.0, *)
    open var rootViewController: UIViewController? = nil // default is nil
    
    open func makeKeyAndVisible() // convenience. most apps call this to show the main window and also make it key. otherwise use view hidden
    {

        
        UIApplication.shared.win = self
        rootViewController?.view._window = self
        didAddSubview(rootViewController!.view!)
        
        
        //UIApplication.shared.showWindow()
        
    }
    
    
    
    
    
}


extension UIWindow
{
    
}
