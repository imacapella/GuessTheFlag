//
//  ContentView.swift
//  Guess The Flag
//
//  Created by Gürkan Karadaş on 6.02.2023.
//

import SwiftUI

struct ContentView: View {
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
    @State var correctAnswer = Int.random(in: 0...2)
    @State var gameDone = false
    @State var userScore = 0
    @State var timeRemaining = 30
    @State var timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    @State var timeRun = false
    @State var gameStart = false
    @State var showingAlert = false
    @State var gameRunning = false
    @State var answerCorrection = true
    @State var resetTap = false
    @State var lastGameScore = 0
    var body: some View {
        ZStack{
            LinearGradient(colors: [.mint,.cyan,.blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack (spacing: 30){
                HStack {
                    Text("\(timeRemaining)")
                        .onReceive(timer) { _ in
                            if gameDone == false && timeRemaining > 0 && timeRun == true{
                                timeRemaining -= 1
                            }
                        }
                        .font(.largeTitle.weight(.bold))
                        .foregroundColor(.white)
                }
                VStack {
                    Text("Tap The Flag")
                        .font(.custom("Pacifico-Regular", size: 35))
                        .foregroundColor(.white)
                        .font(.title2.weight(.semibold))
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle.weight(.bold))
                }
                
                //BAYRAK BUTONLARI
                ForEach(0..<3) { number in
                    Button{
                        flagTapped(number)
                        timeRun = true
                    } label: {
                        Image(countries[number])
                            .renderingMode(.original)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .shadow(radius: 5)
                    }
                    
                }
                if answerCorrection == false && gameDone == true{
                    VStack {
                        Text("Your Answer was Wrong :(")
                            .foregroundColor(.white)
                        .fontWeight(.bold)
                        Text("Game Over!")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                }
                else if answerCorrection == true && gameDone == false && gameStart == true && resetTap == false{
                    Text("True, Continue!")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
                
                // RESET BUTTON
                HStack {
                    Button(){
                        resetGame()
                    } label: {
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    .foregroundColor(.white)
                    .padding(.trailing, 40)
                    Button(){showingAlert = true
                        gameStart = false
                    }
                        label: {
                        Image(systemName: "flag.checkered.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                        .foregroundColor(.white)
                        .alert("Your Score is \(lastGameScore)", isPresented: $showingAlert){}message: {
                            if lastGameScore <= 0 {
                                Text("WTF?")
                            }
                            else if lastGameScore > 0 && lastGameScore <= 30{
                                Text("Try Harder!")
                            }
                            else if lastGameScore > 30 && lastGameScore <= 60{
                                Text("Well, That's Okay")
                            }
                            else if lastGameScore > 60 && lastGameScore <= 100{
                                Text("That's Fantastic")
                            }
                            else if lastGameScore > 100{
                                Text("You're Damn Good!")
                            }
                        }
                }
                // RESET BUTTON
                
               
            }
        }
    }
    // BAYRAK BUTONLARININ FONKSİYONU
    func flagTapped (_ number: Int){
        if number == correctAnswer{
            rightChoice()
        }
        else {
            wrongChoice()
        }
    }
    // YANLIŞ SEÇİM OLDUĞU ZAMAN ÇALIŞACAK FONKSYİON
    func wrongChoice (){
        lastGameScore = userScore
        gameStart = true
        gameDone = true
        timeRun = false
        answerCorrection = false
        userScore = 0
        timeRemaining = 30
        resetTap = false
    }
    // DOĞRU SEÇİM OLDUĞU ZAMAN ÇALIŞACAK FONKSİYON
    func rightChoice(){
        gameStart = true
        timeRemaining += 1
        correctAnswer = Int.random(in: 0...2)
        userScore += 10
        countries.shuffle()
        resetTap = false
    }
    
    func resetGame(){
        gameDone = false
        timeRun = false
        lastGameScore = userScore
        userScore = 0
        timeRemaining = 30
        correctAnswer = Int.random(in: 0...2)
        countries.shuffle()
        resetTap = true
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}
