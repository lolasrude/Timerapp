//
//  ContentView.swift
//  TimerApp
//
//  Created by Antea La Cava on 20/11/23.
//

import SwiftUI
import Combine


struct ContentView: View {
    @State private var hours = 0
    @State private var minutes = 0
    @State private var seconds = 0
    @State private var timer: Timer?
    @State private var timerRunning = false
    @State private var timeRemaining = 0
    @State private var timerName = ""
    @State private var cancellable: AnyCancellable?
    
    var body: some View {
        VStack {
            
            Text("Timer: \(formattedTime(timeRemaining))")
                .font(.headline)
                .padding()
            
            HStack {
                Picker("Hours", selection: $hours) {
                    ForEach(0..<24) { hour in
                        Text("\(hour) hours")
                    }
                }
                .pickerStyle(WheelPickerStyle())
                //.labelsHidden()
                
                
                
                Picker("Minutes", selection: $minutes) {
                    ForEach(0..<60) { minute in
                        Text("\(minute) min")
                    }
                }
                .pickerStyle(WheelPickerStyle())
                //.labelsHidden()
                
                
                Picker("Seconds", selection: $seconds) {
                    ForEach(0..<60) { second in
                        Text("\(second) sec")
                    }
                }
                .pickerStyle(WheelPickerStyle())
                //.labelsHidden()
            }
            
            HStack {
                Text("Label")
                    .padding()
                    .foregroundColor(.gray)
                Spacer()
                TextField("", text: $timerName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                        Text("Timer")
                            .foregroundColor(.gray)
                            .padding(.leading, 160)
                            .opacity(timerName.isEmpty ? 1 : 0)
                    )
            }
            
            HStack {
                Button("Cancel") {
                    resetTimer()
                }
                .padding()
                
                
                Spacer()
                
                Button(action: {
                    startTimer()
                }) {
                    Text("Start")
                        .font(.headline)
                        .padding()
                }
                .disabled(timerRunning)
            }
        }
        .padding()
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            if self.timerRunning && self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else if self.timeRemaining == 0 {
                resetTimer()
            }
        }
    }
    
    private func startTimer() {
        let totalSeconds = hours * 3600 + minutes * 60 + seconds
        
        guard totalSeconds > 0 else {
            return // Non avviare il timer se il tempo è zero
        }
        
        timerRunning = true
        timeRemaining = totalSeconds
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.timeRemaining > 0 {
                // Aggiorna l'UI sulla coda principale
                DispatchQueue.main.async {
                    self.timeRemaining -= 1
                }
            } else {
                resetTimer()
            }
        }
    }
    
    private func resetTimer() {
           timerRunning = false
           timer?.invalidate()
           timer = nil
           timeRemaining = 0
       }
    
    private func formattedTime(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = seconds % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, remainingSeconds)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
