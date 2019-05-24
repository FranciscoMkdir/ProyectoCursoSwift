//
//  ListViewController.swift
//  ejemplo1
//
//  Created by macbook on 20/05/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var model: Model?
    var employees = [Employee]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "EMPLEADOS"
        tableView.delegate = self
        getEmployees()
    }
    
    private func getEmployees(){
        activityIndicator.startAnimating()
        guard let employees = CoreDataManager.getEmployees() else{
            fetchEmployeesFromWS()
            return
        }
        if employees.isEmpty {
            fetchEmployeesFromWS()
            return
        }
        activityIndicator.stopAnimating()
        self.employees = employees
        tableView.reloadData()
    }
    
    private func fetchEmployeesFromWS(){
        Webservice().loadAllEmployees { [weak self] (result) in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                guard let result = result else {return}
                self?.employees = result
                self?.tableView.reloadData()
                self?.saveEmployeesCoreData()
            }
        }
    }
    
    func saveEmployeesCoreData(){
        CoreDataManager.saveEmployees(employees)
    }
    
    private func showDetailController(employee: Employee){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            fatalError("Error instantiate DetailViewController")
        }
        vc.delegate = self
        vc.employee = employee
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func shareBirthday(button: UIButton){
        guard let employee = employees[safe: button.tag] else {return}
        let title = "Feliz cumpleaños \(employee.name ?? "")"
        let image = UIImage(named: "iconShare")
        let activityController = UIActivityViewController(activityItems: [title, image!], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    }
}

extension ListViewController: UpdateEmployeeProtocol{
    func update(employee: Employee) {
        guard let index = employees.firstIndex(where: { $0.id == employee.id }) else {return}
        employees[index] = employee
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellUser", for: indexPath) as? UserTableViewCell else{
            fatalError("Error: initializate UITableViewCell with identifier cellUser")
        }
        cell.employee = employees[safe: indexPath.row]
        cell.selectionStyle = .none
        cell.buttonShare.tag = indexPath.row
        cell.buttonShare.addTarget(self, action: #selector(self.shareBirthday(button:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let employee = employees[safe: indexPath.row] else {return}
        showDetailController(employee: employee)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}




