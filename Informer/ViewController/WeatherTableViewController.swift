//
//  WeatherTableViewController.swift
//  Informer
//
//  Created by Admin on 2/21/17.
//  Copyright © 2017 BSUIR. All rights reserved.
//

import UIKit

protocol WeatherTableReloadAsyncDelegate {
    func reloadWeather()
    func onError()
    func onReloadEnd()
}


class WeatherTableViewController: UITableViewController, WeatherTableReloadAsyncDelegate {
    let alertController = UIAlertController(title: "Error", message: "Can't get weather info", preferredStyle: .alert)
    
    lazy var weatherModel: WeatherModel = WeatherModel(delegate: self)
        
    @IBAction func RefreshButtonAction(_ sender: UIButton) {
        updateWeather()
    }

    internal func reloadWeather() {
        tableView.reloadData()
        onReloadEnd()
    }

    internal func onError() {
        present(alertController, animated: true, completion: nil)
        onReloadEnd()
    }

    internal func onReloadEnd() {
        self.view.isUserInteractionEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultAlertAction()
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
        self.view.isUserInteractionEnabled = false
        weatherModel.refresh()
    }
}
