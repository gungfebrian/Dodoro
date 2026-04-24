//
//  video.swift
//  Challenge 2
//
//  Created by Gung  on 20/04/26.
//

import SwiftUI
import AVKit

struct Video: View {
    @State private var player: AVPlayer? = nil

    var body: some View {
        Group {
            if let player {
                VideoPlayer(player: player)
                    .frame(height: 300)
            } else {
                Text("Video not found.")
                    .foregroundStyle(.secondary)
                    .frame(height: 300)
            }
        }
        .onAppear {
            if player == nil {
                if let url = Bundle.main.url(forResource: "MyVideo", withExtension: "mp4") {
                    player = AVPlayer(url: url)
                    player?.play()
                }
            } else {
                player?.play()
            }
        }
        .onDisappear {
            player?.pause()
        }
    }
}


#Preview {
    Video()
}
