//
//  RandomizeOrderOfPaintings.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-06-07.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit

struct RandomizeOrderOfIndexArray {
   static func generateRandomIndex(from: Int, to: Int, quantity: Int?) -> [Int] {
        var randomNumbers: [Int] = []
        for n in from...to {
            randomNumbers.append(n)
        }
        randomNumbers.shuffle()
        
        return randomNumbers
    }
}
extension Array{
    public mutating func shuffle() {
        var temp = [Element]()
        while !isEmpty{
            let i = Int(arc4random_uniform(UInt32(count)))
            let obj = remove(at:i)
            temp.append(obj)
        }
        self = temp
    }
}
