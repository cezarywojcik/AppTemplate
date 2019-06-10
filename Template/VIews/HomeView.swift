//
//  HomeView.swift
//  Template
//
//  Created by Cezary Wojcik on 6/9/19.
//  Copyright © 2019 Cezary Wojcik. All rights reserved.
//

import SwiftUI

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
