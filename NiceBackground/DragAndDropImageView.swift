//
//  DragAndDropImageView.swift
//  NiceBackground
//
//  Created by TheEvilRoot on 10.04.21.
//

import Foundation
import Cocoa

protocol DragAndDropImageViewDelegate {
    
    func imageDragged(on url: NSURL)
    
    func imageDragged(image: NSImage)
    
}

class DragAndDropImageView : NSImageView, NSDraggingSource {
    
    var delegate: DragAndDropImageViewDelegate? = nil
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.registerForDraggedTypes([.png])
    }
    
    func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation {
        return NSDragOperation.copy
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        return .copy
    }
    
    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        return .copy
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let objects = sender.draggingPasteboard.readObjects(forClasses: [NSURL.self, NSImage.self], options: nil) else {
            print("perfromDragOperation objects is nil")
            return false
        }
        
        if objects.count == 0 {
            print("perfromDragOperation objects size is 0")
            return false
        }
        
        if let first = objects[0] as? NSImage {
            delegate?.imageDragged(image: first)
            return true
        } else if let first = objects[0] as? NSURL {
            delegate?.imageDragged(on: first)
            return true
        } else {
            return false
        }
    }
    
}
