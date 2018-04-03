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
            g_object_ref(_impl)
            
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
        //rootViewController?.view._window = self
        didAddSubview(rootViewController!.view!)
        
        
        //UIApplication.shared.showWindow()
        
    }
    
    
    func removeCurrentViewController()
    {
        gtk_container_remove( toGtkContainer( _impl), rootViewController!.view._impl)
    }
    
    
    internal var _vcList = [UIViewController]()
    
    open func presentRootViewController(animated flag: Bool, completion: (() -> Swift.Void)? = nil)
    {
        if( prepare())
        {
            _ = rootViewController?.view.prepare()
            
            let currentCount = _vcList.count
            _vcList.append(rootViewController!)
            
            
            doAddView( rootViewController! ,animated:  flag)
            //gtk_container_add ( toGtkContainer( _impl), rootViewController!.view._impl);
            //gtk_widget_show_all( _impl )
            
            
            assert( _vcList.count == currentCount + 1)
            completion?()
        }


    }
    
    internal func doAddView( _ viewController : UIViewController , animated flag: Bool)
    {
        assert( viewController.view!._impl != nil)
        assert( GtkIsWidget(viewController.view!._impl))
        
        viewController.viewWillAppear(flag)
        
        viewController.view._window = self
        gtk_container_add ( toGtkContainer( _impl), viewController.view._impl);
        gtk_widget_show_all( _impl )
        viewController.viewDidAppear(flag)
    }
    open func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Swift.Void)? = nil)
    {
        // at this point 'prepare' MUST have been called
        assert(_impl != nil)
        
        
        print("Begin UIViewController.present")
        
        if( flag)
        {
            print("[Warning] UIWindow.present.animated flag not supported for now !")
        }
        let lastViewController = rootViewController
        rootViewController = viewControllerToPresent
        
        let currentCount = _vcList.count
        _vcList.append(rootViewController!)
        
        gtk_container_remove(toGtkContainer( _impl), lastViewController?.view._impl)
        doAddView( rootViewController! ,animated:  flag)
        
        // configure old View
        lastViewController?.view._window = nil
        
        
        print("End UIViewController.present")
        assert( _vcList.count == currentCount + 1)
        completion?()
        /*
        self.view.window!.rootViewController = viewControllerToPresent
        self.view.window!.makeKeyAndVisible()
        
        
        // remove stuf from old viewController
        lastViewController?._view._window = nil
        
        self.view.window!.showWindow()
         */
        
    }
    
    // does nothing if only one viewController is present
    open func dismiss(animated flag: Bool, completion: (() -> Swift.Void)? = nil)
    {
        if( _vcList.isEmpty)
        {
            return
        }
        print("Begin UIViewController.dismiss")
        
        if( flag)
        {
            print("[Warning] UIWindow.dismiss.animated flag not supported for now !")
        }
        let currentCount = _vcList.count
        
        let lastViewController = _vcList.popLast()!
        assert( _vcList.count == currentCount - 1)
        assert(_vcList.isEmpty == false)
        
        gtk_container_remove(toGtkContainer( _impl), lastViewController.view._impl)
        
        rootViewController = _vcList.last!
        
        doAddView(rootViewController!, animated: flag)
        
        lastViewController.view._window = nil
        
        print("End UIViewController.dismiss")
        completion?()
    }
    
    
}


extension UIWindow
{
    
}
