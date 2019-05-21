//
//  RecoverPasswordViewController.swift
//  ejemplo1
//
//  Created by macbook on 20/05/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit

class RecoverPasswordViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    var model: Model?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "RECUPERAR CONTRASEÑA"
        emailTextField.delegate = self
    }
    
    @IBAction func recover() {
        guard let email = emailTextField.text,
               let model = model else {return}
        if email.isEmpty{
            showAlert(success: false, message: "Porfavor escriba el correo electronico") {}
            return
        }
        guard let user = model.isUserRegistered(email: email) else {
            showAlert(success: false, message: "Usuario no encontrado") {}
            return
        }
        showAlert(success: true, message: "Contrase: \(user.password)") {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showAlert(success: Bool, message: String, completion: @escaping () -> ()){
        let alert = UIAlertController(title: success ? "Verificado" : "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: { (_) in
            completion()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension RecoverPasswordViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
