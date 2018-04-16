//
//  TextField.swift
//  TestStoryBoard
//
//  Created by Manuel Deneu on 16/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

import UIKit

class TextField: UITextField {

    
    required init?(coder aDecoder: NSCoder)
    {
        let lol = TestCoder("TextField" , coder: aDecoder )
        
        
        super.init(coder: lol )
        
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
