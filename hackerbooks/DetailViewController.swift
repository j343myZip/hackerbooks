//
//  DetailViewController.swift
//  hackerbooks
//
//  Created by Jeremy Hernández on 05/01/16.
//  Copyright © 2015 Jeremy Hernández. All rights reserved.
//

import UIKit

protocol DetailDelegate {
    func setFavorite (PK : NSIndexPath, favorite : Bool) ->Bool
    func saveData()
 }

class DetailViewController: UIViewController {

    var delegate:DetailDelegate?
    
    var PK : NSIndexPath?
    
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var authors: UILabel!
    @IBOutlet weak var favorito: UIBarButtonItem!
   
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    @IBAction func btnSave(sender: AnyObject) {
        delegate?.saveData()
    }
        
    @IBAction func setFavorite(sender: AnyObject) {
        if let _ = PK {
            if ( delegate?.setFavorite(PK! , favorite: !(self.model?.isFavorite)! ) == true ) {
                SetColorFavorito()
            }
        }
    }
    
    var model : AGTBook? {
        get {
            return detailItem as? AGTBook
        }
    }
    

    func configureView() {
        // Update the user interface for the detail item.
        if let modelo = detailItem as? AGTBook{
            
            if let item = self.titulo {
                item.text = modelo.title
            }
            
            if let item = self.tags {
                item.text = modelo.tags
                SetColorFavorito()
            }
            
            if let item = self.authors {
                item.text = modelo.authors
            }
            
            if let _ = self.image , ab = model?.urlImage {
                    image.addImageWithPlaceholder(link: ab.absoluteString, placeholder: "placeholder1")
            }
            
        }
    }
    
    func SetColorFavorito(){
            favorito.tintColor =  UIColor.blackColor()
            if (model?.isFavorite == true){
                favorito.tintColor =  UIColor.brownColor()
            }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "AGTSimplePDFViewController" {
            
            if let controller = segue.destinationViewController as? AGTSimplePDFViewController {
                if let modelo = detailItem as? AGTBook{
                    controller.title  = modelo.title
                    controller.pdfUrl = modelo.urlPdf
                }
            }
            
        }
    }


}

