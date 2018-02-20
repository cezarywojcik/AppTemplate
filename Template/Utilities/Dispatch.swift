//
//  Dispatch.swift
//  Template
//
//  Created by Cezary Wojcik on 2/19/18.
//  Copyright © 2018 Cezary Wojcik. All rights reserved.
//

import Foundation

class Dispatch {

    /**
     Some context: http://blog.benjamin-encz.de/post/main-queue-vs-main-thread/
     And: http://blog.krzyzanowskim.com/2016/06/03/queues-are-not-bound-to-any-specific-thread/
     Basically, `Thread.isMainQueue` is not reliable.
     */
    private let mainQueueKey = DispatchSpecificKey<Void>()
    private static let shared = Dispatch()

    private init() {
        DispatchQueue.main.setSpecific(key: self.mainQueueKey, value: ())
    }

    static var isOnMainQueue: Bool {
        return DispatchQueue.getSpecific(key: Dispatch.shared.mainQueueKey) != nil
    }

}
