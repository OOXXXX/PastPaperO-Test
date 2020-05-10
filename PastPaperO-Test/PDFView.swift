//
//  PDFView.swift
//  PastPaperO-Test
//
//  Created by Rhapsody on 2020/5/7.
//  Copyright © 2020 Rhapsody. All rights reserved.
//
 
 import SwiftUI
 import UIKit

 struct ShareSheet: UIViewControllerRepresentable {
     typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
     
     let activityItems: [Any]
     let applicationActivities: [UIActivity]? = nil
     let excludedActivityTypes: [UIActivity.ActivityType]? = nil
     let callback: Callback? = nil
     
     func makeUIViewController(context: Context) -> UIActivityViewController {
         let controller = UIActivityViewController(
             activityItems: activityItems,
             applicationActivities: applicationActivities)
         controller.excludedActivityTypes = excludedActivityTypes
         controller.completionWithItemsHandler = callback
         return controller
     }
     
     func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
         // nothing to do here
     }
 }

  
