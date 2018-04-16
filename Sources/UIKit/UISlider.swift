//
//  UISlider.swift
//  NUXKit
//
//  Created by Manuel Deneu on 12/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

import Foundation


open class UISlider : UIControl /*, NSCoding*/
{
    /*
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
 */
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    open var value: Float // default 0.0. this value will be pinned to min/max
    {
        get
        {
            return Float( gtk_range_get_value( toGtkRange(_impl) ))
        }
        
    }
    
    open var minimumValue: Float = 0.0 // default 0.0. the current value may change if outside new min value
    
    open var maximumValue: Float = 1.0 // default 1.0. the current value may change if outside new max value
    
    open func setValue(_ value: Float, animated: Bool) // move slider at fixed velocity (i.e. duration depends on distance). does not
    {
        gtk_range_set_value( toGtkRange(_impl), gdouble(value) )
    }
    
    
    public override func prepare() -> Bool
    {
        if( _impl == nil)
        {
            
            
            
            
            _impl = gtk_scale_new(GTK_ORIENTATION_HORIZONTAL , nil)
            
            gtk_range_set_show_fill_level ( toGtkRange(_impl) , 1)
            
            let adj = gtk_range_get_adjustment(toGtkRange(_impl))
            
            gtk_adjustment_set_lower(adj, 0.0)
            gtk_adjustment_set_upper(adj, 1.0)
            gtk_adjustment_set_step_increment(adj, 0.01)
            gtk_range_set_adjustment(toGtkRange(_impl), adj)
            
            
            gtk_scale_set_draw_value(toGtkScale(_impl), 1 );
            
            gtk_widget_set_size_request(toGtkWidget(_impl) , Int32( frame.size.width) , Int32( frame.size.height) );
            
            /*var alloc = GtkAllocation(x: Int32( frame.origin.x), y: Int32( frame.origin.y), width:200/* Int32( frame.size.width)*/, height: Int32( frame.size.height) )
            withUnsafeMutablePointer(to: &alloc) { (ptr) -> Void in
                
                
                gtk_widget_size_allocate( toGtkWidget(_impl), ptr)
                
            }
             */
            
            
            
            
            
            
            g_object_ref(_impl)
            
            let ptr = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
            
            g_signal_connect_with_data(_impl, "value-changed", { (widget, data) in
                
                if let data = data
                {
                    let this = Unmanaged<UIButton>.fromOpaque(data).takeUnretainedValue()
                    assert(widget == this._impl)
                    this.invokeAction(controlEvent: .valueChanged)
                }
                
            }, ptr, nil, GConnectFlags(rawValue: 0))
            
            //return true
        }
        
        assert(_impl != nil)
        //assert( GtkIsButton(_impl))
        
        return _impl != nil
    }
}
