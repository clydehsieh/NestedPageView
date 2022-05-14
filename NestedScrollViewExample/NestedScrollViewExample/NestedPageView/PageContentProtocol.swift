//
//  PageContentProtocol.swift
//  Eatgether
//
//  Created by ClydeHsieh on 2021/12/27.
//  Copyright © 2021 EatMe. All rights reserved.
//

import UIKit
import Combine

protocol PageContentProtocol {
    // binding in parent layer to notify scrollable
    var nestedParentAllowScrollEvent: ((Bool) -> Void)? { get set }
    // binding in child layer to notify scrollable
    var nestedChildCanScroll: PassthroughSubject<Bool, Never> { get set }
    // binding in child layer to notify is freeze
    var enableUserInteraction: PassthroughSubject<Bool, Never> { get set }
    
    func pageButton() -> PageSegmentButton
    func pageContentView() -> UIView
}
