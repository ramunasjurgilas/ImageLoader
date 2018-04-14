//
//  ImagesViewModel.swift
//  ImageLoader
//
//  Created by Ramunas Jurgilas on 2018-03-27.
//  Copyright © 2018 Ramūnas Jurgilas. All rights reserved.
//

import Foundation
import UIKit

class ImagesViewModel {
    
    var images = [DummyImageModel]()
    var numberOfImages: Int { get { return images.count } }
    var block: ((Int) -> Void)?
    
    let operationQueue = OperationQueue()
    
    init() {
        operationQueue.maxConcurrentOperationCount = 4
        UserDefaults.standard.set(0, forKey: "PhotosCount")
    }

    func loadModels(count: Int) -> [IndexPath] {
        var result = [IndexPath]()
        for index in numberOfImages...(numberOfImages + count) {
            let model = DummyImageModel(id: index)
            images.append(model)
            result.append(IndexPath(row: index, section: 0))
        }
        return result
    }
    
    func modelAtIndex(index: Int) -> DummyImageModel {
        let model = images[index]
        return model
    }

    func startFeatchingFor(_ indexPaths: [IndexPath]?) {
        indexPaths?.forEach { startFeatchingFor($0.row) }
    }
    
    func stopLoading() {
        operationQueue.operations.forEach {
            if let index = ($0 as? DummyImageDownloadOperation)?.index {
                images[index].status = .idle
                self.block!(index)
            }
        }
        operationQueue.cancelAllOperations()
    }
    
    func removeImageAtIndex(_ index: Int) {
        if images[index].image != nil {
            decreaseCount()
        }
        images[index].image = nil
        images[index].status = .idle
    }
    
    func totalDownloadedImages() -> Int {
        return UserDefaults.standard.integer(forKey: "PhotosCount")
    }
    
    func startFeatchingFor(_ index: Int) {
        let model = images[index]
        if model.status == .idle || model.image == nil {
            
            let operation = DummyImageDownloadOperation(index: model.imageId, url: model.url)
            operation.progressBlock = { (status, image) in
                model.image = image
                model.status = status
                DispatchQueue.main.async { [weak self] in
                    if image != nil {
                        self!.increaseCount()
                    }
                    self?.block!(index)
                }
            }
            model.status = .inQueueForDownload
            operationQueue.addOperation(operation)
        }
    }
    
    private func updateModel(forIndex index: Int, status: DummyImageModel.Status, image: UIImage?) {
        let model = images.first { $0.imageId == index }
        model?.status = status
        model?.image = image
        DispatchQueue.main.async {
            self.block!(index)
        }
    }
    private func increaseCount() {
        let count = UserDefaults.standard.integer(forKey: "PhotosCount") + 1
        UserDefaults.standard.set(count, forKey: "PhotosCount")
        UserDefaults.standard.synchronize()
    }
    
    private func decreaseCount() {
        let count = UserDefaults.standard.integer(forKey: "PhotosCount") - 1
        UserDefaults.standard.set(count, forKey: "PhotosCount")
        UserDefaults.standard.synchronize()
    }
}






