//
//  Window.swift
//  TestAPI
//
//  Created by Manuel Deneu on 03/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

import Foundation

class Window: UIWindow
{
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        print("Window.didAddSubview  \(subview.description)")
    }
}
