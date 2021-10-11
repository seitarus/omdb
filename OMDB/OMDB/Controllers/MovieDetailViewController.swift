//
//  TopStoryDetailViewController.swift
//  CodingTest
//
//  Created by faizal on 07/10/18.
//  Copyright © 2018 test. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailViewController: UIViewController {
    
    var movieDetailImdbId : String?
    
    lazy var viewModel: MovieDetailViewModel = {
        return MovieDetailViewModel()
    }()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblGenre: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblWeb: UILabel!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init the static view
        initView()
        
        // init view model
        initVM()
    }
    
    //Mark: Setup View Methods
    func initView() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageMovie.isUserInteractionEnabled = true
        imageMovie.addGestureRecognizer(tapGestureRecognizer)
        
        self.lblTitle.text       = ""
        self.lblDate.text        = ""
        self.lblDuration.text    = ""
        self.lblGenre.text       = ""
        self.lblDescription.text = ""
        self.lblWeb.text         = ""
        
        activityIndicator.style = .large
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = ColorPalette.RWGreen
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
                    
                }else {
                    self?.activityIndicator.stopAnimating()
                    
                }
            }
        }
        
        viewModel.reloadViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
        
        if let movieDetailImdbId = movieDetailImdbId {
            viewModel.fetchMovie(by: movieDetailImdbId)
        }
        
    }
    
    func updateUI()  {
        
        self.navigationController?.navigationBar.topItem?.title = ""
        
        if let movieDetail = viewModel.getMovie() {
            
            if let posterUrl = movieDetail.poster, let url = URL(string: posterUrl) {
                    
                let placeholderImage = UIImage(named: "placeholder")!

                imageMovie.af.setImage(withURL: url, placeholderImage: placeholderImage)
            }
                        
            self.navigationItem.title = movieDetail.title
            
            self.lblTitle.text = movieDetail.title
            self.lblDate.text = movieDetail.released
            self.lblDuration.text = movieDetail.runtime
            self.lblGenre.text = movieDetail.genre
            self.lblDescription.text = movieDetail.plot
            self.lblWeb.text = movieDetail.website
            
            shareButton.isEnabled = (movieDetail.website != nil && movieDetail.website != "N/A" )
        }
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: Strings.alertTitle, message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sharePressed(_ sender: UIBarButtonItem) {
    
        if let movieDetail = viewModel.getMovie(), let text = movieDetail.website, text != "N/A" {
        
            let textToShare = [ text ]
            let activityViewController = UIActivityViewController(activityItems: textToShare as [Any], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        viewModel.downloadImage { imageUrl in
            
            DispatchQueue.main.async {
                
                self.openImage(url: imageUrl)
            }
        }
    }
    
    func openImage(url: URL) {
        
        self.performSegue(withIdentifier: SegueIdentifier.showImageSegue, sender: url)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == SegueIdentifier.showImageSegue {
           
           let destinationVc = segue.destination as! ImagePreviewViewController
           
           if let imageUrl = sender as? URL {
               
               let data = try! Data.init(contentsOf: imageUrl)
               let photo = UIImage.init(data: data)
               destinationVc.image = photo
           }
       }
    }
}
