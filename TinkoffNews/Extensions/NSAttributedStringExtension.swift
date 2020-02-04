//
//  NSAttributedStringExtension.swift
//  TinkoffNews
//
//  Created by Daniil on 03.02.2020.
//  Copyright © 2020 Daniil. All rights reserved.
//

import Foundation

extension NSAttributedString {
    
    convenience init?(fromHTMLString html: String) {
        guard let data = html.data(using: .utf8) else { return nil }
        
        try? self.init(data: data, options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        )
    }
    
}
