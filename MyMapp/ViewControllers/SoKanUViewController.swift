//
//  SoKanUViewController.swift
//  BaseProject
//
//  Created by Bazyl Reinstein on 28/11/2016.
//  Copyright © 2016 BJSS Ltd. All rights reserved.
//

import UIKit

class SoKanUViewController: BaseViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var header: UIView!
    var url: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let urlString = url, let link = URL(string:urlString), webView != nil {
            webView.loadRequest(URLRequest(url: link))
        } else {
            webView.loadRequest(URLRequest(url: URL(string: "https://www.sokanu.com")!))
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension SoKanUViewController: MCMHeaderAnimatedDelegate {
    
    func headerView() -> UIView {
        return self.header
    }
    
    func headerCopy(subview: UIView) -> UIView {
        let headerN = UIView()
        headerN.backgroundColor = UIColor.rnsSokanuRed
        return headerN
    }
}
