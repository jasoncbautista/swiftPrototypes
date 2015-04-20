//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


var someDic = [
      "one": 1
    , "two" : 2
    , "twenty": 20

]


for (key, value) in someDic {
    println(value)
    println("Key \(key)")


}

var scores = [1 ,2 ,3 ,4 ]
var min = scores[0]


func calculateSimple(scores: [Int]) -> (min: Int, max: Int, sum:Int){


    return (0, 0,0)

}