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
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .modifier(FlagImage())
                        }
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
        if gamesPlayed == 2 {
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
