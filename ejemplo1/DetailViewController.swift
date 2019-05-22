//
//  DetailViewController.swift
//  ejemplo1
//
//  Created by macbook on 22/05/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var seniorityLabel: UILabel!
    @IBOutlet weak var dateInPayrollLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var marialStatusLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    
    
    @IBOutlet weak var productsPurchasedLabel: UILabel!
    
    var employee: Employee?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DETALLE DE EMPLEADO"
        guard let employee = employee else {return}
        setDetail(employee: employee)
    }
    
    private func setDetail(employee: Employee){
        nameLabel.text = employee.name
        emailLabel.text = employee.email
        companyLabel.text = employee.company
        areaLabel.text = employee.area
        adressLabel.text = employee.address
        seniorityLabel.text = employee.seniority
        dateInPayrollLabel.text =  "Fecha de Pago: \(dateFromTimestamp(birthday: employee.dateInPayroll) ?? "Sin especificar")"
        ageLabel.text = employee.age
        birthdayLabel.text = "Cumpleaños: \(dateFromTimestamp(birthday: employee.birthday) ?? "Sin especificar")"
        roleLabel.text = employee.role
        marialStatusLabel.text = employee.maritalStatus
        productsPurchasedLabel.text = employee.productsPurchased ?? "Sin especificar"
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
