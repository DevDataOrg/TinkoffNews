//
//  TableViewViewModel.swift
//  TinkoffNews
//
//  Created by Daniil on 30.01.2020.
//  Copyright © 2020 Daniil. All rights reserved.
//

import Foundation
import CoreData

class MainViewViewModel {
    
    typealias Dependencies = HasCoreDataManager & HasAPIManager
    
    private let apiManager: APIManager
    private let coreDataManager: CoreDataManager
    
    init(dependencies: Dependencies) {
        self.apiManager = dependencies.apiManager
        self.coreDataManager = dependencies.coreDataManager
    }
    
    private var newsList: [NSManagedObject] = []
    private let offset: Int = 20
    private var urlOffest: Int {
        return newsList.count
    }
    
    var context: NSManagedObjectContext!
    
    var currentCountOfNews: Int {
        return newsList.count - 1
    }
}

extension MainViewViewModel {
    
    func numberOfRowsInSection() -> Int {
        return newsList.count
    }
    
    func cellViewModel(for indexPath: IndexPath) -> CellViewModel {
        let newsForIndexPath = newsList[indexPath.row]
        
        return CellViewModel(news: newsForIndexPath)
    }
    
    func detailViewModel(for indexPath: IndexPath) -> DetailViewModel {
        let newsForIndexPath = newsList[indexPath.row]
        
        return DetailViewModel(for: newsForIndexPath)
    }
    
    func getNews(completionHandler: @escaping (Result<String, Error>) -> ()) {
    
        if coreDataManager.isAvailableData() {
            let fetchRequest: NSFetchRequest<News> = News.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
            do {
                self.newsList = try context.fetch(fetchRequest)
            } catch {
                print(error)
                completionHandler(.failure(error))
            }
        } else {
            apiManager.loadNews(with: urlOffest) { result  in
                switch result {
                case .success(let newNews):
                    DispatchQueue.main.async {
                        for news in newNews {
                            self.newsList.append(self.coreDataManager.createAndSaveEntityWithData(data: news))
                        }
                        completionHandler(.success("Success"))
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
        
    }
    
    func updateNews(completionHandler: @escaping (Result<String, Error>) -> ()) {
        
        let urlOffsetForUpdate: Int = 0
        var temporaryListOfNews: [NewsDescription] = []
        
        apiManager.loadNews(with: urlOffsetForUpdate) { result in
            switch result {
            case .success(let newNews):
                temporaryListOfNews = newNews
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        
        for tempNews in temporaryListOfNews {
            if coreDataManager.newsIsAlreadyExist(news: tempNews) {
                completionHandler(.success("Success"))
            } else {
                self.newsList.append(self.coreDataManager.createAndSaveEntityWithData(data: tempNews))
            }
        }
        
        completionHandler(.success("Success"))
    }
    
    func getMoreNews(completionHandler: @escaping (Result<String, Error>) -> ()) {
        apiManager.loadNews(with: urlOffest) { result in
            
            switch result {
            case .success(let newNews):
                DispatchQueue.main.async {
                    for news in newNews {
                        self.newsList.append(self.coreDataManager.createAndSaveEntityWithData(data: news))
                    }
                    completionHandler(.success("Success"))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func increaseCountOfViews(at indexPath: IndexPath) {
        let oldCountOfViews: Int = (newsList[indexPath.row].value(forKey: "countOfViews") as? Int)!
        let newCountOfViews = oldCountOfViews + 1
        
        newsList[indexPath.row].setValue(newCountOfViews, forKey: "countOfViews")
        
        coreDataManager.save()
    }
}
