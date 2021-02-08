//  AppDelegate.swift
//  SoyebSayyadTask
//
//  Created by Mac on 08/02/21.
//  Copyright © 2021 Mac. All rights reserved.
//


import Foundation
class NetworkService {
    static let shared = NetworkService()
    let URL_SAMPLE = "http://api.openweathermap.org/data/2.5/weather?q=Pune&appid=094aa776d64c50d5 b9e9043edd4ffd00"
    let URL_API_KEY = "094aa776d64c50d5b9e9043edd4ffd00"
    var URL_CITY = "Pune"
    var URL_GET_ONE_CALL = ""
    let URL_BASE = "http://api.openweathermap.org/data/2.5/weather?"
    let session = URLSession(configuration: .default)
    func buildURL() -> String {
        URL_GET_ONE_CALL = "q=" + URL_CITY  + "&appid=" + URL_API_KEY
        return URL_BASE + URL_GET_ONE_CALL
    }
    func setCity(_ city: String) {
        URL_CITY = city
    }
   func getWeather(onSuccess: @escaping (Result) -> Void, onError: @escaping (String) -> Void) {
        guard let url = URL(string: buildURL()) else {
            onError("Error building URL")
            return
        }
        let task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    onError(error.localizedDescription)
                    return
                }
                guard let data = data, let response = response as? HTTPURLResponse else {
                    onError("Invalid data or response")
                    return
                }
                do {
                    if response.statusCode == 200 {
                        let items = try JSONDecoder().decode(Result.self, from: data)
                        onSuccess(items)
                    } else {
                        onError("Response wasn't 200. It was: " + "\n\(response.statusCode)")
                        Alert.showAlert(alertTitle: "Alert..", alertMessage: "Please enetr valid city.", actionTitle: "OK")
                    }
                } catch {
                    onError(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
}
