//
//  LoginViewController.swift
//  ejemplo1
//
//  Created by macbook on 20/05/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var model = Model()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        model.start()
        setupView()
    }
    
    func setupView(){
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func validateUser() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }
        if email.isEmpty{
            showErrorAlert(message: "Porfavor insertar correo electronico")
            return
        }
        if password.isEmpty{
            showErrorAlert(message: "Porfavor insertar contrasseña")
            return
        }
        let (user, error) = model.validUserWith(email: email, password: password)
        guard let _ = user else {
            showErrorAlert(message: error?.localizedDescription ?? "error")
            return
        }
        goHomeViewController()
    }
    
    func goHomeViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else {return}
        vc.model = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showErrorAlert(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let recoverController = segue.destination as? RecoverPasswordViewController  {
            recoverController.model = model
        }
        if let registerController = segue.destination as? RegisterViewController {
            registerController.model = model
            registerController.delegate = self
        }
    }
}

extension LoginViewController: UpdateModelDelegate{
    func inserNewUser(_ user: User) {
        model.appendNew(user: user)
    }
}

extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
