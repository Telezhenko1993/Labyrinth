//
//  Point.swift
//  Labyrinth
//
//  Created by Евгений Тележенко on 12.04.2020.
//  Copyright © 2020 Евгений Тележенко. All rights reserved.
//

import Foundation

//Ввел структуру координат, чтобы потом перевести для собственного удобства и хранения

struct Point: Equatable{
    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == lhs.y
    }
    
    var x: Int
    var y: Int
    var coordinate: (Int, Int)
    
    init(x: Int, y: Int) {
        
        self.x = x
        self.y = y
        
        coordinate = (self.x, self.y)
    }
    
}
extension Point: Hashable {
  
     func hash(into hasher: inout Hasher) {
           hasher.combine(x)
           hasher.combine(y)
        
       }
}
