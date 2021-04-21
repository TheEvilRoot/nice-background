//
//  ResolutionHelper.swift
//  NiceBackground
//
//  Created by TheEvilRoot on 11.04.21.
//

import Foundation
import Cocoa

func getScreen(_ window: NSWindow?) -> NSScreen? {
    if let window = window {
        if let screen = window.screen {
            return screen
        }
    }
    return NSScreen.main
}

func getCurrentResolution(window: NSWindow?) -> CGSize {
    if let screen = getScreen(window) {
        return screen.frame.size
    } else {
        return CGSize.zero
    }
}
