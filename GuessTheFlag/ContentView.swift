//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Kuba on 07/09/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var score = 0
    @State private var finalScore = ""
    @State private var gamesPlayed = 0
    
    @State private var endGame = false
    
    @State private var animationAmount = 0.0
    @State private var tappedFlag = 5
    @State private var blurDegree = 0.0
    @State private var flagSize = 1.0
    // Custom modifier
    struct FlagImage: ViewModifier {
        func body(content: Content) -> some View {
            content
                .clipShape(.capsule)
                .shadow(radius: 5)
        }
    }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag off")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            tappedFlag = number
                            flagTapped(number)
                            blurDegree = 3.0
                            flagSize -= 0.2
                            animationAmount += 360
                        } label: {
                            Image(countries[number])
                                .modifier(FlagImage())
                        }
                        .rotation3DEffect(.degrees(tappedFlag == number ? animationAmount : 0.0), axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/)
                        .animation(.spring(duration: 1, bounce: 0.6), value: animationAmount)
                        .blur(radius: (tappedFlag != number ? blurDegree : 0.0))
                        .scaleEffect(tappedFlag != number ? flagSize : 1.0)
                        .animation(.spring(duration: 1, bounce: 0.8), value: blurDegree)
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        
        .alert(finalScore, isPresented: $endGame) {
            Button("New Game?", action: restartGame)
            Button("Or not?", action: closeApp)
        } message: {
            Text("Your final score is \(score)")
        }
    }
    
    func flagTapped (_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong, that's a flag of \(countries[number])"
        }
        
        showingScore = true
        gamesPlayed += 1
    }
    
    func askQuestion () {
        blurDegree = 0.0
        flagSize = 1.0
        if gamesPlayed == 8 {
            endGame = true
        }
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func restartGame () {
        gamesPlayed = 0
        score = 0
    }
    
    func closeApp () {
        exit(0)
    }
}

#Preview {
    ContentView()
}
