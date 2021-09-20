//
//  MoviesViewController.swift
//  flixster
//
//  Created by Joohak Lee on 9/19/21.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    
    
    var movies = [[String:Any]]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    
                    self.movies = dataDictionary["results"] as! [[String:Any]]

                    self.tableView.reloadData()
 

             }
        }
        task.resume()
    }
    // this method will say print the rows how many times times//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    //this method will return the above int and return the movies)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String // as! = casting//
        let synopsis = movie["overview"] as! String
        
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        
        let posterUrl = URL(string: baseURL + posterPath)
        
        cell.posterView.af.setImage(withURL: posterUrl!)
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //prepare for the next screen aka passing data
        //find the selected movie
        let cell = sender as! UITableViewCell //tabbed on cell
        let indexPath = tableView.indexPath(for:cell)! //get the index of the tabbed movie
        let movie = movies[indexPath.row] //go get the movie
        
        //pass the selected movie to the details view controller
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        
        tableView.deselectRow(at: indexPath, animated: true) //this deselects the tab so that when we come back it's not highlighted
    }
}
