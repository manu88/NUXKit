//
//  SecondViewController.swift
//  TestStoryBoard
//
//  Created by Manuel Deneu on 16/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

#if os(iOS)
import UIKit
#endif

class SecondViewController: UIViewController {

    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func actionReturn(sender : AnyObject)
    {
        dismiss(animated: true )
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
