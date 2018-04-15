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

    

    /*
     NO if the app cannot handle the URL resource or continue a user activity, or if the app should not perform the application:performActionForShortcutItem:completionHandler: method because you’re handling the invocation of a Home screen quick action in this method; otherwise return YES. The return value is ignored if the app is launched as a result of a remote notification.
     */
    @available(iOS 6.0, *)
    /*optional public*/ func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?/* = nil*/) -> Bool
 
    /*
     Return Value
     NO if the app cannot handle the URL resource or continue a user activity, otherwise return YES. The return value is ignored if the app is launched as a result of a remote notification.
     */
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
    
    fileprivate var storyboard : UIStoryboard! = nil
    
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
    @objc open class var shared: UIApplication
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
    
    fileprivate func createWindowIfNeeded() -> Bool
    {

        if( window == nil )
        {
            window = UIWindow(frame: UIScreen.main.bounds )
        }

        let d = delegate as! NSObject
        
        if( d.responds(to: Selector(("setWindow:")) ))
        {
            d.perform( Selector(("setWindow:") ), with: window)
        }
        else
        {
            print("[Application] The app delegate must implement the window property if it wants to use a main storyboard file.")
            
            return false
        }
        
        return true
    }
    
    
    fileprivate func loadStoryboard(_ storyboardFile : String? ) -> Bool
    {
        guard let storyboardFile = storyboardFile else
        {
            return false
        }
        
        storyboard =  UIStoryboard(name: storyboardFile, bundle: nil)
        
        if let vc = storyboard.instantiateInitialViewController()
        {
            print("Did find an initial view controller")
            
            //window = UIWindow(frame: UIScreen.main.bounds )
            
            if( createWindowIfNeeded() == false )
            {
                
            }
            window?.rootViewController = vc
            
            return true
            
        }
        else
        {
            print("Did NOT find an initial view controller")
        }
        
        
        return false
    }
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
        
        
        
        let storyboardURL = "/Users/manueldeneu/Documents/projets/TestPortUIKit/NUXKit/Sources/TestUIStoryBoard/TestStoryBoard/Base.lproj/Main.storyboard"
        
        if( loadStoryboard( storyboardURL ) )
        {
            print("Storyboard load OK")
            
        }
        else
        {
            print("Storyboard load ERROR")
        }
        
        
        /*
          We only care of returned values IF the application was invoked from another app, or service.
         For a 'normal' launch ( or remote) discard the returned value
         */
        if( delegate?.application(self, willFinishLaunchingWithOptions: nil) == false )
        {
            
        }

        let createWindows = false // set to true if loaded from storyboard/Nib/Xib
        
        if( createWindows)
        {
            window = UIWindow(frame: UIScreen.main.bounds )
            
        }
        
        /*
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
        */
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
    
    
    @objc fileprivate func segueDestination(sender : AnyObject)
    {
        
        
        if let senderID = storyboard.getSegueTargetIDFromSender(sender)
        {
            print("Do segue to \( senderID)")
        }
        
    /*
    
    assert(sender);
    NSValue *myKey = [NSValue valueWithNonretainedObject:sender];
    
    NSString* destId = [_segueSenders objectForKey: myKey];
    assert(destId);
    
    NSLog(@"Dest id is %@ " , destId);
    
    */
    }
}
