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
    @State private var showShareSheet = false
    var xxx: OEng19

    var body: some View {
        VStack {
            //Webview(url: (xxx.url))
            SafariView(url:URL(string: self.xxx.url)!)
            .navigationBarHidden(true)
        }
        .navigationBarTitle(Text(xxx.name), displayMode: .inline)
         
            
        
        .edgesIgnoringSafeArea(.all)
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


  
