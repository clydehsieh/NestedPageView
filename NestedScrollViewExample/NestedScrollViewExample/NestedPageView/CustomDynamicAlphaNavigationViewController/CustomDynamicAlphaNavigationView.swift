//
//  CustomDynamicAlphaNavigationView.swift
//  Eatgether
//
//  Created by Chen Yi-Wei on 2021/11/24.
//  Copyright © 2021 EatMe. All rights reserved.
//

import UIKit

final class CustomDynamicAlphaNavigationView: UIView {

    static let navigationBarHeight: CGFloat = 70
    static let largeNavigationBarHeight: CGFloat = 48

    var onAssociateButtonTap: (() -> Void)?
    var onLeftNaviButtonTap: (() -> Void)?

    // MARK: UI
    lazy var leftNaviButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
//        button.setImage("naviArrowLeftBlack".alwaysOriginalImage, for: .normal)
//        button.touchEdgeInsets = .init(top: -10, left: -10, bottom: -10, right: -20)
        button.addTarget(self, action: #selector(leftNaviButtonDidTapped), for: .touchUpInside)
        return button
    }()

    let naviTitleStackView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .clear
        view.spacing = 4
        view.alpha = 0
        return view
    }()

    let naviTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .lightGray
        return label
    }()

    private lazy var naviTitleAssociateButton: UIButton = {
        let button = UIButton()
//        button.touchEdgeInsets = .init(top: -10, left: -10, bottom: -10, right: -20)
        button.addTarget(self, action: #selector(associateButtonDidTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    private lazy var naviStackView: UIStackView = {
        let stackView = UIStackView.init()
        stackView.axis = .horizontal
        stackView.spacing = 21
        stackView.alignment = .center
        return stackView
    }()

    let largeTitleStackView:  UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .clear
        view.spacing = 4
        return view
    }()

    private let largeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .lightGray
        return label
    }()

    private lazy var largeTitleAssocciateButton: UIButton = {
        let button = UIButton()
//        button.touchEdgeInsets = .init(top: -10, left: -10, bottom: -10, right: -20)
        button.addTarget(self, action: #selector(associateButtonDidTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    private var viewHiearchyNotReady: Bool = true

    override func didMoveToWindow() {
        super.didMoveToWindow()

        guard viewHiearchyNotReady else { return }
        constructViewHierarchy()
        activateConstriants()
        viewHiearchyNotReady = false
    }

    private func constructViewHierarchy() {
        naviStackView.addArrangedSubview(leftNaviButton)
        naviTitleStackView.addArrangedSubview(naviTitleLabel)
        naviTitleStackView.addArrangedSubview(naviTitleAssociateButton)
        naviStackView.addArrangedSubview(naviTitleStackView)


        addSubview(naviStackView)
        largeTitleStackView.addArrangedSubview(largeTitleLabel)
        largeTitleStackView.addArrangedSubview(largeTitleAssocciateButton)
        addSubview(largeTitleStackView)
    }

    private func activateConstriants() {
        let topPadding = safeAreaInsets.top + 24

        leftNaviButton.snp.makeConstraints { maker in
            maker.size.equalTo(22)
        }

        naviStackView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(topPadding)
            maker.left.equalToSuperview().offset(24)
            maker.right.lessThanOrEqualToSuperview().offset(-24)
            maker.height.equalTo(28)
        }

        largeTitleStackView.snp.makeConstraints {
            $0.top.equalTo(naviStackView.snp.bottom).offset(14)
            $0.left.equalTo(naviStackView)
            $0.right.lessThanOrEqualToSuperview().offset(-24)
            $0.height.equalTo(34)
        }

        snp.makeConstraints { make in
            let height: CGFloat = CustomDynamicAlphaNavigationView.navigationBarHeight + CustomDynamicAlphaNavigationView.largeNavigationBarHeight
            make.height.equalTo(height)
        }
    }

    func setTitleText(to text: String) {
        naviTitleLabel.text = text
        largeTitleLabel.text = text
    }

    func setAssocateButtonImageName(to name: String) {
        naviTitleAssociateButton.setImage(UIImage(named: name), for: .normal)
        naviTitleAssociateButton.isHidden = false
        largeTitleAssocciateButton.setImage(UIImage(named: name), for: .normal)
        largeTitleAssocciateButton.isHidden = false
    }

    @objc
    private func associateButtonDidTapped() {
        onAssociateButtonTap?()
    }

    @objc
    private func leftNaviButtonDidTapped() {
        onLeftNaviButtonTap?()
    }
}
