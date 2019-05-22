//
//  Services.swift
//  ejemplo1
//
//  Created by macbook on 21/05/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit

let url = URL(string: "http://www.develogeeks.com/netec/capitulo4/consumoApi/Empleados/getList.php")!

final class Webservice{
    typealias Handler = ([Employee]?) -> ()
    
    func loadAllEmployees(completion: @escaping Handler){
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                return completion(nil)
            }
            do{
                let result =  try JSONDecoder().decode(EmployeesWS.self, from: data)
                return completion(result.employees)
            }catch let error{
                print(error)
                return completion(nil)
            }
        }.resume()
    }
    
}
