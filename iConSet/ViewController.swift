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
    var isResize: Bool = true
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

    func draw(imageInfos: [ImageInfo], saveTo folder: URL) {
        
        guard imageInfos.count > 0 else { return }
        
        var saveFolder = folder
        
        let name = imageInfos.first!.originName
        
        if self.isCreateImageAssests {
            saveFolder = saveFolder.appendingPathComponent("\(name).imageset")
            try! FileManager.default.createDirectory(at: saveFolder, withIntermediateDirectories: true, attributes: nil)
        }
        
        NSLog("self.isJPGResult \(self.isJPGResult) self.jpgComresionValue: \(self.jpgComresionValue) isCreateImageAssests: \(isCreateImageAssests)")
        
        let assetsJSON = AssestsJSON()

        for imageInfo in imageInfos {
            
            if self.isResize {
                let data = imageInfo.data()
                try? data?.write(to: saveFolder.appendingPathComponent(imageInfo.name), options: [.atomic])
            } else {
                _ = try! FileManager.default.copyItem(at: imageInfo.originalUrl, to: saveFolder.appendingPathComponent(imageInfo.name))
            }
            
            assetsJSON.append(imageInfo)
        }
        
        if self.isCreateImageAssests {
            assetsJSON.save(to: saveFolder)
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
    
    // MARK: DragView Delegate
    func dragView(_ dragView: DragView, didReciveURLs urls: [URL]) {
        if self.isProcesing == true && urls.count > 0 {
            return
        }
        
        self.isProcesing = true

        self.info.removeAll()
        
        let folder = self.folderToSave(from: urls[0])
        
        self.folder = folder
        
        var assestsURL = [String: [URL]]()
        for url in urls {
            NSLog("didReciveURL \(url.lastPathComponent)")
            var urls: [URL]
            
            if let oldURLs = assestsURL[url.name] {
                urls = oldURLs
            } else {
                urls = [URL]()
            }
            urls.append(url)
            urls.sort(by: { $0.scale < $1.scale })
            assestsURL[url.name] = urls
        }
        
        for (_, urls) in assestsURL where urls.count > 0 {
            
            let imageInfos: [ImageInfo]
            
            if self.isResize {
                
                let lastURL = urls.last!
                let scales = (1...3)
                imageInfos = scales.flatMap({ ImageInfo(url: lastURL, scale: $0, jpgComresion:  self.isJPGResult ? self.jpgComresionValue : nil) })
            } else {
                imageInfos = urls.flatMap({ ImageInfo(url: $0, scale: $0.scale, jpgComresion: nil) })
            }
            
            self.draw(imageInfos: imageInfos, saveTo: folder)
        }
        
        if self.isCreateImageAssests && assestsURL.count > 1 {
            AssestsJSON().save(to: folder)
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

