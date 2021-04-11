//
//  WindowController.swift
//  NiceBackground
//
//  Created by TheEvilRoot on 10.04.21.
//

import Foundation
import Cocoa

extension Notification.Name {
    static let export = Notification.Name("export")
    static let openImage = Notification.Name("openImage")
    static let clearAll = Notification.Name("clearAll")
    static let copy = Notification.Name("copyImage")
    static let paste = Notification.Name("pasteImage")
}

class WindowController : NSWindowController {
    
    
    @IBAction func exportAction(_ sender: NSToolbarItem) {
        NotificationCenter.default.post(Notification(name: .export))
    }
    
    @IBAction func openImageAction(_ sender: NSToolbarItem) {
        NotificationCenter.default.post(Notification(name: .openImage))
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
}
