//
//  ViewController2.swift
//  TestNoStoryboard
//
//  Created by Manuel Deneu on 02/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//


#if os(iOS)
import UIKit
#endif

class ViewController2: UIViewController
{
    
    
    var button : UIButton!
    var buttonNext : UIButton!
    
    override func viewWillAppear(_ animated: Bool) // Called when the view is about to made visible. Default does nothing
    {
        assert(view.window == nil)
        assert(view.next == self)
    }
    
    override func viewDidAppear(_ animated: Bool) // Called when the view has been fully transitioned onto the screen. Default does nothing
    {
        assert(view.window != nil)
        assert(view.window!.next == UIApplication.shared)
        assert(view.next == self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        print("ViewController2.viewDidLoad  \(view.description)")
        
        view.backgroundColor = UIColor.blue
        
        
        button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.backgroundColor = .green
        button.setTitle("Back", for: .normal)
        view.addSubview(button)
        button.addTarget(self, action: #selector(ViewController.buttonAction), for: .touchUpInside)
        
        
        buttonNext = UIButton(frame: CGRect(x: 100, y: 400, width: 100, height: 50))
        buttonNext.backgroundColor = .red
        buttonNext.setTitle("Next", for: .normal)
        view.addSubview(buttonNext)
        buttonNext.addTarget(self, action: #selector(ViewController2.buttonActionNext), for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func buttonAction(/*sender: UIButton!*/) {
        print("Back Button tapped")
        
        dismiss(animated: false) {
            print("ViewController2.dismiss.completion")
        }
    }
    
    @objc func buttonActionNext(/*sender: UIButton!*/) {
        print("Next Button tapped")
        
        present(ViewController3(), animated: false)
        {
            print("Transition ended")
            assert(self.view.window == nil)
            assert(self.view.superview == nil )
            assert( self.view.isHidden == false  )// not hidden
        }
    }
    
    
    
}

