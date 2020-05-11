//
//  ContentView.swift
//  PastPaperO-Test
//
//  Created by Rhapsody on 2020/5/6.
//  Copyright © 2020 Rhapsody. All rights reserved.
//

import SwiftUI

let screen = UIScreen.main.bounds

struct ContentView: View {
@State var selection = 0
   var body: some View {
    
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    if selection == 0 {
                        Image(systemName: "house.fill")
                        .font(.system(size: 23))
                    } else {
                        Image(systemName: "house")
                        .font(.system(size: 23))
                    }
       
                }.tag(0)
                 
    
            
            Text("Second View")
                .tabItem {
                    if selection == 1 {
                        Image(systemName: "doc.text.fill")
                        .font(.system(size: 23))
                    } else {
                        Image(systemName: "doc.text")
                        .font(.system(size: 23))
                    }
                }.tag(1)
            .transition(.slide)
            
            Text("Third View")
            .tabItem {
                if selection == 2 {
                    Image(systemName: "person.fill")
                    .font(.system(size: 23))
                } else {
                    Image(systemName: "person")
                    .font(.system(size: 23))
                }
            }.tag(2)
            .transition(.slide)
        }
                    
                 
         
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct YearRoundedButton: ButtonStyle {
 
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.system(size: 30))
            .foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
            //.padding(.bottom, -10)
            .frame(width: 110, height: 60)
            .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
            
            //.cornerRadius(15)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            //.overlay(
               //RoundedRectangle(cornerRadius: 20).stroke(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), lineWidth: 1))
            .shadow(color: Color.gray.opacity(0.2), radius: 3, x: 0, y: 2)
    }
}

 


 struct SettingsView: View {
 @State var show2019 = false
  var body: some View {
      Button("English") {
              
              
              self.show2019.toggle()
          }
          .buttonStyle(YearRoundedButton())
            
          .hoverEffect(.lift)
          .sheet(isPresented: self.$show2019) {
              OEng19ListView()
          }
      }
      
  }


