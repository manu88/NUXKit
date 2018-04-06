//
//  AppDelegate.swift
//  TestNoStoryboard
//
//  Created by Manuel Deneu on 02/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

#if os(iOS)
import UIKit
#endif

/* This is somewhat complicated to do conditional compilation for '@UIApplicationMain' to disapear for NUXKit builds.
 So for now, a main.swift as to be created with:
 
 `exit(UIApplicationMain(0,nil , nil, APP_DELEGATE_CLASS_NAME))`
 
 note : APP_DELEGATE_CLASS_NAME must be something like ModuleName.AppDelegate , ModuleName being the name of the module/app.
 */
//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    @objc var window: UIWindow? = nil
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        assert(window == nil)
        
        window = UIWindow(frame: UIScreen.main.bounds )
        
        
        window!.rootViewController = ViewController()
        
        print("AppDelegate.didFinishLaunchingWithOptions rootView is \(String(describing: window!.rootViewController?.view))")
        window!.rootViewController?.view.backgroundColor = UIColor.white
        
        
        window!.makeKeyAndVisible()
        
        
        let win2 = UIWindow(frame: UIScreen.main.bounds)
        assert(win2.next == UIApplication.shared)
        
        
        return true
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        // seems that AppDelegate MUST be a UIResponder
        assert(application.next == self)
        /*
         if( self is UIResponder)
         {
         assert(application.next == self)
         }
         else
         {
         assert(application.next == nil)
         }
         */
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

