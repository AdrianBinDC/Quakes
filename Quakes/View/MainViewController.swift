//
//  MainViewController.swift
//  Quakes
//
//  Created by Adrian Bolinger on 10/25/19.
//  Copyright © 2019 Adrian Bolinger. All rights reserved.
//

import UIKit

//class QuakesDataSource: UITableViewDiffableDataSource<AlertLevel, Earthquake> {
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "hello world"
//    }
//}

class MainViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    let reuseID = "cell"
    private lazy var dataSource: UITableViewDiffableDataSource<AlertLevel, Earthquake> = {
       return makeDataSource()
    }()
    
    lazy var apiManager: USGSAPIManager = {
        return USGSAPIManager()
    }()
    
    var results: [Earthquake] = [] {
        didSet {
            DispatchQueue.global(qos: .userInitiated).async {
                var snapshot = NSDiffableDataSourceSnapshot<AlertLevel, Earthquake>()
                snapshot.appendSections(AlertLevel.allCases)
                snapshot.appendItems(self.results)
                self.dataSource.apply(snapshot, animatingDifferences: true)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        let queryParams = USGSQueryParams(minMag: 5,
                                          maxMag: nil,
                                          alertLevel: nil,
                                          minLat: nil,
                                          maxLat: nil,
                                          minLong: nil,
                                          maxLong: nil,
                                          startTime: Date.date(year: 2018, month: 10, day: 10),
                                          endTime: nil)
        apiManager.getData(queryType: .queryParams(params: queryParams)) { earthquakes, error in
            if let error = error {
                print(error.self)
            }
            
            if let earthquakes = earthquakes {
                self.results = earthquakes
            }
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.snapshot().numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource.snapshot().sectionIdentifiers[section].rawValue.capitalized
    }
}

extension MainViewController: UITableViewDelegate {
    
}

extension MainViewController {
    func makeDataSource() -> UITableViewDiffableDataSource<AlertLevel, Earthquake> {
        return UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, earthquake in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseID, for: indexPath)
            cell.textLabel?.text = earthquake.properties.title
            cell.detailTextLabel?.text = earthquake.properties.detail
            
            return cell
        }
    }
}
