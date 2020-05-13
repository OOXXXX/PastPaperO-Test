//
//  WebView.swift
//  PastPaperO-Test
//
//  Created by Rhapsody on 2020/5/7.
//  Copyright © 2020 Rhapsody. All rights reserved.
//

import Foundation
import SwiftUI
import WebKit

var activityIndicator: UIActivityIndicatorView!

struct Webview:  UIViewRepresentable {
    
    var url: String
    
    func makeUIView(context: Context) -> WKWebView {
        
        guard let url = URL(string: self.url) else {
            return WKWebView()
            
        }
        
        
        
        let request = URLRequest(url: url)
        let wkWebview = WKWebView()
        wkWebview.load(request)
        return wkWebview
        
        
    }
    
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<Webview>) {
        
        
        
    }
    
}

// You can change the SafariServices to WebView in "OLEngListview" and I've already wrote the code.
