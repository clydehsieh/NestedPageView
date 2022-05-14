//
//  ViewController.swift
//  NestedScrollViewExample
//
//  Created by ClydeHsieh on 2022/5/14.
//

import UIKit

class ViewController: UIViewController {

    private let nestedPageView: NestedPageView = {
        let layout = NestedPageViewLayout()
        layout.pageEdgeInsets = .init(top: 114, left: 0, bottom: 0, right: 0)
        let view = NestedPageView(layout: layout)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

