//
//  DetailViewModel.swift
//  TinkoffNews
//
//  Created by Daniil on 02.02.2020.
//  Copyright © 2020 Daniil. All rights reserved.
//

import Foundation
import CoreData

class DetailViewModel {
    
    private var apiManager = APIManager()
    private var news: NSManagedObject
    
    var newsTitle: String = ""
    var newsText: NSAttributedString!
    
    init(for news: NSManagedObject) {
        self.news = news
    }
}

extension DetailViewModel {
    
    func loadDetailNews(completionHandler: @escaping (Result<String, Error>) -> ()) {
        
        if let newsText = news.value(forKey: "text"), let newsTitle = news.value(forKey: "title") {
            DispatchQueue.main.async {
                if let attributedString = NSAttributedString(fromHTMLString: "\(newsText)") {
                    self.newsText = attributedString
                }
                self.newsTitle = "\(newsTitle)"
            }
            completionHandler(.success("Success"))
        } else {
            let urlSlug = "\(news.value(forKey: "slug") ?? "")"
            
            apiManager.loadTextForNews(with: urlSlug) { result in
                
                switch result {
                case .success(let detailNews):
                    DispatchQueue.main.async {
                        let data = Data(detailNews.text.utf8)
                        if let dataString = String(bytes: data, encoding: .utf8),
                            let attributedString = NSAttributedString(fromHTMLString: dataString) {
                            self.newsText = attributedString
                            self.newsTitle = detailNews.title
                        }
                        completionHandler(.success("Success"))
                    }
                    print(detailNews.text)
                    self.news.setValue(detailNews.text, forKey: "text")
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }
}
