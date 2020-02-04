//
//  DetailNews.swift
//  TinkoffNews
//
//  Created by Daniil on 02.02.2020.
//  Copyright © 2020 Daniil. All rights reserved.
//

import Foundation

struct DetailNewsResponse: Decodable {
    var response: DetailNews
}

struct DetailNews: Decodable {
    var title: String
    var text: String
}
