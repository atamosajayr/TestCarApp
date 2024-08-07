//
//  Helper.swift
//  CarTest
//
//  Created by JayR Atamosa on 8/7/24.
//

import Foundation

func countWords(in string: String) -> Int {
    let words = string.components(separatedBy: CharacterSet.whitespacesAndNewlines)
    let filteredWords = words.filter { !$0.isEmpty }
    return filteredWords.count
}
