//
//  VectorMath.swift
//  NiceBackground
//
//  Created by TheEvilRoot on 10.04.21.
//

import Foundation

func + (_ cgPoint: CGPoint, _ value: CGFloat) -> CGPoint {
    return CGPoint(x: cgPoint.x + value, y: cgPoint.y + value)
}

func - (_ cgPoint: CGPoint, _ value: CGFloat) -> CGPoint {
    return CGPoint(x: cgPoint.x - value, y: cgPoint.y - value)
}

func + (_ cgPoint: CGPoint, _ value: CGPoint) -> CGPoint {
    return CGPoint(x: cgPoint.x + value.x, y: cgPoint.y + value.y)
}

func - (_ cgPoint: CGPoint, _ value: CGPoint) -> CGPoint {
    return CGPoint(x: cgPoint.x - value.x, y: cgPoint.y - value.y)
}

func + (_ cgSize: CGSize, _ value: CGFloat) -> CGSize {
    return CGSize(width: cgSize.width + value, height: cgSize.height + value)
}

func - (_ cgSize: CGSize, _ value: CGFloat) -> CGSize {
    return CGSize(width: cgSize.width - value, height: cgSize.height - value)
}

func * (_ cgSize: CGSize, _ value: CGFloat) -> CGSize {
    return CGSize(width: cgSize.width * value, height: cgSize.height * value)
}

func / (_ cgPoint: CGPoint, _ value: CGFloat) -> CGPoint {
    return CGPoint(x: cgPoint.x / value, y: cgPoint.y / value)
}

// MARK: - normalize vector
func / (_ cgPoint: CGPoint, _ vec: CGSize) -> CGPoint {
    return CGPoint(x: cgPoint.x / vec.width, y: cgPoint.y / vec.height)
}

// MARK: - denormalize vector
func * (_ cgPoint: CGPoint, _ vec: CGSize) -> CGPoint {
    return CGPoint(x: cgPoint.x * vec.width, y: cgPoint.y * vec.height)
}

func abs(_ cgPoint: CGPoint) -> CGPoint {
    return CGPoint(x: abs(cgPoint.x), y: abs(cgPoint.y))
}

func / (_ cgSize: CGSize, _ value: CGFloat) -> CGSize {
    return CGSize(width: cgSize.width / value, height: cgSize.height / value)
}
