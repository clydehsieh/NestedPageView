//
//  PageSegmentView.swift
//  Eatgether
//
//  Created by ClydeHsieh on 2021/12/24.
//  Copyright © 2021 EatMe. All rights reserved.
//

import UIKit
import Combine

class PageSegmentView: NiblessView {
    //MARK: - Components
    private let containerView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        return sv
    }()
    
    private let separatorLine: UIView = {
        let v = UIView()
        v.backgroundColor = .secondaryGYGY910
        return v
    }()
    
    private let segmentLine: UIView = {
        let v = UIView()
        v.backgroundColor = .secondaryGYGY9
        return v
    }()
    
    //MARK: - Parameters
    let didTapControlIndex: PassthroughSubject<Int, Never> = .init()
    let selectedIndex: CurrentValueSubject<Int, Never> = .init(0)
    
    private var segmentControls: [UIControl] = []
    private var subscribtions: Set<AnyCancellable> = Set<AnyCancellable>()
    
    //MARK: - Life cycle
    init() {
        super.init(frame: .zero)
        constructViewHierarchy()
        activateConstraints()
        setupBinding()
    }
    
    func add(_ segmentControls: [UIControl]) {
        guard segmentControls.count > 0 else { return }
        
        self.segmentControls = segmentControls
        
        for control in segmentControls {
            containerView.addArrangedSubview(control)
            control.addTarget(self, action: #selector(didTapControlAction(_:)), for: .touchUpInside)
        }
        
        if let first = containerView.arrangedSubviews.first {
            segmentLine.snp.removeConstraints()
            segmentLine.snp.makeConstraints {
                $0.bottom.equalToSuperview()
                $0.height.equalTo(2)
                $0.left.equalToSuperview()
                $0.width.equalTo(first.snp.width)
            }
        }
    }
    
    @objc private func didTapControlAction(_ sender: UIControl) {
        if let index = segmentControls.firstIndex(of: sender) {
            didTapControlIndex.send(index)
        }
    }
}

//MARK: - segment lint
extension PageSegmentView {
    func moveSegmentLine(to rate: CGFloat) {
        let offsetX = self.frame.width * rate
        
        self.segmentLine.snp.updateConstraints {
            $0.left.equalToSuperview().offset(offsetX)
        }
    }
}

extension PageSegmentView {
    private func constructViewHierarchy() {
        addSubview(containerView)
        addSubview(separatorLine)
        addSubview(segmentLine)
    }
    
    private func activateConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        separatorLine.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        segmentLine.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
            $0.left.equalToSuperview()
            $0.width.equalTo(0)
        }
    }
    
    private func setupBinding() {
        selectedIndex.sink { [weak self] targetIndex in
            guard let self = self else { return }
            for (index, control) in self.segmentControls.enumerated() {
                control.isSelected = index == targetIndex
            }
        }
        .store(in: &subscribtions)
    }
}
