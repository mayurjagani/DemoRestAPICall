//
//  ShowDetailsViewController.swift
//  DemoAPICall
//
//  Created by iMac on 26/04/24.
//

import UIKit

class ShowDetailsViewController: UIViewController {

    @IBOutlet weak var lblDescriptioni: UILabel!
    @IBOutlet weak var lblUserID: UILabel!
    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var lblTItle: UILabel!
    
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblID.text = "ID: " + "\(post?.id ?? 0)"
        self.lblTItle.text = "TITLE: " + (post?.title ?? "")
        self.lblUserID.text = "USERID: " + "\(post?.userId ?? 0)"
        self.lblDescriptioni.text = "DESCRIPTION: " + (post?.body ?? "")
    }
    
    deinit {
        post = nil
    }

}
