//GestureUtil.swift

import Foundation
import UIKit

enum UIPanGestureRecognizerDirection {
    case undefined
    case up
    case down
    case left
    case right
}

class GestureUtil {
    static func detectGestureDirection(_ velocity: CGPoint) -> UIPanGestureRecognizerDirection {
        let isVerticalGesture = fabs(velocity.y) > fabs(velocity.x)

        if (isVerticalGesture) {
            if (velocity.y > 0) {
                return UIPanGestureRecognizerDirection.down
            } else {
                return UIPanGestureRecognizerDirection.up
            }
        } else {
            if (velocity.x > 0) {
                return UIPanGestureRecognizerDirection.right
            } else {
                return UIPanGestureRecognizerDirection.left
            }
        }
    }

    static func processGesture(_ gesture: UIGestureRecognizer, views: [UIView]) -> Bool {
        var zIndexes: [UIView: Int] = [:]
        for view in views {
            zIndexes[view] = view.superview?.subviews.firstIndex(of: view) ?? -1
        }
        for view in views.sorted(by: { zIndexes[$0]! < zIndexes[$1]! }) {
            if let view = view as? BaseView, !view.isHidden {
                if GestureUtil.isGesture(gesture, inView: view) {
                    if view.onTouch(gesture) {
                        return true
                    }
                }
            }
        }
        return false
    }

    static func isGesture(_ gesture: UIGestureRecognizer, inView view: UIView) -> Bool {
        let position = gesture.location(in: view)
        return view.bounds.contains(position)
    }
}
