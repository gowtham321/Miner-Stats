//
//  DataModel.swift
//  Dashboard
//
//  Created by Gowtham S on 20/07/21.
//

import Foundation

protocol DataModelDelegate {
    func doUpdateView(_ dataModel: DataModel, finalData: ApiData)
}

struct DataModel {
    let url = "https://api-ravencoin.flypool.org/miner/RM2MR746UHwgJWuPo3vjMiwgJkR9DFaZUD/dashboard"
    
    var delegate: DataModelDelegate?
    
    func connectToUrl() {
        let url = URL(string: url)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url!) { data, response, error in
            if error != nil {
                print(error!)
            }
            if let safeData = data {
                do {
                    let decoder = JSONDecoder()
                    let finalData = try decoder.decode(ApiData.self, from: safeData)
                    self.delegate?.doUpdateView(self, finalData: finalData)
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
}
