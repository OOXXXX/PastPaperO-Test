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
@State var show2019 = false
 var body: some View {
    
    NavigationView{
    
        Button("English") {
             
             
             self.show2019.toggle()
         }
            
         .buttonStyle(YearRoundedButton())
         
         .hoverEffect(.lift)
         .sheet(isPresented: self.$show2019) {
             OEng19ListView()
         }
            
            .navigationBarTitle("Home")
         
         
        }
        .navigationViewStyle(StackNavigationViewStyle())
     }
     
 }

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
