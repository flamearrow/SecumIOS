//
//  ConversationView.swift
//  Secum
//
//  Created by Chen Cen on 10/20/23.
//

import Foundation
import SwiftUI

struct ConversationView: View {
    @Binding var shouldShowTabBar: Bool
    @ObservedObject var viewModel:ConversationViewModel
    
    @State var messageToSend = ""
    
    @FetchRequest var messages: FetchedResults<MessageData>
    
    init(owner: User, peerId: String,  shouldShowTabBar: Binding<Bool>) {
        self._shouldShowTabBar = shouldShowTabBar
        self.viewModel = ConversationViewModel(ownerId: owner.userId, peerId: peerId)
        self._messages = FetchRequest(fetchRequest: owner.messagesWith(peerId: peerId))
    }
    
    var body: some View {
        switch viewModel.state {
        case .loaded:
            chatView()
                .onAppear {
                    shouldShowTabBar = false
                }
                .onDisappear{
                    shouldShowTabBar = true
                }
        case .error(let reason):
            Text("Error! \(reason)")
                .onAppear {
                    shouldShowTabBar = false
                }
                .onDisappear{
                    shouldShowTabBar = true
                }
        }
    }
    
    @ViewBuilder
    private func chatView() -> some View {
        VStack {
            ScrollView {
                ScrollViewReader { proxy in
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(messages, id: \.time) { message in
                            HStack {
                                if message.isFromOwner() {
                                    Spacer()
                                    messageContent(message)
                                    Image("cathead")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 35, height: 35)
                                } else {
                                    Image("botIcon")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 35, height: 35)
                                    messageContent(message)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding()
                    .onAppear {
                        scrollToBottom(proxy: proxy)
                    }
                    .onChange(of: messages.last?.messageId) { _ in
                        scrollToBottom(proxy: proxy)
                    }
                }
            }
            
            HStack {
                TextField("type something to send", text: $messageToSend)
                Button(LocalizedStringKey("send")) {
                    viewModel.sendMessage(msg: messageToSend)
                    messageToSend = ""
                }
                
            }.padding()
        }.onTapGesture {
            hideKeyboard()
        }
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        if let lastMessage = messages.last {
            withAnimation {
                proxy.scrollTo(lastMessage.time, anchor: .bottom)
            }
        }
    }
    
    @ViewBuilder
    private func messageContent(_ message: MessageData) -> some View {
        if let imageUrlString = message.imageUrl, let imageUrl = URL(string: imageUrlString) {
            AsyncImage(url: imageUrl) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .clipped()
                case .failure:
                    Text("Failed to load image")
                @unknown default:
                    EmptyView()
                }
            }
        } else if let content = message.content {
            if(message.isFromOwner()) {
                Text(content)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            } else {
                Text(content)
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        } else {
            EmptyView()
        }
    }
}



private struct ChatView : View {
    // fake test data, to be replaced with MessageData
    private struct MessageTest {
        var isSender: Bool
        var content: String?
        var imageUrl: String?
        var time: Int64
    }
    
    @State var messageToSend = ""
    var body : some View {
        chatView()
    }
    
    @ViewBuilder
    private func chatView() -> some View {
        let msgs: [MessageTest] = [
            .init(isSender: true, content: "sender to receiver1", imageUrl: nil, time: 12345),
            .init(isSender: false, content: "receiver to sender1", imageUrl: "https://image.shutterstock.com/image-photo/funny-british-shorthair-cat-portrait-260nw-2097266809.jpg", time: 12346),
            .init(isSender: true, content: "sender to receiver2", imageUrl: nil, time: 12347),
            .init(isSender: false, content: "receiver to sender2", imageUrl: nil, time: 12348),
            .init(isSender: true, content: "sender to receiver3", imageUrl: nil, time: 12349),
            .init(isSender: true, content: "sender to receiver1", imageUrl: nil, time: 12345),
            .init(isSender: false, content: "receiver to sender1", imageUrl: "https://image.shutterstock.com/image-photo/funny-british-shorthair-cat-portrait-260nw-2097266809.jpg", time: 12346),
            .init(isSender: true, content: "sender to receiver2", imageUrl: nil, time: 12347),
            .init(isSender: false, content: "receiver to sender2", imageUrl: nil, time: 12348),
            .init(isSender: true, content: "sender to receiver3", imageUrl: nil, time: 12349),
            .init(isSender: true, content: "sender to receiver1", imageUrl: nil, time: 12345),
            .init(isSender: false, content: "receiver to sender1", imageUrl: "https://image.shutterstock.com/image-photo/funny-british-shorthair-cat-portrait-260nw-2097266809.jpg", time: 12346),
            .init(isSender: true, content: "sender to receiver2", imageUrl: nil, time: 12347),
            .init(isSender: false, content: "receiver to sender2", imageUrl: nil, time: 12348),
            .init(isSender: true, content: "sender to receiver3", imageUrl: nil, time: 12349),
            .init(isSender: true, content: "sender to receiver1", imageUrl: nil, time: 12345),
            .init(isSender: false, content: "receiver to sender1", imageUrl: "https://image.shutterstock.com/image-photo/funny-british-shorthair-cat-portrait-260nw-2097266809.jpg", time: 12346),
            .init(isSender: true, content: "sender to receiver2", imageUrl: nil, time: 12347),
            .init(isSender: false, content: "receiver to sender2", imageUrl: nil, time: 12348),
            .init(isSender: true, content: "sender to receiver3", imageUrl: nil, time: 12349),
            .init(isSender: true, content: "sender to receiver1", imageUrl: nil, time: 12345),
            .init(isSender: false, content: "receiver to sender1", imageUrl: "https://image.shutterstock.com/image-photo/funny-british-shorthair-cat-portrait-260nw-2097266809.jpg", time: 12346),
            .init(isSender: true, content: "sender to receiver2", imageUrl: nil, time: 12347),
            .init(isSender: false, content: "receiver to sender2", imageUrl: nil, time: 12348),
            .init(isSender: true, content: "sender to receiver3", imageUrl: nil, time: 12349),
            .init(isSender: true, content: "sender to receiver1", imageUrl: nil, time: 12345),
            .init(isSender: false, content: "receiver to sender1", imageUrl: "https://image.shutterstock.com/image-photo/funny-british-shorthair-cat-portrait-260nw-2097266809.jpg", time: 12346),
            .init(isSender: true, content: "sender to receiver2", imageUrl: nil, time: 12347),
            .init(isSender: false, content: "receiver to sender2", imageUrl: nil, time: 12348),
            .init(isSender: true, content: "sender to receiver3", imageUrl: nil, time: 12349),
        ]
        
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(msgs, id: \.time) { message in
                        HStack {
                            if message.isSender {
                                Spacer()
                                messageContent(message)
                                Image("cathead")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 35, height: 35)
                            } else {
                                Image("botIcon")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 35, height: 35)
                                messageContent(message)
                                Spacer()
                            }
                        }
                    }
                }
                .padding()
            }
            
            HStack {
                TextField("type something to send", text: $messageToSend)
                Button("Send") {}
            }.padding()
        }
    }
    
    @ViewBuilder
    private func messageContent(_ message: MessageTest) -> some View {
        if let imageUrlString = message.imageUrl, let imageUrl = URL(string: imageUrlString) {
            AsyncImage(url: imageUrl) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .clipped()
                case .failure:
                    Text("Failed to load image")
                @unknown default:
                    EmptyView()
                }
            }
        } else if let content = message.content {
            if(message.isSender) {
                Text(content)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            } else {
                Text(content)
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        } else {
            EmptyView()
        }
    }
}

#Preview {
    ChatView()
}
