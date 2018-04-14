//
//  ImageCell.swift
//  ImageLoader
//
//  Created by Ramunas Jurgilas on 2018-03-27.
//  Copyright © 2018 Ramūnas Jurgilas. All rights reserved.
//

import UIKit

@objc protocol ImageCellDelegate {
    func prepareForReuse(_ cell: ImageCell)
}

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    
    weak var imageCellDelegate: ImageCellDelegate?
    var index: Int = 0
    
    override func prepareForReuse() {
        imageCellDelegate?.prepareForReuse(self)
        super.prepareForReuse()
    }
 
}
