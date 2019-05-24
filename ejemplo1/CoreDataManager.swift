//
//  CoreDataManager.swift
//  ejemplo1
//
//  Created by macbook on 24/05/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import Foundation
import CoreData

let CoreDataManager = CoreDataManagerClass()

class CoreDataManagerClass {
    fileprivate init() {}
    
    func editEmployee(_ element: Employee) -> Bool{
        guard let id = element.id else {return false}
        let manageContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EmployeeCD")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let result = try manageContext.fetch(fetchRequest)
            guard let employee = (result as? [NSManagedObject])?.first else {return false}
            employee.setValue(element.email, forKey: "email")
            employee.setValue(element.photo, forKey: "photo")
            employee.setValue(element.address, forKey: "address")
            employee.setValue(element.area, forKey: "area")
            employee.setValue(element.seniority, forKey: "seniority")
            employee.setValue(element.dateInPayroll, forKey: "dateInPayroll")
            employee.setValue(element.maritalStatus, forKey: "maritalStatus")
            employee.setValue(element.role, forKey: "role")
            employee.setValue(element.productsPurchased, forKey: "productsPurchased")
            do{
                try manageContext.save()
                return true
            }catch let error{
                print("No se pudo guardar los cambios: \(error.localizedDescription)")
                return false
            }
        }catch let error{
            print("No se pudo actualizar: \(error.localizedDescription)")
            return false
        }
    }
    
    
    func saveEmployees(_ employees: [Employee]){
        let manageContext = persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "EmployeeCD", in: manageContext) else {return}
        for element in employees{
            let employee = NSManagedObject(entity: entity, insertInto: manageContext)
            employee.setValue(element.id, forKey: "id")
            employee.setValue(element.name, forKey: "name")
            employee.setValue(element.email, forKey: "email")
            employee.setValue(element.photo, forKey: "photo")
            employee.setValue(element.address, forKey: "address")
            employee.setValue(element.company, forKey: "company")
            employee.setValue(element.area, forKey: "area")
            employee.setValue(element.seniority, forKey: "seniority")
            employee.setValue(element.dateInPayroll, forKey: "dateInPayroll")
            employee.setValue(element.birthday, forKey: "birthday")
            employee.setValue(element.age, forKey: "age")
            employee.setValue(element.maritalStatus, forKey: "maritalStatus")
            employee.setValue(element.role, forKey: "role")
            employee.setValue(element.productsPurchased, forKey: "productsPurchased")
        }
        do{
            try manageContext.save()
        }catch let error{
            print("No se pudo guardar: \(error.localizedDescription)")
        }
    }
    
    func getEmployees() -> [Employee]? {
        let manageContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EmployeeCD")
        do{
            let result = try manageContext.fetch(fetchRequest)
            return convertObjectsToEmployees(result)
        }catch let error{
            print("No se pudieron obetener los datos: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    private func convertObjectsToEmployees(_ result: [Any]) -> [Employee]?{
        guard let objects = result as? [NSManagedObject] else {
            return nil
        }
        var employees = [Employee]()
        for object in objects{
            var newEmployee = Employee()
            newEmployee.id = object.value(forKey: "id") as? Int
            newEmployee.name = object.value(forKey: "name") as? String
            newEmployee.email = object.value(forKey: "email") as? String
            newEmployee.photo = object.value(forKey: "photo") as? String
            newEmployee.address = object.value(forKey: "address") as? String
            newEmployee.company = object.value(forKey: "company") as? String
            newEmployee.area = object.value(forKey: "area") as? String
            newEmployee.seniority = object.value(forKey: "seniority") as? String
            newEmployee.dateInPayroll = object.value(forKey: "dateInPayroll") as? String
            newEmployee.birthday = object.value(forKey: "birthday") as? String
            newEmployee.age = object.value(forKey: "age") as? String
            newEmployee.maritalStatus = object.value(forKey: "maritalStatus") as? String
            newEmployee.role = object.value(forKey: "role") as? String
            newEmployee.productsPurchased = object.value(forKey: "productsPurchased") as? String
            employees.append(newEmployee)
        }
        return employees
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

