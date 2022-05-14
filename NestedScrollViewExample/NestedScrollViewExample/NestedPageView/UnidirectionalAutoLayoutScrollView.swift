//
//  UnidirectionalAutoLayoutScrollView.swift
//  Eatgether
//
//  Created by Alex Huang on 8/1/20.
//  Copyright © 2020 EatMe. All rights reserved.
//

import UIKit

class UnidirectionalAutoLayoutScrollView: UIScrollView {
    enum Direction {
        case horizontal
        case vertical
    }
    
    private let direction: Direction
    
    init(direction: Direction) {
        self.direction = direction
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let containerView = UIView()
    
    private func setup() {
        switch direction {
        case .horizontal:
            showsHorizontalScrollIndicator = false
        case .vertical:
            showsVerticalScrollIndicator = false
        }
        super.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            switch direction {
            case .horizontal:
                $0.height.equalTo(self)
            case .vertical:
                $0.width.equalTo(self)
            }
        }
    }
    
    override func addSubview(_ view: UIView) {
        containerView.addSubview(view)
    }
    
    func removeAllSubView() {
        for subView in containerView.subviews {
            subView.removeFromSuperview()
        }
    }
}
