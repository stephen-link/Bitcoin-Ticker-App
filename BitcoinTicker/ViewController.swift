//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let symbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    
    var bitcoinJSON = JSON()
    var finalURL = ""
    var symbolString = ""
    var averageSelection = "day"
    

    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var averagePicker: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }

    @IBAction func averagePickerPressed(_ sender: UISegmentedControl) {
        switch averagePicker.selectedSegmentIndex {
        case 0:
            averageSelection = "day"
            break
        case 1:
            averageSelection = "week"
            break
        case 2:
            averageSelection = "month"
            break
        default: break
        
            
        }
        updateBitcoinPrice(json: bitcoinJSON)
    }
    
    
    

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        symbolString = symbolArray[row]
        getBitcoinPrice(url: finalURL)
    }
    

    
    
    
//    
//    //MARK: - Networking
//    /***************************************************************/
    
    func getBitcoinPrice(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the bitcoin data")
                    self.bitcoinJSON = JSON(response.result.value!)

                    self.updateBitcoinPrice(json: self.bitcoinJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }

    
    
    
    
//    //MARK: - JSON Parsing
//    /***************************************************************/
    
    func updateBitcoinPrice(json : JSON) {
        
        if let tempResult = json["averages"][averageSelection].double {
            
            self.bitcoinPriceLabel.text = "\(symbolString)\(tempResult)"
        
        } else {
            self.bitcoinPriceLabel.text = "Price Unavailable"
        }
        
        
    }
    




}

