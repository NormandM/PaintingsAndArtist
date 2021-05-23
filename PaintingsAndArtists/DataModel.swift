//
//  DataModel.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2021-03-16.
//  Copyright © 2021 Normand Martin. All rights reserved.
//

import Foundation
struct AllPaintingInfo {
    let artistName: String
    let birthDeathyears: String
    let paintingName: String
    let painterBio: String
    let painterWikiLink: String
    let painterSurname: String
    let painterBirthInfo: String
    let painterDeathInfo: String
    let painterActivePeriod: String
    let painterNationality: String
    let artMovement: String
    let paintingSchool: String
    let genre: String
    let field: String
    let paintingNameTranslated: String
    init(paintingsInfo: [[String]], item: Int) {
        artistName = paintingsInfo[item][0]
        birthDeathyears = paintingsInfo[item][1]
        paintingName = paintingsInfo[item][2]
        painterBio = paintingsInfo[item][3]
        painterWikiLink = paintingsInfo[item][4]
        painterSurname = paintingsInfo[item][5]
        painterBirthInfo = paintingsInfo[item][6]
        painterDeathInfo = paintingsInfo[item][7]
        painterActivePeriod = paintingsInfo[item][8]
        painterNationality = paintingsInfo[item][9]
        artMovement = paintingsInfo[item][10]
        paintingSchool = paintingsInfo[item][11]
        genre = paintingsInfo[item][12]
        field = paintingsInfo[item][13]
        paintingNameTranslated = paintingsInfo[item][14]
    }
}

