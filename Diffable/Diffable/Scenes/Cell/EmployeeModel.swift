//
//  EmployeeModel.swift
//  Diffable
//
//  Created by Vladimir Ho on 20.12.2019.
//  Copyright © 2019 Viety Software. All rights reserved.
//

import UIKit

class EmployeeModel {

    struct Employee: Hashable { // ALL YOU NEED IS HASHABLE 👍
        let name: String
        let height: String
        
        
        let identifier = UUID() // MAKING IDENTIFIER 🔢
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier) // HASHING 🧩
        }
        static func == (lhs: Employee, rhs: Employee) -> Bool {
            return lhs.identifier == rhs.identifier // OVERLOADING == 💭
        }
        
        
        func contains(_ filter: String?) -> Bool {
            guard let filterText = filter else { return true }
            if filterText.isEmpty { return true }
            let lowercasedFilter = filterText.lowercased()
            return name.lowercased().contains(lowercasedFilter)
        }
    }
    func filteredEmployees(with filter: String? = nil, limit: Int? = nil) -> [Employee] {
        let filtered = mountains.filter { $0.contains(filter) }
        if let limit = limit {
            return Array(filtered.prefix(through: limit))
        } else {
            return filtered
        }
    }
    lazy var mountains: [Employee] = {
        return generateMountains()
    }()
}

extension EmployeeModel {
    private func generateMountains() -> [Employee] {
        let components = employeeRawData.components(separatedBy: CharacterSet.newlines)
        var mountains = [Employee]()
        for line in components {
            let mountainComponents = line.components(separatedBy: ",")
            let name = mountainComponents[0]
            let height = mountainComponents[1]
            mountains.append(Employee(name: name, height: height))
        }
        return mountains
    }
}
