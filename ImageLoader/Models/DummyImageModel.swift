//
//  DummyImageModel.swift
//  ImageLoader
//
//  Created by Ramunas Jurgilas on 2018-03-27.
//  Copyright © 2018 Ramūnas Jurgilas. All rights reserved.
//

import UIKit


class DummyImageModel {
    enum Status: Equatable {
        case idle
        case inQueueForDownload
        case downloaded
        case downloading
        case error
    }
    let imageId: Int
    
    var image: UIImage?
    
    var status = Status.idle
    
    var url: URL {
        get {
            return URL(string: "https://dummyimage.com/300&text=\(imageId+1)")!
        }
    }
    
    init(id: Int) {
        self.imageId = id
        if status == .error { return }
    }
}

func ==(lhs: DummyImageModel, rhs: DummyImageModel) -> Bool {
    return lhs.status == rhs.status
}
