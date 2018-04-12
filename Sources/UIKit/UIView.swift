//
//  UIView.swift
//  TestAPI
//
//  Created by Manuel Deneu on 31/03/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

import Foundation


open class UIView : UIResponder, NSCoding/*, UIAppearance, UIAppearanceContainer, UIDynamicItem, UITraitEnvironment, UICoordinateSpace, UIFocusItem, CALayerDelegate*/
{
    
    
    
    
    //open class var layerClass: Swift.AnyClass { get } // default is [CALayer class]. Used when creating the underlying layer for the view.
    //open var layer: CALayer { get } // returns view's layer. Will always return a non-nil value. view is layer's delegate
    var _impl : UnsafeMutablePointer<GtkWidget>? = nil
    
    
    public func prepare() -> Bool
    {
        if (_impl == nil)
        {
            _impl = toGtkWidget( GtkDrawableContainer_new() )// gtk_fixed_new()// gtk_button_new()
            g_object_ref(_impl)
            
            /*
            var defaultColor = GdkRGBA()
            defaultColor.alpha = 1.0
            defaultColor.red   = 1.0
            defaultColor.green = 1.0
            defaultColor.blue  = 1.0
            gtk_widget_override_background_color( _impl, GTK_STATE_FLAG_NORMAL, &defaultColor)
 */
            assert(_impl != nil)
        }
        
        
        return _impl != nil
 

    }
    public init(frame: CGRect)
    {
        _frame = frame
        
    }
    
    public required init?(coder aDecoder: NSCoder)
    {
        super.init()
        
        if( aDecoder.containsValue(forKey: "UIFrame"))
        {
                assert(false) // todo :)
        }
        
        let bounds_ = aDecoder.decodeRect(forKey: "UIBounds")
        if( bounds_ != CGRect.zero)
        {
            _frame = bounds_
        }
    
        if let center = aDecoder.decodeObject(of: NSString.self, forKey: "UICenter")
        {
            assert(false && (center != center) ) // todo :)
        }
        if let transform = aDecoder.decodeObject(of: NSString.self, forKey: "UITransform")
        {
            assert(false && (transform != transform) ) // todo :)
        }
        
        let deepDrawRect = aDecoder.decodeBool(forKey: "UIDeepDrawRect")
        assert(deepDrawRect == true) // temp! don't know what to do with this one...
        
        
        if let tintCol = aDecoder.decodeObject( forKey: "UITintColor") as? UIColor
        {
            _tintColor = tintCol
        }
    
        do
        {
            if let subViews = try aDecoder.decodeTopLevelObject( forKey: "UISubviews") as? [UIView]
            {
                //self._subviews = subViews
                
                for v in subViews
                {
                    addSubview(v)
                }
            }
            else
            {
                
            }
        }
        catch
        {
            
        }
        
        isHidden = aDecoder.decodeBool(forKey: "UIHidden")
        
        
        if let backCol = aDecoder.decodeObject(forKey: "UIBackgroundColor") as? UIColor
        {
            backgroundColor = backCol
        }
        //return self
    }
 
    public func encode(with aCoder: NSCoder)
    {
        fatalError("Implement me :)")
        
    }
    
    deinit
    {
        if( _impl != nil)
        {
            g_object_unref(_impl)
            gtk_widget_destroy( _impl)
        }
    }
    
    
    open func draw(_ rect: CGRect)
    {}
    
    open func didAddSubview(_ subview: UIView)
    {
        
    }
    
    /*
     UIView implements this method and returns the UIViewController object that manages it (if it has one) or its superview (if it doesn’t).
     */
    override open var next: UIResponder?
    {
        get
        {
            if( _viewController != nil)
            {
                return _viewController
            }
            
            return _superview
        }
    }
    
    
    
    // Temp Method!
    func setViewController( _ vc: UIViewController?)
    {
        _viewController = vc
    }
    
    
    private var _viewController : UIViewController? = nil
    //private var _view: UnsafeMutablePointer<GtkWidget>? = nil
    private var _superview : UIView? = nil
    internal var _window : UIWindow? = nil
    private var _subviews = [UIView]()
    
    private var _bounds = CGRect()
    private var _frame = CGRect()
    private var _tag = 0
    
    private var _opaque = true
    private var _hidden = false
    
    internal var _tintColor : UIColor? = nil
}

extension UIView // Color and parameters
{
    open var tag: Int // default is 0
    {
        get {return _tag}
        set { _tag = newValue }
        
    }
    
    open var isOpaque: Bool // default is YES. opaque views must fill their entire bounds or the results are undefined. the active CGContext in drawRect: will not have been cleared and may have non-zeroed pixels
    {
        get
        {
            return _opaque;
        }
        set
        {
            _opaque = newValue
        }
    }
    open var isHidden: Bool // default is NO. doesn't check superviews
    {
        get
        {
            if( _impl != nil)
            {
                return gtk_widget_get_visible( _impl) == 0
            }
            return _hidden
        }
        
        set
        {
            if( _impl != nil)
            {
                if( newValue == true)
                {
                    gtk_widget_set_visible(_impl, 0 )
                }
                else
                {
                    gtk_widget_set_visible(_impl, 1 )
                }
            }
            else
            {
                _hidden = newValue
            }
            
        }
    }
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
            
                _ = prepare()
                assert(_impl != nil)

                let context = gtk_widget_get_style_context(_impl);
                
                let provider = gtk_css_provider_new()
                
                let vR = UInt8( newColor.red * 255 )
                let vG = UInt8( newColor.green * 255 )
                let vB = UInt8( newColor.blue * 255 )
                let vA = UInt8( newColor.alpha * 255 )
                
                let cssStr = "window * { color: red; background-color: rgba(\(vR),\(vG),\(vB),\(vA)); }"
                
                gtk_css_provider_load_from_data( provider, cssStr ,-1,  nil)
                
                gtk_style_context_add_provider(context, toGtkStyleProvider(provider), guint(GTK_STYLE_PROVIDER_PRIORITY_USER))
                
                g_object_unref(provider)
                
                setNeedsDisplay()
                
                /*
                gtk_style_context_add_provider_for_screen(gdk_display_get_default_screen(gdk_display_get_default()), toGtkStyleProvider(provider), guint(GTK_STYLE_PROVIDER_PRIORITY_USER))
                */
                //gtk_widget_override_background_color( _impl!, GTK_STATE_FLAG_NORMAL, &color)

                
            }
            
        }
    }
    
    
    /*
     -tintColor always returns a color. The color returned is the first non-default value in the receiver's superview chain (starting with itself).
     If no non-default value is found, a system-defined color is returned.
     If this view's -tintAdjustmentMode returns Dimmed, then the color that is returned for -tintColor will automatically be dimmed.
     If your view subclass uses tintColor in its rendering, override -tintColorDidChange in order to refresh the rendering if the color changes.
     */
    @available(iOS 7.0, *)
    open var tintColor: UIColor!
    {
        get
        {
            if let tint = _tintColor
            {
                return tint
            }
            if let superV = _superview
            {
                return superV.tintColor
            }
            
            return UIColor.white
            
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
    
    
    internal func applyDefaultStyleBase()
    {
        assert(_impl != nil)
        
    }
    
}
