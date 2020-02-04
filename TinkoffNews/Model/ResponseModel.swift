//
//  ResponseModel.swift
//  TinkoffNews
//
//  Created by Daniil on 30.01.2020.
//  Copyright © 2020 Daniil. All rights reserved.
//

import Foundation

struct ResponseDescription: Decodable {
    var response: NewsResponse
}

struct NewsResponse: Decodable {
    var news: [NewsDescription]
}

struct NewsDescription: Decodable {
    var title: String
    var slug: String
    var id: String
}
