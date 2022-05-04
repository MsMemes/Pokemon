//
//  PokemonModel.swift
//  Pokemon
//
//  Created by j.jimenez.herrera on 5/3/22.
//

import Foundation

struct PokemonModel : Decodable {
    
    let count : Int
    let next : String?
    let previous : String?
    let results : [Results]
    
    struct Results : Decodable {
        let name : String
        let url : String
    }    
    
}
