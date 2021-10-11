//
//  MoviesListTableViewCell.swift
//  OMDB
//
//  Created by Alex on 09/10/21.
//  Copyright © 2021 test. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

class MoviesListTableViewCell: UITableViewCell {
    @IBOutlet weak var imageMovie: UIImageView!
    
    @IBOutlet weak var lblTittle: UILabel!
    
    @IBOutlet weak var lblYear: UILabel!
    
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    
    override func prepareForReuse() {
      super.prepareForReuse()
      
      configure(with: .none)
    }
    
    override func awakeFromNib() {
      super.awakeFromNib()
      
      indicatorView.hidesWhenStopped = true
      indicatorView.color = ColorPalette.RWGreen
    }
    
    func configure(with movie: MovieShort?) {
        if let movie = movie {
            lblTittle.text = movie.title
            lblYear.text  = movie.year
            
            let url = URL(string: movie.poster)!
            let placeholderImage = UIImage(named: "placeholder")!
            
            imageMovie.af.setImage(withURL: url, placeholderImage: placeholderImage)
            
            lblTittle.alpha = 1
            lblYear.alpha = 1
            
            indicatorView.stopAnimating()
        } else {
            lblTittle.alpha = 0
            lblYear.alpha = 0
            
            indicatorView.startAnimating()
        }
    }
}
