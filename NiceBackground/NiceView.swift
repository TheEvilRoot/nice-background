//
//  NiceView.swift
//  NiceBackground
//
//  Created by TheEvilRoot on 9.04.21.
//

import Foundation
import Cocoa
import AppKit

fileprivate func fitInto(_ cgSize: CGSize, ratio: CGFloat, miniman value: CGFloat, allowedPadding pad: CGFloat) -> CGSize {
    if cgSize.width < cgSize.height {
        let newHeight = value * pad
        let newWidth = newHeight * ratio
        return CGSize(width: newWidth, height: newHeight)
    } else {
        let newWidth = value * pad
        let newHeight = newWidth / ratio
        return CGSize(width: newWidth, height: newHeight)
    }
}


fileprivate func dimensions(in rect: CGRect, with ratio: CGFloat) -> CGSize {
    let frameRatio = rect.width / rect.height
    
    if (frameRatio > ratio) {
        let newHeight = rect.height
        let newWidth = newHeight * ratio;
        return CGSize(width: newWidth, height: newHeight)
        
    } else {
        let newWidth = rect.width
        let newHeight = newWidth / ratio;
        return CGSize(width: newWidth, height: newHeight)
    }
}

class NiceView : NSView {
    
    struct Image {
        
        let image: CGImage
        let cgSize: CGSize
        let ratio: CGFloat
        
        init(image cgImage: CGImage) {
            self.image = cgImage
            self.cgSize = CGSize(width: CGFloat(cgImage.width), height: CGFloat(cgImage.height))
            self.ratio = cgSize.width / cgSize.height
        }
        
        init?(_ cgImage: CGImage?) {
            guard let cgImage = cgImage else {return nil}
            self.init(image: cgImage)
        }
        
        func centerDimensions(_ rect: CGRect, allowedPadding pad: CGFloat) -> CGSize {
            if rect.width < rect.height {
                return fitInto(cgSize, ratio: ratio, miniman: rect.width, allowedPadding: pad)
            } else {
                return fitInto(cgSize, ratio: ratio, miniman: rect.height, allowedPadding: pad)
            }
        }
        
    }
    
    var backgroundColor: CGColor = NSColor.black.cgColor {
        didSet {
            needsDisplay = true
        }
    }
    
    var centerImage: Image? = nil {
        didSet {
            needsDisplay = true
        }
    }
    
    var allowedPadding: CGFloat = 0.8 {
        didSet {
            needsDisplay = true
        }
    }
    
    var strokeWidth: CGFloat = 2.0 {
        didSet {
            needsDisplay = true
        }
    }
    
    var strokeColor: CGColor = CGColor.white {
        didSet {
            needsDisplay = true
        }
    }
    
    var aspectRatio: CGFloat = CGFloat(16.0 / 9.0) {
        didSet {
            needsDisplay = true
        }
    }
    
    var borderBlurRadius: CGFloat = CGFloat(16.0) {
        didSet {
            needsDisplay = true
        }
    }
    
    var position: CGPoint = CGPoint(x: 0.5, y: 0.5) {
        didSet {
            needsDisplay = true
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        preserveContext {
            drawCanvas(frame, $0)
        }
        preserveContext {
            let size = dimensions(in: frame, with: aspectRatio)
            let center = centerCoordinates(frame, withSize: size, verticalPosition: 0.5, horizontalPosition: 0.5)
            drawContent(CGRect(origin: center, size: size), center, $0)
        }
    }
    
    func drawCanvas(_ frame: CGRect, _ ctx: NSGraphicsContext) {
        ctx.cgContext.setFillColor(NSColor.init(red: CGFloat.zero, green: CGFloat.zero, blue: CGFloat.zero, alpha: CGFloat.zero).cgColor)
        ctx.cgContext.fill(frame)
    }
    
    func drawContent(_ frame: CGRect, _ pos: CGPoint, _ ctx: NSGraphicsContext) {
        ctx.cgContext.setFillColor(backgroundColor)
        ctx.cgContext.fill(frame)
        
        if let centerImage = centerImage {
            let imageSize = centerImage.centerDimensions(frame, allowedPadding: allowedPadding)
            let imagePos = centerCoordinates(frame, withSize: imageSize, verticalPosition: position.y, horizontalPosition: position.x) + pos
            let imageRect = CGRect(origin: imagePos, size: imageSize)
            if (strokeWidth > 0) {
                ctx.cgContext.setFillColor(strokeColor)
                ctx.cgContext.beginPath()
                ctx.cgContext.addRect(CGRect(origin: imagePos - strokeWidth, size: imageSize + (strokeWidth * 2)))
                ctx.cgContext.fillPath()
            }
            ctx.cgContext.draw(centerImage.image, in: imageRect)
        }
    }
    
    func export(size: CGSize = CGSize(width: 2560, height: 1600)) -> NSImage {
        let rep = NSBitmapImageRep(
                bitmapDataPlanes: nil,
                pixelsWide: Int(size.width),
                pixelsHigh: Int(size.height),
                bitsPerSample: 8,
                samplesPerPixel: 4,
                hasAlpha: true,
                isPlanar: false,
                colorSpaceName: NSColorSpaceName.calibratedRGB,
                bytesPerRow: 0,
                bitsPerPixel: 0)
        
        let image = NSImage(size: size)
        let context = NSGraphicsContext(bitmapImageRep: rep!)
        
        preserveContext(context: context) {
            drawContent(CGRect(origin: CGPoint(x: 0, y: 0), size: size), CGPoint.zero, $0)
        }
        
        image.addRepresentation(rep!)
        return image
    }
}
