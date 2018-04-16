//
//  UIWindow.swift
//  TestAPI
//
//  Created by Manuel Deneu on 31/03/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

import Foundation

/*
func bridgeRetained<T : AnyObject>(obj : T) -> UnsafeMutableRawPointer
{
    return UnsafeMutableRawPointer(Unmanaged.passRetained(obj).toOpaque())
}

func bridgeTransfer<T : AnyObject>(ptr : UnsafeRawPointer) -> T {
    return Unmanaged<T>.fromOpaque(UnsafeRawPointer(ptr)).takeRetainedValue()
}
*/
open class UIWindow : UIView
{
    override open var next: UIResponder? { get { return UIApplication.shared}}
    
    deinit
    {
        if( _windowImpl != nil)
        {
            gtk_widget_destroy( _windowImpl)
        }
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
            
            var color = GdkRGBA()
            color.alpha = 0.0
            gtk_widget_override_background_color( _impl, GTK_STATE_FLAG_NORMAL, &color)
            gtk_widget_override_background_color( _windowImpl, GTK_STATE_FLAG_NORMAL, &color)
            
            gtk_container_add (toGtkContainer(_windowImpl), _impl);
        }

        return _impl != nil && _windowImpl != nil
    }
    

    @available(iOS 4.0, *)
    open var rootViewController: UIViewController? = nil // default is nil
    
    open func makeKeyAndVisible() // convenience. most apps call this to show the main window and also make it key. otherwise use view hidden
    {

        
        UIApplication.shared.window = self
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
            
            
            doAddView( rootViewController! ,animationMode: flag ? .PresentAnim : .NoAnim)
            //gtk_container_add ( toGtkContainer( _impl), rootViewController!.view._impl);
            //gtk_widget_show_all( _impl )
            
            
            assert( _vcList.count == currentCount + 1)
            completion?()
        }


    }
    
    internal enum AnimationMode : Int
    {
        case NoAnim = 0
        case PresentAnim
        case DismissAnim
        
        func isAnimated() -> Bool
        {
            return self != .NoAnim
        }
    }
    
    internal func doAddView( _ viewController : UIViewController , animationMode flag: AnimationMode)
    {
        assert( viewController.view!._impl != nil)
        assert( GtkIsWidget(viewController.view!._impl))
        
        viewController.viewWillAppear( flag.isAnimated() )
        
        viewController.view._window = self
        
        
        //viewOrigin.y += 100
        let viewOrigin = viewController.view.frame.origin
        gtk_fixed_put(toGtkFixed(_impl), viewController.view._impl, gint( viewOrigin.x ), gint( viewOrigin.y ) )
        
        gtk_widget_show_all( _windowImpl )
        
        
        if( flag.isAnimated() )// flag )
        {
            assert(flag != .NoAnim)
            
            class AnimContext
            {
                static let DeltaMS :UInt32  = 25
                static let DeltaY  :CGFloat = 100
                
                init()
                {
                    
                }
                var window : UIWindow!
                var startOrigin = CGPoint()
                var currentPoint = CGPoint()
                var endOrigin = CGPoint()
                var mode = UIWindow.AnimationMode.NoAnim // default
                var view : UIView!
            }
            
            let animContext = AnimContext()
            animContext.window = self
            
            if( flag == UIWindow.AnimationMode.PresentAnim)
            {
                animContext.startOrigin = CGPoint(x: 0, y: frame.size.height)
                animContext.currentPoint = animContext.startOrigin
            
                animContext.endOrigin = viewController.view.frame.origin
            }
            else if( flag == UIWindow.AnimationMode.DismissAnim)
            {
                animContext.startOrigin = viewOrigin
                animContext.currentPoint = animContext.startOrigin
                
                animContext.endOrigin = CGPoint(x: 0, y: frame.size.height)
            }
            
            animContext.view = viewController.view
            animContext.mode = flag
            
            let ptr = UnsafeMutableRawPointer(Unmanaged.passRetained(animContext).toOpaque())
            // milliseconds
            g_timeout_add_full(G_PRIORITY_DEFAULT, AnimContext.DeltaMS, { (data) -> gboolean in
                // timeout
                let animContext = Unmanaged<AnimContext>.fromOpaque(data!).takeUnretainedValue()
                
                gtk_widget_set_size_request(animContext.window._impl, gint(animContext.window.frame.size.width), gint( animContext.window.frame.size.height) )
                gtk_widget_set_size_request(animContext.window._windowImpl, gint(animContext.window.frame.size.width), gint( animContext.window.frame.size.height) )
                
                gtk_fixed_move ( toGtkFixed( animContext.window._impl),
                                animContext.view._impl,
                    gint( animContext.currentPoint.x),
                    gint( animContext.currentPoint.y)
                )
                
                if( animContext.mode == UIWindow.AnimationMode.PresentAnim)
                {
                    animContext.currentPoint.y -= AnimContext.DeltaY
                    if( animContext.currentPoint.y <= animContext.endOrigin.y )
                    {
                        return 0
                    }
                }
                else if( animContext.mode == UIWindow.AnimationMode.DismissAnim)
                {
                    animContext.currentPoint.y += AnimContext.DeltaY
                    if( animContext.currentPoint.y >= animContext.endOrigin.y )
                    {
                        gtk_fixed_move ( toGtkFixed( animContext.window._impl),
                                         animContext.view._impl,
                                         gint( animContext.startOrigin.x),
                                         gint( animContext.startOrigin.y)
                        )
                        return 0
                    }
                }

                return 1
            }, ptr, { (data) in
                // GDestroyNotify

                _ = Unmanaged<AnimContext>.fromOpaque(data!).release()
            })
        
        } //if( flag.isAnimated() )
        viewController.viewDidAppear( flag.isAnimated() )
    }
    
    
    var currentViewController : UIViewController?
    {
        get
        {
            return _vcList.last
        }
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
        doAddView( rootViewController! ,animationMode: flag ?   .PresentAnim : .NoAnim)
        
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
        
        doAddView(rootViewController!, animationMode: flag ? .DismissAnim : .NoAnim )
        
        lastViewController.view._window = nil
        
        print("End UIViewController.dismiss")
        completion?()
    }
    
    
}


extension UIWindow
{
    
}
