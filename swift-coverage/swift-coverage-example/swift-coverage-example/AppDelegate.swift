//
//  AppDelegate.swift
//  swift-coverage-example
//
//  Created by Elena Vilchik on 17/08/16.
//  Copyright © 2016-2018 SonarSource. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification)
    {
        // Insert code here to tear down your application
    }


}

class A {
    func foo(){
        if (1 > 2) {
            print("hello")
        } else {
            print("Bye")
        }
    }
}
