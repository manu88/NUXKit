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

    
    
    /*
     The designated initializer. If you subclass UIViewController, you must call the super implementation of this
     method, even if you aren't using a NIB.  (As a convenience, the default init method will do this for you,
     and specify nil for both of this methods arguments.) In the specified NIB, the File's Owner proxy should
     have its class set to your view controller subclass, with the view outlet connected to the main view. If you
     invoke this method with a nil nib name, then this class' -loadView method will attempt to load a NIB whose
     name is the same as your view controller's class. If no such NIB in fact exists then you must either call
     -setView: before -view is invoked, or override the -loadView method to set up your views programatically.
     */
    public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init()
        
        
        
    }
    
    // Where is this located in UIKit?
    convenience override init()
    {
        self.init(nibName: nil, bundle: nil)
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
        _view.setViewController(self)
        viewDidLoad()
    }
    
    open func viewDidLoad() // Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set.
    {}
    
    open func didReceiveMemoryWarning() // Called when the parent application receives a memory warning. On iOS 6.0 it will no longer clear the view by default.
    {}
    
    
    /*
     The next two methods are replacements for presentModalViewController:animated and
     dismissModalViewControllerAnimated: The completion handler, if provided, will be invoked after the presented
     controllers viewDidAppear: callback is invoked.
     */
    @available(iOS 5.0, *)
    open func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Swift.Void)? = nil)
    {
        print("Begin UIViewController.present")
        
        print("End UIViewController.present")
        
        if (completion != nil)
        {
            DispatchQueue.main.async {
                completion!()
            }
        }
        
    }
    
    // The completion handler, if provided, will be invoked after the dismissed controller's viewDidDisappear: callback is invoked.
    @available(iOS 5.0, *)
    open func dismiss(animated flag: Bool, completion: (() -> Swift.Void)? = nil)
    {
        
    }
    
    open func viewWillAppear(_ animated: Bool) // Called when the view is about to made visible. Default does nothing
    {}
    open func viewDidAppear(_ animated: Bool) // Called when the view has been fully transitioned onto the screen. Default does nothing
    {}
    open func viewWillDisappear(_ animated: Bool) // Called when the view is dismissed, covered or otherwise hidden. Default does nothing
    {}
    open func viewDidDisappear(_ animated: Bool) // Called after the view was dismissed, covered or otherwise hidden. Default does nothing
    {}
}
