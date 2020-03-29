//
//  HomeView.swift
//  Template
//
//  Created by Cezary Wojcik on 6/9/19.
//  Copyright © 2019 Cezary Wojcik. All rights reserved.
//

import SwiftUI
import SFSymbolsSafe

struct ModalButton<Destination>: View where Destination: View {

    @State
    private var isPresenting = false

    private let destination: Destination

//    private var presentation: Modal? {
//        self.isPresenting
//            ? Modal(self.destination, onDismiss: {
//                self.isPresenting = false
//            })
//            : nil
//    }

    var body: some View {
        Button(action: {
            self.isPresenting = true
        }, label: {
            Text("press me")
        })
        .sheet(isPresented: self.$isPresenting) {
            self.destination
        }
    }

    init(_ destination: Destination) {
        self.destination = destination
    }

}

struct HomeView: View {

    // MARK: - properties

    private unowned let app: App

    // MARK: - initialization

    init(app: App) {
        self.app = app
    }

    // MARK: - view

    var body: some View {
        NavigationView {
            ModalButton(HStack {
                Image(symbol: .bubbleLeft)
                Text("destination modal💤")
            })
            List {
                Text(/*@START_MENU_TOKEN@*/"Hello World!"/*@END_MENU_TOKEN@*/)
            }
            .navigationBarTitle(Text(App.Constant.appName))
        }
    }

}

#if DEBUG
struct HomeView_Previews: PreviewProvider {

    static var previews: some View {
        HomeView(app: App())
    }

}
#endif
