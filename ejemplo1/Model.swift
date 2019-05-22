//
//  Model.swift
//  ejemplo1
//
//  Created by macbook on 20/05/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import Foundation

struct EmployeesWS: Codable {
    var employees = [Employee]()
    
    enum CodingKeys: String, CodingKey {
        case employees = "data"
    }

}

struct Employee: Codable {
    var id: Int?
    var name: String?
    var email: String?
    var photo: String?
    var address: String?
    var company: String?
    var area: String?
    var seniority: String?
    var dateInPayroll: String?
    var birthday: String?
    var age: String?
    var maritalStatus: String?
    var role: String?
    var productsPurchased: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "idEmployee"
        case name = "fullName"
        case email, photo, address, seniority
        case company, area, dateInPayroll, birthday
        case age, maritalStatus, role, productsPurchased
    }
}


protocol UpdateModelDelegate: class {
    func inserNewUser(_ user: User)
}

enum ErrorLogin: Error {
    case passwordIncorrect
    case userNotFound
}

extension ErrorLogin: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .passwordIncorrect: return "Contraseña incorrecta"
        case .userNotFound: return "Usuario no encontrado"
        }
    }
}

struct Model {
    let dateFormater = DateFormatter()
    var users = [User]()
    
    mutating func start(){
        dateFormater.dateFormat = "dd/MM/yyy"
        users.append(User(nombre: "Francisco Javier",
                          date: dateFormater.date(from: "08/02/1990")!,
                          email: "francisco@gmail.com",
                          numberEmployee: "001",
                          phone: "22222222",
                          password: "password1"))
        
        users.append(User(nombre: "Javier Ramirez",
                          date: dateFormater.date(from: "24/05/1992")!,
                          email: "javier@gmail.com",
                          numberEmployee: "001",
                          phone: "22222222",
                          password: "password1"))
        
        users.append(User(nombre: "Miguel Dolores",
                          date: dateFormater.date(from: "04/01/1985")!,
                          email: "miguel@gmail.com",
                          numberEmployee: "001",
                          phone: "22222222",
                          password: "password1"))
        
        users.append(User(nombre: "Rosalia",
                          date: dateFormater.date(from: "19/05/1992")!,
                          email: "rosalia@gmail.com",
                          numberEmployee: "001",
                          phone: "22222222",
                          password: "password1"))
    }
    
    mutating func appendNew(user: User){
        users.append(user)
    }
    
    func isUserRegistered(email: String) -> User?{
        guard let user = users.first(where: { $0.email == email }) else {
            return nil
        }
        return user
    }
    
    func validUserWith(email: String, password: String) -> (User?,  Error?){
        guard let user = isUserRegistered(email: email) else {
            return (nil, ErrorLogin.userNotFound)
        }
        if user.password != password{
            return (nil, ErrorLogin.passwordIncorrect)
        }
        return (user, nil)
    }
}

struct User {
    let nombre: String
    let date: Date
    let email: String
    let numberEmployee: String
    let phone: String
    let password: String
}



