//
//  ImagesViewController.swift
//  ImageLoader
//
//  Created by Ramunas Jurgilas on 2018-03-27.
//  Copyright © 2018 Ramūnas Jurgilas. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ImageCell"

class ImagesViewController: UICollectionViewController {

    var model = ImagesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        model.block = { [weak self] in
            let indexPath = IndexPath(row: $0, section: 0)
            if self?.collectionView?.indexPathsForVisibleItems.contains(indexPath) ?? false {
                self?.collectionView?.reloadItems(at: [indexPath])
            }
        }
        
        _ = model.loadModels(count: 100)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.model.startFeatchingFor(self.collectionView?.indexPathsForVisibleItems)
        }
    }

    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.numberOfImages
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        if let imageCell = cell as? ImageCell {
            let imageModel = model.modelAtIndex(index: indexPath.row)
            imageCell.imageCellDelegate = self
            imageCell.configureWith(imageModel)
        }

        if indexPath.row == model.numberOfImages - 1 {
            let indexPaths = model.loadModels(count: 100)
            collectionView.performBatchUpdates({
                collectionView.insertItems(at: indexPaths)
            }, completion: nil)
        }
  
        return cell
    }

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        model.stopLoading()
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        model.startFeatchingFor(collectionView?.indexPathsForVisibleItems)
    }
    
    // MARK: - IBAction
    
    @IBAction func didClickMoreButton(_ sender: UIBarButtonItem) {
        let downloadedImages = model.totalDownloadedImages()
        let alert = UIAlertController(title: "Total download images", message: "\(downloadedImages)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
       // collectionView?.reloadData()
    }
    
}

extension ImageCell {
    func configureWith(_ model :DummyImageModel) {
        imageView.image = model.image
        progressView.isHidden = (model.status != .downloading)
        progressView.startAnimating()
        index = model.imageId
    }
}

extension ImagesViewController: ImageCellDelegate {
    
    func prepareForReuse(_ cell: ImageCell) {
        for indexPath in collectionView!.indexPathsForVisibleItems {
            if indexPath.row == cell.index { return }
        }
        model.removeImageAtIndex(cell.index)
    }
}
