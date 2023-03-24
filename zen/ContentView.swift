//
//  ContentView.swift
//  zen
//
//  Created by Simone Bellavia on 24/03/23.
//

import SwiftUI
import Combine

struct ContentView: View {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let fontSize: CGFloat = 50
    
    @State private var timer: AnyCancellable?
    @State private var timeRemaining = 1500
    @State private var timerRunning = false

    private func startTimer() {
        timerRunning = true
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1

                    // Aggiorna l'icona dell'applicazione nella top bar
                    if let appDelegate = NSApp.delegate as? AppDelegate,
                                       let button = appDelegate.statusItem?.button {

                                        let progress = timerProgress()
                                        let iconImage = NSImage(named: "zenIcon")?.withProgress(progress)
                                        button.image = iconImage
                                    }

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
    
    private func timerProgress() -> CGFloat {
        return CGFloat(1 - Double(timeRemaining) / 1500.0)
    }
    
    var body: some View {
        let playIcon = Image(systemName: "play.circle.fill")
        let stopIcon = Image(systemName: "stop.circle.fill")
        let resetIcon = Image(systemName:  "arrow.counterclockwise.circle.fill")
        
        VStack {
            Text(String(format: "%02d:%02d", timeRemaining / 60, timeRemaining % 60))
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
        .frame(width: 350, height: 240)
        .fixedSize()
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .onAppear {
                    if let button = NSApp.mainMenu?.item(withTag: 1)?.submenu?.item(withTag: 1)?.view as? NSStatusBarButton {
                        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
                        statusItem.button?.image = nil
                        statusItem.button?.title = String(format: "%02d:%02d", timeRemaining / 60, timeRemaining % 60)
                        statusItem.button?.toolTip = "Timer"
                        statusItem.button?.addSubview(button)
                    }
                }

    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            .environment(\.sizeCategory, .medium)
    }
}
