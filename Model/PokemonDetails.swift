//
//  PokemonDetails.swift
//  Pokemon
//
//  Created by j.jimenez.herrera on 5/3/22.
//

import Foundation

struct PokemonDetails : Decodable {
    var height : Int
    var stats : [Stats]?
    var types : [Types]?
    var weight : Int
    
    
    struct Stats : Decodable {
        var base_stat : Int
    }
    
    struct Types : Decodable {
        var type : TypeInfo
        
        struct TypeInfo : Decodable {
            var name : String
        }
    }
    
    
}
