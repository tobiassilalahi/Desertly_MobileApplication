//
//  Cook.swift
//  Desertly
//
//  Created by Mikhael Adiputra on 10/06/20.
//  Copyright © 2020 Mikhael Adiputra. All rights reserved.
//

import Foundation

class Cook{
    var cookTime : Int?
    var image : String?
    var ingredientString : [String]?
    var fullURL : String?
    var carbs: Int?
    var protein : Int?
    var vitaminD : Int?
    var vitaminC : Int?
    var vitaminA : Int?
    var sodium : Int?
    var cholestrol : Int?
    var energy : Int?
    var fat : Int?
    var recipeName : String?
    var sugar : Int?
    var calories : Int?
    var source :String?
    
    
    init(recipeName: String, cookTime : Int, ingredients : [String], urlRecipe: String, carbs : Int, protein : Int, vitaminD : Int, vitaminC : Int, sodium : Int, cholestrol : Int, energy : Int, fat: Int, vitaminA : Int, image: String, sugar : Int, source: String, calories : Int) {
        self.calories = calories
        self.source = source
        self.carbs = carbs
        self.cholestrol = cholestrol
        self.cookTime = cookTime
        self.energy = energy
        self.fat = fat
        self.ingredientString = ingredients
        self.fullURL = urlRecipe
        self.vitaminA = vitaminA
        self.vitaminC = vitaminC
        self.vitaminD = vitaminD
        self.recipeName = recipeName
        self.sodium = sodium
        self.protein = protein
        self.image = image
        self.sugar = sugar
    }
}
