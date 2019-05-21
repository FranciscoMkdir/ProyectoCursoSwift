//
//  Services.swift
//  ejemplo1
//
//  Created by macbook on 21/05/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit

let url = URL(string: "http://www.develogeek.com/netec/capitulo4/consumoApi/Empleados/getList.php")!

final class Webservice{
    typealias Handler = ([Employee]?) -> ()
    
    func loadAllEmployees(completion: @escaping Handler){
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(response)
            print(error)
            guard let data = data else {
                return completion(nil)
            }
            do{
                let result =  try JSONDecoder().decode([Employee].self, from: data)
                return completion(result)
            }catch{
                return completion(nil)
            }
        }
    }
    
}
