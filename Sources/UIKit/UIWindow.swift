//
//  UIWindow.swift
//  TestAPI
//
//  Created by Manuel Deneu on 31/03/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

import Foundation


func bridgeRetained<T : AnyObject>(obj : T) -> UnsafeMutableRawPointer
{
    return UnsafeMutableRawPointer(Unmanaged.passRetained(obj).toOpaque())
}

func bridgeTransfer<T : AnyObject>(ptr : UnsafeRawPointer) -> T {
    return Unmanaged<T>.fromOpaque(UnsafeRawPointer(ptr)).takeRetainedValue()
}

open class UIWindow : UIView
{
    // will go private
    
    
    
    
    /*
    init()
    {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0) )
    }
 */
    
    deinit {
        gtk_widget_destroy( _windowImpl)
    }
    var _windowImpl : UnsafeMutablePointer<GtkWidget>? = nil
    
    public override func prepare() -> Bool
    {
        if( _impl == nil)
        {
            _impl = gtk_fixed_new()
            g_object_ref(_impl)
            
        }
        
        if( _windowImpl == nil)
        {
            _windowImpl = gtk_window_new(GTK_WINDOW_TOPLEVEL)
            gtk_window_set_default_size( toGtkWindow (_windowImpl), gint(frame.size.width), gint( frame.size.height) )
            gtk_window_set_resizable( toGtkWindow (_windowImpl), 0)
            gtk_widget_set_size_request(_windowImpl, gint(frame.size.width), gint( frame.size.height) )
            
            gtk_window_set_title (toGtkWindow (_windowImpl), "Test UIKit");
            //gtk_fixed_put(toGtkFixed(_impl), view._impl, gint( view.frame.origin.x ), gint( view.frame.origin.y ) )
            
            gtk_container_add (toGtkContainer(_windowImpl), _impl);
        }

        return _impl != nil && _windowImpl != nil
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
        
        
        //viewOrigin.y += 100
        let viewOrigin = viewController.view.frame.origin
        gtk_fixed_put(toGtkFixed(_impl), viewController.view._impl, gint( viewOrigin.x ), gint( viewOrigin.y ) )
        
        gtk_widget_show_all( _windowImpl )
        
        
        if( true)// flag )
        {
            class AnimContext
            {
                init()
                {
                    
                }
                var window : UIWindow!
                var startOrigin = CGPoint()
                var currentPoint = CGPoint()
                var endOrigin = CGPoint()
                
                var view : UIView!
            }
            
            let animContext = AnimContext()
            animContext.window = self
            animContext.startOrigin = CGPoint(x: 0, y: frame.size.height)
            animContext.currentPoint = CGPoint(x: 0, y: frame.size.height)
            animContext.endOrigin = viewController.view.frame.origin
            animContext.view = viewController.view
            
            
            let ptr = UnsafeMutableRawPointer(Unmanaged.passRetained(animContext).toOpaque())
            // milliseconds
            g_timeout_add_full(G_PRIORITY_DEFAULT, 25, { (data) -> gboolean in
                // timeout
                let animContext = Unmanaged<AnimContext>.fromOpaque(data!).takeUnretainedValue()
                
                gtk_widget_set_size_request(animContext.window._impl, gint(animContext.window.frame.size.width), gint( animContext.window.frame.size.height) )
                gtk_widget_set_size_request(animContext.window._windowImpl, gint(animContext.window.frame.size.width), gint( animContext.window.frame.size.height) )
                gtk_fixed_move ( toGtkFixed( animContext.window._impl),
                                animContext.view._impl,
                    gint( animContext.currentPoint.x),
                    gint( animContext.currentPoint.y)
                )
                
                animContext.currentPoint.y -= 100
                print("Y pos \(animContext.currentPoint.y) \(animContext.endOrigin.y )")
                
                if( animContext.currentPoint.y <= animContext.endOrigin.y )
                {
                    return 0
                }
                return 1
            }, ptr, { (data) in
                // GDestroyNotify
                print("Anim ended")
                
            })
        
        }
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
