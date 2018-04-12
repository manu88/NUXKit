//
//  ViewController.swift
//  TestNoStoryboard
//
//  Created by Manuel Deneu on 02/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

#if os(iOS)
import UIKit
#endif

class ViewController: UIViewController {
    
    var button : UIButton!
    var toggle : UISwitch!
    var  label : UILabel!
    var  label2 : UILabel!
    
    var customView : CustomView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        assert(view != nil )
        assert(view.next != nil)
        assert(view.window  == nil)
        
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    override func viewWillDisappear(_ animated: Bool) // Called when the view is dismissed, covered or otherwise hidden. Default does nothing
    {
    }
    
    override func viewDidDisappear(_ animated: Bool) // Called after the view was dismissed, covered or otherwise hidden. Default does nothing
    {
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        assert(view.window == nil)
        
        assert(view.next == self)
        
        view.backgroundColor = UIColor.white
        
        button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.backgroundColor = .green

        button.setTitleColor(UIColor.black, for: .normal)
        
        assert(button.titleColor(for: .normal) != nil)
        
        button.setTitle("Hello", for: .normal)
        view.addSubview(button)
        button.addTarget(self, action: #selector(ViewController.buttonAction), for: .touchUpInside)
        
        
        label = UILabel(frame: CGRect(x: 100, y: 200, width: 100, height: 20))
        label.text = "Some text"
        view.addSubview(label)
        
        let count = view.subviews.count
        view.addSubview(label)
        assert(count == view.subviews.count)
        
        assert(label.superview == view)
        assert(view.superview == view.window)
        
        
        toggle = UISwitch(frame: CGRect(x: 300, y: 220, width: 100, height: 20))
        toggle.addTarget(self, action: #selector(ViewController.switchAction), for: .valueChanged)
        view.addSubview(toggle)
        
        
        label2 = UILabel(frame: CGRect(x: 120, y: 240, width: 100, height: 20))
        label2.text = "Some label"
        view.addSubview(label2)
        
        customView = CustomView(frame: CGRect(x: 10, y: 400, width: 200, height: 100))
        
        view.addSubview(customView)
        
        // closure must never be called !!
        dismiss(animated: true) {
            assert(false)
        }
        
    }
    
    @objc func switchAction(/*sender: UIButton!*/)
    {
        print("Switch is ON? \( toggle.isOn)")
        
        if( toggle.isOn)
        {
            label2.alpha = 1.0
        }
        else
        {
            label2.alpha = 0.0
        }
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
        
        
        present(ViewController2(), animated: toggle.isOn)
        {
            print("Transition ended")
            assert(self.view.window == nil)
            assert(self.view.superview == nil )
            assert( self.view.isHidden == false  )// not hidden
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

