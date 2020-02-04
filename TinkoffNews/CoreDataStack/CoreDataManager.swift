//
//  CoreDataManager.swift
//  TinkoffNews
//
//  Created by Daniil on 03.02.2020.
//  Copyright © 2020 Daniil. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func createAndSaveEntityWithData(data: NewsDescription) -> News {
        let newsEntity = News(context: self.context)
        newsEntity.newsId = data.id
        newsEntity.title = data.title
        newsEntity.slug = data.slug
        newsEntity.countOfViews = 0
        newsEntity.date = Date()
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.userInfo)
        }
        
        return newsEntity
    }
    
    func isAvailableData() -> Bool {
        
        let fetchRequest: NSFetchRequest<News> = News.fetchRequest()
        var newsListFromCD: [NSManagedObject] = []
        do {
            newsListFromCD = try context.fetch(fetchRequest)
        } catch {
            print(error)
        }
        
        if newsListFromCD.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    func newsIsAlreadyExist(news: NewsDescription) -> Bool {
        
        let fetchRequest: NSFetchRequest<News> = News.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "newsId = %@", news.id)
        
        var tempList: [NSManagedObject] = []
        
        do {
            tempList = try context.fetch(fetchRequest)
            print(tempList)
        } catch {
            print(error)
        }
        
        return tempList.count > 0
    }
    
    func save() {
        do {
            try context.save()
        } catch let error as NSError {
            print(error.userInfo)
        }
    }
    
}
