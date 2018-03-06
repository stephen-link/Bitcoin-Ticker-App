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
    
    //Constants
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let symbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    
    //Variables
    var bitcoinJSON = JSON()
    var finalURL = ""
    var symbolString = ""
    var averageSelection = "day"
    
    //Outlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var averagePicker: UISegmentedControl!
    
    //Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }

    //Update averageSelection String to reflect what option the user has toggled
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
        //Update label accordingly
        updateBitcoinPrice(json: bitcoinJSON)
    }
    
    
    

    //PickerView functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    //If a currency has been selected, update the API URL and get the data
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        symbolString = symbolArray[row]
        getBitcoinPrice(url: finalURL)
    }
    

    
    
    
//    
//    //MARK: - Networking
//    /***************************************************************/
    
    //Make the API call, if success send the data to be parsed and displayed, if error update label accordingly
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
    
    
    //Parse and display the bitcoin data
    func updateBitcoinPrice(json : JSON) {
        
        if let tempResult = json["averages"][averageSelection].double {
            
            self.bitcoinPriceLabel.text = "\(symbolString)\(tempResult)"
        
        } else {
            
            self.bitcoinPriceLabel.text = "Price Unavailable"
            
        }
        
        
    }
    




}

