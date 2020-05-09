//
//  ContentView.swift
//  PastPaperO-Test
//
//  Created by Rhapsody on 2020/5/6.
//  Copyright © 2020 Rhapsody. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var selection = 0
   var body: some View {
        TabView(selection: $selection) {
            
            NavigationView {
                HomeView()
            }
            //.navigationBarTitle("Home")
                .tabItem {
                    VStack {
                        if selection == 0 {
                            Image(systemName: "house.fill")
                        } else
                        {
                            Image(systemName: "house")
                        }
                        //Text("Home")
                    }
                }
            .tag(0)
            NavigationView {
                SettingsView()
            }.navigationBarTitle("Settings")
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        //Text("Settings")
                    }
                }
                .tag(1)
            }
            .accentColor(.black)
                    
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
            .frame(width: 200, height: 80)
            .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
            //.cornerRadius(15)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            //.overlay(
               //RoundedRectangle(cornerRadius: 20).stroke(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), lineWidth: 1))
            .shadow(color: Color.gray.opacity(0.2), radius: 3, x: 0, y: 2)
    }
}

 
struct HomeView: View {
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
