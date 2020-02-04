//
//  DependencyContainer.swift
//  TinkoffNews
//
//  Created by Daniil on 04.02.2020.
//  Copyright © 2020 Daniil. All rights reserved.
//

import Foundation
import CoreData

protocol HasCoreDataManager {
    var coreDataManager: CoreDataManager { get }
}

protocol HasAPIManager {
    var apiManager: APIManager { get }
}

typealias HasAllDependencies = HasCoreDataManager & HasAPIManager

struct DependencyContainer: HasAllDependencies {
    let apiManager: APIManager
    let coreDataManager: CoreDataManager
    let contextForCoreDataManager: NSManagedObjectContext
    
    init(contextForCoreDataManager: NSManagedObjectContext) {
        self.contextForCoreDataManager = contextForCoreDataManager
        self.coreDataManager = CoreDataManager(context: self.contextForCoreDataManager)
        self.apiManager = APIManager()
    }
}
