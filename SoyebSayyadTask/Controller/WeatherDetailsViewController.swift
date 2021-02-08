//
//  WeatherDetailsViewController.swift
//  SoyebSayyadTask
//
//  Created by Mac on 08/02/21.
//  Copyright © 2021 Mac. All rights reserved.
//

import UIKit
class WeatherDetailsViewController: UIViewController,UpdateDataDelegate {
    func didUpdateData(data: weatherDetailsFinal) {
        dataArray.append(data)
        dataArray = dataArray.uniques(by: \.city).reversed()
        self.tblWeatherDetails.reloadData()
    }
    @IBOutlet weak var tblWeatherDetails: UITableView!
    @IBOutlet weak var txtCity: UITextField!
    var dataArray = [weatherDetailsFinal] ()
    var apiData = [Current] ()
    private var WeatherVM = WeatherDetailsVM ()
    override func viewDidLoad() {
        super.viewDidLoad()
        setTablviewData()
    }
    
  @IBAction func btnSubmitTap(_ sender: Any) {
        if let strCity = self.txtCity.text {
            if strCity == ""
            {
                Alert.showAlert(alertTitle: "Alert..", alertMessage: "Please enter city.", actionTitle: "OK")
                
            }else{
                NetworkService.shared.setCity(strCity)
                WeatherVM.City = strCity
                WeatherVM.getWeather()
                txtCity.text = ""
            }
        }
    }
    
    func setTablviewData()
    {
        WeatherVM.delegate = self
        dataArray = WeatherVM.retriveData
        dataArray = dataArray.uniques(by: \.city).reversed()
        self.tblWeatherDetails.reloadData()
        DispatchQueue.global(qos: .background).async {
            Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
                self.WeatherVM.deleteRecord()
            }
            RunLoop.current.run()
        }
    }
}
extension Array {
    func uniques<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return reduce([]) { result, element in
            let alreadyExists = (result.contains(where: { $0[keyPath: keyPath] == element[keyPath: keyPath] }))
            return alreadyExists ? result : result + [element]
        }
    }
}

