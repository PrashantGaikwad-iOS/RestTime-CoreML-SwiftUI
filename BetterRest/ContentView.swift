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
                VStack(alignment: .leading, spacing: 0) {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    DatePicker("Enter time",selection: $wakeup,displayedComponents: .hourAndMinute)
                        .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25){
                        Text("\(sleepAmount,specifier: "%g") hours")
                    }
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Daily Coffe Intake")
                    Stepper(value:$coffeAmount,in: 1...20) {
                        if coffeAmount == 1 {
                            Text("1 Cup")
                        }
                        else{
                            Text("\(coffeAmount) Cups")
                        }
                    }
                }
            }
            .navigationBarTitle(Text("BetterRest"))
            .navigationBarItems(trailing:
                Button(action: calculateBedtime) {
                    Text("Calculate")
            })
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    func calculateBedtime() {
        let model = sleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour,.minute],from: wakeup)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let predictions = try model.prediction(wake: Double(hour+minute), estimatedSleep: sleepAmount, coffee: Double(coffeAmount))
            let sleepTime = wakeup - predictions.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            alertMessage = formatter.string(from: sleepTime)
            alertTitle = "Your ideal bed time is - "
            
        }catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there's a problem calculating your bed time!"
        }
        
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
