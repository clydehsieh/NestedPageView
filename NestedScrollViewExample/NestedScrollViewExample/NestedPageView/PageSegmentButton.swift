//
//  PageSegmentButton.swift
//  Eatgether
//
//  Created by ClydeHsieh on 2021/12/24.
//  Copyright © 2021 EatMe. All rights reserved.
//

import UIKit

class PageSegmentButton: UIControl {
   
    override var isSelected: Bool {
        didSet {
            if isSelected {
                titleLabel.textColor = configuration.enableColor
            } else {
                titleLabel.textColor = configuration.disableColor
            }
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let lb = UILabel()
            .textColor(color: configuration.disableColor)
            .font(size: 16, weight: .semibold)
        lb.textAlignment = .center
        lb.isUserInteractionEnabled = false
        return lb
    }()
    
    private let redDotView: UIView = {
        let v = UIView()
        v.backgroundColor = .supportDangerWarning
        v.layer.cornerRadius = 3.5
        v.isHidden = true
        return v
    }()
    
    private let configuration: PageSegmentButtonConfiguration
    
    init(configuration: PageSegmentButtonConfiguration = .defaultConfiguration()) {
        self.configuration = configuration
        
        super.init(frame: .zero)
        constructViewHierarchy()
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PageSegmentButton {
    func set(title: String) {
        titleLabel.text = title
    }

    func isBadgeHidden(_ isHidden: Bool) {
        self.redDotView.isHidden = isHidden
    }
}

extension PageSegmentButton {
    private func constructViewHierarchy() {
        addSubview(titleLabel)
        addSubview(redDotView)
    }
    
    private func activateConstraints() {
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        redDotView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8.41)
            $0.left.equalTo(titleLabel.snp.right).offset(3.5)
            $0.size.equalTo(7)
        }
    }
}


