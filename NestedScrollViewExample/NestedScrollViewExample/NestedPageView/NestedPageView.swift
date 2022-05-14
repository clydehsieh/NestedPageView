//
//  NestedPageView.swift
//  Eatgether
//
//  Created by ClydeHsieh on 2022/1/4.
//  Copyright © 2022 EatMe. All rights reserved.
//

import UIKit
import Combine

//MARK: - NestedPageViewDelegate
protocol NestedPageViewDelegate: AnyObject {
    // 允許其他頁面滾動
    func nestedPageView(view: NestedPageView, at index: Int, allowScroll: Bool)
    // 允許其他頁面互動
    func nestedPageView(view: NestedPageView, at index: Int, enableUserInteraction: Bool)
    // 換頁通知
    func nestedPageViewDidScrollToIndex(view: NestedPageView, to index: Int)
}

protocol NestedPageViewDatasource: AnyObject {
    // navigation
    func nestedPageViewNavigationView(view: NestedPageView) -> CustomDynamicAlphaNavigationViewController?
    // page number
    func nestedPageViewPageNumberOfPage(view: NestedPageView) -> Int
    // page segment
    func nestedPageViewSegmentControl(at index: Int) -> UIControl
    // page content view
    func nestedPageViewPageView(at index: Int) -> UIView
}

//MARK: - NestedPageView
class NestedPageView: NiblessView {
    //MARK: - Components
    private var customNavigation: CustomDynamicAlphaNavigationViewController?
    
    private let mainScrollView: NestedScrollView = {
        let v = NestedScrollView.init(direction: .vertical)
        v.bounces = false
        v.canScroll = true
        return v
    }()
    
    private lazy var pageView: HorizontalPageContentView = {
        HorizontalPageContentView()
    }()
    
    private let segmentView: PageSegmentView = {
        PageSegmentView()
    }()
    
    //MARK: - Parameters
    private let segmentViewTopPadding: PassthroughSubject<CGFloat, Never> = .init()
    private var subscribtions: Set<AnyCancellable> = Set<AnyCancellable>()
    
    private let layout: NestedPageViewLayout
    weak var datasource: NestedPageViewDatasource?
    weak var delegate: NestedPageViewDelegate?
    
    @Published var allowMainScroll: Bool = true
    
    //MARK: - Lifecycle
    init(layout: NestedPageViewLayout) {
        self.layout = layout
        super.init(frame: .zero)
        
        backgroundColor = .supportBg
        
        constructViewHierarchy()
        activateConstraints()
        
        setupBinding()
    }
    
    func reload() {
        configureNavigationView()
        configureMainScrollView()
        configurePages()
    }
    
    func currentPageIndex() -> Int {
        pageView.currentPage
    }
}

//MARK: - View Hierarchy
extension NestedPageView {
    private func constructViewHierarchy() {
        addSubview(mainScrollView)
        mainScrollView.addSubview(pageView)
        addSubview(segmentView)
    }
    
    private func activateConstraints() {
        let mainScrollViewHeight = UIScreen.main.bounds.height - layout.segmentCollapseMaxY()
        mainScrollView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(mainScrollViewHeight)
        }
        
        pageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(mainScrollView.snp.width)
            $0.height.equalTo(mainScrollViewHeight)
        }
        
        let segmentInitalPadding = layout.segmentTopConstraint(scrollDistance: 0)
        segmentView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(segmentInitalPadding)
            $0.left.equalToSuperview().offset(layout.pageEdgeInsets.left)
            $0.right.equalToSuperview().inset(layout.pageEdgeInsets.right)
            $0.height.equalTo(layout.segmentHeight)
        }
    }
    
    private func configureNavigationView() {
        guard let navigation = datasource?.nestedPageViewNavigationView(view: self) else { return }
        customNavigation?.view.removeFromSuperview()
        customNavigation = navigation
        
        insertSubview(navigation.view, at: 0)
        
        navigation.view.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
        }
    }
    
    private func configureMainScrollView() {
        mainScrollView.delegate = self
        mainScrollView.contentInset = .init(top: layout.segmentScrollMaxDistance, left: 0, bottom: 0, right: 0)
        allowMainScroll = true
    }
    
    private func configurePages() {
        
        pageView.removeAllSubView()
        pageView.pageDelegate = self

        guard let datasource = datasource else { return }
        let totalPage = datasource.nestedPageViewPageNumberOfPage(view: self)
        
        var buttons: [UIControl] = []
        var pageContentViews: [UIView] = []
        
        for pageIndex in 0..<totalPage {
            buttons.append(datasource.nestedPageViewSegmentControl(at: pageIndex))
            pageContentViews.append(datasource.nestedPageViewPageView(at: pageIndex))
        }
        
        pageView.setupPages( pageContentViews )
        segmentView.add(buttons)
        segmentView.moveSegmentLine(to: 0)
        buttons.first?.isSelected = true
    }
}

extension NestedPageView {
    private func setupBinding() {
        // bind horizontal scroll offset to segment line offset
        pageView.scrollOffsetXRate.bindAndFire { [weak self] rate in
            self?.segmentView.moveSegmentLine(to: rate)
        }
        
        pageView.$currentPage
            .sink { [weak self] currentPage in
                guard let self = self else { return }
                self.delegate?.nestedPageView(view: self, at: currentPage, allowScroll: true)
                self.segmentView.selectedIndex.send(currentPage)
            }
            .store(in: &subscribtions)
        
        segmentView.didTapControlIndex
            .sink { [weak self] index in
                self?.pageView.forceScroll(to: index)
            }
            .store(in: &subscribtions)
        
        segmentViewTopPadding
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newTopPadding in
                guard let self = self else { return }
                self.segmentView.snp.updateConstraints {
                    $0.top.equalToSuperview().offset(newTopPadding)
                }
            }
            .store(in: &subscribtions)
        
        $allowMainScroll
            .sink { [weak self] allowScroll in
                self?.mainScrollView.canScroll = allowScroll
            }
            .store(in: &subscribtions)
        
        pageView.$currentPage
            .sink { [weak self] page in
                guard let self = self else { return }
                self.delegate?.nestedPageViewDidScrollToIndex(view: self, to: page)
            }
            .store(in: &subscribtions)
    }
}

//MARK: - Scroll/ main
extension NestedPageView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // gesture
        if !mainScrollView.canScroll {
            mainScrollView.contentOffset.y = 0
            delegate?.nestedPageView(view: self, at: pageView.currentPage, allowScroll: true)
        } else {
            if mainScrollView.contentOffset.y >= 0 {
                mainScrollView.contentOffset.y = 0
                mainScrollView.canScroll = false
                delegate?.nestedPageView(view: self, at: pageView.currentPage, allowScroll: true)
            }
        }
        // segmentViewTopPadding
        let newPadding = layout.segmentTopConstraint(scrollDistance: scrollView.contentOffset.y)
        segmentViewTopPadding.send(newPadding)
        
        // navigation
        customNavigation?.scrollViewDidScroll(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        customNavigation?.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        customNavigation?.scrollViewDidEndDecelerating(scrollView)
    }
}

//MARK: - Scroll/ horizontal page, HorizontalNestedPageViewDelegate
extension NestedPageView: HorizontalPageContentViewDelegate {
    // when horizontal scrolling occur, disable vertical scrolling
    func pageContentViewDidScroll(_ view: HorizontalPageContentView) {
        mainScrollView.isScrollEnabled = false
        delegate?.nestedPageView(view: self, at: pageView.currentPage, enableUserInteraction: false)
    }

    func pageContentViewDidEndScroll(_ view: HorizontalPageContentView) {
        mainScrollView.isScrollEnabled = true
        delegate?.nestedPageView(view: self, at: pageView.currentPage, enableUserInteraction: true)
    }
}

