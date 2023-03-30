//
//  ContentView.swift
//  zen
//
//  Created by Simone Bellavia on 24/03/23.
//

import SwiftUI
import Combine
import Foundation
import UserNotifications

enum TimerType {
    case work
    case work_break
}

struct ContentView: View {
    
    let fontSize: CGFloat = 50
    
    @ObservedObject var appDelegate: AppDelegate
    @State private var timer: AnyCancellable?
    @State var timeRemaining = 1500
    @State private var timerRunning = false
    @State private var currentTimerType: TimerType = .work
    
    // Aggiungi una variabile di stato per il timer rimanente
    @State private var toolbarTimeRemaining = 1500
    
    private func startTimer() {
        timerRunning = true
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if appDelegate.timeRemaining > 0 {
                    appDelegate.timeRemaining -= 1
                } else {
                    nextTimer()
                }
            }
    }
    
    private func stopTimer() {
        timerRunning = false
        timer?.cancel()
    }
    
    private func resetTimer() {
        appDelegate.timeRemaining = 1500
    }
    
    func playSound(soundName: String) {
        if let sound = NSSound(named: NSSound.Name(soundName)) {
            sound.play()
        } else {
            print("Errore nella riproduzione del suono: \(soundName) non trovato.")
        }
    }
    
    private func nextTimer() {
        switch currentTimerType {
        case .work:
            appDelegate.timeRemaining = 300 // 5 minutes break
            currentTimerType = .work_break
            playSound(soundName: "Glass")
            showNotification(title: "The break begins", body: "Time to take a five-minute break.")
        case .work_break:
            appDelegate.timeRemaining = 60 // 25 minutes work
            currentTimerType = .work
            playSound(soundName: "Blow")
            showNotification(title: "Another pomodoro starts", body: "Time to work for 25 minutes.")
        }
    }
    
    private func timerProgress() -> CGFloat {
        return CGFloat(1 - Double(timeRemaining) / 1500.0)
    }
    
    func showNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Errore durante l'invio della notifica: \(error)")
            }
        }
    }
    
    var body: some View {
        let playIcon = Image(systemName: "play.circle.fill")
        let stopIcon = Image(systemName: "stop.circle.fill")
        let resetIcon = Image(systemName:  "arrow.counterclockwise.circle.fill")
        
        VStack {
            Text(String(format: "%02d:%02d", appDelegate.timeRemaining / 60, appDelegate.timeRemaining % 60))
                .font(.system(size: 60))
                .padding()
            
            HStack {
                Button(action: {
                    if timerRunning {
                        stopTimer()
                    } else {
                        startTimer()
                    }
                }) {
                    if timerRunning {
                        stopIcon
                            .font(.system(size: 20))
                    } else {
                        playIcon
                            .font(.system(size: 20))
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding()
                
                Button(action: resetTimer) {
                    resetIcon
                        .font(.system(size: 20))
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding()
                .opacity(timerRunning ? 0.5 : 1.0) // Imposta l'opacità del pulsante di reset
                .disabled(timerRunning)
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .foregroundColor(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onAppear {
            if let button = NSApp.mainMenu?.item(withTag: 1)?.submenu?.item(withTag: 1)?.view as? NSStatusBarButton {
                let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
                statusItem.button?.image = nil
                statusItem.button?.title = String(format: "%02d:%02d", timeRemaining / 60, timeRemaining % 60)
                statusItem.button?.toolTip = "Timer"
                statusItem.button?.addSubview(button)
            }
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                if let error = error {
                    print("Errore durante la richiesta di autorizzazione per le notifiche: \(error)")
                } else if !granted {
                    print("Le notifiche non sono state autorizzate.")
                }
            }
        }
        
    }
    
    func makeNSView() -> NSView {
        return NSHostingView(rootView: self)
    }
    
    // Funzione per formattare il tempo rimanente in una stringa
    private func formattedTime(timeRemaining: Int) -> String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}

// struct ContentView_Previews: PreviewProvider {
//     static var previews: some View {
//         ContentView()
//             .preferredColorScheme(.dark)
//             .environment(\.sizeCategory, .medium)
//     }
// }
