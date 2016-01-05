//
//  FoundationExtensions.swift
//  hackerbooks
//
//  Created by Jeremy Hernández on 05/01/16.
//  Copyright © 2015 Jeremy Hernández. All rights reserved.
//

import Foundation
import UIKit

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}

extension NSBundle{
    
    func URLForResource(fileName: String)->NSURL?{
        let tokens = fileName.componentsSeparatedByString(".")
        
        return self.URLForResource(tokens.first,
            withExtension: tokens.last)
        
    }
}
extension NSFileManager{
    func getLocalPathForCloudFile(link link:String)->String{
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let filename = NSURL(string:link)!.lastPathComponent?.lowercaseString
        return path + "/" + filename!
    }
}
extension UIImageView {
    func addImageWithPlaceholder(link link:String, placeholder:String){
        let fileManager = NSFileManager.defaultManager()
        let pathImg = fileManager.getLocalPathForCloudFile(link:  link)
        if (!fileManager.fileExistsAtPath(pathImg)){
            self.image = UIImage(named: placeholder)
            self.downloadImageFrom(link: link, contentMode: UIViewContentMode.ScaleAspectFit,replace:true)
        }else{
            self.image=UIImage(contentsOfFile: pathImg)
        }
    }
    func downloadImageFrom(link link:String, contentMode: UIViewContentMode,replace: Bool=false) {
        let fileManager = NSFileManager.defaultManager()
        let pathImg = fileManager.getLocalPathForCloudFile(link: link)
        if (!fileManager.fileExistsAtPath(pathImg)) {
            
            NSURLSession.sharedSession().dataTaskWithURL( NSURL(string:link)!, completionHandler: {
                (data, response, error) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    self.contentMode =  contentMode
                    if let data = data {
                        if replace{
                        self.image = UIImage(data: data)
                        }
                        UIImageJPEGRepresentation(self.image!, 100)!.writeToFile(pathImg, atomically: true)
                        
                    }
                }
            }).resume()
            
        }
        
    }
}