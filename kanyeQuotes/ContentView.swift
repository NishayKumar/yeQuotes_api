//
//  ContentView.swift
//  kanyeQuotes
//
//  Created by Nishay Kumar on 24/09/23.
//

import SwiftUI

struct Quotes: Codable {
    var quote: String?
}

struct JP: Codable {
    var image: String?
}

// loading animation
struct AnimationView: View {
    @State private var isAnimate: Bool = false
    var body: some View {
        HStack {
            Capsule()
                .frame(width: 60,height: 30)
                .offset(x: isAnimate ? 50 : -50)
                .animation(.easeInOut(duration: 0.3).repeatForever(), value: isAnimate)
        }
        .onAppear {
            isAnimate = true
        }
    }
}

struct ContentView: View {
    @State private var quotes = Quotes()
    @State private var images = JP()
    
    var body: some View {
        NavigationStack{
            VStack {
                AsyncImage(url: URL(string: images.image ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 440)
                    default:
                        EmptyView() // Placeholder or loading view
                    }
                }
                    .frame(width: 300, height: 440)
                    .border(.red)
                Spacer()
                if let quote = quotes.quote {
                    Text(quote)
                        .font(.title)
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    AnimationView()
                }
                Spacer()
                Spacer()
                
            }
            .navigationTitle("ye's quotes")
            .task {
                await fetchData()
            }
        }
    }
    func fetchData() async {
        //create url
        guard let url = URL(string: "https://api.kanye.rest/") else {
            print("api not working...")
            return
        }
        //fetch data from that url
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            //decode that data
            if let decodedRequest = try? JSONDecoder().decode(Quotes.self, from: data) {
                quotes = decodedRequest
            }
        } catch {
            print("data isn't available...;(")
        }
        
    }
    
    func fetchSecondData() async {
        guard let url = URL(string: "http://api.nekos.fun:8080/api/cry") else {
            print("api not working...")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedRequest = try? JSONDecoder().decode(JP.self, from: data) {
                images = decodedRequest
            }
        } catch {
            print("data isn't available...;(")
        }
    }
}

#Preview {
    ContentView()
}
