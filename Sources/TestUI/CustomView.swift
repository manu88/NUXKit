//
//  CustomView.swift
//  TestNoStoryboard
//
//  Created by Manuel Deneu on 05/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

#if os(iOS)
import UIKit
#endif

class CustomView: UIView {


    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 0.2, green: 0.0, blue: 0.2, alpha: 0.5)
    }
    
    required override init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect)
    {

/*
        let h = rect.height
        let w = rect.width
        let color:UIColor = UIColor.yellow
        
        let drect = CGRect(x: (w * 0.25),y: (h * 0.25),width: (w * 0.5),height: (h * 0.5))
        let bpath:UIBezierPath = UIBezierPath(rect: drect)
        
        color.set()
        bpath.stroke()
        
*/
        
    }
 

}
