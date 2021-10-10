//
//  ViewController.swift
//  OMDB
//
//  Created by Alex on 09/10/21.
//  Copyright © 2021 test. All rights reserved.
//

import UIKit
import AlamofireImage

class SearchListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    lazy var viewModel: MoviesListViewModel = {
        return MoviesListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init the static view
        initView()
        
        // init view model
        initVM()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = Strings.homeTitle

        if let searchText = searchBar.text, !searchText.isEmpty {
          return
        }
    }
    
    //Mark: Setup View Methods
    func initView() {
        searchBar.delegate = self
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func initVM() {
        
        // Naive binding
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 0.0
                    })
                }else {
                    self?.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: Strings.alertTitle, message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension SearchListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.movieListCellId, for: indexPath) as? MoviesListTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        
        let cellVM = viewModel.getCellViewModel( at: indexPath )

        cell.lblTittle.text = cellVM.titleText
        cell.lblYear.text = cellVM.yearText
//        cell.imageMovie.image = UIImage(named: "placeholder")
        
        
        let url = URL(string: cellVM.imageUrl)!
        let placeholderImage = UIImage(named: "placeholder")!

        cell.imageMovie.af.setImage(withURL: url, placeholderImage: placeholderImage)
//        cell.imageTopStory.imageFromServerURL(cellVM.imageUrl,placeHolder: UIImage(named: "placeholder"))
        
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

// MARK: - UISearchBarDelegate
extension SearchListViewController: UISearchBarDelegate {
    
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let query = searchBar.text else {
      return
    }
    
      viewModel.searchMovies(for: query)
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    
      searchBar.text = nil
      searchBar.resignFirstResponder()
    
  }
    
}
