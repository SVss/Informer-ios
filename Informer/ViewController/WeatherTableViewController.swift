//
//  WeatherTableViewController.swift
//  Informer
//
//  Created by Admin on 2/21/17.
//  Copyright © 2017 BSUIR. All rights reserved.
//

import UIKit

class WeatherTableViewController: UITableViewController, WeatherTableReloadAsyncDelegate {
    let alertController = UIAlertController(title: "Error", message: "Can't get weather info", preferredStyle: .alert)
    
    lazy var weatherModel: WeatherModel = WeatherModel(delegate: self)

    internal func reloadWeather() {
        tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    internal func onError() {
        self.refreshControl?.endRefreshing()
        present(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(WeatherTableViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        setDefaultAlertAction()
    }

    func handleRefresh(_ refreshControl: UIRefreshControl) {
        updateWeather()
    }
    
    private func setDefaultAlertAction() {
        let defaultAlertAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        )
        alertController.addAction(defaultAlertAction)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateWeather()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherModel.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath)

        let city = weatherModel.getWeather[indexPath.row]
        
        cell.textLabel?.text = city.cityName
        cell.detailTextLabel?.text = city.temperature

        return cell
    }
    
    private func updateWeather() {
        weatherModel.refresh()
    }
}
