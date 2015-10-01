//
//  MXWebViewController.swift
//  MXSegmentedPager-Swift
//
//  Created by Maxime Epain on 01/10/2015.
//  Copyright © 2015 Maxime Epain. All rights reserved.
//

import UIKit

class MXWebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = NSURL(string: "http://nshipster.com/");
        let request = NSURLRequest(URL: url!);
        self.webView.loadRequest(request);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
