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
    
    
    //open class var layerClass: Swift.AnyClass { get } // default is [CALayer class]. Used when creating the underlying layer for the view.
    //open var layer: CALayer { get } // returns view's layer. Will always return a non-nil value. view is layer's delegate
    var _impl : UnsafeMutablePointer<GtkWidget>? = nil
    
    
    public func prepare() -> Bool
    {
        if (_impl == nil)
        {
            _impl = gtk_fixed_new()// gtk_button_new()
            
            var defaultColor = GdkRGBA()
            defaultColor.alpha = 1.0
            defaultColor.red   = 1.0
            defaultColor.green = 1.0
            defaultColor.blue  = 1.0
            gtk_widget_override_background_color( _impl, GTK_STATE_FLAG_BACKDROP, &defaultColor)
            assert(_impl != nil)
        }
        
        
        return _impl != nil
 

    }
    public init(frame: CGRect)
    {
        _frame = frame
    }
    
    public init?(coder aDecoder: NSCoder)
    {
        return nil
    }
    
    deinit
    {
        if( _impl != nil)
        {
            
            gtk_widget_destroy( _impl)
        }
    }
    
    
    open func didAddSubview(_ subview: UIView)
    {
        
    }
    
    
    private var view: UnsafeMutablePointer<GtkWidget>? = nil
    private var _superview : UIView? = nil
    private var _window : UIWindow? = nil
    private var _subviews = [UIView]()
    
    private var _bounds = CGRect()
    private var _frame = CGRect()
}

extension UIView // Color and parameters
{
    open var backgroundColor: UIColor? // default is nil. Can be useful with the appearance proxy on custom UIView subclasses.
    {
        get
        {
            return nil
        }
        set
        {
            var color = GdkRGBA()
            
            if let newColor = newValue
            {
                color.red   = gdouble( newColor.red   )
                color.green = gdouble( newColor.green )
                color.blue  = gdouble( newColor.blue  )
                color.alpha = gdouble( newColor.alpha )
            
                prepare()
                assert(_impl != nil)
                
                if( _impl != nil)
                {
                    gtk_widget_override_background_color( _impl, GTK_STATE_FLAG_NORMAL, &color)
                    
                }
                
            }
            
        }
    }
    
    open var alpha: CGFloat // animatable. default is 1.0
        {
            get
            {
                return 1.0
            }
            set
            {
                
            }
        }

}

extension UIView // geometry
{
    // use bounds/center and not frame if non-identity transform. if bounds dimension is odd, center may be have fractional part
    open var bounds: CGRect // default bounds is zero origin, frame size. animatable
        {
        get { return _bounds}
        }
    
    // animatable. do not use frame if view is transformed since it will not correctly reflect the actual location of the view. use bounds + center instead.
    open var frame: CGRect // default bounds is zero origin, frame size. animatable
        {
        get { return _frame}
    }
}

extension UIView // Draw
{
    open func setNeedsDisplay()
    {
        print("gtk_widget_show")
        gtk_widget_show(_impl)
    }
}


extension UIView // Hierarchy
{
    open var superview: UIView?
        { get
            {
                return _superview
            }
        
        }
    
    open var subviews: [UIView] { get {return _subviews }}
    
    open var window: UIWindow?
        { get
            {
                return _window
            }
        }
    
    open func addSubview(_ view: UIView)
    {
        
        if( _subviews.contains(view))
        {
            return
        }
        
        if( view._impl == nil)
        {
            if( view.prepare() == false)
            {
                assert(false)
            }
        }
        
        if( prepare() == false)
        {
            assert(false)
        }
        
        gtk_widget_show(view._impl);
        gtk_fixed_put(toGtkFixed(_impl), view._impl, gint( view.frame.origin.x ), gint( view.frame.origin.y ) )
        
        doAddSubview(subview: view)
        

        //setNeedsDisplay()
    }
    
    private func doAddSubview( subview : UIView)
    {
        _subviews.append( subview )
        subview._superview = self
        
        
        didAddSubview( subview )
    }
    
    
}
