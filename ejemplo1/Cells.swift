//
//  Cells.swift
//  ejemplo1
//
//  Created by macbook on 21/05/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit


class UserTableViewCell: UITableViewCell {
    let dateFormater = DateFormatter()
    @IBOutlet weak var buttonShare: UIButton!
    @IBOutlet weak var nameTextField: UILabel!
    @IBOutlet weak var dateTextField: UILabel!
    @IBOutlet weak var ageTextField: UILabel!
    
    
    var user: User?{didSet{
        guard let user = user else {return}
        nameTextField.text = user.nombre
        dateTextField.text = dateFormater.string(from: user.date)
        ageTextField.text = "\(Date().calculate(birthday: user.date)) años"
        buttonShare.isHidden = !Date().isCurrentBirthday(user.date)
        }}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buttonShare.isHidden = true
        dateFormater.dateFormat = "dd/MM/yyy"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        buttonShare.isHidden = true
    }
    
}
