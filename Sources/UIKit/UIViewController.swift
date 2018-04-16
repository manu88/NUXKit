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
    
    public required init?(coder aDecoder: NSCoder)
    {
        super.init()
        
        /*
         Ask for decodeObject: UIView
         Ask for decodeObject: UITitle
         Ask for decodeObject: UITabBarItem
         Ask for decodeObject: UINavigationItem
         Ask for decodeObject: UIParentViewController
         Ask for decodeBool: UIWantsFullScreenLayout
         Ask for containsValue: UIAutoresizesArchivedViewToFullSize
         Ask for decodeBool: UIAutoresizesArchivedViewToFullSize
         Ask for decodeObject: UIStoryboardSegueTemplates
         Ask for decodeObject: UIStoryboardPreviewSegueTemplates
         Ask for decodeObject: UIStoryboardCommitSegueTemplates
         Ask for decodeObject: UIStoryboardPreviewingRegistrants
         Ask for decodeObject: UIExternalObjectsTableForViewLoading
         Ask for decodeObject: UITopLevelObjectsToKeepAliveFromStoryboard
         Ask for decodeObject: UINibName
         Ask for containsValue: UINibBundleIdentifier
         Ask for decodeObject: UINibBundleIdentifier
         Ask for decodeObject: UIToolbarItems
         Ask for decodeObject: UIChildViewControllers
         Ask for containsValue: UIDefinesPresentationContext
         Ask for decodeBool: UIDefinesPresentationContext
         Ask for decodeBool: UIProvidesPresentationContextTransitionStyle
         Ask for containsValue: UIRestoresFocusAfterTransition
         Ask for decodeBool: UIRestoresFocusAfterTransition
         Ask for containsValue: UIModalTransitionStyle
         Ask for decodeInt64: UIModalTransitionStyle
         Ask for containsValue: UIModalPresentationStyle
         Ask for decodeInt64: UIModalPresentationStyle
         Ask for decodeBool: UIHidesBottomBarWhenPushed
         Ask for containsValue: UIContentSizeForViewInPopover
         Ask for decodeObject: UIContentSizeForViewInPopover
         Ask for containsValue: UIPreferredContentSize
         Ask for decodeObject: UIPreferredContentSize
         Ask for decodeObject: UIRestorationIdentifier
         Ask for decodeObject: UIStoryboardIdentifier
         Ask for containsValue: UIKeyCommands
         Ask for decodeObject: UIKeyCommands
         Ask for containsValue: UIAddedKeyCommands
         Ask for decodeObject: UIAddedKeyCommands
         Ask for containsValue: UIKeyEdgesForExtendedLayout
         Ask for decodeInt64: UIKeyEdgesForExtendedLayout
         Ask for containsValue: UIKeyExtendedLayoutIncludesOpaqueBars
         Ask for decodeInt64: UIKeyExtendedLayoutIncludesOpaqueBars
         Ask for containsValue: UIKeyAutomaticallyAdjustsScrollViewInsets
         Ask for decodeInt64: UIKeyAutomaticallyAdjustsScrollViewInsets
         Ask for containsValue: UIViewControllerViewRespectsSystemMinimumLayoutMargins
         Ask for decodeBool: UIViewControllerViewRespectsSystemMinimumLayoutMargins
         Ask for decodeObject: UIViewControllerTopLayoutGuide
         Ask for decodeObject: UIViewControllerBottomLayoutGuide
         */
        /*
        do
        {
            if let view = try aDecoder.decodeTopLevelObject( forKey: "UIView") as? UIView
            {
                self.view = view
            }
            else
            {
                return nil
            }
            
        }
        catch
        {
            return nil
        }
 */

    }
    
    
    private var _view : UIView! = nil
    @objc open var view: UIView! // The getter first invokes [self loadView] if the view hasn't been set yet. Subclasses must call super if they override the setter or getter.
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
        view.window?.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    // The completion handler, if provided, will be invoked after the dismissed controller's viewDidDisappear: callback is invoked.
    @available(iOS 5.0, *)
    open func dismiss(animated flag: Bool, completion: (() -> Swift.Void)? = nil)
    {
        view.window?.dismiss(animated: flag, completion: completion)
    }
    
    open func viewWillAppear(_ animated: Bool) // Called when the view is about to made visible. Default does nothing
    {}
    open func viewDidAppear(_ animated: Bool) // Called when the view has been fully transitioned onto the screen. Default does nothing
    {}
    open func viewWillDisappear(_ animated: Bool) // Called when the view is dismissed, covered or otherwise hidden. Default does nothing
    {}
    open func viewDidDisappear(_ animated: Bool) // Called after the view was dismissed, covered or otherwise hidden. Default does nothing
    {}
    
    
    
    @available(iOS 5.0, *)
    open func performSegue(withIdentifier identifier: String, sender: Any?)
    {
        
    }
    
    @available(iOS 6.0, *)
    open func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool // Invoked immediately prior to initiating a segue. Return NO to prevent the segue from firing. The default implementation returns YES. This method is not invoked when -performSegueWithIdentifier:sender: is used.
    {
        return true
    }
    
    @available(iOS 5.0, *)
    open func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
    }
}
