//
//  AGTSimplePDFViewController.swift
//  hackerbooks
//
//  Created by Jeremy Hernández on 05/01/16.
//  Copyright © 2015 Jeremy Hernández. All rights reserved.
//

import UIKit

class AGTSimplePDFViewController: UIViewController,UIWebViewDelegate {
    
    @IBOutlet weak var webViewPdf: UIWebView!
       var pdfUrl : NSURL?

    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let url = pdfUrl {
           let request = NSURLRequest(URL: url)
           webViewPdf.delegate = self
           webViewPdf.loadRequest(request)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func webViewDidFinishLoad(_: UIWebView) {
        activity.stopAnimating()
    }
    func webViewDidStartLoad(_: UIWebView) {
        activity.startAnimating()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
