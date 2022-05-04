//
//  PokemonDetailsViewController.swift
//  Pokemon
//
//  Created by j.jimenez.herrera on 5/3/22.
//

import UIKit

class PokemonDetailsViewController: UIViewController{
    
    
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imagePokemon: UIImageView!
    
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var atkLabel: UILabel!
    @IBOutlet weak var defLabel: UILabel!
    @IBOutlet weak var satkLabel: UILabel!
    @IBOutlet weak var sdefLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    @IBOutlet weak var hpDisplayLabel: UILabel!
    @IBOutlet weak var atkDisplayLabel: UILabel!
    @IBOutlet weak var speedDisplayLabel: UILabel!
    @IBOutlet weak var sdefDisplayLabel: UILabel!
    @IBOutlet weak var satkDisplayLabel: UILabel!
    @IBOutlet weak var defDisplayLabel: UILabel!
    
    var image : UIImage = UIImage()
    var name : String = ""
    var url : String = ""
    
    var details = PokemonDetails(height: 0, stats: nil, types: nil, weight: 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBorder()
        getPokemon()
        imagePokemon.image = image
        nameLabel.text = name
    }
    
    func addBorder() {
        hpLabel.layer.borderWidth = 1.0
        atkLabel.layer.borderWidth = 1.0
        defLabel.layer.borderWidth = 1.0
        satkLabel.layer.borderWidth = 1.0
        sdefLabel.layer.borderWidth = 1.0
        speedLabel.layer.borderWidth = 1.0
        hpDisplayLabel.layer.borderWidth = 1.0
        atkDisplayLabel.layer.borderWidth = 1.0
        defDisplayLabel.layer.borderWidth = 1.0
        satkDisplayLabel.layer.borderWidth = 1.0
        sdefDisplayLabel.layer.borderWidth = 1.0
        speedDisplayLabel.layer.borderWidth = 1.0
    }
    
    func getPokemon(){
        if let url = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let safeData = data {
                    self.parse(jsonData: safeData)
                    DispatchQueue.main.async {
                        self.fillData()
                    }
                }
            }
            task.resume()
        }
    }
    
    func fillData() {
        sizeLabel.text = "Height \(details.height) - Weight \(details.weight)"
        if details.types!.count > 1 {
            typeLabel.text = "\(details.types![0].type.name) - \(details.types![1].type.name)"
        } else {
            typeLabel.text = "\(details.types![0].type.name)"
        }
        hpLabel.text = " \(details.stats![0].base_stat)"
        atkLabel.text = " \(details.stats![1].base_stat)"
        defLabel.text = " \(details.stats![2].base_stat)"
        satkLabel.text = " \(details.stats![3].base_stat)"
        sdefLabel.text = " \(details.stats![4].base_stat)"
        speedLabel.text = " \(details.stats![5].base_stat)"
    }
    
    private func parse(jsonData: Data) {
        do {
            let decodedData = try JSONDecoder().decode(PokemonDetails.self, from: jsonData)
            
            details.weight = decodedData.weight
            details.types = decodedData.types
            details.stats = decodedData.stats
            details.height = decodedData.height
            
            print("===================================")
        } catch {
            print("decode error")
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
