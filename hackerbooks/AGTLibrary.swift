//
//  AGTLibrary.swift
//  hackerbooks
//
//  Created by Jeremy Hernández on 05/01/16.
//  Copyright © 2015 Jeremy Hernández. All rights reserved.
//

import UIKit

class AGTLibrary {
    
    var books : [AGTBook]
    var objects : [String:[AGTBook]]
    var tags : [String]
    var savedData : Bool
    var favorites : [String]
    //var model : AGTMultiDictionary
    
    //MARK: Inicializador
    // Comprueba que existe un clave en NSUserDefauls llamada AGTBook y si es así obtiene de la misma
    // la decodificación del array de books ,en caso de no existir se inicia proceso de initData
    // que descarga JSON , crea clave NSUserDefaults y guarda todo el array de books
    init()
    {
        self.books = [AGTBook]()
        self.objects = [String:[AGTBook]]()
        self.tags = [String]()
        self.savedData=false
        self.favorites=[String]()
        loadData()
      }
    
    // MARK: Funciones
    // Crear los tags de todos los lilbros
    func initTags(){
        
         initObjects()
         for data in books {
            let ltags=data.tags.componentsSeparatedByString(",")
            for tag in ltags{
                let tkey = tag.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).uppercaseString
                addObject(data, forkey: tkey)
            }
        }
       orderObjects()
    }
    
    // Carga todos los libros desde NSUserDefault
    func loadData(){
        let defaults = NSUserDefaults.standardUserDefaults()
        if let saveBooks = defaults.objectForKey("AGTBook") as? NSData,
            let arr = NSKeyedUnarchiver.unarchiveObjectWithData(saveBooks) as? [AGTBook] {
                self.books = arr
                self.savedData=true
           
        }
        else {
            self.savedData=false
           initData()
        }
        
        setFavoritesFromDefault()
         initTags()
    }
    func setFavoritesFromDefault(){
                let defaults = NSUserDefaults.standardUserDefaults()
        if let saveFavorites = defaults.objectForKey("AGTBookFavorite") as? NSData,
            let arr = NSKeyedUnarchiver.unarchiveObjectWithData(saveFavorites) as? [String] {
                for  fav in self.books{
                    if let _ = arr.indexOf(fav.title)
                    {
                        fav.isFavorite=true
                        
                    }
                }
                
        }
    }
    func initData(){
        initObjects()
        let items = JSON().loadFile("https://t.co/K9ziV0z3SJ")
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("AGTBook")
        self.books=items
        
    }
    
    func saveData(){
        let saveData = NSKeyedArchiver.archivedDataWithRootObject(self.books)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(saveData, forKey: "AGTBook")
        self.savedData=true
    }
    
    
    //MARK: funciones del antiguo AGTMultiDictionary
    
    func addObject(value:AGTBook , forkey:String){
        if var  valor = objects[forkey]{
            valor.append(value)
            objects[forkey]=valor
            return
        }
        objects[forkey]=[value]
    }
    
    func objectForName(key:Int)->String {
        return tags[key]
    }
    
    func objectsForKey(key:Int)->Int{
        let fkey = tags[key]
        if let tag = objects[fkey] {
            return tag.count
        }
        return 0
    }
    
    func initObjects(){
        objects.removeAll()
    }
    
    func orderObjects(){
        tags.removeAll()
        let a =  (objects.keys).sort({ $0 < $1})
        
        if (a.indexOf("FAVORITES") != nil) {
            tags.append("FAVORITES")
        }
        
        for value in a {
            if value != "FAVORITES" {
                tags.append(value.uppercaseString)
            }
        }
    }
    
    func objectsForKey(key:Int,item:Int)->AGTBook?{
        let fkey = tags[key]
        if let tag  = objects[fkey] {
            return tag[item]
        }
        return nil
    }

    func setfavoriteForKey(key:Int,item : Int,favorite:Bool)->Bool{
        if let reg = objectsForKey(key, item: item){
            reg.isFavorite = favorite
           let defaults = NSUserDefaults.standardUserDefaults()
            if let saveBooks = defaults.objectForKey("AGTBookFavorite") as? NSData,
                var arr = NSKeyedUnarchiver.unarchiveObjectWithData(saveBooks) as? [String] {
                    var initial = arr
                    if favorite==false {
                        for (index, fav) in arr.enumerate(){
                            if fav==reg.title
                            {
                                initial.removeAtIndex(index)
                                arr=initial
                                break;
                            }
                        }
                    }
                    else{
                        arr.append(reg.title)
                    }
                    self.favorites=arr
                    let saveData = NSKeyedArchiver.archivedDataWithRootObject(self.favorites)
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(saveData, forKey: "AGTBookFavorite")
            }
            else{
                self.favorites.append(reg.title)
                let saveData = NSKeyedArchiver.archivedDataWithRootObject(self.favorites)
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(saveData, forKey: "AGTBookFavorite")
            
            }
            return true
        }
        return false
    }
    
    
    func count()->Int{
        return tags.count
    }
    
}
