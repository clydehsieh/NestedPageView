//
//  HorizontalPageContentView.swift
//  Eatgether
//
//  Created by ClydeHsieh on 2021/12/23.
//  Copyright © 2021 EatMe. All rights reserved.
//

import UIKit

protocol HorizontalPageContentViewDelegate: AnyObject {
    // scroll delegate
    func pageContentViewDidScroll(_ view: HorizontalPageContentView)
    func pageContentViewDidEndScroll(_ view: HorizontalPageContentView)
}

class HorizontalPageContentView: UnidirectionalAutoLayoutScrollView {

    //MARK: - Components
    private var pageViews: [UIView] = []
    
    
    //MARK: - Parameters
    weak var pageDelegate: HorizontalPageContentViewDelegate?
    
    @Published var currentPage: Int = 0
    
    // rate: 0 - 1, contentOffsetX 跑完的程度
    let scrollOffsetXRate: Dynamic<CGFloat> = .init(0)
    
    //MARK: - life cycle
    init() {
        super.init(direction: .horizontal)
        self.isPagingEnabled = true
        self.bounces = false
        delegate = self
    }
    
    func setupPages(_ pageViews: [UIView]) {
        self.pageViews = pageViews
        
        for (index, contentView) in pageViews.enumerated() {
            addSubview(contentView)
            contentView.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.width.equalTo(self.snp.width)
                if index == 0 {
                    $0.left.equalToSuperview()
                } else {
                    $0.left.equalTo(pageViews[index - 1].snp.right)
                }
                if index == pageViews.count - 1 {
                    $0.right.equalToSuperview()
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
extension HorizontalPageContentView {
    func forceScroll(to page: Int) {
        let offsetX = CGFloat(page) * frame.width
        setContentOffset(.init(x: offsetX, y: 0), animated: true)
    }
}
extension HorizontalPageContentView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageDelegate?.pageContentViewDidScroll(self)
        
        var offsetRate = scrollView.contentOffset.x / scrollView.contentSize.width
        offsetRate = min(max(0, offsetRate), 1)
        scrollOffsetXRate.value = offsetRate
        
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width + 0.5)
        if currentPage != page {
            currentPage = page
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageDelegate?.pageContentViewDidEndScroll(self)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageDelegate?.pageContentViewDidEndScroll(self)
    }
}
