//
//  UIImageView.swift
//  NUXKit
//
//  Created by Manuel Deneu on 17/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

import Foundation


@available(iOS 2.0, *)
open class UIImageView : UIView
{

    public init(image: UIImage?)
    {
        super.init(frame: CGRect.infinite)
        
    }
    
    @available(iOS 3.0, *)
    public init(image: UIImage?, highlightedImage: UIImage?)
    {
        super.init(frame: CGRect.infinite)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    open var image: UIImage? = nil // default is nil
}
