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
        return MoviesListViewModel( delegate: self )
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init the static view
        initView()
                
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
        tableView.prefetchDataSource = self
        
        activityIndicator.style = .large
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = ColorPalette.RWGreen
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
        
        if isLoadingCell(for: indexPath) {
          cell.configure(with: .none)
        } else {
          cell.configure(with: viewModel.getMovie(at: indexPath.row))
        }
        
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        self.viewModel.userPressed(at: indexPath)
        return indexPath
       
    }

}

extension SearchListViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    if indexPaths.contains(where: isLoadingCell) {
        guard let query = searchBar.text else {
          return
        }
        
        viewModel.searchMovies(for: query)
    }
  }
}

extension SearchListViewController: MoviesListViewModelDelegate {
  func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
    
    guard let newIndexPathsToReload = newIndexPathsToReload else {
      activityIndicator.stopAnimating()
      tableView.isHidden = false
      tableView.reloadData()
      return
    }
    
    let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
    tableView.reloadRows(at: indexPathsToReload, with: .automatic)
  }
  
  func onFetchFailed(with reason: String) {
      activityIndicator.stopAnimating()
    
      showAlert(reason)
  }
}

private extension SearchListViewController {
  func isLoadingCell(for indexPath: IndexPath) -> Bool {
    return indexPath.row >= viewModel.currentCount
  }
  
  func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
    let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
    let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
    return Array(indexPathsIntersection)
  }
}

// MARK: - UISearchBarDelegate
extension SearchListViewController: UISearchBarDelegate {
    
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let query = searchBar.text else {
      return
    }
    
      viewModel.searchMovies(for: query)
      searchBar.resignFirstResponder()
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    
      searchBar.text = nil
      searchBar.resignFirstResponder()
    
  }
}

// MARK: - Navigation
extension SearchListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MovieDetailViewController,
            let movieDetailImdbId = viewModel.selectedMovieImdbID {
            vc.movieDetailImdbId = movieDetailImdbId
                        
        }
    }
}


