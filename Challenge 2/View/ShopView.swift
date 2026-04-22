//
//  ShopView.swift
//  Challenge 2
//
//  Created by Alan Brian Frederick on 21/04/26.
//

import SwiftUI

struct ShopView: View {
    
    @State private var money: Int = 24
    
    var body: some View {
        ZStack{
            Image("titikkertas")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack{
                HStack {
                    Text("Shop")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.trailing, 140)
                    
                    
                    HStack {
                        Text("􁞱")
                            .font(Font.system(size: 24))
                            .foregroundStyle(Color.blue)
                        
                        Image(systemName: "multiply")
                        
                        Text(String(money))
                            .font(.system(size: 24, weight: .bold))
                    }.padding()
                }
                
                HStack {
                    ZStack{
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.lightGrayy)
                            .strokeBorder(Color.darkGrayy, lineWidth: 5)
                            .frame(width: 170, height: 170)
                        
                        VStack {
                            Image("Dodit")
                                .resizable()
                                .frame(width: 100, height: 100)
                        
                            Text("Dodit")
                                .font(.system(size: 21, design: .rounded))
                                .bold()
                        }
                    }.padding(.trailing, 10)
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.lightGrayy)
                            .strokeBorder(Color.darkGrayy, lineWidth: 5)
                            .frame(width: 170, height: 170)
                        
                        VStack {
                            Image("Scribi")
                                .resizable()
                                .frame(width: 100, height: 100)
                        
                            Text("Scribi")
                                .font(.system(size: 21, design: .rounded))
                                .bold()
                        }
                    }.padding(.trailing, 10)
                }
            }
        }
        
        
                
    }
}

#Preview {
    ShopView()
}
