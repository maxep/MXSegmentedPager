//
//  MXTextViewController.swift
//  MXSegmentedPager-Swift
//
//  Created by Maxime Epain on 01/10/2015.
//  Copyright © 2015 Maxime Epain. All rights reserved.
//

import UIKit

class MXTextViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let filePath = NSBundle.mainBundle().pathForResource("LongText", ofType: "txt");

        self.textView.text = try! String(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
