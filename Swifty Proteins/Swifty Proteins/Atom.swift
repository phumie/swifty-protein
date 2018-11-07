//
//  Atom.swift
//  Swifty Proteins
//
//  Created by Phumudzo NEVHUTALA on 2018/10/29.
//  Copyright © 2018 Phumudzo NEVHUTALA. All rights reserved.
//

import Foundation

class Atom {
    var ID : Int = 0
    var symbol : String = ""
    var xPos : Double = 0.0
    var yPos : Double = 0.0
    var zPos : Double = 0.0
    var connections : [Int] = []
    
    init(_id : Int, _symbol : String, _xPos : Double, _yPos : Double, _zPos : Double) {
    self.ID = _id
    self.symbol = _symbol
    self.xPos = _xPos
    self.yPos = _yPos
    self.zPos = _zPos
    }
    
    func setConnections(connection : Int) {
        self.connections.append(connection)
    }
    
    func getConnections() -> [Int] {
        return self.connections
    }
}
