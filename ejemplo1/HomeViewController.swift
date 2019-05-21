//
//  HomeViewController.swift
//  ejemplo1
//
//  Created by macbook on 20/05/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    var model: Model?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "INICIO"
    }

    @IBAction func showListEmployees() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ListViewController") as? ListViewController else {return}
        vc.model = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
