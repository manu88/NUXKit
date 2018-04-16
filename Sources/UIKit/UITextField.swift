    //
//  UITextField.swift
//  NUXKit
//
//  Created by Manuel Deneu on 16/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

import Foundation




public enum UITextBorderStyle : Int {
    
    
    case none
    
    case line
    
    case bezel
    
    case roundedRect
}

public enum UITextFieldViewMode : Int {
    
    
    case never
    
    case whileEditing
    
    case unlessEditing
    
    case always
}

@available(iOS 10.0, *)
public enum UITextFieldDidEndEditingReason : Int {
    
    
    case committed
}

@available(iOS 2.0, *)
open class UITextField : UIControl
                /*, UITextInput*/  /*NSCoding SAID TO BE REDUNDANT FROM INHERITANCE BY UIControl->UIView->NSCoding*//*, UIContentSizeCategoryAdjusting */
{
    
    
    public required init?(coder aDecoder : NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    open var text: String? = nil // default is nil
    
    @available(iOS 6.0, *)
    @NSCopying open var attributedText: NSAttributedString? // default is nil
    
    open var textColor: UIColor? // default is nil. use opaque black
    
    //open var font: UIFont? // default is nil. use system font 12 pt
    
    open var textAlignment: NSTextAlignment = .left // default is NSLeftTextAlignment
    
    open var borderStyle: UITextBorderStyle = .none // default is UITextBorderStyleNone. If set to UITextBorderStyleRoundedRect, custom background images are ignored.
    
    @available(iOS 7.0, *)
    //open var defaultTextAttributes: [String : Any] // applies attributes to the full range of text. Unset attributes act like default values.
    
    
    open var placeholder: String? = nil // default is nil. string is drawn 70% gray
    
    @available(iOS 6.0, *)
    @NSCopying open var attributedPlaceholder: NSAttributedString? = nil // default is nil
    
    
    public override func prepare() -> Bool
    {
        if( _impl == nil)
        {
            _impl = gtk_entry_new()
        }
        
        return _impl != nil
    }
}
