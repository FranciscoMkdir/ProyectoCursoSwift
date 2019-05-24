//
//  DetailViewController.swift
//  ejemplo1
//
//  Created by macbook on 22/05/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit

protocol UpdateEmployeeProtocol: class {
    func update(employee: Employee)
}

class DetailViewController: UIViewController {
    weak var delegate: UpdateEmployeeProtocol?
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var areaTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var seniorityTextField: UITextField!
    @IBOutlet weak var maritalTextField: UITextField!
    @IBOutlet weak var roleTextField: UITextField!
    @IBOutlet weak var productsTextField: UITextField!
    
    var employee: Employee?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DETALLE DE EMPLEADO"
        guard let employee = employee else {return}
        setDetail(employee: employee)
    }
    
    private func setDetail(employee: Employee){
        idLabel.text = "ID empleado: \(employee.id ?? 0)"
        nameLabel.text = employee.name
        emailTextField.text = employee.email
        companyLabel.text = employee.company
        areaTextField.text = employee.area
        addressTextField.text = employee.address
        seniorityTextField.text = employee.seniority
        ageLabel.text = employee.age
        birthdayLabel.text = "Cumpleaños: \(dateFromTimestamp(birthday: employee.birthday) ?? "Sin especificar")"
        roleTextField.text = employee.role ?? "Sin especificar"
        maritalTextField.text = employee.maritalStatus ?? "Sin especificar"
        productsTextField.text = employee.productsPurchased ?? "Sin especificar"
    }
    
    
    @IBAction func update() {
        guard var employee = employee else { return }
        employee.email = emailTextField.text
        employee.area = areaTextField.text
        employee.address = addressTextField.text
        employee.seniority =  seniorityTextField.text
        employee.maritalStatus = maritalTextField.text
        employee.role = roleTextField.text
        employee.productsPurchased = productsTextField.text
        
        activityIndicator.startAnimating()
        if CoreDataManager.editEmployee(employee){
            showAlertController(success: true)
            delegate?.update(employee: employee)
        }else{
            showAlertController(success: false)
        }
        activityIndicator.stopAnimating()
    }
    
    private func showAlertController(success: Bool){
        let alertController = UIAlertController(title: success ? "Actualización" : "Error",
                                                message: success ? "Los datos se actualizaron" : "Los datos no pudieron salvarse",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func dateFromTimestamp(birthday: String?) -> String?{
        guard let birthdayString = birthday,
              let birthday = Double(birthdayString) else {
                return nil
        }
        let date = Date(timeIntervalSince1970: birthday)
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd/MM/yyy"
        return dateFormater.string(from: date)
    }

}
