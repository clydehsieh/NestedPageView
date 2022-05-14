//
//  NestedScrollView.swift
//  Eatgether
//
//  Created by ClydeHsieh on 2021/12/23.
//  Copyright © 2021 EatMe. All rights reserved.
//

import UIKit

class NestedScrollView: UnidirectionalAutoLayoutScrollView, UIGestureRecognizerDelegate {
    var canScroll = false
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
