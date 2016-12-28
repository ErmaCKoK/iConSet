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

    func saveImagesBy(_ URL :Foundation.URL) {

        let directory = URL.deletingLastPathComponent()
        
        
        let folderName = "Scale"
        let assetFolde = directory.appendingPathComponent(folderName)
        
        
        try! FileManager.default.createDirectory(at: assetFolde, withIntermediateDirectories: true, attributes: nil)
        
        self.folder = assetFolde
        
        
        if let image = NSImage(contentsOf: URL),
            let imageSize = NSBitmapImageRep.sizeImageByURL(URL){

            let scale = URL.scale ?? 1
            let originalSize = BitmapImageSize(width: imageSize.width/scale, height: imageSize.height/scale)
            
            var imagesInfo = [ImageInfo]()
            
            self.info[URL.name] = "\(originalSize.width):\(originalSize.height)"
            
            for index in 1...3 {
                imagesInfo.append(ImageInfo(URL: URL, scale: index, imageSize: originalSize, folder: folderName, isJPG: self.isJPGResult))
            }

            var fileType = NSBitmapImageFileType.PNG
            var properties = [NSImageInterlaced : NSNumber(value: false)]
            
            if self.isJPGResult == true {
                fileType = .JPEG2000
                properties = [NSImageProgressive : NSNumber(value: false), NSImageCompressionFactor: self.jpgComresionValue]
            }
            NSLog("self.isJPGResult \(self.isJPGResult) type: \(fileType) properties: \(properties)")
            for imageInfo in imagesInfo {
                
                let newImage = imageInfo.drawImage(image)

                let targetColorSpace = NSColorSpace(cgColorSpace: CGColorSpace(name: CGColorSpace.sRGB)!)!
                
                let imageRepNew = NSBitmapImageRep(data: newImage.tiffRepresentation!)?.retagging(with: targetColorSpace)
                
                let imageData = imageRepNew!.representation(using: fileType, properties: properties)
                
                try? imageData?.write(to: imageInfo.path, options: [.atomic])
            }
            
        }
        
    }
    
    // MARK: DragView Delegate
    func dragView(_ dragView: DragView, didReciveURL url: URL) {
        NSLog("didReciveURL \(url.lastPathComponent)")
        self.saveImagesBy(url)
    }
    
    func dragView(_ dragView: DragView, didReciveURLs urls: [URL]) {
        if self.isProcesing == true {
            return
        }
        
        self.isProcesing = true

        self.info.removeAll()
        self.folder = nil
        
        for url in urls {
            NSLog("didReciveURL \(url.lastPathComponent)")
            self.saveImagesBy(url)
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

