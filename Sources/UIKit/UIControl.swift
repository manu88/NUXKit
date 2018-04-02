//
//  UIControl.swift
//  TestAPI
//
//  Created by Manuel Deneu on 02/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

import Foundation

public struct UIControlEvents : OptionSet {
    public var rawValue: UInt
    
    
    public init(rawValue: UInt)
    {
        self.rawValue = rawValue
    }
    
    
    public static var touchDown: UIControlEvents { get {return UIControlEvents(rawValue: 1)} } // on all touch downs
    
    public static var touchDownRepeat: UIControlEvents { get {return UIControlEvents(rawValue: 2)}} // on multiple touchdowns (tap count > 1)
    
    public static var touchDragInside: UIControlEvents { get  {return UIControlEvents(rawValue: 4)}}
    
    public static var touchDragOutside: UIControlEvents { get {return UIControlEvents(rawValue: 8)}}
    
    public static var touchDragEnter: UIControlEvents { get {return UIControlEvents(rawValue: 16)}}
    
    public static var touchDragExit: UIControlEvents { get {return UIControlEvents(rawValue: 32)}}
    
    public static var touchUpInside: UIControlEvents { get {return UIControlEvents(rawValue: 64)}}
    
    public static var touchUpOutside: UIControlEvents { get {return UIControlEvents(rawValue: 128)}}
    
    public static var touchCancel: UIControlEvents { get {return UIControlEvents(rawValue: 128)}}
    
    
    public static var valueChanged: UIControlEvents { get {return UIControlEvents(rawValue: 4096)}} // sliders, etc.
    
    @available(iOS 9.0, *)
    public static var primaryActionTriggered: UIControlEvents { get {return UIControlEvents(rawValue: 8192)}} // semantic action: for buttons, etc.
    
    /*
    public static var editingDidBegin: UIControlEvents { get } // UITextField
    
    public static var editingChanged: UIControlEvents { get }
    
    public static var editingDidEnd: UIControlEvents { get }
    
    public static var editingDidEndOnExit: UIControlEvents { get } // 'return key' ending editing
    
    
    public static var allTouchEvents: UIControlEvents { get } // for touch events
    
    public static var allEditingEvents: UIControlEvents { get } // for UITextField
    
    public static var applicationReserved: UIControlEvents { get } // range available for application use
    
    public static var systemReserved: UIControlEvents { get } // range reserved for internal framework use
    
    public static var allEvents: UIControlEvents { get }
 */
}


public struct UIControlState : OptionSet {
    public var rawValue: UInt
    
    
    public init(rawValue: UInt)
    {
        self.rawValue = rawValue
    }
    
    public static var normal: UIControlState { get {return UIControlState( rawValue :0)} }
    
    public static var highlighted: UIControlState { get {return UIControlState( rawValue :1)}} // used when UIControl isHighlighted is set
    
    public static var disabled: UIControlState { get {return UIControlState( rawValue :2)}}
    
    public static var selected: UIControlState { get {return UIControlState( rawValue :4)}} // flag usable by app (see below)
    
    @available(iOS 9.0, *)
    public static var focused: UIControlState { get {return UIControlState( rawValue :8)} } // Applicable only when the screen supports focus
    
    // TODO TEMP!
    public static var application: UIControlState { get {return UIControlState( rawValue :16711680)} } // additional flags available for application use
    
    // TODO TEMP!
    public static var reserved: UIControlState { get {return UIControlState( rawValue :4278190080)} } // flags reserved for internal framework use
}

open class UIControl : UIView
{
    private struct ActionCall
    {
        var target : AnyObject? = nil
        var select : Selector!
    }
    
    private var _actions = [Int/*this is the UIControlEvents*/ : [ActionCall] ]()
    // add target/action for particular event. you can call this multiple times and you can specify multiple target/actions for a particular event.
    // passing in nil as the target goes up the responder chain. The action may optionally include the sender and the event in that order
    // the action cannot be NULL. Note that the target is not retained.
    open func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents)
    {
        var act = ActionCall()
        act.select = action
        act.target = target as AnyObject
        
        if var list = _actions[Int(controlEvents.rawValue)]
        {
            list.append(act)
        }
        else
        {
            _actions[Int(controlEvents.rawValue)] = [ActionCall]()
            _actions[Int(controlEvents.rawValue)]!.append( act )
        }
    }
    
    func invokeAction( controlEvent : UIControlEvents)
    {
        if let list = _actions[Int( controlEvent.rawValue)]
        {
            for action in list
            {
                action.target?.perform(action.select)
            }
        }
        //if let action = _actions[
    }
}
