//
//  ViewController.swift
//  8_puzzle_iOS
//
//  Created by Abdalla Elsaman on 11/15/20.
//  Copyright © 2020 Dumbies. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let cppWrapper = CPPWrapper()
        cppWrapper.bfs("182043765")
    }


}

