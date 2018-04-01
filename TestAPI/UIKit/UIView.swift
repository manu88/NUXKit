//
//  UIView.swift
//  TestAPI
//
//  Created by Manuel Deneu on 31/03/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

import Foundation


open class UIView : UIResponder/*, NSCoding, UIAppearance, UIAppearanceContainer, UIDynamicItem, UITraitEnvironment, UICoordinateSpace, UIFocusItem, CALayerDelegate*/
{
    public init(frame: CGRect)
    {
        
    }
    
    public init?(coder aDecoder: NSCoder)
    {
        return nil
    }
    
    private var view: UnsafeMutablePointer<GtkWidget>? = nil
    
    private var _superView : UIView? = nil
    private var _window : UIWindow? = nil
    private var _subViews = [UIView]()
}


extension UIView // Hierarchy
{
    open var superview: UIView?
        { get
            {
                return _superView
            }
        }
    
    open var subviews: [UIView] { get {return _subViews }}
    
    open var window: UIWindow?
        { get
            {
                return _window
            }
        }
}
