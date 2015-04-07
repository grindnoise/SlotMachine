//
//  Calculation.swift
//  SlotMachine
//
//  Created by Admin on 06.04.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import Foundation

class ArrayOfRows {
    
    class func createRows(slots: [[Slot]]) -> [[Slot]] {
        var rows = [[Slot]]()
        var firstRow = [Slot]()
        var secondRow = [Slot]()
        var thirdRow = [Slot]()
        
        for container in slots {
            for var i = 0; i < container.count; i++ {
                let slot = container[i]
                if i == 0 {
                    firstRow.append(slot)
                } else if i == 1 {
                    secondRow.append(slot)
                } else if i == 2 {
                    thirdRow.append(slot)
                }
            }
        }
        rows += [firstRow, secondRow, thirdRow]
        return rows
    }
    
    class func calculateWinnigs (slots: [[Slot]]) -> Int {
    
        var winning = 0
        var flushWinCount = 0
        var threeOfAKind = 0
        var straightWinCount = 0
        let rows = createRows(slots)
        
        for row in rows {
            if checkFlush(row) {
                flushWinCount += 1
                winning += 2
                println("Flush")
            }
            if checkThreeOfAKind(row) {
                threeOfAKind += 1
                winning += 3
                println("Three of a kind")
            }
            if checkStraight (row) {
                straightWinCount += 1
                winning += 4
                println("Straight")
            }
        }
        
        if flushWinCount == 3 {
            winning += 15
        }
        if straightWinCount == 3 {
            winning += 1000
        }
        if threeOfAKind == 3 {
            winning += 50
        }
        
        return winning
    }
    
    class func checkFlush (row: [Slot]) -> Bool {
       
        if (row[0].isRed == true && row[1].isRed == true && row[2].isRed == true) || (row[0].isRed == false && row[1].isRed == false && row[2].isRed == false) {
            return true
        } else {
            return false
        }
        
    }
    
    class func checkThreeOfAKind (row: [Slot]) -> Bool {
        
        if row[0].value == row[1].value && row[1].value == row[2].value {
            return true
        } else {
            return false
        }
        
    }
    
    class func checkStraight (row: [Slot]) -> Bool {
    
        if row[0].value == row[1].value - 1 && row[1].value == row[2].value {
            return true
        } else {
            return false
        }
        
    }
    
}

