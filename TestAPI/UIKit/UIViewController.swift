//
//  UIViewController.swift
//  TestAPI
//
//  Created by Manuel Deneu on 31/03/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

import Foundation

//@objc(UIViewController)
open class UIViewController : UIResponder, NSCoding /*,UIAppearanceContainer, UITraitEnvironment, UIContentContainer, UIFocusEnvironment*/
{
    // TEST !!!
    required override public init()
    {
        
    }
    public func encode(with aCoder: NSCoder) {
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
    }
    
    open var view: UIView! // The getter first invokes [self loadView] if the view hasn't been set yet. Subclasses must call super if they override the setter or getter.
    
    open func loadView() // This is where subclasses should create their custom view hierarchy if they aren't using a nib. Should never be called directly.
    {
        
    }
    
    open func viewDidLoad() // Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set.
    {}
    
    open func didReceiveMemoryWarning() // Called when the parent application receives a memory warning. On iOS 6.0 it will no longer clear the view by default.
    {}
    
}
