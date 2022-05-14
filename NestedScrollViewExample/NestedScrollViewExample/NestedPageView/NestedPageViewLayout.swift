//
//  NestedPageViewLayout.swift
//  Eatgether
//
//  Created by ClydeHsieh on 2022/1/4.
//  Copyright © 2022 EatMe. All rights reserved.
//

import UIKit

class NestedPageViewLayout {
    var pageEdgeInsets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
    var segmentHeight: CGFloat = 45
    var segmentScrollMaxDistance: CGFloat = 48
    
    init() { }
}

extension NestedPageViewLayout {
    func segmentCollapseMaxY() -> CGFloat {
        pageEdgeInsets.top + segmentHeight
    }
    
    func segmentTopConstraint(scrollDistance: CGFloat) -> CGFloat {
        pageEdgeInsets.top - min(0, max(-segmentScrollMaxDistance, scrollDistance))
    }
}
