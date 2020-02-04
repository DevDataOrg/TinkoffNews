//
//  APIManager.swift
//  TinkoffNews
//
//  Created by Daniil on 30.01.2020.
//  Copyright © 2020 Daniil. All rights reserved.
//

import Foundation

class APIManager {
    
    private let session = URLSession.shared
    private let defaultStringForListOfNews = "https://cfg.tinkoff.ru/news/public/api/platform/v1/getArticles?pageSize=20&pageOffset="
    private let defaultStringForDetailNews = "https://cfg.tinkoff.ru/news/public/api/platform/v1/getArticle?urlSlug="
    
    var news: [NewsDescription] = []
}

extension APIManager {
    
    func loadNews(with urlOffset: Int, completionHandler: @escaping (Result<[NewsDescription], Error>) -> ()) {
        
        let urlString = defaultStringForListOfNews + "\(urlOffset)"
        guard let url = URL(string: urlString) else { return }
        
        session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
            }
            
            guard let data = data else { return }
            
            do {
                let decodedData = try JSONDecoder().decode(ResponseDescription.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(.success(decodedData.response.news))
                }
            } catch {
                print(error)
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
            }
        }.resume()
    }
    
    func loadTextForNews(with urlSlug: String, completionHandler: @escaping (Result<DetailNews, Error>) -> ()) {
        guard let url = URL(string: defaultStringForDetailNews + urlSlug) else { return }
        
        session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
            }
            
            guard let data = data else { return }
            
            do {
                let decodedData = try JSONDecoder().decode(DetailNewsResponse.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(.success(decodedData.response))
                }
            } catch {
                print(error)
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
            }
        }.resume()
    }
}
