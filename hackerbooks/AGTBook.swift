//
//  AGTBook.swift
//  hackerbooks
//
//  Created by Jeremy Hernández on 05/01/16.
//  Copyright © 2015 Jeremy Hernández. All rights reserved.
//

import UIKit

class AGTBook: NSObject, NSCoding {
    
    let title    : String
    let authors  : String
    var tags     : String
    let urlImage : NSURL
    let urlPdf   : NSURL
    var isFavorite : Bool {
        didSet{
            
            let wordf = "FAVORITES"
            if !self.isFavorite && tags.containsString(wordf){
                self.tags = self.tags.stringByReplacingOccurrencesOfString(", \(wordf)", withString: "")
              
            }
            else if(!tags.containsString(wordf)){
                self.tags = self.tags + ", \(wordf)"
            }
        }
     }
    
    init(
        title    : String,
        authors  : String,
        tags     : String,
        urlImage : NSURL,
        urlPdf   : NSURL,
        isFavorite: Bool
        ){
            
            self.title = title
            self.authors = authors
            self.tags = tags
            self.urlImage = urlImage
            self.urlPdf = urlPdf
            self.isFavorite = isFavorite
        }
    
    //MARK: - Decoder
    required init(coder aDecoder:NSCoder){
        
        title = aDecoder.decodeObjectForKey("title") as? String ?? ""
        authors = aDecoder.decodeObjectForKey("authors") as? String ?? ""
        tags = aDecoder.decodeObjectForKey("tags") as? String ?? ""
        urlImage = aDecoder.decodeObjectForKey("urlImage") as! NSURL
        urlPdf = aDecoder.decodeObjectForKey("urlPdf") as! NSURL
        isFavorite = aDecoder.decodeObjectForKey("isfavorite") as? Bool ?? false

    }
    
    // Save data
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(authors, forKey: "authors")
        aCoder.encodeObject(tags, forKey: "tags")
        aCoder.encodeObject(urlPdf, forKey: "urlPdf")
        aCoder.encodeObject(urlImage, forKey: "urlImage")
        aCoder.encodeObject(isFavorite, forKey: "isfavorite")
        
    }
    
}