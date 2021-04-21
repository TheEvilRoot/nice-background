//
//  DrawHelper.swift
//  NiceBackground
//
//  Created by TheEvilRoot on 13.04.21.
//

import Foundation
import Cocoa

func preserveContext (context: NSGraphicsContext? = NSGraphicsContext.current, _ f: (NSGraphicsContext) -> Void) {
    guard let context = context else { return }
    context.saveGraphicsState()
    f(context)
    context.restoreGraphicsState()
}

func centerCoordinates(_ rect: CGRect, withSize size: CGSize, verticalPosition vPos: CGFloat, horizontalPosition hPos: CGFloat) -> CGPoint {
    let centerX = rect.width * hPos
    let centerY = rect.height * vPos
    let halfWidth = CGFloat(size.width / 2)
    let halfHeight = CGFloat(size.height / 2)
    
    return CGPoint(x: centerX - halfWidth, y: centerY - halfHeight)
}
