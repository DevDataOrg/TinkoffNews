//
//  DetailViewController.swift
//  TinkoffNews
//
//  Created by Daniil on 02.02.2020.
//  Copyright © 2020 Daniil. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsTextLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: DetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        newsTextLabel.text = ""
        newsTitleLabel.text = ""
        activityIndicator.startAnimating()
        
        viewModel.loadDetailNews { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.newsTitleLabel.text = self.viewModel.newsTitle
                    self.newsTextLabel.attributedText = self.viewModel.newsText
                    self.newsTextLabel.accessibilityScroll(.down)
                }
            case .failure(let error):
                self.showAlertForError(error: error.localizedDescription)
            }
        }
    }
}

extension DetailViewController {
    
    func showAlertForError(error: String) {
        let ac = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
        let acAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        ac.addAction(acAction)
        self.present(ac, animated: true, completion: nil)
    }
}
