//
//  CarouselViewController.swift
//  Desertly
//
//  Created by Mikhael Adiputra on 10/06/20.
//  Copyright © 2020 Mikhael Adiputra. All rights reserved.
//

import UIKit

class CarouselViewController: UIViewController {
    
    private var selectedIndex = 0
    var cookArray : [Cook]?
    var searchString : String?
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  title = "Search Results for \(searchString ?? "")"
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail" {
            if let nextViewController = segue.destination as? DetailViewController {
                nextViewController.cook = cookArray![selectedIndex]
                nextViewController.queryName = searchString!
            }
        }
    }
}
extension CarouselViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
         return cookArray?.count ?? 0
     }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "carousel", for: indexPath) as! CarouselTableViewCell
         cell.configureCookCell(Cook: cookArray![indexPath.row])
         return cell
     }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "goToDetail", sender: self)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
     
}
