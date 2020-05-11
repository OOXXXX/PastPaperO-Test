//
//  HomeView.swift
//  PastPaperO-Test
//
//  Created by Rhapsody on 2020/5/9.
//  Copyright © 2020 Rhapsody. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 30)!]
    }
@State private var action: Int? = 0
@State private var hovered = false
@State var show2019 = false
 var body: some View {
    
 NavigationView{
    VStack{
        Button("Sheet") {
            
            
             
             self.show2019.toggle()
         }
            
         .buttonStyle(YearRoundedButton())
         .scaleEffect(hovered ? 1.1 : 1.0)
         .animation(.easeInOut)
         .onHover { isHovered in
             self.hovered = isHovered
         }
 
         .sheet(isPresented: self.$show2019) {
             OEng19ListView()
         }
            
            .navigationBarTitle("Home")
         
         
        }
        
        .navigationViewStyle(StackNavigationViewStyle())
    
  
     }
    }
 }

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
