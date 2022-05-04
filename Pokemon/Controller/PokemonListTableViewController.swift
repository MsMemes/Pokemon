//
//  PokemonListTableViewController.swift
//  Pokemon
//
//  Created by j.jimenez.herrera on 5/3/22.
//

import UIKit

class PokemonListTableViewController: UITableViewController {
    
    var pokeStats = [PokemonStats]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadJson() { (result) in
            switch result {
            case .success(let data):
                self.parse(jsonData: data)
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    private func parse(jsonData: Data) {
        do {
            let decodedData = try JSONDecoder().decode(PokemonModel.self, from: jsonData)
            
            var count = 1
            for poke in decodedData.results {
                
                let newPoke = PokemonStats(id: count, name: poke.name, url: poke.url, image: nil)
                pokeStats.append(newPoke)
                downloadImage(count: count, id: newPoke.id)
                count += 1
            }
            
        } catch {
            print("decode error")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func loadJson(completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151%27") {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if let data = data {
                    completion(.success(data))
                }
                if let error = error {
                    completion(.failure(error))
                }
            }
            urlSession.resume()
        }
    }
    
    func getImage(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(count : Int, id : Int) {
        var index = count - 1
        let url = URL(string:"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")!
        getImage(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            self.pokeStats[index].image = UIImage(data: data)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pokeStats.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonCell", for: indexPath) 
        
        let poke = pokeStats[indexPath.row]
        cell.textLabel?.text = "#\(poke.id)"
        cell.detailTextLabel?.text = poke.name
        cell.imageView?.image = poke.image
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let viewController = storyboard?.instantiateViewController(identifier: "detailsVC") as? PokemonDetailsViewController {
            let poke = pokeStats[indexPath.row]
            viewController.url = poke.url
            viewController.name = poke.name
            viewController.image = poke.image!
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

}
