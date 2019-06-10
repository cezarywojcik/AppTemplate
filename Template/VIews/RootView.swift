//
//  RootView.swift
//  Template
//
//  Created by Cezary Wojcik on 6/9/19.
//  Copyright © 2019 Cezary Wojcik. All rights reserved.
//

import Foundation
import SwiftUI

struct RootView: View {

    enum ContentViewType {

        case home

    }

    // MARK: - properties

    private unowned let app: App

    @State var contentViewType: ContentViewType = .home
    private var viewForContentViewType: some View {
        switch self.contentViewType {
        case .home:
            return HomeView(app: self.app)
        }
    }

    // MARK: - initialization

    init(app: App) {
        self.app = app
    }

    // MARK: - view

    var body: some View {
        self.viewForContentViewType
    }

}

#if DEBUG
struct RootView_Preview: PreviewProvider {

    static var previews: some View {
        RootView(app: App())
    }

}
#endif
