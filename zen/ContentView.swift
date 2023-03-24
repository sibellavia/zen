//
//  ContentView.swift
//  zen
//
//  Created by Simone Bellavia on 24/03/23.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var timer: AnyCancellable?
    @State private var timeRemaining = 1500 // 25 minuti in secondi
    @State private var timerRunning = false

    private func startTimer() {
        timerRunning = true
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    timer?.cancel()
                    timerRunning = false
                }
            }
    }

    private func stopTimer() {
        timerRunning = false
        timer?.cancel()
    }

    private func resetTimer() {
        timeRemaining = 1500
    }
    
    var body: some View {
        VStack {
            Text(String(format: "%02d:%02d", timeRemaining / 60, timeRemaining % 60))
                .font(.largeTitle)
                .padding()

            HStack {
                Button(action: {
                    if timerRunning {
                        stopTimer()
                    } else {
                        startTimer()
                    }
                }) {
                    Text(timerRunning ? "Stop" : "Start")
                }
                .padding()

                Button(action: resetTimer) {
                    Text("Reset")
                }
                .padding()
                .disabled(timerRunning)
            }
        }
        .frame(width: 350, height: 240)
        .fixedSize()
        .aspectRatio(contentMode: .fit)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/))
            .preferredColorScheme(.dark)
            .environment(\.sizeCategory, .medium)
    }
}
