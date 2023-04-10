import SwiftUI
import Combine
import Foundation
import UserNotifications

extension ContentView {
 
    func setUserDefinedDuration(duration: Int) {
        appDelegate.timeRemaining = duration
        customDuration = duration
    }
    
    func startTimer() {
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
    
    func stopTimer() {
        timerRunning = false
        timer?.cancel()
    }
    
    func resetTimer() {
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
            appDelegate.timeRemaining = customDuration
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
    
    // Funzione per formattare il tempo rimanente in una stringa
    private func formattedTime(timeRemaining: Int) -> String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}
