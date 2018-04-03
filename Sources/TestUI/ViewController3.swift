//
//  ViewController3.swift
//  TestAPI
//
//  Created by Manuel Deneu on 03/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

#if os(iOS)
import UIKit
#endif

class ViewController3: UIViewController
{
    var button : UIButton!
    var button2 : UIButton!
    var label : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        print("ViewController3.viewDidLoad  \(view.description)")
        
        view.backgroundColor = UIColor.cyan
        
        button = UIButton(frame: CGRect(x: 120, y: 140, width: 100, height: 50))
        button.backgroundColor = .green
        button.setTitle("Back", for: .normal)
        view.addSubview(button)
        button.addTarget(self, action: #selector(ViewController3.buttonAction), for: .touchUpInside)
        
        
        button2 = UIButton(frame: CGRect(x: 120, y: 440, width: 100, height: 50))
        button2.backgroundColor = .yellow
        button2.setTitle("Hide", for: .normal)
        view.addSubview( button2 )
        button2.addTarget(self, action: #selector(ViewController3.buttonAction2), for: .touchUpInside)
        
        label = UILabel(frame: CGRect(x: 120, y: 550, width: 100, height: 50))
        label.text = "Some text"
        
        view.addSubview( label )
    }
    
    @objc func buttonAction(/*sender: UIButton!*/) {
        print("Back Button tapped")
        
        dismiss(animated: false) {
            print("ViewController3.dismiss.completion")
        }
    }
    
    @objc func buttonAction2(/*sender: UIButton!*/)
    {
        label.isHidden = !label.isHidden
    }
}
