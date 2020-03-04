

import Foundation
import UIKit

//MARK:- Variable

let appDelegate : AppDelegate = AppDelegate.shareAppDelegate()

//MARK:- Constant Classs

let LoginStatus = "LoginStatus"

let BaseUrlHome = "https://api.themoviedb.org/3/discover/movie?api_key="
let ApiKey = "f771750ffc6163cf135dde886196b657"

let HomeAllMoviesGet = "&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page="

let HomePosterPath = "https://image.tmdb.org/t/p/w500"

let BaseUrlCateGory = "https://api.themoviedb.org/3/genre/movie/list?api_key="
let CateGoryMoviesGet = "&language=en-US"

let BaseUrlSearch = "https://api.themoviedb.org/3/search/movie?api_key="

let BaseUrlPeople = "https://api.themoviedb.org/3/person/popular?api_key="

let PeopleGet = "&language=en-US&page="

let BaseUrlMoviesDetails = "https://api.themoviedb.org/3/movie/"

let MoviesDetailsGet = "&append_to_response=videos,credits"

let MoviesDetailsPosterPath = "https://image.tmdb.org/t/p/h632"

let MoviePictureGet = "&language=en-US&include_image_language=en,null"

let BaseUrlCastDetails = "https://api.themoviedb.org/3/person/"

let CastDetailsGet = "?append_to_response=movie_credits&api_key="

let CateGoryDetailsGet = "&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page="
