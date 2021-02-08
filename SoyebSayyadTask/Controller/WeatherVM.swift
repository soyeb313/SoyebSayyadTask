//
//  WeatherVM.swift
//  SoyebSayyadTask
//
//  Created by Mac on 08/02/21.
//  Copyright © 2021 Mac. All rights reserved.
//

import Foundation
import UIKit
import CoreData
protocol UpdateDataDelegate: class {
    func didUpdateData(data : weatherDetailsFinal)
}
class WeatherDetailsVM {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var weatherResult: Result?
    var City: String?
    weak var delegate: UpdateDataDelegate?
    var retriveData = [weatherDetailsFinal] ()
    init() {
        self.retrieveData()
    }
}
extension WeatherDetailsVM {
    func getWeather() {
        retriveData = [weatherDetailsFinal] ()
        self.retrieveData()
        if retriveData.count == 0 {
            NetworkService.shared.getWeather(onSuccess: { (result) in
                self.weatherResult = result
                self.coreDataSave(Main: result.main)
                self.delegate?.didUpdateData(data: (weatherDetailsFinal(temp:self.weatherResult?.main.temp ?? 0.00, city: self.City ?? "", mintemp: self.weatherResult?.main.temp_min ?? 0.00, max: self.weatherResult?.main.temp_max ?? 0.00, date: Date.getTodaysDate() , Humidity : self.weatherResult?.main.humidity ?? 0 )))
            }) { (errorMessage) in
                debugPrint(errorMessage)
            }
        }else{
            self.delegate?.didUpdateData(data: self.retriveData[0])
        }
    }
    func coreDataSave(Main : Current)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        //Now let’s create an entity and new user records.
        let userEntity = NSEntityDescription.entity(forEntityName: "Details", in: managedContext)!
        let Details = NSManagedObject(entity: userEntity, insertInto: managedContext)
        Details.setValue(Main.temp, forKeyPath: "temp")
        Details.setValue(self.City, forKey: "city")
        Details.setValue(Main.temp_min, forKey: "mintemp")
        Details.setValue(Main.temp_max, forKeyPath: "max")
        Details.setValue(Date.getTodaysDate(), forKey: "date")
        Details.setValue(Main.humidity, forKey: "Humidity")
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func retrieveData() {
                //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Details")
        if let city = self.City{
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "city contains[c] %@", city )
        }
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                // print(data.value(forKey: "temp") as! String)
                retriveData.append( weatherDetailsFinal(temp: data.value(forKey: "temp") as! Double , city: data.value(forKey: "city") as? String ?? "", mintemp: data.value(forKey: "mintemp") as! Double , max: data.value(forKey: "max") as! Double , date: data.value(forKey: "date") as? String ?? "", Humidity: Int(data.value(forKey: "humidity") as! Double )))
            }
            
        } catch {
            
            print("Failed")
        }
    }
    func deleteRecord()
    {
    //We need to create a context from this container
        let managedContext = appDelegate?.persistentContainer.viewContext
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Details")
        do {
            let result = try managedContext?.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                // print(data.value(forKey: "temp") as! String)
                let fmt = DateFormatter()
                 fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
                guard let date1 = fmt.date(from: data.value(forKey: "date") as! String) else { return }
                guard let date2 = fmt.date(from: Date.getTodaysDate()) else { return  }
                let diffs = Calendar.current.dateComponents([.minute], from: date1, to: date2)
                if diffs.minute ?? 0 >= 10
                {
                    managedContext?.delete(data)
                   print(diffs)
                }
            }
             do {
                try managedContext?.save()
                }
                catch {
              print("Failed")
                }
        } catch {
            print("Failed")
        }
    }
}
extension WeatherDetailsViewController : UITableViewDelegate, UITableViewDataSource{
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tblWeatherDetails.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        cell.lblCity.text = dataArray[indexPath.row].city
        cell.lblDateandTime.text = dataArray[indexPath.row].date
        cell.lblTemp.text = "\(dataArray[indexPath.row].temp)"
        cell.lblTempMin.text = "\(dataArray[indexPath.row].mintemp)"
        cell.lblTempMax.text = "\(dataArray[indexPath.row].max)"
        cell.lblHumidity.text = "\(dataArray[indexPath.row].Humidity)"
        return cell
    }
}
