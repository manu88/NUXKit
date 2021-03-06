//
//  ViewController.swift
//  TestStoryBoard
//
//  Created by Manuel Deneu on 05/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

#if os(iOS)
import UIKit
#endif

class TestCoder2 : NSCoder
{
    
    
    var id  = ""
    var _coder : NSCoder?
    
    
    init( _ name: String , coder: NSCoder)
    {
        super.init()
        self.id = name
        self._coder = coder
    }
    
    override func decodeObject(forKey key: String) -> Any?
    {
        print("\(id) Ask for decodeObject: \(key)")
        
        
        return _coder!.decodeObject(forKey: key)
    }
    
    override func decodeBool(forKey key: String) -> Bool {
        print("\(id) Ask for decodeBool: \(key)")
        
        return _coder!.decodeBool(forKey: key)
    }
    
    override func containsValue(forKey key: String) -> Bool {
        print("\(id) Ask for containsValue: \(key)")
        
        return _coder!.containsValue(forKey:key)
    }
    
    
    override func decodeInt64(forKey key: String) -> Int64 {
        print("\(id) Ask for decodeInt64: \(key)")
        
        return _coder!.decodeInt64(forKey:key)
    }
    
    override func decodeFloat(forKey key: String) -> Float
    {
        print("\(id) Ask for decodeFloat: \(key)")
        return _coder!.decodeFloat(forKey: key)
    }
    override var allowsKeyedCoding: Bool
        { get
            {
                return true
            }
        }
    
    
    /*
    func decodeObject(of classes: [AnyClass]?, forKey key: String) -> Any?
    {
        print("Ask for decodeObject: \(key)")
        return nil
    }
 */
 
}


class ViewController: UIViewController {

    @IBOutlet var mylabel : UILabel?
    @IBOutlet var mySlider : UISlider?
    @IBOutlet var myText : UITextField?
    required init?(coder aDecoder: NSCoder)
    {
        //let lol = TestCoder("UIViewController", coder: aDecoder)
        super.init(coder: aDecoder)
        
        
        print("ViewController.init did END")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func testButton(lol : AnyObject?)
    {
        print("Yeaaah 😊")
        
        
    }
    
    /*@IBAction*/ @objc func testButton2()
    {
        print("Yoooo 😊")
    }

    
    @IBAction/* @objc*/ func sliderChanged(sender : UISlider?)
    {
        assert(sender != nil)
        assert(sender == mySlider)
        
        if let slider = sender
        {
            mylabel?.text = "\(slider.value)"
            print("Slider value changed \(slider.value)")
        }
    }
  
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool
    {
        
        assert(sender != nil)
        
        return true
    }
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?)
     {
        assert(sender != nil)
     }
    
    @IBAction func textEditDidEnd(sender : AnyObject? )
    {
        assert( myText!.isEqual(sender))
        print("Text Ended \(myText!.text!)")
        
    }
    @IBAction func textChanged(sender : AnyObject? )
    {
        assert( myText!.isEqual(sender))
        
        
        print("TextChanged \(myText!.text!)")

    }

}

