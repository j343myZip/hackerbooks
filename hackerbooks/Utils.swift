//
//  Utils.swift
//  hackerbooks
//
//  Created by Jeremy Hernández on 05/01/16.
//  Copyright © 2015 Jeremy Hernández. All rights reserved.
//

import UIKit

//MARK: - Enum JSON
enum JSONKeys: String{
    case authors
    case image_url
    case pdf_url
    case tags
    case title
}

//MARK: - Errors
enum ResourceError : ErrorType{
    case WrongFormat(msg: String)
}


//MARK: - JSON
struct JSON {
    
    //MARK: - Aliases
    typealias JSONObject        = AnyObject
    typealias JSONDictionary    = [String:JSONObject]
    typealias JSONArray         = [JSONDictionary]
    
    
    func loadFile(URL:String)->[AGTBook]{
        
        var results = [AGTBook]() 
        
        do{
            
            if let url = NSURL(string: URL),
                data = NSData(contentsOfURL: url),
                anyData = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as JSONObject? {

                    if anyData is JSONArray {
                        if let data = anyData as? JSONArray{
                            results = decode(books : data)
                        }
                    }
            }
            
        }catch{
            
            fatalError("El modelo se fue al carajo")
        }
        
        return results
        
    }
    
    
    //MARK: - Decoding single AGTBook
    func decode(book json: JSONDictionary) throws -> AGTBook{
        
        guard let urlPdfS = json[JSONKeys.pdf_url.rawValue] as? String,
            urlPdf = NSURL(string: urlPdfS) else{
                throw ResourceError.WrongFormat(msg: "pdf_url")
        }
        
        guard let urlImageS = json[JSONKeys.image_url.rawValue] as? String,
            urlImage = NSURL(string: urlImageS) else{
                 throw ResourceError.WrongFormat(msg: "image_url")
        }
        
        guard let authors = json[JSONKeys.authors.rawValue] as? String else{
            throw ResourceError.WrongFormat(msg: "authors")
        }
        
        guard let title = json[JSONKeys.title.rawValue] as? String else{
            throw ResourceError.WrongFormat(msg: "title")
        }
        
        guard let tags = json[JSONKeys.tags.rawValue] as? String else{
            throw ResourceError.WrongFormat(msg: "tags")
        }
    
        return AGTBook(title: title, authors: authors, tags: tags, urlImage: urlImage, urlPdf : urlPdf, isFavorite: false)
        
    }
    
    //MARK: - Decoding array
    func decode(books json: JSONArray) -> [AGTBook]{
        
        var results = [AGTBook]()
        do{
            for dict in json{
                let s = try decode(book: dict)
                results.append(s)
            }
        }catch let ResourceError.WrongFormat(error){
            fatalError("WrongFormatForResource : \(error)")
        }
        catch {
            print("Mandatory exhaustive catch")
        }
        return results
    }
    
}









