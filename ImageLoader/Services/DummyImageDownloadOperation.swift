//
//  DummyImageDownloadOperation.swift
//  ImageLoader
//
//  Created by Ramunas Jurgilas on 2018-03-27.
//  Copyright © 2018 Ramūnas Jurgilas. All rights reserved.
//

import UIKit

class DummyImageDownloadOperation: Operation {

    let url: URL
    let index: Int
    open var progressBlock: ((DummyImageModel.Status, UIImage?) -> Swift.Void)?

    init(index: Int, url: URL) {
        self.url = url
        self.index = index
        super.init()
    }
    
    override func start() {
        isExecuting = true
        isFinished = false
        main()
    }
    
    override func main() {
        if isCancelled {
            isExecuting = false
            isFinished = true
            progressBlock!(.idle, nil)
            return
        }
        var image: UIImage?
        progressBlock!(.downloading, nil)
        do {
            let du1 = DataUsage.getDataUsage()
  //          print(du)
            let data = try Data(contentsOf: url)
            let du2 = DataUsage.getDataUsage()
            let dif = du2 - du1
            print("Data recieved: \(data.count)")
            
            image = UIImage(data: data)
        } catch {
            print("Photo can not be downloaded.")
        }
        progressBlock!(image == nil ? .error : .downloaded, image)
        isFinished = true
    }
    
    fileprivate var _executing: Bool = false
    override var isExecuting: Bool {
        get {
            return _executing
        }
        set {
            if _executing != newValue {
                willChangeValue(forKey: "isExecuting")
                _executing = newValue
                didChangeValue(forKey: "isExecuting")
            }
        }
    }
    
    fileprivate var _finished: Bool = false;
    override var isFinished: Bool {
        get {
            return _finished
        }
        set {
            if _finished != newValue {
                willChangeValue(forKey: "isFinished")
                _finished = newValue
                didChangeValue(forKey: "isFinished")
            }
        }
    }
}
