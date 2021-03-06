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
         TextField containsValueForKey UIRoundedRectBackgroundCornerRadius : NO
         TextField containsValueForKey UIAllowsEditingTextAttributes : NO
         */
        
         text = aDecoder.decodeObject(forKey: "UIText") as? String
        
         //TextField decodeObjectForKey UIAttributedText -> (null)
        
        if ( aDecoder.containsValue(forKey: "UITextAlignment"))
        {
            textAlignment = NSTextAlignment(rawValue: Int( aDecoder.decodeInt64(forKey: "UITextAlignment") ) )!
        }
        
        /*
         
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
    
    
    weak open var delegate: UITextFieldDelegate? = nil // default is nil. weak reference
    
    open var text: String?  // default is nil
    {
        get
        {
            return String(cString:  gtk_entry_get_text( toGtkEntry(_impl)) )
        }
        set
        {
            if (newValue != nil)
            {
                gtk_entry_set_text(toGtkEntry(_impl), newValue )
            }
        }
    }
    
    
    open var placeholder: String? // default is nil. string is drawn 70% gray
    {
        get
        {
            return String(cString:  gtk_entry_get_placeholder_text( toGtkEntry(_impl)) )
        }
        set
        {
            gtk_entry_set_placeholder_text(toGtkEntry(_impl), newValue )
        }
    }
    
    @available(iOS 6.0, *)
    @NSCopying open var attributedText: NSAttributedString? // default is nil
    
    open var textColor: UIColor? // default is nil. use opaque black
    
    //open var font: UIFont? // default is nil. use system font 12 pt
    
    open var textAlignment: NSTextAlignment  // default is NSLeftTextAlignment
    {
        get
        {
            /*
             The horizontal alignment, from 0 (left) to 1 (right). Reversed for RTL layouts
             */
            let rawVal = gtk_entry_get_alignment( toGtkEntry(_impl))
            
            switch rawVal
            {
            case 0.0..<0.4:
                return .left
            case 0.4..<0.6:
                return .center
            case 0.6..<1.0:
                return .right
            default:
                assert(false)
                return .left
            }

        }
        set
        {
            var val : Float = -1.0
            
            switch newValue
            {
            case .left:
                val = 0.0
            case .center:
                val = 0.5
            case .right:
                val = 1.0
            default:
                assert(false)
            }
            
            gtk_entry_set_alignment( toGtkEntry(_impl) , val)
            
        }
    }
    
    open var borderStyle: UITextBorderStyle = .none // default is UITextBorderStyleNone. If set to UITextBorderStyleRoundedRect, custom background images are ignored.
    
    /*
    @available(iOS 7.0, *)
    open var defaultTextAttributes: [String : Any] // applies attributes to the full range of text. Unset attributes act like default values.
    */
    
    
    
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
    
public protocol UITextFieldDelegate : NSObjectProtocol {
    
    
    @available(iOS 2.0, *)
    /*optional public*/ func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool // return NO to disallow editing.
    
    @available(iOS 2.0, *)
    /*optional public*/ func textFieldDidBeginEditing(_ textField: UITextField) // became first responder
    
    @available(iOS 2.0, *)
    /*optional public*/ func textFieldShouldEndEditing(_ textField: UITextField) -> Bool // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
    
    @available(iOS 2.0, *)
    /*optional public*/ func textFieldDidEndEditing(_ textField: UITextField) // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    
    @available(iOS 10.0, *)
    /*optional public*/ func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) // if implemented, called in place of textFieldDidEndEditing:
    
    
    @available(iOS 2.0, *)
    /*optional public*/ func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool // return NO to not change text
    
    
    @available(iOS 2.0, *)
    /*optional public*/ func textFieldShouldClear(_ textField: UITextField) -> Bool // called when clear button pressed. return NO to ignore (no notifications)
    
    @available(iOS 2.0, *)
    /*optional public*/ func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    }
