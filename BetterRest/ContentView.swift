//
//  ContentView.swift
//  BetterRest
//
//  Created by Saif on 21/10/19.
//  Copyright © 2019 LeftRightMind. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var coffeAmount = 1
    @State private var sleepAmount = 8.0
    @State private var wakeup = defaultWakeTime
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header:Text("When do you want to wake up?").font(.headline)) {
                    DatePicker("Enter time",selection: $wakeup,displayedComponents: .hourAndMinute)
                        .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
                }
                
                Section(header:Text("Desired amount of sleep").font(.headline)) {
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25){
                        Text("\(sleepAmount,specifier: "%g") hours")
                    }
                }
                
                Section(header:Text("Daily Coffe Intake").font(.headline)) {
                    Picker(selection: $coffeAmount, label: Text("Number of Cups")) {
                        ForEach(0 ..< 20) {
                            if $0 == 1 {
                                Text("1 Cup")
                            }
                            else{
                                Text("\($0) Cups")
                            }

                        }
                    }
                }
                Section(header:Text("Your Ideal Bed time is: ").font(.headline)) {
                    Text("\(idealWakeupTime)")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                }
            }
            .navigationBarTitle(Text("BetterRest"))
//            .navigationBarItems(trailing:
//                Button(action: calculateBedtime) {
//                    Text("Calculate")
//            })
//            .alert(isPresented: $showingAlert) {
//                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//            }
        }
        
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var idealWakeupTime:String {
        let model = sleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour,.minute],from: wakeup)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let predictions = try model.prediction(wake: Double(hour+minute), estimatedSleep: sleepAmount, coffee: Double(coffeAmount))
            let sleepTime = wakeup - predictions.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            DispatchQueue.main.async {
                self.alertMessage = formatter.string(from: sleepTime)
            }
        }catch {
            DispatchQueue.main.async {
                self.alertMessage = "Sorry, theself.re's a problem calculating your bed time!"
            }
            
        }
        return alertMessage
    }
    
//    func calculateBedtime() {
//        let model = sleepCalculator()
//
//        let components = Calendar.current.dateComponents([.hour,.minute],from: wakeup)
//        let hour = (components.hour ?? 0) * 60 * 60
//        let minute = (components.minute ?? 0) * 60
//
//        do {
//            let predictions = try model.prediction(wake: Double(hour+minute), estimatedSleep: sleepAmount, coffee: Double(coffeAmount))
//            let sleepTime = wakeup - predictions.actualSleep
//
//            let formatter = DateFormatter()
//            formatter.timeStyle = .short
//
//            alertMessage = formatter.string(from: sleepTime)
//            alertTitle = "Your ideal bed time is - "
//
//        }catch {
//            alertTitle = "Error"
//            alertMessage = "Sorry, there's a problem calculating your bed time!"
//        }
//
//        showingAlert = true
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
