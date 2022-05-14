//
//  PageSegmentButtonConfiguration.swift
//  Eatgether
//
//  Created by ClydeHsieh on 2021/12/24.
//  Copyright © 2021 EatMe. All rights reserved.
//

import UIKit

struct PageSegmentButtonConfiguration {
    let enableColor: UIColor
    let disableColor: UIColor
}

extension PageSegmentButtonConfiguration {
    static func defaultConfiguration() -> PageSegmentButtonConfiguration {
        .init(enableColor: .secondaryGYGY9,
              disableColor: .secondaryGYGY940)
    }
}
