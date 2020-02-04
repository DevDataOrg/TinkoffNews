//
//  CellViewController.swift
//  TinkoffNews
//
//  Created by Daniil on 30.01.2020.
//  Copyright © 2020 Daniil. All rights reserved.
//

import UIKit

class CellViewController: UITableViewCell {
    
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var viewsCountLabel: UILabel!
    
    weak var viewModel: CellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            
            newsTitleLabel.text = viewModel.title
            newsTitleLabel.numberOfLines = 0
            viewsCountLabel.text = "\(viewModel.viewsCount)"
        }
    }
}
