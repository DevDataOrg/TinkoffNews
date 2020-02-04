//
//  CellViewModel.swift
//  TinkoffNews
//
//  Created by Daniil on 30.01.2020.
//  Copyright © 2020 Daniil. All rights reserved.
//

import Foundation
import CoreData

class CellViewModel {
    
    private var news: NSManagedObject
    
    var title: String {
        return "\(news.value(forKey: "title") ?? "")"
    }
    
    var viewsCount: String {
        return "\(news.value(forKey: "countOfViews") ?? "0")"
    }
    
    init(news: NSManagedObject) {
        self.news = news
    }
}
