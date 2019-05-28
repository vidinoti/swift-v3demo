//
//  ViewController.swift
//  V3Demo
//
//  Created by Johan Leuenberger on 28.05.19.
//  Copyright © 2019 Vidinoti. All rights reserved.
//

import UIKit
import VidinotiARViewer

/// This class demonstrates how to use the Vidinoti 3D SDK
class ViewController: UIViewController, VidinotiARControllerDelegate {

    /// The V-Director license key (https://armanager.vidinoti.com)
    private let LICENSE_KEY = "qv8db1pcnzc444ysnqtj"


    /// The TableViewController embedded into the view (see Main.storyboard)
    lazy var tableViewController = {
        self.children.first! as! ModelTableViewController
    }()

    /// For avoiding downloading the asset list every time, we can store the list locally.
    /// This variable contains the URL of the local storage where the data will be saved.
    lazy var localSavePath = {
        FileManager.default.temporaryDirectory.appendingPathComponent(Bundle.main.bundleIdentifier! + "-SavedAssets")
    }();

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize the SDK with the license key
        VidinotiARController.shared.configure(with: self, license: LICENSE_KEY)

        // Retrieve local model list if any
        if let assets = VidinotiARController.shared.loadAssets(from: localSavePath) {
            tableViewController.populateTable(with: assets)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Retrieve the list of models from the server
        VidinotiARController.shared.downloadAssetList(for: nil)
    }

    /// Called when the "Start AR with all models" button is clicked
    @IBAction func startArWithAllModels(_ sender: Any) {
        VidinotiARController.shared.resetViewController()
        // Configure the AR view to show a list of models that can be added to the AR session
        VidinotiARController.shared.setAssetList(assets: tableViewController.modelList)
        startARView()
    }

    func downloadFinished(status: VidinotiARController.DownloadStatus, assets: [AssetDetails]?) {
        guard status == .SUCCESS else {
            print("Failed to download the model list")
            // It can be a network error or you may have misconfigured your project.
            // 1. Check that your license key is correct.
            // 2. Check that the application Bundle Id is correctly configured in V-Director.
            return
        }
        if let assets = assets {
            // Add the models in the table view
            tableViewController.populateTable(with: assets)
            // Store the models locally
            if (VidinotiARController.shared.save(assets: assets, to: localSavePath)) {
                print("Model list saved locally")
            }
        } else {
            tableViewController.populateTable(with: [])
        }
    }

    func downloadFinished(status: VidinotiARController.DownloadStatus, asset: AssetDetails?) {
        guard status == .SUCCESS else {
            print("Failed to download the model")
            return
        }
        // Do something here if necessary
    }

    /// Starts the VidinotiARViewController
    func startARView() {
        let vc = VidinotiARController.shared.getViewController()
        self.present(vc, animated: true, completion: nil)
    }

}

