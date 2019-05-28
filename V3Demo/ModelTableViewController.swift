//
//  ModelTableViewController.swift
//  V3Demo
//
//  Created by Johan Leuenberger on 28.05.19.
//  Copyright © 2019 Vidinoti. All rights reserved.
//

import UIKit
import VidinotiARViewer

/// Table view for listing the 3D models
class ModelTableViewController: UITableViewController {

    var modelList = [AssetDetails]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelList.count
    }

    func populateTable(with assets: [AssetDetails]) {
        modelList = assets
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        cell.textLabel?.text = modelList[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        VidinotiARController.shared.resetViewController()
        VidinotiARController.shared.setSelectedModel(asset: modelList[indexPath.row])
        let parent = self.parent as! ViewController
        parent.startARView()
    }

}
