//
//  Window.swift
//  TestAPI
//
//  Created by Manuel Deneu on 03/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

#if os(iOS)
import UIKit
#endif

import Foundation

class Window: UIWindow
{
    override var next: UIResponder? { get { return UIApplication.shared}}
    
    override func didAddSubview(_ subview: UIView)
    {
        super.didAddSubview(subview)
        
        //assert(subview.window == self)
        
        print("Window.didAddSubview  \(subview.description)")
        
    }
}
