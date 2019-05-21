//
//  ListViewController.swift
//  ejemplo1
//
//  Created by macbook on 20/05/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var model: Model?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "EMPLEADOS"
        tableView.delegate = self
    }
    
    @objc func shareBirthday(button: UIButton){
        guard let user = model?.users[safe: button.tag] else {return}
        let title = "Feliz cumpleaños \(user.nombre)"
        let image = UIImage(named: "iconShare")
        let activityController = UIActivityViewController(activityItems: [title, image!], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.users.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellUser", for: indexPath) as? UserTableViewCell else{
            fatalError("Error: initializate UITableViewCell with identifier cellUser")
        }
        cell.user = model?.users[safe: indexPath.row]
        cell.selectionStyle = .none
        cell.buttonShare.tag = indexPath.row
        cell.buttonShare.addTarget(self, action: #selector(self.shareBirthday(button:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}




