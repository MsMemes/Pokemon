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
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func readJSON(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    private func parse(jsonData: Data) {
        do {
            let decodedData = try JSONDecoder().decode(PokemonModel.self, from: jsonData)
            
            print("ID: ", decodedData.count)
            print("Name: ", decodedData.next)
            var count = 1
            for poke in decodedData.results {
                
                let newPoke = PokemonStats(id: count, name: poke.name, url: poke.url, image: nil)
                pokeStats.append(newPoke)
                downloadImage(count: count, id: newPoke.id)
                count += 1
            }
            
            print("===================================")
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
