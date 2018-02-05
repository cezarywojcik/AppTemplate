//
//  Extensions.swift
//  Template
//
//  Created by Cezary Wojcik on 2/4/18.
//  Copyright © 2018 Cezary Wojcik. All rights reserved.
//

import Foundation

extension Collection {

    subscript(safe index: Index) -> Iterator.Element? {
        return self.indices.contains(index) ? self[index] : nil
    }

}
