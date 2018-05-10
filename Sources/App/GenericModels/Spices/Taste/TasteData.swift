//
//  TasteData.swift
//  App
//
//  Created by Mihaela Mihaljevic Jakic on 10/05/2018.
//

import Foundation

//FIXME: This is a dirty hack to make Pivot fields unique, because (as far as I know) there is no way to make an idex on 2 fields.
func makeUnitedID(int1: Int, int2: Int) -> String {
  return "\(String(int1))|\(String(int2))"
}

public typealias TasteTouple = (name: String, desc: String, tastes: [String])

public typealias TasteDictionary = [String: Int]

//let tasteSources1  = [
//  "sweet" :  ["fruit", "grains", "natural sugars", "milk"],
//  "salty" :  ["natural salts", "sea vegetables"],
//  "sour" :  ["sour fruits", "yogurt", "fermented foods"],
//  "bitter" :  ["dark leafy greens", "herbs", "spices"],
//  "umami" :  ["fish", "shellfish", "cured meats", "mushrooms", "vegetables", "green tea", "cheese"]
//]

let tastes : [(String, String, String, String)] = [
  
  ("sweet",
   "Sweet taste as in honey, mango.",
   "Builds tissues, calms nerves.",
   "Fruit, grains, natural sugars, milk."),
  
  ("salty",
   "Salty as anchovies.",
   "Improves taste to food, lubricates tissues, stimulates digestion.",
   "Natural salts, sea vegetables."),
  
  ("sour",
   "The sour taste comes from higher acidic foods such as citrus, which includes lemons or limes. The sour taste is caused by a hydrogen atom, or ions. The more atoms present in a food, the more sour it will taste.",
   "Cleanses tissues, increases absorption of minerals.",
   "Sour fruits, yogurt, fermented foods."),
  
  ("bitter",
   "Bitterness can be described as a sharp, pungent, or disagreeable flavor. Bitterness is neither salty nor sour, but may at times accompany these flavor sensations.",
   "Detoxifies and lightens tissues.",
   "Dark leafy greens, herbs and spices."),
  
  ("umami",
   "Savory, and characteristic of broths and cooked meats. The sensation of umami is due to the detection of the carboxylate anion of glutamate in specialized receptor cells present on the human and other animal tongues. (The taste of monosodium glutamate, commonly found in Chinese takeaways)",
   "Satiating.",
   "Fish, shellfish, cured meats, mushrooms, vegetables (e.g., ripe tomatoes, Chinese cabbage, spinach, celery, etc.) or green tea, and fermented and aged products involving bacterial or yeast cultures, such as cheeses, shrimp pastes, fish sauce, soy sauce, nutritional yeast, and yeast extracts.")
]

let tasteItems : [(String, String)] = [
  
  ("sweet",
   "Sweet taste as in honey, mango."),
  
  ("salty",
   "Salty as anchovies."),
  
  ("sour",
   "The sour taste comes from higher acidic foods such as citrus, which includes lemons or limes. The sour taste is caused by a hydrogen atom, or ions. The more atoms present in a food, the more sour it will taste."),
  
  ("bitter",
   "Bitterness can be described as a sharp, pungent, or disagreeable flavor. Bitterness is neither salty nor sour, but may at times accompany these flavor sensations."),
  
  ("umami",
   "Savory, and characteristic of broths and cooked meats. The sensation of umami is due to the detection of the carboxylate anion of glutamate in specialized receptor cells present on the human and other animal tongues. (The taste of monosodium glutamate, commonly found in Chinese takeaways)")
]

let tasteSources : [TasteTouple] = [
  (name: "fruit", desc: "Fruit.", tastes: ["sweet"]),
  (name: "grains", desc: "Grains.", tastes: ["sweet"]),
  (name: "natural-sugars", desc: "Natural sugar found in food.", tastes: ["sweet"]),
  (name: "milk", desc: "Dairy products.", tastes: ["sweet"]),
  (name: "natural-salts", desc: "Natural salt found in food, like celery.", tastes: ["salty"]),
  (name: "sea-vegetables", desc: "Algae.", tastes: ["salty", "umami"]),
  (name: "sour-fruits", desc: "Sour fruit like cherry, citrus fruit, Granny Smith apples.", tastes: ["sour"]),
  (name: "yogurt", desc: "Yogurt.", tastes: ["sour"]),
  (name: "fermented-foods", desc: "fermented foods like yogurt, natto, kefir, sauerkraut, pickles.", tastes: ["sour", "umami"]),
  (name: "dark-leafy-greens", desc: "Darl leafy greens like kale, spinach, mustard greens, collard greens, arugula.", tastes: ["bitter"]),
  (name: "herbs", desc: "Herbs like basil, chives, cilantro, parsley.",tastes: ["bitter"]),
  (name: "fish", desc: "Sea fish." ,tastes: ["umami"]),
  (name: "shellfish", desc: "Shellfish like clams, mussels, oysters, shrimp, lobsters.", tastes: ["umami"]),
  (name: "cured-meats", desc: "Curing is any of various food preservation and flavoring processes of foods such as meat, fish and vegetables, by the addition of combinations of salt, nitrates, nitrites, or sugar, with the aim of drawing moisture out of the food by the process of osmosis.", tastes: ["umami"]),
  (name: "mushrooms", desc: "Edible mushrooms.", tastes: ["umami"]),
  (name: "green-tea", desc: "Green tea is a type of tea that is made from Camellia sinensis leaves that are not fermented.", tastes: ["umami"]),
  (name: "cheese", desc: "Cheese.", tastes: ["umami"]),
  (name: "soy-sauce", desc: "Soy sauce like Shoyu, Tamari.", tastes: ["umami"]),
  (name: "fish-sauce", desc: "Fish sauce is a condiment made from fish coated in salt and fermented from weeks to up to two years.", tastes: ["umami"]),
  (name: "nutritional-yeast", desc: "Nutritional yeast is a deactivated yeast, often a strain of Saccharomyces cerevisiae, which is sold commercially as a food product.", tastes: ["umami"]),
  (name: "broth", desc: "Soup consisting of meat or vegetables cooked in stock, sometimes thickened with barley or other cereals.", tastes: ["umami"]),
  (name: "cooked-meat", desc: "Any cooked meat, not fish.", tastes: ["umami"])
]


let tasteActions : [TasteTouple] = [
  (name: "builds-tissues", desc: "Help build and maintain body cells and tissues.", tastes: ["sweet"]),
  (name: "calms-nerves", desc: "Camls nerves", tastes: ["sweet"]),
  (name: "improves-taste", desc: "Makes the food taste more deep and full.", tastes: ["salty", "umami"]),
  (name: "lubricates-tissues", desc: "Lubricate mucous membranes and skin.", tastes: ["salty"]),
  (name: "digestiv", desc: "Helps the digestion.", tastes: ["salty"]),
  (name: "increases-absorption-of-minerals", desc: "Increases the absorption of minerals.", tastes: ["sour"]),
  (name: "detoxifies", desc: "Has a detoxifying effect.", tastes: ["bitter", "sour"]),
  (name: "lightens-tissues", desc: "Speeds up the tissue repair.", tastes: ["bitter"]),
  (name: "satiating", desc: "Makes one less hungry.", tastes: ["umami"])
]
