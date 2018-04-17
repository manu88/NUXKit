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
        
        /*
         TextField containsValueForKey UIContentVerticalAlignment : NO
         TextField containsValueForKey UIContentHorizontalAlignment : YES
         TextField decodeInt64ForKey UIContentHorizontalAlignment -> 1
         TextField containsValueForKey UIRoundedRectBackgroundCornerRadius : NO
         TextField containsValueForKey UIAllowsEditingTextAttributes : NO
         */
        
         text = aDecoder.decodeObject(forKey: "UIText") as? String
        
         //TextField decodeObjectForKey UIAttributedText -> (null)
        /*
         TextField containsValueForKey UITextAlignment : YES
         TextField decodeInt64ForKey UITextAlignment -> 4
         TextField decodeObjectForKey UIFont -> <UICTFont: 0x7fcf0af057f0> font-family: ".SFUIText"; font-weight: normal; font-style: normal; font-size: 14.00pt
         TextField decodeObjectForKey UITextColor -> UIExtendedGrayColorSpace 0 1
         TextField containsValueForKey UIAdjustsFontForContentSizeCategory : NO
         TextField decodeObjectForKey UIDelegate -> (null)
         TextField decodeBoolForKey UIClearsOnBeginEditing -> NO
         TextField decodeBoolForKey UIAdjustsFontSizeToFit -> YES
         TextField decodeInt64ForKey UIMinimumFontSize -> 17.000000
         TextField containsValueForKey UIBorderStyle : YES
         TextField decodeInt64ForKey UIBorderStyle -> 3
         TextField containsValueForKey UIClearButtonMode : NO
         */
        placeholder = aDecoder.decodeObject(forKey: "UIPlaceholder") as? String
        /*
         TextField decodeObjectForKey UILeftView -> (null)
         TextField decodeObjectForKey UIRightView -> (null)
         TextField decodeObjectForKey UITextFieldBackground -> (null)
         TextField decodeObjectForKey UITextFieldDisabledBackground -> (null)
         TextField containsValueForKey UIBecomesFirstResponderOnClearButtonTap : NO
         TextField decodeCGPointForKey UIClearButtonOffset -> {3.000000 1.000000 }
         TextField decodeObjectOfClass NSString key : UIPadding -> (null)
         TextField containsValueForKey UIAutocapitalizationType : NO
         TextField containsValueForKey UIAutocorrectionType : NO
         TextField containsValueForKey UISpellCheckingType : NO
         TextField containsValueForKey UIDisableTextColorUpdateOnTraitCollectionChange : YES
         TextField decodeBoolForKey UIDisableTextColorUpdateOnTraitCollectionChange -> NO
         TextField containsValueForKey UIKeyboardAppearance : NO
         TextField containsValueForKey UIKeyboardType : NO
         TextField containsValueForKey UIReturnKeyType : NO
         TextField decodeBoolForKey UIEnablesReturnKeyAutomatically -> NO
         TextField decodeObjectOfClass NSString key : UITextContentType -> (null)
         TextField containsValueForKey UITextSmartInsertDeleteType : NO
         TextField containsValueForKey UITextSmartQuotesType : NO
         TextField containsValueForKey UITextSmartDashesType : NO
         TextField decodeBoolForKey UISecureTextEntry -> NO
         TextField decodeObjectForKey UIIcon -> (null)
         */
    }
    
    open var text: String?  // default is nil
    {
        get
        {
            return String(cString:  gtk_entry_get_text( toGtkEntry(_impl)) )
        }
        set
        {
            gtk_entry_set_text(toGtkEntry(_impl), newValue )
        }
    }
    
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
            
            let ptr = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
            
            /* editingChanged callback */
            g_signal_connect_with_data(_impl, "changed", { (widget, data) in
                
                if let data = data
                {
                    let this = Unmanaged<UIButton>.fromOpaque(data).takeUnretainedValue()
                    assert(widget == this._impl)
                    this.invokeAction(controlEvent: .editingChanged)
                }
                
            }, ptr, nil, GConnectFlags(rawValue: 0))
            
            /* editingDidEndOnExit callback */
            
            g_signal_connect_with_data(_impl, "activate", { (widget, data) in
                
                if let data = data
                {
                    let this = Unmanaged<UIButton>.fromOpaque(data).takeUnretainedValue()
                    assert(widget == this._impl)
                    this.invokeAction(controlEvent: .editingDidEndOnExit)
                }
                
            }, ptr, nil, GConnectFlags(rawValue: 0))
            
        }
        
        return _impl != nil
    }
}
