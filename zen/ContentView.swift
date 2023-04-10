import SwiftUI
import Combine
import Foundation
import UserNotifications

struct ContentView: View {
    
    let fontSize: CGFloat = 50
    
    @ObservedObject var appDelegate: AppDelegate
    @State var timer: AnyCancellable?
    @State var timeRemaining = 1500
    @State var timerRunning = false
    @State var currentTimerType: TimerType = .work
    @State var customDuration = 1500
    
    // Aggiungi una variabile di stato per il timer rimanente
    @State var toolbarTimeRemaining = 1500
    
    
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
    
}
