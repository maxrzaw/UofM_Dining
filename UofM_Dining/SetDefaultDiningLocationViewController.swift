//
//  SetDefaultDiningLocationViewController.swift
//  UofM_Dining
//
//  Created by Ryan Kish on 12/10/17.
//  Copyright © 2017 teamzucc. All rights reserved.
//

/*
 Inspiration from:
 * https://stackoverflow.com/questions/25379559/custom-alert-uialertview-with-swift
 * https://medium.com/if-let-swift-programming/design-and-code-your-own-uialertview-ec3d8c000f0a
 */

import UIKit

class SetDefaultDiningLocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let setDefaultDiningLocationTableViewCellID = "setDefaultDiningLocationTableViewCellID"
    
    let provider = MenusProvider.shared
    
    var diningLocations: [DiningLocation] = []
    var selectedDiningLocationIndex: Int? = nil
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var diningLocationsTableView: UITableView!
    @IBOutlet weak var okButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        diningLocationsTableView.dataSource = self
        diningLocationsTableView.delegate = self
        
        okButton.isEnabled = false
        titleLabel.text = "Favorite Dining Location"
        headerLabel.text = "To get started with this app, please select your favorite dining location."
        
        NotificationCenter.default.addObserver(self, selector: #selector(diningLocationsBecameAvailable), name: .diningLocationsHaveLoaded, object: nil)
    }
    
    /// Called when dining locations become available; populate tableview
    @objc func diningLocationsBecameAvailable() {
        diningLocations = provider.diningLocations
        diningLocationsTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
        diningLocationsTableView.separatorColor = UIColor.umBlue
        diningLocationsTableView.backgroundColor = UIColor.alertViewGrayColor
    }
    
    func setupView() {
        alertView.layer.cornerRadius = 15
        alertView.backgroundColor = UIColor.white
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        okButton.setTitleColor(UIColor.alertViewGrayColor, for: .disabled)
        okButton.setTitleColor(UIColor.umBlue, for: .normal)
        okButton.setTitle("OK", for: .normal)
    }
    
    func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }
    
    // MARK: - table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diningLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: setDefaultDiningLocationTableViewCellID, for: indexPath)
        cell.backgroundColor = UIColor.alertViewGrayColor
        cell.tintColor = UIColor.umBlue
        
        
        cell.textLabel?.text = diningLocations[indexPath.row].name
        if selectedDiningLocationIndex == indexPath.row {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .checkmark
        selectedDiningLocationIndex = indexPath.row
        diningLocationsTableView.reloadData()
        diningLocationsTableView.deselectRow(at: indexPath, animated: true)
        okButton.isEnabled = true
    }
    
    // MARK: - Actions
    @IBAction func okButtonPressed(_ sender: UIButton) {
        // set default dining locatoin name
        provider.defaultDiningLocationName = diningLocations[selectedDiningLocationIndex!].name
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
