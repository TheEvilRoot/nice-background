//
//  DialogHelper.swift
//  NiceBackground
//
//  Created by TheEvilRoot on 11.04.21.
//

import Foundation
import Cocoa

func showMessageAlert(_ window: NSWindow?, _ message: String, error: Error? = nil) {
    guard let window = window else { print("[Alert] \(message) \(error?.localizedDescription ?? "nil")"); return }
    let alert = error != nil ? NSAlert(error: error!) : NSAlert()
    alert.messageText = message
    alert.beginSheetModal(for: window, completionHandler: { _ in })
}
