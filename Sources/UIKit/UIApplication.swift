//
//  UIApplication.swift
//  TestAPI
//
//  Created by Manuel Deneu on 31/03/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

import Foundation



public struct UIApplicationLaunchOptionsKey : Hashable, Equatable, RawRepresentable {
    public var rawValue: String
    
    
    public init(_ rawValue: String)
    {
        self.rawValue = rawValue
    }
    
    public init(rawValue: String)
    {
        self.rawValue = rawValue
    }
}

protocol UIApplicationDelegate //: NSObjectProtocol
{
    
    @available(iOS 2.0, *)
    /*optional public*/ func applicationDidFinishLaunching(_ application: UIApplication)

    @available(iOS 6.0, *)
    /*optional public*/ func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?/* = nil*/) -> Bool
 
    
    @available(iOS 3.0, *)
    /*optional public*/ func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? /*= nil*/) -> Bool
    
}

extension UIApplicationDelegate
{
    func applicationDidFinishLaunching(_ application: UIApplication)
    {}
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool
    {
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool
    {
        return true
    }
}

class UIApplication
{
    
    var win : UIWindow? = nil
    
    
    static let _sharedInstance = UIApplication()
    open class var shared: UIApplication
        { get
            {
                g_log_set_always_fatal( G_LOG_LEVEL_CRITICAL )
                return _sharedInstance
            }
        }
    
    
    init()
    {
        
        doPlateformInit()
    }
    
    func doPlateformInit()
    {
        gtk_init(nil, nil);
    }
    
    /*unowned(unsafe)*/ open var delegate: UIApplicationDelegate?
    
    
    // If nil is specified for principalClassName, the value for NSPrincipalClass from the Info.plist is used. If there is no
    // NSPrincipalClass key specified, the UIApplication class is used. The delegate class will be instantiated using init.
    public func UIApplicationMain(_ argc: Int32, _ argv: UnsafeMutablePointer<UnsafeMutablePointer<Int8>>!, _ principalClassName: String?, _ delegateClassName: String?) -> Int32
    {
        
        /*
        let storyboard =  UIStoryboard(name: "/Users/manueldeneu/Documents/projets/TestPortUIKit/TestSimpleView/TestSimpleView/Base.lproj/Main.storyboard", bundle: nil)
        
        if let vc = storyboard.instantiateInitialViewController()
        {
            win.rootViewController = vc
            
            let coder = NSCoder();
            
            vc.view = UIView(coder: coder)
        }
            
        else
        {
            print("UIApplication error : unable to get initial view Controller from Storyboard")
        }

        let d = delegate as! NSObject
        
        
        if( d.responds(to: Selector(("setWindow:"))))
        {
            d.setValue(win, forKey: "window")
            //d.setValue(win as UIWindow?, forKey: "window")
        }
        else
        {
            print("[Application] The app delegate must implement the window property if it wants to use a main storyboard file.")
        }
        
        
        if( win.prepare() == false )
        {
            
        }
        
        g_signal_connect2( win._impl, "destroy",
                           {
            UIApplication.shared.quitSignal()
        } )
         */
        /*
         let ptrToSelf: UnsafeMutableRawPointer = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        g_signal_connect_with_data(win!.window, "destroy", { (data) in

            UIApplication.shared.quitSignal()
        }, ptrToSelf, nil, GConnectFlags(rawValue: 0) )
        */
        
        if( delegate?.application(self, willFinishLaunchingWithOptions: nil) == false )
        {
            
        }
        
        
        
        
        // UIStoryboard.instantiateInitialViewController here

        
        /*
        if  as? UIViewController
        {
            
        }
        */
        
        if( delegate?.application(self, didFinishLaunchingWithOptions: nil) == false)
        {
            
        }
        
        
        
        showWindow()
        
        gtk_main();
        return 0
    }
    
    func showWindow()
    {
        assert(win != nil)
        
        print("showWindow")
        
        if( win!.prepare())
        {
            win!.rootViewController?.view.prepare()
            
            gtk_container_add (toGtkContainer(win!._impl), win!.rootViewController!.view._impl);
            gtk_widget_show_all( win!._impl )
        }
    }
    
    private func quitSignal()
    {
        gtk_main_quit()
    }
}
