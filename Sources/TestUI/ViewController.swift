//
//  ViewController.swift
//  TestNoStoryboard
//
//  Created by Manuel Deneu on 02/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//



class ViewController: UIViewController {
    
    var button : UIButton!
    var  label : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewController.viewDidLoad  \(view.description)")
        
        button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.backgroundColor = .green
        button.setTitle("Hello", for: .normal)
        view.addSubview(button)
        button.addTarget(self, action: #selector(ViewController.buttonAction), for: .touchUpInside)
        
        
        label = UILabel(frame: CGRect(x: 100, y: 200, width: 100, height: 20))
        label.text = "Some text"
        view.addSubview(label)
        
        
        
    }
    
    @objc func buttonAction(/*sender: UIButton!*/) {
        print("Button tapped")
        
        if( label.text == "Some text")
        {
            label.text = "Some other text"
        }
        else
        {
            label.text = "Some text"
        }
        if( button.title(for: .normal) == "Hello")
        {
            button.setTitle("Other title", for: .normal)
        }
        else
        {
            button.setTitle("Hello", for: .normal)
        }
        
        present(ViewController2(), animated: true) {
            print("Transition ended")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

