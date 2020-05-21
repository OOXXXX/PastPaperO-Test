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
    @State private var isPresented = false
     
   
    var xxx: OEng19

    var body: some View {
        VStack {
            SafariView(url: URL(string: xxx.url)!)
          
            
        }
        .navigationBarTitle(Text(xxx.name), displayMode: .inline)
        .edgesIgnoringSafeArea(.all)
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


  
