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
    var folder: NSURL?
    
    dynamic var isProcesing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dragView.delegate = self
        // Do any additional setup after loading the view.
        
        NSLog("isCreateImageAssests: \(self.isCreateImageAssests) isJPGResult:  \(self.isJPGResult)")
    }
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func saveImagesBy(URL :NSURL) {

        let directory = URL.URLByDeletingLastPathComponent!
        
        
        let folderName = "Scale"
        let assetFolde = directory.URLByAppendingPathComponent(folderName)
        
        
        try! NSFileManager.defaultManager().createDirectoryAtURL(assetFolde!, withIntermediateDirectories: true, attributes: nil)
        
        self.folder = assetFolde
        
        
        if let image = NSImage(contentsOfURL: URL),
            let imageSize = NSBitmapImageRep.sizeImageByURL(URL){

            let scale = URL.scale ?? 1
            let originalSize = BitmapImageSize(width: imageSize.width/scale, height: imageSize.height/scale)
            
            var imagesInfo = [ImageInfo]()
            
            self.info[URL.name] = "\(originalSize.width):\(originalSize.height)"
            
            for index in 1...3 {
                imagesInfo.append(ImageInfo(URL: URL, scale: index, imageSize: originalSize, folder: folderName, isJPG: self.isJPGResult))
            }

            var fileType = NSBitmapImageFileType.PNG
            var properties = [NSImageInterlaced : NSNumber(bool: false)]
            
            if self.isJPGResult == true {
                fileType = .JPEG2000
                properties = [NSImageProgressive : NSNumber(bool: false), NSImageCompressionFactor: self.jpgComresionValue]
            }
            NSLog("self.isJPGResult \(self.isJPGResult) type: \(fileType) properties: \(properties)")
            for imageInfo in imagesInfo {
                
                let newImage = imageInfo.drawImage(image)

                let targetColorSpace = NSColorSpace(CGColorSpace: CGColorSpaceCreateWithName(kCGColorSpaceSRGB)!)!
                
                let imageRepNew = NSBitmapImageRep(data: newImage.TIFFRepresentation!)?.bitmapImageRepByRetaggingWithColorSpace(targetColorSpace)
                
                let imageData = imageRepNew!.representationUsingType(fileType, properties: properties)
                
                imageData?.writeToURL(imageInfo.path, atomically: true)
            }
            
        }
        
    }
    
    // MARK: DragView Delegate
    func dragView(dragView: DragView, didReciveURL url: NSURL) {
        NSLog("didReciveURL \(url.lastPathComponent)")
        self.saveImagesBy(url)
    }
    
    func dragView(dragView: DragView, didReciveURLs urls: [NSURL]) {
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
    
    func dragViewEntered(dragView: DragView) {
        self.imageView.image = NSImage(named: "ic_drag_selected")
    }
    
    func dragViewExited(dragView: DragView) {
        self.imageView.image = NSImage(named: "ic_drag")
    }

}

