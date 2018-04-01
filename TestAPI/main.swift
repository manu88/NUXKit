//
//  main.swift
//  TestAPI
//
//  Created by Manuel Deneu on 30/03/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

import Foundation

/*
let sb = StoryBoardPlugin()
sb.loadStoryboard("/Users/manueldeneu/Documents/projets/TestPortUIKit/TestSimpleView/TestSimpleView/Base.lproj/Main.storyboard")
*/

// This code sort of replaces '@UIApplicationMain' 
let app = UIApplication.shared
app.delegate = AppDelegate()
let retCode = app.UIApplicationMain(0, nil, nil, nil)
exit (retCode)


    

