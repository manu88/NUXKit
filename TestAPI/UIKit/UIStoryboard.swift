//
//  UIStoryboard.swift
//  TestAPI
//
//  Created by Manuel Deneu on 31/03/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

import Foundation


@available(iOS 5.0, *)
open class UIStoryboard1 : NSObject
{
   
    public /*not inherited*/ init(name: String, bundle storyboardBundleOrNil: Bundle?)
    {
        
    }
    
    
    open func instantiateInitialViewController() -> UIViewController?
    {
        /*
        if let t = NSClassFromString("TestAPI.ViewController") as? UIViewController.Type
        {
            let viewControler = t.init()
        }
        else
        {
            
        }
        */
        return nil
    }
    /*
    open func instantiateViewController(withIdentifier identifier: String) -> UIViewController
    {
        return nil
    }
    */
}
