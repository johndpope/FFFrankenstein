//
//  Dictionary+Utilities.swift
//  FFFrankenstein
//
//  Created by Mark Malstrom on 3/25/19.
//

import Foundation

func +=<K, V>(left: inout [K: V], right: [K: V]) {
    for (k, v) in right {
        left[k] = v
    }
}
