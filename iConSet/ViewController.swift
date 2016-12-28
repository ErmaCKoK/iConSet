//
//  ViewController.swift
//  iConSet
//
//  Created by Andrii Kurshyn on 9/11/15.
//  Copyright © 2015 Andrii Kurshyn. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, DragViewDelegate {

    @IBOutlet weak var dragView: DragView!
    @IBOutlet weak var imageView: NSImageView!

    var isCreateImageAssests: Bool = false
    
    var isDetectScale: Bool = false
    var isJPGResult: Bool = false
    var jpgComresionValue: NSNumber = (1.0)
    
    var info = [String: String]()
    var folder: URL?
    
    dynamic var isProcesing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dragView.delegate = self
        // Do any additional setup after loading the view.
        
        NSLog("isCreateImageAssests: \(self.isCreateImageAssests) isJPGResult:  \(self.isJPGResult)")
    }

    func saveImage(by URL: URL, to folder: URL) {
        
        guard let image = NSImage(contentsOf: URL),
              let imageSize = NSBitmapImageRep.sizeImage(by: URL)
        else {
            return
        }
        
        var saveFolder = folder
        
        if self.isCreateImageAssests {
            saveFolder = saveFolder.appendingPathComponent("\(URL.name).imageset")
            try! FileManager.default.createDirectory(at: saveFolder, withIntermediateDirectories: true, attributes: nil)
        }
        
        let scale = URL.scale
        let originalSize = BitmapImageSize(width: imageSize.width/scale, height: imageSize.height/scale)
        
        var imagesInfo = [ImageInfo]()
        
        self.info[URL.name] = "\(originalSize.width):\(originalSize.height)"
        
        for index in 1...3 {
            imagesInfo.append(ImageInfo(image: image, named: URL.name, scale: index, imageSize: originalSize, isJPG: self.isJPGResult, jpgComresion: self.jpgComresionValue))
        }
        
        NSLog("self.isJPGResult \(self.isJPGResult) self.jpgComresionValue: \(self.jpgComresionValue) isCreateImageAssests: \(isCreateImageAssests)")
        
        var json = [String: Any]()
        
        json["images"] = [Any]()
        
        for imageInfo in imagesInfo {
            let data = imageInfo.data()
            try? data?.write(to: saveFolder.appendingPathComponent(imageInfo.name), options: [.atomic])
            
            if var array = json["images"] as? [Any] {
                array.append(["idiom" : "universal", "filename" : imageInfo.name, "scale" : "\(imageInfo.scale)x"])
                json["images"] = array
            }
        }
        
        if self.isCreateImageAssests {
            json["info"] = ["version" : (1), "author" : "xcode"]
            self.saveJSONAssests(json: json, to: saveFolder)
        }
    }
    
    func folderToSave(from: URL) -> URL {
        
        let directory = from.deletingLastPathComponent()
        
        
        let folderName = "Scale"
        var assetFolder: URL!
        
        var newFolder = false
        var count = 0
        while newFolder == false {
            let sufix = count > 0 ? "-\(count)" : ""
            assetFolder = directory.appendingPathComponent("\(folderName)\(sufix)")
            newFolder = !FileManager.default.fileExists(atPath: assetFolder.path)
            count += 1
        }
        
        try! FileManager.default.createDirectory(at: assetFolder, withIntermediateDirectories: true, attributes: nil)
        
        return assetFolder
    }
    
    func saveJSONAssests(json: [String: Any], to folder: URL) {
        let date = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
        try! date.write(to: folder.appendingPathComponent("Contents.json"), options: [.atomic])
    }
    
    // MARK: DragView Delegate
    func dragView(_ dragView: DragView, didReciveURLs urls: [URL]) {
        if self.isProcesing == true && urls.count > 0 {
            return
        }
        
        self.isProcesing = true

        self.info.removeAll()
        
        let folder = self.folderToSave(from: urls[0])
        
        self.folder = folder
        
        for url in urls {
            NSLog("didReciveURL \(url.lastPathComponent)")
            self.saveImage(by: url, to: folder)
        }
        
        if self.isCreateImageAssests && urls.count > 1 {
            let dic = [ "info" : ["version" : (1), "author" : "xcode"]]
            self.saveJSONAssests(json: dic, to: folder)
        }
        
//        if let folder = self.folder {
//            let date = try! NSJSONSerialization.dataWithJSONObject(NSDictionary(dictionary:info), options: NSJSONWritingOptions.PrettyPrinted)
//        
//            date.writeToURL(folder.URLByDeletingLastPathComponent!.URLByAppendingPathComponent("Contents.json")!, atomically: true)
//        }
        
        self.isProcesing = false
    }
    
    func dragViewEntered(_ dragView: DragView) {
        self.imageView.image = NSImage(named: "ic_drag_selected")
    }
    
    func dragViewExited(_ dragView: DragView) {
        self.imageView.image = NSImage(named: "ic_drag")
    }

}

