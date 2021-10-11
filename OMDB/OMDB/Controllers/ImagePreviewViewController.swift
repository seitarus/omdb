//
//  ImagePreviewViewController.swift
//  OMDB
//
//  Created by iMac 27 iOS on 11/10/21.
//

import UIKit

class ImagePreviewViewController: UIViewController {

    var image : UIImage?
    
    @IBOutlet weak var imageMovie: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadImageUrl()
    }
    
    func loadImageUrl()  {
        
        if let image = image {
            self.imageMovie.image = image
            
        }
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        guard let image = imageMovie.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Guardada", message: "La imagen se ha guardado en tu carrete.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}
