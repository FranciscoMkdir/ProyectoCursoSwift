//
//  RegisterViewController.swift
//  ejemplo1
//
//  Created by macbook on 20/05/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var dateTextFiel: UITextField!
    @IBOutlet weak var numberEmployeeTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var switchTerms: UISwitch!
    
    
    var activeField: UITextField?
    var model: Model?
    var delegate: UpdateModelDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "REGISTRO"
        setupView()
    }

    func setupView(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        nameTextField.delegate = self
        emailTextField.delegate = self
        dateTextFiel.delegate = self
        numberEmployeeTextField.delegate = self
        phoneTextField.delegate = self
        phoneTextField.tag = 1
        passwordTextField.delegate = self
        passwordTextField.tag = 1
        repeatPasswordTextField.delegate = self
        repeatPasswordTextField.tag = 1
        addDoneButtonOnKeyboard(textField: numberEmployeeTextField)
        addDoneButtonOnKeyboard(textField: phoneTextField)
    }
    
    
    @IBAction func registerUser() {
        view.endEditing(true)
        guard let name = nameTextField.text,
              let email = emailTextField.text,
              let date = dateTextFiel.text,
              let number =  numberEmployeeTextField.text,
              let phone = phoneTextField.text,
              let password = passwordTextField.text,
              let repatPassword = repeatPasswordTextField.text else {return}
        
        if name.isEmpty {
            showErrorAlert(message: "Nombre incorrecto")
            return
        }
        if email.isEmpty {
            showErrorAlert(message: "Email incorrect")
            return
        }
        if !validateEmail(email: email){
            showErrorAlert(message: "Formato de correo incorrecto")
            return
        }
        if date.isEmpty{
            showErrorAlert(message: "Fecha incorrecta")
            return
        }
        guard let dateUser = validateDate(date: date) else{
            showErrorAlert(message: "Formato de fecha incorrecta (dd/MM/yyy)")
            return
        }
        if number.isEmpty{
            showErrorAlert(message: "Número de empleado incorrecto")
            return
        }
        if phone.isEmpty{
            showErrorAlert(message: "Telefono incorrecto")
            return
        }
        if password.isEmpty{
            showErrorAlert(message: "Contrasña incorrecta")
            return
        }
        if repatPassword.isEmpty{
            showErrorAlert(message: "Contraseña repetida incorrecta")
            return
        }
        if password != repatPassword{
            showErrorAlert(message: "Las contraseñas no coinciden")
            return
        }
        
        if !switchTerms.isOn {
            showErrorAlert(message: "Porfavor aceptar terminos y condiciones")
            return
        }
        
        let user = User(nombre: name,
                        date: dateUser,
                        email: email,
                        numberEmployee: number,
                        phone: phone,
                        password: password)
        delegate?.inserNewUser(user)
        self.navigationController?.popViewController(animated: true)
    }
    
    func showErrorAlert(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func validateEmail(email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
    
    func validateDate(date: String) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        guard let dateUser = dateFormatter.date(from: date) else {
            return nil
        }
        return dateUser
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if activeField?.tag == 1{
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

extension RegisterViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func addDoneButtonOnKeyboard(textField: UITextField) {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Aceptar", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneButtonAction))
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        textField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
}



