//
//  ViewController.swift
//  Desertly
//
//  Created by Mikhael Adiputra on 10/06/20.
//  Copyright © 2020 Mikhael Adiputra. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import UIColor_Hex_Swift
import Vision
import CoreML
import TTGSnackbar

class HomeController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, NVActivityIndicatorViewable {

    @IBOutlet weak var scanCard: UIView!
    @IBOutlet weak var helloCard: UIView!
    @IBOutlet weak var dessertsCollection: UICollectionView!
    @IBOutlet weak var backgroundCollectionView: UIView!
    @IBOutlet weak var featureActivity: NVActivityIndicatorView!
    @IBOutlet weak var featurePageControl: UIPageControl!
    @IBOutlet weak var FeaturedCollection: UICollectionView!
    @IBOutlet weak var scanButton: UIButton!
    
    private var state = false;
    private let imageView  = UIImagePickerController()
    private var cookArray = [Cook]()
    private var featuredCook = [Cook]()
    private var recommendedArray = [Cook]()
    private var recommendedIndex = 0
    private var searchString : String?
    private let snackbar =  TTGSnackbar(message: "No Internet Connection!", duration: .long)
    
    private let detailSegue = "goToDetail"
    private let carouselSegue = "goToCarousel"
    private lazy var alamoFireManager: SessionManager? = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5
        configuration.timeoutIntervalForResource = 5
        let alamoFireManager = Alamofire.SessionManager(configuration: configuration)
        return alamoFireManager
     }()
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        backgroundCollectionView.layer.masksToBounds = false
        backgroundCollectionView.layer.shadowRadius  = 5
        backgroundCollectionView.layer.shadowOpacity = 0.3
        backgroundCollectionView.layer.shadowOffset  = CGSize(width: 1, height: 1)
        backgroundCollectionView.layer.shadowColor   = UIColor(red:0/255.0, green:0/255.0, blue:0/255.0, alpha: 1.0).cgColor
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Reachability.isConnectedToNetwork() == true {
             fetchNutrition(DessertName: "Desserts", condition: 0)
        }else {
            self.snackbar.animationType = .slideFromTopBackToTop
            self.snackbar.backgroundColor = UIColor.black
            self.snackbar.messageTextColor = UIColor.white
            self.snackbar.leftMargin = 25
            self.snackbar.rightMargin = 25
            self.snackbar.show()
            self.snackbar.alpha = 0.8
        }
       
        FeaturedCollection.alpha = 0
        addDummyRecommends()
        scanButton.layer.cornerRadius = scanButton.frame.height/2
        dessertsCollection.delegate = self
        dessertsCollection.dataSource = self
        FeaturedCollection.delegate = self
        FeaturedCollection.dataSource = self
        scanCard.setHalloShadow()
        helloCard.setHalloShadow()
        
        imageView.delegate = self
        imageView.allowsEditing = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        snackbar.dismiss()
    }
    private func addDummyRecommends() {
        for _ in stride(from: 0, to: 4, by: 1) {
            let cook = Cook(recipeName: "", cookTime: 0, ingredients: [""], urlRecipe: "", carbs: 0, protein: 0, vitaminD: 0, vitaminC: 0, sodium: 0, cholestrol: 0, energy: 0, fat: 0, vitaminA: 0, image: "", sugar: 0, source: "", calories: 0)
            recommendedArray.append(cook)
        }
        self.dessertsCollection.reloadData()
    }

    @IBAction func scanButtonPressed(_ sender: UIButton) {
        
        let contextualMenu = UIAlertController(title: "Scan Desserts", message: "Choose From", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Take a Photo", style: .default) { (UIAlertAction) in
             self.imageView.sourceType = .camera
             self.present(self.imageView, animated: true, completion: nil)
         }
         let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (UIAlertAction) in
             self.imageView.sourceType = .photoLibrary
             self.present(self.imageView, animated: true, completion: nil)
         }
           
         let savedPhotosAction = UIAlertAction(title: "Saved Photos Album", style: .default) { (action) in
              self.imageView.sourceType = .savedPhotosAlbum
              self.present(self.imageView, animated: true, completion: nil)
         }
         
         let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
             return
         }
        
         contextualMenu.addAction(camera)
         contextualMenu.addAction(photoLibrary)
         contextualMenu.addAction(savedPhotosAction)
         contextualMenu.addAction(cancelButton)
         
         self.present(contextualMenu, animated: true, completion: nil)
    }
    
    //MARK: - IMAGE PICKER CONTROLLER ATAU CAMERA
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     
           if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage]  as? UIImage {
        
              guard let ciImage = CIImage(image: userPickedImage) else {fatalError("Photos can be used for Core ML Image")}

              detect(image: ciImage)
              let size = CGSize(width: 50, height: 50)
              imageView.dismiss(animated: true, completion: nil)
      startAnimating(size, message: "Loading",type: .ballRotateChase, color: UIColor.white, textColor: UIColor.white)
      DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            NVActivityIndicatorPresenter.sharedInstance.setMessage("Hang in there")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                        self.stopAnimating(nil)
                }
            }
        }
    }


    private func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for:Dessertly().model) else {fatalError("Failed getting the core ml model")}
            let request = VNCoreMLRequest(model: model) { (request2, error) in
              let results = request2.results as? [VNClassificationObservation] 
                if let firstResult = results?.first {
                    self.searchString = firstResult.identifier
                    self.fetchNutrition(DessertName: firstResult.identifier, condition: 1)
                }else {
                    print("no result")
                }
               }
        
           let handler = VNImageRequestHandler(ciImage : image)
           do {
               try? handler.perform([request])
            }catch {
                print("\(error) performing the classification")
            }
    }
    
    
    private func fetchNutrition(DessertName: String, condition: Int) {
       featureActivity.type = .ballRotateChase
       featureActivity.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now()+5) {
            self.featureActivity.stopAnimating()
            UIView.animate(withDuration: 0.3) {
                self.FeaturedCollection.alpha = 1
                self.featureActivity.alpha = 0
            }
        }
       alamoFireManager!.request("https://api.edamam.com/search?q=\(DessertName)&app_id=74fdc0ce&app_key=a35c588bcbc6153df7710a2530d0e6ba", method: .get ).responseJSON { (response) in
        if response.result.isSuccess {
            let cookJSON : JSON = JSON(response.result.value!)
            print(cookJSON)
            self.parseCookCollection(cook: cookJSON, condition: condition)
            } else {
                self.featureActivity.stopAnimating()
                UIView.animate(withDuration: 0.3) {
                    self.FeaturedCollection.alpha = 1
                    self.featureActivity.alpha = 0
                  }
                print(response.error?.localizedDescription as Any)
            }
        }
    }

    private func parseCookCollection(cook: JSON, condition: Int) {
         for index in stride(from: 0, to: 8, by: 1) {
             var ingredientArray : [String] = [String]()
             let source = cook["hits"].arrayValue[index]["recipe"]["source"].stringValue
             let calories = cook["hits"].arrayValue[index]["recipe"]["calories"].intValue
             let cookTime = cook["hits"].arrayValue[index]["recipe"]["totalTime"].intValue
             let ingredientCount =  cook["hits"].arrayValue[index]["recipe"]["ingredientLines"].arrayValue.count
             let recipeName = cook["hits"].arrayValue[index]["recipe"]["label"].stringValue
             let urlRecipe =  cook["hits"].arrayValue[index]["recipe"]["url"].stringValue
             let image =  cook["hits"].arrayValue[index]["recipe"]["image"].stringValue
             print(recipeName)
             for miniIndex in stride(from: 0, to: ingredientCount, by: 1) {
                 let ingredient =  cook["hits"].arrayValue[index]["recipe"]["ingredientLines"].arrayValue[miniIndex].stringValue
                 ingredientArray.append(ingredient)
                 print(ingredient)
             }
             print("\n")
             let fat =  cook["hits"].arrayValue[index]["recipe"]["totalNutrients"]["FAT"]["quantity"].intValue
             let sugar = cook["hits"].arrayValue[index]["recipe"]["totalNutrients"]["SUGAR"]["quantity"].intValue
             let carbs = cook["hits"].arrayValue[index]["recipe"]["totalNutrients"]["CHOCDF"]["quantity"].intValue
             let energy = cook["hits"].arrayValue[index]["recipe"]["totalNutrients"]["ENERC_KCAL"]["quantity"].intValue
             let protein =  cook["hits"].arrayValue[index]["recipe"]["totalNutrients"]["PROCNT"]["quantity"].intValue
             let vitaminD = cook["hits"].arrayValue[index]["recipe"]["totalNutrients"]["VITD"]["quantity"].intValue
             let vitaminC =  cook["hits"].arrayValue[index]["recipe"]["totalNutrients"]["VITC"]["quantity"].intValue
             let sodium =  cook["hits"].arrayValue[index]["recipe"]["totalNutrients"]["NA"]["quantity"].intValue
             let cholestrol =  cook["hits"].arrayValue[index]["recipe"]["totalNutrients"]["CHOLE"]["quantity"].intValue
             let vitaminA =  cook["hits"].arrayValue[index]["recipe"]["totalNutrients"]["VITA_RAE"]["quantity"].intValue
             let cook = Cook(recipeName: recipeName, cookTime: cookTime, ingredients: ingredientArray, urlRecipe: urlRecipe, carbs: carbs,
                             protein: protein, vitaminD: vitaminD, vitaminC: vitaminC, sodium: sodium,
                             cholestrol: cholestrol, energy: energy, fat: fat, vitaminA: vitaminA, image: image, sugar: sugar, source: source,
                             calories: calories)
           
           if condition == 0 {
               if index >=  0 && index <= 3 {
                   self.featuredCook.append(cook)
               }else {
                   let customIndex = index-4
                   recommendedArray[customIndex] = cook
               }
           }else {
               self.cookArray.append(cook)
           }
       }
        if condition != 0 {
            self.stopAnimating()
            self.performSegue(withIdentifier: carouselSegue, sender: self)
        }else {
            let range = Range(uncheckedBounds: (0, dessertsCollection.numberOfSections))
            let indexSet = IndexSet(integersIn: range)
            dessertsCollection.reloadSections(indexSet)
            self.FeaturedCollection.reloadData()
            self.dessertsCollection.reloadData()
            self.featureActivity.stopAnimating()
            UIView.animate(withDuration: 0.3) {
               self.FeaturedCollection.alpha = 1
               self.featureActivity.alpha = 0
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == carouselSegue {
            if let nextViewController = segue.destination as?  CarouselViewController{
                nextViewController.cookArray = self.cookArray
                nextViewController.searchString = self.searchString
            }
        }else if segue.identifier == detailSegue {
            if let nextViewController = segue.destination as?  DetailViewController {
                if self.state == true {
                    nextViewController.cook = featuredCook[recommendedIndex]
                }else {
                    nextViewController.cook = recommendedArray[recommendedIndex]
                }
            }
        }
    }
}

extension HomeController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == FeaturedCollection {
            featurePageControl.numberOfPages = featuredCook.count
            featurePageControl.isHidden = !(featuredCook.count > 1)
            return featuredCook.count
        }else {
            return recommendedArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == FeaturedCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "featured", for: indexPath) as! FeaturedCollectionViewCell
            cell.setFeatureCell(Cook: featuredCook[indexPath.row])
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dessertsCollection", for: indexPath) as! DessertCollectionViewCell
            cell.configureDessert(Cook: recommendedArray[indexPath.row])
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.recommendedIndex = indexPath.row
        if collectionView == FeaturedCollection {
            self.state = true
            self.performSegue(withIdentifier: detailSegue, sender: self)
            self.FeaturedCollection.deselectItem(at: indexPath, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.FeaturedCollection.contentOffset, size: self.FeaturedCollection.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.FeaturedCollection.indexPathForItem(at: visiblePoint) {
            self.featurePageControl.currentPage = visibleIndexPath.row
        }
    }
}

extension HomeController : dessertTapped {
    func responseTapped(Cell: DessertCollectionViewCell) {
        let indexpath = self.dessertsCollection.indexPath(for: Cell)
        self.recommendedIndex = indexpath!.row
        self.state = false
        self.performSegue(withIdentifier: detailSegue, sender: self)
    }
}
