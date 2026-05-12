//
//  Book.swift
//  BookTrackerPOC
//
//  Created by Francisco Miranda Soares on 11/05/26.
//

import Foundation
import SwiftData

@Model
final class Book {
    var name: String
    var author: String
    var review: String
    var finished: Bool

    init(name: String = "", author: String = "", review: String = "", finished: Bool = false) {
        self.name = name
        self.author = author
        self.review = review
        self.finished = finished
    }
}
