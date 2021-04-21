//
//  PositionView.swift
//  NiceBackground
//
//  Created by TheEvilRoot on 13.04.21.
//

import Foundation
import Cocoa

protocol PositionViewListener {
    
    func positionView(positionChanged value: CGPoint, on view: PositionView)
    
}

class PositionView : NSView {
    
    var currentPosition: CGPoint = CGPoint(x: 0.5, y: 0.5) {
        didSet {
            needsDisplay = true
            
            if let listener = listener {
                listener.positionView(positionChanged: currentPosition, on: self)
            }
        }
    }
    
    var currentRadius: CGFloat = CGFloat(8) {
        didSet {
            needsDisplay = true
        }
    }
    
    var isPointDrag: Bool = false
    
    var listener: PositionViewListener? = nil
    
    private let backgroundColor = CGColor(genericCMYKCyan: 0.73, magenta: 0.47, yellow: 0, black: 0.04, alpha: 0.9)
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        preserveContext { ctx in
            ctx.cgContext.setFillColor(backgroundColor)
            ctx.cgContext.beginPath()
            ctx.cgContext.addRect(CGRect(origin: CGPoint.zero, size: frame.size))
            ctx.cgContext.fillPath()
        }
        preserveContext { ctx in
            let size = CGSize(width: currentRadius, height: currentRadius)
            let pos = centerCoordinates(frame, withSize: size, verticalPosition: currentPosition.y, horizontalPosition: currentPosition.x)
            ctx.cgContext.setFillColor(NSColor.red.cgColor)
            ctx.cgContext.beginPath()
            ctx.cgContext.addEllipse(in: CGRect(origin: pos, size: size))
            ctx.cgContext.fillPath()
            
        }
    }
    
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return false
    }
    
    override func mouseDown(with event: NSEvent) {
        let point = convert(event.locationInWindow, from: nil)
        let abnormal = currentPosition * frame.size
        let delta = abs(abnormal - point)
        isPointDrag = delta.x < currentRadius && delta.y < currentRadius
    }
    
    override func mouseDragged(with event: NSEvent) {
        let point = convert(event.locationInWindow, from: nil)
        if !isPointDrag { return super.mouseDragged(with: event) }
        let normal = point / frame.size
        currentPosition = normal
    }
    
    override func mouseUp(with event: NSEvent) {
        isPointDrag = false
    }
    
}
