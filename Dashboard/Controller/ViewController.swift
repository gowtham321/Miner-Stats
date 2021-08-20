//
//  ViewController.swift
//  Dashboard
//
//  Created by Gowtham S on 20/07/21.
//

import UIKit


class ViewController: UIViewController, DataModelDelegate {
   
    

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var validSharesLabel: UILabel!
    @IBOutlet weak var currenHashrateLabel: UILabel!
    @IBOutlet weak var averageHashrateLabel: UILabel!
    @IBOutlet weak var immatureBalanceLabel: UILabel!
    @IBOutlet weak var unpaidBalanceLabel: UILabel!
    @IBOutlet weak var payoutThreshold: UIProgressView!
    @IBOutlet weak var payoutInfoLabel: UILabel!
    @IBOutlet weak var workerNameLabel: UILabel!
    
    var dataModel = DataModel(delegate: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataModel.delegate = self
        dataModel.connectToUrl()
        
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.timerfunction), userInfo: nil, repeats: true)
        
        
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        dataModel.connectToUrl()
        self.showToast(message: "Data Refreshed", font: .systemFont(ofSize: 12.0))

    }
    @objc func timerfunction() {
        dataModel.connectToUrl()

    }
    
    
    
    func doUpdateView(_ dataModel: DataModel, finalData: ApiData) {
        DispatchQueue.main.async {
            self.statusLabel.text = finalData.status
            self.currenHashrateLabel.text = String(format: "%.3f Mhs", (finalData.data.currentStatistics.currentHashrate / 1000000))
            self.immatureBalanceLabel.text = self.formatValues(value: Double(finalData.data.currentStatistics.unconfirmed))
            self.unpaidBalanceLabel.text = self.formatValues(value: Double(finalData.data.currentStatistics.unpaid))
            self.averageHashrateLabel.text = self.calculateAverage(values: finalData.data.statistics)
            self.payoutThreshold.progress = self.updateProgress(Value: finalData.data.currentStatistics.unpaid)
            self.validSharesLabel.text = String(finalData.data.currentStatistics.validShares)
            self.workerNameLabel.text = finalData.data.workers[0].worker
            }
            
        }
    
    func formatValues(value: Double) -> String {
        let valueString = String(value)
        let newString = valueString.prefix(5)
        let newValue = Double(newString)! / 10000
        return String(format: "%.4f Rvn", newValue)
        }
    
    func calculateAverage(values: [Statistics]) -> String {
        var sum = 0.0
        for value in values {
            sum += value.currentHashrate
        }
        let finalString = String(format: "%.3f Mhs", (sum / Double(values.count)) / 1000000.0)
        return finalString
    }
    
func updateProgress(Value: Int) -> Float {
    
    let strinValue = String(Value)
    let floatValue = Float(strinValue.prefix(3))
    
    if floatValue! / 1000 < 1 && floatValue! / 1000 > 0.15 {
        payoutInfoLabel.text = "Still haven't reached the payout threshold!"
        return (floatValue! / 1000)
    }  else if (floatValue! / 1000) >= 1 {
        payoutInfoLabel.text = "Payment threshold reached!"
        return 1.0
    } else {
        payoutInfoLabel.text = "Payment has just been made!"
        return (floatValue! / 1000)
    }
}
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-60, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

}
