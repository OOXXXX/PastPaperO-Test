//
//  OLEngListView.swift
//  PastPaperO-Test
//
//  Created by Rhapsody on 2020/5/7.
//  Copyright © 2020 Rhapsody. All rights reserved.
//

import SwiftUI
import SafariServices

struct OEng19ListView: View {

@State var selected = 1

var body: some View {
    
  
    NavigationView {
         
        VStack{
            
            OEng19List()
            
        }
       .navigationBarTitle(Text("2019"))
    }
       .navigationViewStyle(StackNavigationViewStyle())
  }
}



struct OEng19List: View {
    var body: some View {
        List(OEng19Data) { xxx in
            
            NavigationLink(destination: OEng19Detail(xxx: xxx)) {
                OEng19Row(xxx: xxx)
            }
        }
        
    }
}

 

struct OEng19Row: View {
    var xxx: OEng19

    var body: some View {
        HStack {
            Text(xxx.name)
                .frame(width: 230, height: 45, alignment: .leading)
            Spacer()
        }
    }
}

 


struct OEng19Detail: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @State private var isActivityPopoverPresented = false
    @State private var isActivitySheetPresented = false
    @State private var showShareSheet = false
    var xxx: OEng19

    var body: some View {
        VStack {
          Webview(url: (xxx.url))
          //Here you can chage.
            
        }
        .navigationBarTitle(Text(xxx.name), displayMode: .inline)
        
        .navigationBarItems(trailing: shareButton)
            // ⚠️ IMPORTANT: `UIActivityViewController` must be presented in a popover on iPad:
            .popover(isPresented: $isActivityPopoverPresented, content: activityView)
            // ⚠️ IMPORTANT: `UIActivityViewController` must be presented in a popover on iPhone and iPod Touch:
            .sheet(isPresented: $isActivitySheetPresented, content: activityView)
        
        .edgesIgnoringSafeArea(.all)
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
        })
    }
    
    private func activityView() -> some View {
        let url = URL(string: self.xxx.url)!
        let activityItemProvider = RemoteURLActivityItemProvider(url: url)
        return ActivityView(activityItems: [activityItemProvider], applicationActivities: nil)
    }
}

 





//struct SafariView: UIViewControllerRepresentable {
//
//     let url: URL
//
//     func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
//         return SFSafariViewController(url: url)
//     }
//
//     func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
//
//     }
//
//     func prefersStatusBarHidden() -> Bool {
//          return true
//      }
//
//
// }


  
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
