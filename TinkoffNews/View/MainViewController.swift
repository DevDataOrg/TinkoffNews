//
//  TableViewController.swift
//  TinkoffNews
//
//  Created by Daniil on 30.01.2020.
//  Copyright © 2020 Daniil. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    var viewModel: MainViewViewModel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = myRefreshControll
        activityIndicator.startAnimating()
        
        viewModel.getNews { result in
            
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                    self.showAlertForError(error: error.localizedDescription)
                }
            }
        }
    }
    
    let myRefreshControll: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    @objc private func refresh(sender: UIRefreshControl) {
        viewModel.updateNews { result in
            
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlertForError(error: error.localizedDescription)
                }
            }
        }
        sender.endRefreshing()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CellView

        cell.viewModel = viewModel.cellViewModel(for: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.increaseCountOfViews(at: indexPath)
        tableView.reloadData()
        self.performSegue(withIdentifier: "ShowDetailController", sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.currentCountOfNews {
            viewModel.getMoreNews { result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlertForError(error: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    // MARK: – Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = sender as? IndexPath,
            let destination = segue.destination as? DetailViewController {
            destination.viewModel = viewModel.detailViewModel(for: indexPath)
        }
    }
}

extension UIViewController {
    
    func showAlertForError(error: String) {
        let ac = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
        let acAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        ac.addAction(acAction)
        self.present(ac, animated: true, completion: nil)
    }
}
