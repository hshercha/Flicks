//
//  Movie.swift
//  MovieDemo
//
//  Created by hsherchan on 9/12/17.
//  Copyright © 2017 Hearsay. All rights reserved.
//

import Foundation

class Movie {
    var voteCount: String?
    var id: Int?
    var hasVideo: Bool?
    var voteAverage: Double?
    var movieTitle: String?
    var popularity: Double?
    var posterPath: String?
    var origLang: String?
    var origTitle: String?
    var genreIds: [Double]?
    var backdropPath: String?
    var hasMatureContent: Bool?
    var overview: String?
    var releaseDate: String?
    
    init(movieTitle title:String) {
        self.movieTitle = title
    }
}
