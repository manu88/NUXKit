//
//  UIButton.swift
//  TestAPI
//
//  Created by Manuel Deneu on 02/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

import Foundation

public enum UIButtonType : Int {
    
    
    case custom // no button type
    
    @available(iOS 7.0, *)
    case system // standard system button
    
    
    case detailDisclosure
    
    case infoLight
    
    case infoDark
    
    case contactAdd
    
    
    //public static var roundedRect: UIButtonType { get } // Deprecated, use UIButtonTypeSystem instead
}

open class UIButton : UIControl/*, NSCoding */
{
    
    var _titles : [UInt : String? ] = [ UIControlState.normal.rawValue : "Button"]
    var _colors = [UInt : UIColor? ]()
    
    var _buttonType = UIButtonType.system
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        isHighlighted =  aDecoder.decodeBool(forKey: "UIHighlighted")
        isSelected    =  aDecoder.decodeBool(forKey: "UISelected")
        isEnabled     = !aDecoder.decodeBool(forKey: "UIDisabled")
        
        
        if( aDecoder.containsValue(forKey: "UIContentVerticalAlignment"))
        {
            assert(false) // todo :)
        }
        if( aDecoder.containsValue(forKey: "UIContentHorizontalAlignment"))
        {
            assert(false) // todo :)
            
        }
        
        if( aDecoder.containsValue(forKey: "UIButtonType"))
        {
            if let type = UIButtonType(rawValue: Int( aDecoder.decodeInt64(forKey: "UIButtonType") ) )
            {
                _buttonType = type
            }
        }
        
        /*
         Button decodeObjectForKey UIReversesTitleShadowOnHighlight -> (null)
         Button decodeBoolForKey UIReversesTitleShadowWhenHighlighted -> NO
         Button decodeBoolForKey UIShowsTouchWhenHighlighted -> NO
         Button decodeBoolForKey UIAdjustsImageWhenHighlighted -> YES
         Button decodeBoolForKey UIAdjustsImageWhenDisabled -> YES
         Button decodeBoolForKey UIAdjustsImageSizeForAccessibilityContentSizeCategory -> NO
         Button decodeObjectOfClass NSString key : UIContentEdgeInsets -> (null)
         Button decodeObjectOfClass NSString key : UITitleEdgeInsets -> (null)
         Button decodeObjectOfClass NSString key : UIImageEdgeInsets -> (null)
         */
        
        
        if let states = aDecoder.decodeObject(forKey: "UIButtonStatefulContent") as? [UInt : UIButtonContent]
        {

            for s in states
            {
                let state = UIControlState(rawValue: s.key)
                setTitle(s.value.title, for: state)
            }
        }
        
        /*
         Button decodeObjectForKey UIButtonStatefulContent -> {
         0 = "<UIButtonContent: 0x60400009a270 Title = Button, AttributedTitle = (null), Image = (null), Background = (null), TitleColor = (null), ImageColor = (null), ShadowColor = (null), DrawingStroke = (null)>";
         }
         */
        
        /*
         Button decodeObjectForKey UIFont -> <UICTFont: 0x7f8ef470c360> font-family: ".SFUIText"; font-weight: normal; font-style: normal; font-size: 15.00pt
         Button containsValueForKey UILineBreakMode : NO
         Button decodeObjectOfClass NSString key : UITitleShadowOffset -> (null)
         Button containsValueForKey UISpringLoaded : NO
         */
    }
    
    open func setTitle(_ title: String?, for state: UIControlState) // default is nil. title is assumed to be single line
    {
        
        _titles[state.rawValue] = title
        
        _ = prepare()
    }
    
    open func setTitleColor(_ color: UIColor?, for state: UIControlState) // default if nil. use opaque white
    {
        _colors[state.rawValue] = color
    }
    
    open func titleColor(for state: UIControlState) -> UIColor?
    {
        
        if let c = _colors[state.rawValue]
        {
            return c
        }
        
        return nil
    }
    
    open func title(for state: UIControlState) -> String? // these getters only take a single state value
    {
        
        if let t = _titles[state.rawValue]
        {
            return t
        }
        return nil
    }
    
    open var buttonType: UIButtonType
    {
        get { return _buttonType }
    }
    
    public override func prepare() -> Bool
    {
        if( _impl == nil)
        {
            _impl = gtk_button_new()
            g_object_ref(_impl)
            let ptr = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
            g_signal_connect_with_data(_impl, "clicked", { (widget, data) in
                
                if let data = data
                {
                    let this = Unmanaged<UIButton>.fromOpaque(data).takeUnretainedValue()
                    assert(widget == this._impl)
                    this.invokeAction(controlEvent: .touchUpInside)
                }
                
            }, ptr, nil, GConnectFlags(rawValue: 0))
            
            //return true
        }
        
        assert(_impl != nil)
        assert( GtkIsButton(_impl))

        if let normalTitle = _titles[UIControlState.normal.rawValue]
        {
            gtk_button_set_label(toGtkButton( _impl), normalTitle )
        }
        
        
        
        /*
        g_signal_connect_with_data(_impl, "clicked", { (data) in
            
            if let data = data
            {
                let this = Unmanaged<UIButton>.fromOpaque(data).takeUnretainedValue()
                
                this.invokeAction(controlEvent: .touchUpInside)
            }
            
        }, ptr, nil, GConnectFlags(rawValue: 0))
         */
        assert(_impl != nil)
        return _impl != nil
    }
}
