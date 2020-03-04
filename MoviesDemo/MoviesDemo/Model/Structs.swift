

import Foundation
import Alamofire
import UIKit


struct AllmoviesResults
{
    var Poster_Path: String
    var Adult: Bool
    var Overview: String
    var Release_Date: String
    var Id: Int
    var Original_Title: String
    var Original_Language: String
    var Title: String
    var Backdrop_Path: String
    var Popularity: Double
    var Vote_Count: String
    var Video: Bool
    var Vote_Average: Double

    init(dic:NSDictionary) {
        self.Poster_Path = dic["poster_path"] as? String ?? ""
        self.Adult = dic["adult"] as! Bool
        self.Overview = dic["overview"] as? String ?? ""
        self.Release_Date = dic["release_date"] as? String ?? ""
        self.Id = dic["id"] as! Int
        self.Original_Title = dic["original_title"] as? String ?? ""
        self.Original_Language = dic["original_language"] as? String ?? ""
        self.Title = dic["title"] as? String ?? ""
        self.Backdrop_Path = dic["backdrop_path"] as? String ?? ""
        self.Popularity = dic["popularity"] as! Double
        self.Vote_Count = dic["vote_count"] as? String ?? ""
        self.Video = dic["video"]  as! Bool
        self.Vote_Average = dic["vote_average"] as! Double
       }
}

struct CateGoryList
{
    var Id : Int
    var Name: String
    
    init(Dict: NSDictionary) {
        self.Id = Dict["id"] as! Int
        self.Name = Dict["name"] as? String ?? ""
    }
}

struct PeopleData
{
    var Id : Int
    var Name: String
    var ProfilePath: String
    
    init(Dict: NSDictionary) {
        self.Id = Dict["id"] as! Int
        self.Name = Dict["name"] as? String ?? ""
        self.ProfilePath = Dict["profile_path"] as? String ?? ""
    }
}



struct FavoriteMovies {
var UserId: String!
var MoviesId : String!
var MoviesName: String!
var MoviesPoster : String!
}

struct FavoriteActors {
var UserId: String!
var CastId : String!
var CastName: String!
var CastProfileUrl : String!
}
