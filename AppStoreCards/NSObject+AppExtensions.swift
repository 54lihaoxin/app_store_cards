//
//  NSObject+AppExtensions.swift
//  AppStoreCards
//
//  Created by Haoxin Li on 7/5/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import Foundation

extension NSObject {
    
    static var className: String {
        guard let className = NSStringFromClass(self).components(separatedBy: ".").last else {
            fatalError("\(#function) class name not found for \(self)")
        }
        return className
    }
}
