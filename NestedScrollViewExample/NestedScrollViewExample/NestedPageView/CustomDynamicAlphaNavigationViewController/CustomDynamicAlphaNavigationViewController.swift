//
//  CustomDynamicAlphaNavigationViewController.swift
//  Eatgether
//
//  Created by Chen Yi-Wei on 2021/11/24.
//  Copyright © 2021 EatMe. All rights reserved.
//

import UIKit

final class CustomDynamicAlphaNavigationViewController: NSObject {

    var onNavigationButtonTap: (() -> Void)? {
        didSet {
            view.onLeftNaviButtonTap = onNavigationButtonTap
        }
    }
    var onAssociateButtonTap: (() -> Void)? {
        didSet {
            view.onAssociateButtonTap = onAssociateButtonTap
        }
    }

    let view: CustomDynamicAlphaNavigationView = {
        let view = CustomDynamicAlphaNavigationView()
        return view
    }()

    init(viewModel: CustomDynamicAlphaNavigationViewModel) {
        view.setTitleText(to: viewModel.title)
        view.leftNaviButton.setImage(viewModel.navigationIconName.image, for: .normal)
        if let buttonIconName = viewModel.associateButtonIconName {
            view.setAssocateButtonImageName(to: buttonIconName)
        }
    }

    private func updateTitleLabelAlpha(with scrollView: UIScrollView) {
        let largeNavigationBarHeight = CustomDynamicAlphaNavigationView.largeNavigationBarHeight
        let offsetY = scrollView.contentOffset.y + scrollView.contentInset.top

        let alpha: CGFloat = min(1, max(0, offsetY / largeNavigationBarHeight))

        view.naviTitleStackView.alpha = alpha
        view.largeTitleStackView.alpha = 1 - alpha
    }

    private func updateTitlesAlphaWhenScrollEnding() {
        let naviTitleAlpha: CGFloat = view.naviTitleStackView.alpha >= 0.5 ? 1 : 0
        let largeTitleAlpha: CGFloat = 1 - naviTitleAlpha

        UIView.animate(withDuration: 0.3) { [self] in
            view.naviTitleStackView.alpha = naviTitleAlpha
            view.largeTitleStackView.alpha = largeTitleAlpha
        }
    }
}

// MARK: - Scroll view delegate
extension CustomDynamicAlphaNavigationViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateTitleLabelAlpha(with: scrollView)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            updateTitlesAlphaWhenScrollEnding()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateTitlesAlphaWhenScrollEnding()
    }
}
