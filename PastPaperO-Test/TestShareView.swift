//
//  TestShareView.swift
//  PastPaperO-Test
//
//  Created by Rhapsody on 2020/5/20.
//  Copyright © 2020 Rhapsody. All rights reserved.
//

import SwiftUI

struct TestShareView: View {
@Environment(\.horizontalSizeClass) var horizontalSizeClass
@Environment(\.verticalSizeClass) var verticalSizeClass
@State private var isPresented = false
@State private var isActivityPopoverPresented = false
@State private var isActivitySheetPresented = false
       
       var body: some View {
           NavigationView {
               VStack(spacing: 0) {
                   Color.red
                   Color.orange
                   Color.yellow
                   Color.green
                   Color.blue
                   Color.purple
                   Color.pink
               }
               .navigationBarTitle("Title")
               .navigationBarItems(trailing: shareButton)
               // ⚠️ IMPORTANT: `UIActivityViewController` must be presented in a popover on iPad:
               .popover(isPresented: $isActivityPopoverPresented, attachmentAnchor: .point(.topTrailing), arrowEdge: .top, content: activityView)
               // ⚠️ IMPORTANT: `UIActivityViewController` must be presented in a popover on iPhone and iPod Touch:
               .sheet(isPresented: $isActivitySheetPresented, content: activityView)
                
             
           }
          
       }
       
       private var shareButton: some View {
           Button(action: {
               switch (self.horizontalSizeClass, self.verticalSizeClass) {
               case (.regular, .regular):
                   // ⚠️ IMPORTANT: `UIActivityViewController` must be presented in a popover on iPad:
                   self.isActivityPopoverPresented.toggle()
               default:
                   // ⚠️ IMPORTANT: `UIActivityViewController` must be presented in a popover on iPhone and iPod Touch:
                   self.isActivitySheetPresented.toggle()
               }
           }, label: {
               Image(systemName: "square.and.arrow.up")
                .font(.system(size: 20, weight: .semibold))
                .frame(width: 35, height: 40)
                .hoverEffect(.automatic)
           })
       }
       
       private func activityView() -> some View {
           let url = URL(string: "https://papers.xtremepape.rs/CAIE/O%20Level/Geography%20(2217)/2217_s04_er.pdf")!
           let filename = url.pathComponents.last!
           let fileManager = FileManager.default
           let itemURL = fileManager.temporaryDirectory.appendingPathComponent(filename)
           let data: Data
           if fileManager.fileExists(atPath: itemURL.path) {
               data = try! Data(contentsOf: itemURL)
           } else {
               data = try! Data(contentsOf: url)
               fileManager.createFile(atPath: itemURL.path, contents: data, attributes: nil)
           }
           let activityView = ActivityView(activityItems: [itemURL], applicationActivities: nil)
           return Group {
               if self.horizontalSizeClass == .regular && self.verticalSizeClass == .regular {
                   activityView.frame(width: 300, height: 480)
               } else {
                   activityView
               }
             
           }
       }
}

class RemoteURLActivityItemProvider : UIActivityItemProvider {
    let remoteURL: URL
    private var urlSession: URLSession
    private var fileManager: FileManager
    private var semaphore: DispatchSemaphore?

    init(url: URL, urlSession: URLSession = .shared, fileManager: FileManager = .default) {
        self.remoteURL = url
        self.urlSession = urlSession
        self.fileManager = fileManager
        super.init(placeholderItem: url)
    }

    override var item: Any {
        guard let filename = remoteURL.pathComponents.last else { return super.item }
        
        // ✅ Return existing data from the user's temp directory, if previously saved:
        let itemURL = fileManager.temporaryDirectory.appendingPathComponent(filename)
        if fileManager.fileExists(atPath: itemURL.path) {
            return try! Data(contentsOf: itemURL)
        }
        
        // ✅ Use a semaphore to make the async data task blocking task:
        var localData: Data?
        semaphore = DispatchSemaphore(value: 0)
        let task = urlSession.dataTask(with: remoteURL) { [weak weakSelf = self] data, response, error in
            defer { weakSelf?.semaphore?.signal() }
            guard let strongSelf = weakSelf, let remoteData = data else { return }

            // ✅ Create (or overwrite) the data to the user's temp directory:
            strongSelf.fileManager.createFile(atPath: itemURL.path, contents: remoteData, attributes: nil)
            localData = try! Data(contentsOf: itemURL)
        }

        task.resume()
        semaphore?.wait()
        semaphore = nil

        // ✅ Return the stored data from the user's temp directory:
        if let item = localData {
            return item
        }

        task.cancel()
        return super.item
    }

    override func cancel() {
        semaphore?.signal()
        super.cancel()
    }
}

struct ActivityView: UIViewControllerRepresentable {
    typealias CompletionWithItemsHandler = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    
    var activityItems: [Any]
    var applicationActivities: [UIActivity]?
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let completion: CompletionWithItemsHandler? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = completion
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // no-op
    }
}

struct TestShareView_Previews: PreviewProvider {
    static var previews: some View {
        TestShareView()
    }
}
