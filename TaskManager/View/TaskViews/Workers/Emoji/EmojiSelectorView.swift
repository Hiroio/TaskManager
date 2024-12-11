//
//  EmojiSelectorView.swift
//  TaskManager
//
//  Created by Vladuslav on 15.09.2024.
//

import SwiftUI

struct EmojiSelectorView: View {  
    @Environment(\.dismiss) var dismiss
    @Binding var selection: String
    
    let columns = [GridItem(.adaptive(minimum: 44), spacing: 10)]
    let emojis: [Emoji]  = Emoji.examples()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Select an Emoji")
                .font(.title3)
                .padding(.horizontal)  
            Divider()
            ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(emojis){ emoji in
                            ZStack{
                                emoji.emojiString == selection ? Color.blue : Color.clear
                                Text(emoji.emojiString)
                                    .font(.title)
                                    .padding(5)
                                    .onTapGesture {
                                        selection = emoji.emojiString
                                        dismiss()
                                    }
                            }
                        }
                    }.padding()
                }
        }
        .padding(.vertical)
    }
}
#Preview {
   ContentView()
}
