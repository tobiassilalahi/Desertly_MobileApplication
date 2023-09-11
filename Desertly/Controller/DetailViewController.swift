//
//  DetailViewController.swift
//  Desertly
//
//  Created by Mikhael Adiputra on 12/06/20.
//  Copyright © 2020 Mikhael Adiputra. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import SwiftyJSON

class DetailViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var descText: UITextView!
    @IBOutlet weak var nutritionTextView: UITextView!

    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var ingredientTextView: UITextView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    private let wikipediaURl = "https://en.wikipedia.org/w/api.php"
    var cook : Cook?
    var queryName : String?

    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.1) {
            self.navigationController?.navigationBar.alpha = 0
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         UIView.animate(withDuration: 0.1) {
           self.navigationController?.navigationBar.alpha = 1
       }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDescriptionData(flowerName: queryName ?? "")
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.headIndent = 20
       
        backButton.layer.cornerRadius = backButton.frame.height/2
        shareButton.layer.cornerRadius = shareButton.frame.height/2
     
        let cookTime = NSMutableAttributedString(string: "\u{2022} Cooking time: \(cook?.cookTime! ?? 0) minutes", attributes: [NSAttributedString.Key.paragraphStyle: style,NSAttributedString.Key.foregroundColor:UIColor.black])
            
        let carbs = NSMutableAttributedString(string: "\n\u{2022} Carbs: \(cook?.carbs! ?? 0)g", attributes: [NSAttributedString.Key.paragraphStyle: style,NSAttributedString.Key.foregroundColor:UIColor.black])
        cookTime.append(carbs)
        let protein = NSMutableAttributedString(string: "\n\u{2022} Protein: \(cook?.protein! ?? 0)g", attributes: [NSAttributedString.Key.paragraphStyle: style,NSAttributedString.Key.foregroundColor:UIColor.black])
        cookTime.append(protein)
        let vitaminD = NSMutableAttributedString(string: "\n\u{2022} Vitamin D: \(cook?.vitaminD! ?? 0)g", attributes: [NSAttributedString.Key.paragraphStyle: style,NSAttributedString.Key.foregroundColor:UIColor.black])
        cookTime.append(vitaminD)
        let vitaminC = NSMutableAttributedString(string: "\n\u{2022} Vitamin C: \(cook?.vitaminC! ?? 0)g", attributes: [NSAttributedString.Key.paragraphStyle: style,NSAttributedString.Key.foregroundColor:UIColor.black])
        cookTime.append(vitaminC)
        let vitaminA = NSMutableAttributedString(string: "\n\u{2022} Vitamin A: \(cook?.vitaminA! ?? 0)g", attributes: [NSAttributedString.Key.paragraphStyle: style,NSAttributedString.Key.foregroundColor:UIColor.black])
              cookTime.append(vitaminA)
        let sodium = NSMutableAttributedString(string: "\n\u{2022} Sodium: \(cook?.sodium! ?? 0)g", attributes: [NSAttributedString.Key.paragraphStyle: style,NSAttributedString.Key.foregroundColor:UIColor.black])
        cookTime.append(sodium)
        let cholestrol = NSMutableAttributedString(string: "\n\u{2022} Cholestrol: \(cook?.cholestrol! ?? 0)g", attributes: [NSAttributedString.Key.paragraphStyle: style,NSAttributedString.Key.foregroundColor:UIColor.black])
        cookTime.append(cholestrol)
        let energy = NSMutableAttributedString(string: "\n\u{2022} Enegy: \(cook?.energy! ?? 0)g", attributes: [NSAttributedString.Key.paragraphStyle: style,NSAttributedString.Key.foregroundColor:UIColor.black])
        cookTime.append(energy)
        let fat = NSMutableAttributedString(string: "\n\u{2022} Fat: \(cook?.fat! ?? 0)g", attributes: [NSAttributedString.Key.paragraphStyle: style,NSAttributedString.Key.foregroundColor:UIColor.black])
        cookTime.append(fat)
        let sugar = NSMutableAttributedString(string: "\n\u{2022} Sugar: \(cook?.sugar! ?? 0)g", attributes: [NSAttributedString.Key.paragraphStyle: style,NSAttributedString.Key.foregroundColor:UIColor.black])
        cookTime.append(sugar)
        let calories = NSMutableAttributedString(string: "\n\u{2022} Calories: \(cook?.calories! ?? 0)g", attributes:
            [NSAttributedString.Key.paragraphStyle: style,NSAttributedString.Key.foregroundColor:UIColor.black])
        cookTime.append(calories)
        nutritionTextView.attributedText = cookTime
        
        
        let title = NSMutableAttributedString(string: "\u{2022} \(cook?.ingredientString![0] ?? "")", attributes: [NSAttributedString.Key.paragraphStyle: style,NSAttributedString.Key.foregroundColor:UIColor.black])
        
        for index in stride(from: 1, to:  (cook?.ingredientString!.count)! , by: 1) {
            let titleStr = NSMutableAttributedString(string: "\n\u{2022} \(cook?.ingredientString![index] ?? "")", attributes: [NSAttributedString.Key.paragraphStyle: style,NSAttributedString.Key.foregroundColor:UIColor.black])
             title.append(titleStr)
        }
       
        ingredientTextView.attributedText = title
        imageView.sd_setImage(with: URL(string: (cook?.image)!))
        sourceLabel.text = "Source: \(cook?.source! ?? "")"
        recipeName.text = cook?.recipeName
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    private func getDescriptionData (flowerName: String) {
        let parameters : [String:String] = [
          "format" : "json",
          "action" : "query",
          "prop" : "extracts",
          "exintro" : "",
          "explaintext" : "",
          "titles" : flowerName,
          "indexpageids" : "",
          "redirects" : "1",
          ]

          Alamofire.request(wikipediaURl, method: .get, parameters: parameters ).responseJSON { (response) in

        if response.result.isSuccess {
          let flowerJSON : JSON = JSON(response.result.value!)
          self.updateUI(json: flowerJSON)
          }
        }
    }
    
   private func updateUI(json: JSON) {
      let pageID = json["query"]["pageids"][0].stringValue
      let result = json["query"]["pages"][pageID]["extract"].stringValue

          if result.count == 0 {
            descText.text = "Description is not available for this food"
            } else {
            descText.text = result
          }
    }
    
    
    @IBAction func backButton(_ sender: Any) {
          self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareButton(_ sender: Any) {
        let activityController =  UIActivityViewController(activityItems: [cook?.fullURL ?? ""], applicationActivities: nil)

        activityController.completionWithItemsHandler = { (nil, completed, _, error) in
            if completed  {
                print("completed")
            } else {
                print("error sharing to another apps")
            }
        }
        self.present(activityController, animated: true, completion: nil)
      
    }
}
