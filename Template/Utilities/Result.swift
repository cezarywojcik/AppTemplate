//
//  Result.swift
//  Template
//
//  Created by Cezary Wojcik on 2/3/18.
//  Copyright © 2018 Cezary Wojcik. All rights reserved.
//

import Foundation

enum Result<ResultType> {

    case success(ResultType)
    case failure(Swift.Error)

}
