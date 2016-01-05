//
//  MasterViewController.swift
//  hackerbooks
//
//  Created by Jeremy Hernández on 05/01/16.
//  Copyright © 2015 Jeremy Hernández. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, DetailDelegate {

    var detailViewController : DetailViewController? = nil
    var model   : AGTLibrary?
    var actInd : UIActivityIndicatorView? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "HackerBooks"
        self.model = AGTLibrary()
        
        

        let addButton = UIBarButtonItem(barButtonSystemItem: .Refresh , target: self, action: "reloadData:")
        let savedButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveData")
        
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = savedButton
        
        self.navigationItem.leftBarButtonItem!.enabled = !(model?.savedData)!
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        //self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
       // super.viewWillAppear(animated)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func reloadData(sender: AnyObject) {
                self.navigationItem.leftBarButtonItem!.enabled=true
        self.showActivityIndicator()
     
        dispatch_async(dispatch_get_main_queue()) {

            self.model?.initData()
            self.model?.setFavoritesFromDefault()
            self.model?.initTags()
            self.tableView.reloadData()
            self.hideActivityIndicator()
            
        }
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                
                if let  detail = model?.objectsForKey(indexPath.section, item: indexPath.row){
                    controller.detailItem = detail
                    controller.PK = indexPath
                    controller.delegate = self
                }
                
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
                
            }
        }
    }

    // MARK: - Table View
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let count = model?.count() else {
            return 0
        }
        return count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = model?.objectsForKey(section) else {
            return 0
        }
        return count
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       return model?.objectForName(section)
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(red: 0.90, green: 0.57, blue: 0.22, alpha: 1.0)
        header.textLabel!.textColor = UIColor.whiteColor()
        header.alpha = 0.80
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        if let  object = model?.objectsForKey(indexPath.section, item: indexPath.row){
            cell.textLabel!.text = object.title
            cell.detailTextLabel!.text = object.authors
            cell.imageView!.image = UIImage(named: "placeholder1")
            cell.imageView!.addImageWithPlaceholder(link: object.urlImage.absoluteString, placeholder: "placeholder1")

        }
        return cell
    }
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
         if let  object = model?.objectsForKey(indexPath.section, item: indexPath.row){
            if(object.isFavorite){
                let rateAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete") { (action , indexPath ) -> Void in
                    self.editing = false
                    object.isFavorite=false
                    let defaults = NSUserDefaults.standardUserDefaults()
                    if let saveBooks = defaults.objectForKey("AGTBookFavorite") as? NSData,
                        var arr = NSKeyedUnarchiver.unarchiveObjectWithData(saveBooks) as? [String] {
                            var initial = arr
                                for (index, fav) in arr.enumerate(){
                                    if fav==object.title
                                    {
                                        initial.removeAtIndex(index)
                                        arr=initial
                                        break;
                                    }
                                }
                            let saveData = NSKeyedArchiver.archivedDataWithRootObject(arr)
                            let defaults = NSUserDefaults.standardUserDefaults()
                            defaults.setObject(saveData, forKey: "AGTBookFavorite")
                    }
                    self.reloadData(self)
                    print("Delete button pressed")
                }
                return [rateAction]
            }
            else{
                return[]
            }
        }
         else{
            return[]
        }
        

    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    //MARK: Delegados
    
    func setFavorite(PK: NSIndexPath, favorite:Bool ) ->Bool {
        
        if  model?.setfavoriteForKey(PK.section, item: PK.row, favorite: favorite ) == true {
            model?.initTags()
            tableView.reloadData()
            return true
        }
        return false
    }
    
    func saveData() {
        self.navigationItem.leftBarButtonItem!.enabled=false
        model?.saveData()
    }
    //MARK: UtilityView
    func showActivityIndicator(){
        if self.actInd==nil{
            self.actInd = UIActivityIndicatorView(frame: CGRectMake(20, 50, 100, 100)) as UIActivityIndicatorView
            self.actInd!.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0+self.tableView.contentOffset.y+(self.navigationController!.navigationBar.frame.height)-25);
            
            self.actInd!.hidesWhenStopped = true
            self.actInd!.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
            self.actInd!.color = UIColor.blackColor()
            self.actInd!.backgroundColor=UIColor(red: 0.90, green: 0.57, blue: 0.22, alpha: 0.6)
            self.actInd!.layer.cornerRadius = 5
            
            self.actInd!.layer.masksToBounds = true
            self.view.addSubview(self.actInd!)
        }
     
        self.actInd!.startAnimating()
    }
    func hideActivityIndicator(){
        if let _ = self.actInd{
         self.actInd!.stopAnimating()
        }
    }
}

