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
    
    
    private var _view : UIView! = nil
    open var view: UIView! // The getter first invokes [self loadView] if the view hasn't been set yet. Subclasses must call super if they override the setter or getter.
    {
        get
        {
            if( _view == nil)
            {
                loadView()
                
            }
            return _view
        }
        set
        {
            _view = newValue
        }
    }
    open func loadView() // This is where subclasses should create their custom view hierarchy if they aren't using a nib. Should never be called directly.
    {
        _view = UIView(frame: CGRect() )
        viewDidLoad()
    }
    
    open func viewDidLoad() // Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set.
    {}
    
    open func didReceiveMemoryWarning() // Called when the parent application receives a memory warning. On iOS 6.0 it will no longer clear the view by default.
    {}
    
}
