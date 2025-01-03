//
//  SlateView.swift
//  Slate
//
//  Created by Soohan Lee on 1/3/25.
//

import SwiftUI
import SwiftData
import AVFoundation

struct SlateView: View {
  @AppStorage("title") var title = ""
  @AppStorage("subtitle") var subtitle = ""
  @State private var date = ""
  private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  private let dateFomatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
    return dateFormatter
  }()
  @State private var backgorundColor = Color.white
  @State private var player: AVAudioPlayer?
  
  var body: some View {
    ScrollView {
      VStack(alignment: .center, spacing: .zero) {
        Button("Action!") {
          playSlateSound()
          Task {
            await flashBackground()
          }
        }
        .font(.system(size: 100, weight: .bold))
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.blue, lineWidth: 10))
        TextField("Title", text: $title)
          .font(.system(size: 60, weight: .bold))
          .multilineTextAlignment(.center)
        TextField("Subtitle", text: $subtitle)
          .font(.system(size: 60, weight: .bold))
          .multilineTextAlignment(.center)
        Text(date)
          .font(.system(size: 60, weight: .bold))
          .onReceive(timer, perform: { _ in
            date = dateFomatter.string(from: Date())
          })
      }
    }
    .background(backgorundColor)
  }
}

extension SlateView {

  private func flashBackground() async {
    backgorundColor = Color.red
    try? await Task.sleep(for: .seconds(0.2))
    backgorundColor = Color.white
  }
  
  func playSlateSound() {
    guard let asset = NSDataAsset(name: "slate_sound") else { return }
    do {
      player = try AVAudioPlayer(data: asset.data)
      player?.prepareToPlay()
      player?.play()
    } catch let error {
      print(error.localizedDescription)
    }
  }
}

#Preview {
  SlateView()
}
