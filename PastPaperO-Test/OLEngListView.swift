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
       .navigationBarTitle(Text("2018"))
    }
       
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
    @State private var isPresented = false
    @State private var isActivityPopoverPresented = false
    @State private var isActivitySheetPresented = false
    
     
   
    var xxx: OEng19

    var body: some View {
        VStack {
            Webview(url: xxx.url)
          
            
        }
        .navigationBarTitle(Text(xxx.name), displayMode: .inline)
        .navigationBarItems(trailing: shareButton)
        .popover(isPresented: $isActivityPopoverPresented, attachmentAnchor: .point(.topTrailing), arrowEdge: .top, content: activityView)
        .sheet(isPresented: $isActivitySheetPresented, content: activityView)
        
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
                .font(.system(size: 20, weight: .medium))
             .frame(width: 38, height: 43)
             .hoverEffect(.automatic)
             .padding(.trailing, -5)
             .padding(.bottom, 5)
        })
    }
    
    private func activityView() -> some View {
        let url = URL(string: xxx.url)!
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
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

 struct OEng19: Hashable, Codable, Identifiable {
     var id: Int
     var name: String
     var url: String
     
 }

  

 let OEng19Data: [OEng19] = load("OLEng.json")
  

 func load<T: Decodable>(_ filename: String) -> T {
     let data: Data
     
     guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
         else {
         fatalError("Couldn't find \(filename) in main bundle.")
     }
     
     do {
         data = try Data(contentsOf: file)
     } catch {
         fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
     }
     
     do {
         let decoder = JSONDecoder()
         return try decoder.decode(T.self, from: data)
     } catch {
         fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
     }
 }


struct SafariView: UIViewControllerRepresentable {

     let url: URL

     func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
         return SFSafariViewController(url: url)
     }

     func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {

     }

     func prefersStatusBarHidden() -> Bool {
          return true
      }


 }


  
