//
//  WebViewController.swift
//  QRCodeScanner
//
//  Created by Samuel Shaw on 12/28/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

import UIKit

class WebViewController: UIViewController
{
    
    @IBOutlet weak var webView: UIWebView!
    
    var QRlink:String!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let url = NSURL(string: QRlink)
        
        let request = NSURLRequest(URL: url!)
        
        webView.loadRequest(request)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBackButtonPressed(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
