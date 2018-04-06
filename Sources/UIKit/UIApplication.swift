//
//  UIApplication.swift
//  TestAPI
//
//  Created by Manuel Deneu on 31/03/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

import Foundation



// If nil is specified for principalClassName, the value for NSPrincipalClass from the Info.plist is used. If there is no
// NSPrincipalClass key specified, the UIApplication class is used. The delegate class will be instantiated using init.
func UIApplicationMain(_ argc: Int32, _ argv: UnsafeMutablePointer<UnsafeMutablePointer<Int8>>!, _ principalClassName: String?, _ delegateClassName: String?) -> Int32
{
    

    guard let delegateClassName = delegateClassName else
    {
        return 1
    }
    
    let app = UIApplication.shared
    
    if let delegateClass = NSClassFromString(delegateClassName) , let deleg = delegateClass.alloc() as? UIApplicationDelegate
    {
        
        app.delegate = deleg
        return  app.UIApplicationMain(0, nil, nil, nil)
    }
    else
    {
        print("[Warning] unable to create class '\(delegateClassName)'")
    }
    
    return 2
}

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
    
    @available(iOS 2.0, *)
    /*optional public*/ func applicationDidBecomeActive(_ application: UIApplication)
    
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
    
    func applicationDidBecomeActive(_ application: UIApplication)
    {}
}

class UIApplication : UIResponder
{
    
    var _win : UIWindow? = nil
    
    @available(iOS 5.0, *)
    public var window: UIWindow?
    {   get
        {
            return _win
        }
        
        set
        {
            _win = newValue
        }
        
    }
    
    
    
    static let _sharedInstance = UIApplication()
    open class var shared: UIApplication
        { get
            {
                g_log_set_always_fatal( G_LOG_LEVEL_CRITICAL )
                return _sharedInstance
            }
        }
    
    
    override init()
    {
        super.init()
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
        
        
        let createWindows = false // set to true if loaded from storyboard/Nib/Xib
        
        if( createWindows)
        {
            window = UIWindow(frame: UIScreen.main.bounds )
            
        }
        
        let d = delegate as! NSObject
        
        
        if( d.responds(to: Selector(("setWindow:")) ))
        {
            //d.setValue(window, forKey: "window")
            d.perform( Selector(("setWindow:") ), with: window)
            //d.setValue(win as UIWindow?, forKey: "window")
            
        }
        else
        {
            print("[Application] The app delegate must implement the window property if it wants to use a main storyboard file.")
        }
        
        if( delegate?.application(self, didFinishLaunchingWithOptions: nil) == false)
        {
            
        }
        
        
        
        window!.presentRootViewController(animated: true) {
            self.delegate?.applicationDidBecomeActive(self)
        }
        
        
        gtk_main();
        return 0
    }
    
    override var next: UIResponder?
    {
        get
        {
            /*
             The shared UIApplication object normally returns nil, but it returns its app delegate if that object is a subclass of UIResponder and has not already been called to handle the event.
             */
            //FIXME : might return delegate
            
            if let d = delegate as? NSObject
            {
                if( d is UIResponder)
                {
                    // '?' or '!' ?
                    return d as? UIResponder
                }
            }
            return nil
            
        }
        
    }
    
    
    
    private func quitSignal()
    {
        gtk_main_quit()
    }
}
