//
//  UILabel.swift
//  TestAPI
//
//  Created by Manuel Deneu on 02/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

import Foundation

class UILabel : UIView
{
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        
        
        /*
         decodeObjectForKey UIHighlightedColor -> (null)
         decodeObjectForKey UIShadowColor -> (null)
         decodeObjectOfClass NSString key : UIShadowOffset -> (null)
         containsValueForKey UINumberOfLines : NO
         containsValueForKey UIBaselineAdjustment : NO
         decodeBoolForKey UIAdjustsFontSizeToFit -> NO
         decodeBoolForKey UIAdjustsLetterSpacingToFit -> NO
         containsValueForKey UIEnabled : NO
         containsValueForKey UIPreferredMaxLayoutWidth : NO
         containsValueForKey UIAdjustsFontForContentSizeCategory : NO
         decodeObjectForKey UIFont -> <UICTFont: 0x7f9970c09810> font-family: ".SFUIText"; font-weight: normal; font-style: normal; font-size: 17.00pt
         */
         //decodeObjectForKey UITextColor -> UIExtendedGrayColorSpace 0 1
        if let textCol = aDecoder.decodeObject(forKey: "UITextColor") as? UIColor
        {
            self.textColor = textCol
        }
        /*
         decodeInt64ForKey UIMinimumFontSize -> 0.000000
         containsValueForKey UILineBreakMode : NO
         containsValueForKey UITextAlignment : YES
         decodeInt64ForKey UITextAlignment -> 4
         decodeBoolForKey UIAllowsDefaultTighteningForTruncation -> NO
         decodeObjectForKey UIAttributedText -> (null)
         */
        self.text = aDecoder.decodeObject(forKey: "UIText") as? String
        
        /*
         containsValueForKey UIDisableUpdateTextColorOnTraitCollectionChange : YES
         decodeBoolForKey UIDisableUpdateTextColorOnTraitCollectionChange -> NO
         */
        
        
    }
    private var _text : String? = nil
    private var _textColor : UIColor! = nil
    open var text: String? // default is nil
    {
        set
        {
            _text = newValue
            
            _ = prepare()
        }
        get
        {
            return _text
        }
    }
    
    open var textColor: UIColor! // default is nil (text draws black)
    {
        get
        {
            return _textColor
        }
        set
        {
            _textColor = newValue
        }
    }
    
    
    
    override func prepare() -> Bool {
        if( _impl == nil)
        {
            _impl = gtk_label_new( "" /*"Test"*/)
            g_object_ref(_impl)
        }
        
        if let t = text
        {
            gtk_label_set_text(toGtkLabel( _impl), t)
        }
        
        return true
    }
}
