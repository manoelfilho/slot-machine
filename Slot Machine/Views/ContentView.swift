//
//  ContentView.swift
//  Slot Machine
//
//  Created by Manoel Filho on 24/06/21.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    
    let symbols = ["gfx-bell","gfx-cherry","gfx-coin","gfx-grape","gfx-seven","gfx-strawberry"]
    let haptics: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()
    
    @State private var highScore: Int = UserDefaults.standard.integer(forKey: "HighScore")
    @State private var coins: Int = 100
    @State private var betAmount: Int = 10
    @State private var reels: Array = [0,1,2]
    @State private var showingfInfoView: Bool = false
    @State private var isActiveBet10: Bool = true
    @State private var isActiveBet20: Bool = false
    @State private var showingModal: Bool = false
    @State private var animatingSymbol: Bool = false
    @State private var animatingModal: Bool = false
    
    //MARK: - Functions
    
    func spinReels() {
        /*
         reels[0] = Int.random(in: 0...symbols.count - 1)
         reels[1] = Int.random(in: 0...symbols.count - 1)
         reels[2] = Int.random(in: 0...symbols.count - 1)
         */
        
        reels = reels.map({ _ in
            Int.random(in: 0...symbols.count - 1)
        })
        playSound(sound: "spin", type: "mp3")
        self.haptics.notificationOccurred(.success)
    }
    
    func checkWinning(){
        if reels[0] == reels[1] && reels[1] == reels[2] && reels[2] == reels[0] {
            
            self.playerWins()
            
            if coins > highScore {
                newHighScore()
            }else{
                playSound(sound: "win", type: "mp3")
            }
            
        }else{
            
            playerLoses()
            
        }
    }
    
    
    func playerWins(){
        coins += betAmount * 10
    }
    
    func newHighScore(){
        highScore = coins
        UserDefaults.standard.set(highScore, forKey: "HighScore")
        playSound(sound: "high-score", type: "mp3")

    }
    
    func playerLoses(){
        coins -= betAmount
    }
    
    func activateBet20(){
        betAmount = 20
        self.isActiveBet20 = true
        self.isActiveBet10 = false
        playSound(sound: "casino-chips", type: "mp3")
        self.haptics.notificationOccurred(.success)

    }
    
    func activateBet10(){
        betAmount = 10
        self.isActiveBet20 = false
        self.isActiveBet10 = true
        playSound(sound: "casino-chips", type: "mp3")
        self.haptics.notificationOccurred(.success)

    }
    
    func isGameOver(){
        if self.coins <= 0 {
            self.showingModal = true
            playSound(sound: "game-over", type: "mp3")
        }
    }
    
    func resetGame(){
        UserDefaults.standard.set(0, forKey: "HighScore")
        self.highScore = 0
        self.coins = 100
        self.activateBet10()
        playSound(sound: "chimeup", type: "mp3")
    }

    
    // MARK: - Body
    var body: some View {
        
        ZStack {
            
            // MARK: - Background
            LinearGradient(
                gradient: Gradient(colors: [Color("ColorPink"), Color("ColorPurple")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            // MARK: - Interface
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 5) {
                
                // MARK: - Header
                Logo()
                
                Spacer()
                
                // MARK: - Score
                HStack {
                    
                    HStack{
                        Text("Suas\nMoedas".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.trailing)
                        
                        Text("\(coins)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                    }
                    .modifier(ScoreContainerModifier())
                    
                    Spacer()
                    
                    HStack{
                        Text("\(highScore)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                        
                        Text("Pontuaçao\nMáxima".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.leading)
                        
                    }
                    .modifier(ScoreContainerModifier())
                    
                    
                }
                
                // MARK: - Slot Machine
                VStack(alignment: .center, spacing: 0){
                    
                    // MARK: REEL 1
                    ZStack{
                        ReelView()
                        Image(symbols[reels[0]])
                            .resizable()
                            .modifier(ImageModifier())
                            .opacity(self.animatingSymbol ? 1 : 0)
                            .offset(y: self.animatingSymbol ? 0 : -50)
                            .animation(.easeOut(duration: Double.random(in: 0.5...0.7)))
                            .onAppear(
                                perform: {
                                    self.animatingSymbol.toggle()
                                    playSound(sound: "riseup", type: "mp3")
                                }
                            )
                    }
                    
                    HStack(alignment: .center, spacing: 0){
                        
                        // MARK: REEL 2
                        ZStack{
                            ReelView()
                            Image(symbols[reels[1]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(self.animatingSymbol ? 1 : 0)
                                .offset(y: self.animatingSymbol ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.7...0.9)))
                                .onAppear(
                                    perform: {
                                        self.animatingSymbol.toggle()
                                    }
                                )
                        }
                        
                        // MARK: REEL 3
                        ZStack{
                            ReelView()
                            Image(symbols[reels[2]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(self.animatingSymbol ? 1 : 0)
                                .offset(y: self.animatingSymbol ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.9...1.1)))
                                .onAppear(
                                    perform: {
                                        self.animatingSymbol.toggle()
                                    }
                                )
                        }
                    
                    }
                    .frame(maxWidth: 500)
                    
                    //MARK: Spin Button
                    Button(action: {
                        withAnimation{
                            self.animatingSymbol = false
                        }
                        self.spinReels()
                        withAnimation{
                            self.animatingSymbol = true
                        }
                        self.checkWinning()
                        self.isGameOver()
                    }){
                        Image("gfx-spin")
                            .renderingMode(.original)
                            .resizable()
                            .modifier(ImageModifier())
                            
                    }
                    
                }
                .layoutPriority(2)
                
                Spacer()
                // MARK: - Footer
                
                HStack{
                    
                    //MARK: BET 20
                    HStack(alignment: .center, spacing: 10) {
                        
                        //MARK: Button
                        Button(action: {
                            self.activateBet20()
                        }){
                            Text("20")
                                .fontWeight(.heavy)
                                .foregroundColor(self.isActiveBet20 ? Color("ColorYellow") : Color.white)
                                .modifier(BetNumberModifier())
                        }
                        .modifier(BetCapsuleModifier())
                        
                        //MARK: Image
                        Image("gfx-casino-chips")
                            .resizable()
                            .offset(x: self.isActiveBet20 ? 0 : 20)
                            .opacity(self.isActiveBet20 ? 1 : 0)
                            .modifier(CassinoChipsModifier())
                        
                    }
                    
                    Spacer()
                    
                    //MARK: BET 10
                    HStack(alignment: .center, spacing: 10) {
                        
                        //MARK: Image
                        Image("gfx-casino-chips")
                            .resizable()
                            .offset(x: self.isActiveBet20 ? 0 : -20)
                            .opacity( self.isActiveBet10 ? 1 : 0 )
                            .modifier(CassinoChipsModifier())
                        
                        //MARK: Button
                        Button(action: {
                            self.activateBet10()
                        }){
                            Text("10")
                                .fontWeight(.heavy)
                                .foregroundColor(self.isActiveBet10 ? Color("ColorYellow") : Color.white)
                                .modifier(BetNumberModifier())
                        }
                        .modifier(BetCapsuleModifier())
                        
                    }
                    
                }
                
                Spacer()
                
            }
            .overlay(
                // RESET
                Button(action: {
                    self.resetGame()
                }){
                    Image(systemName: "arrow.2.circlepath.circle")
                }
                .modifier(ButtonModifier()),
                alignment: .topLeading
            )
            .overlay(
                // INFO
                Button(action: {
                    self.showingfInfoView = true
                }){
                    Image(systemName: "info.circle")
                }
                .modifier(ButtonModifier()),
                alignment: .topTrailing
            )
            .padding()
            .frame(maxWidth: 720)
            .blur(radius: $showingModal.wrappedValue ? 5 : 0, opaque: false)
            
            //MARK: - PopUp
            if $showingModal.wrappedValue {
                ZStack{
                    Color("ColorTransparentBlack").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    //modal
                    VStack(spacing: 0){
                        
                        Text("GAME OVER")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.heavy)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color("ColorPink"))
                            .foregroundColor(Color.white)
                        
                        Spacer()
                        
                        VStack(alignment: .center, spacing: 16){
                           
                            Image("gfx-seven-reel")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 72)
                            
                            Text("Má sorte! Você perdeu tudo. \nVamos jogar novamante")
                                .font(.system(.body, design: .rounded))
                                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.gray)
                                .layoutPriority(1)
                            
                            Button(action: {
                                self.showingModal = false
                                self.showingModal = false
                                self.activateBet10()
                                self.coins = 100
                            }){
                                Text("Novo jogo".uppercased())
                                    .font(.system(.body, design: .rounded))
                                    .fontWeight(.semibold)
                                    .accentColor(Color("ColorPink"))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minWidth: 128)
                                    .background(
                                        Capsule()
                                            .strokeBorder(lineWidth: 1.75)
                                            .foregroundColor(Color("ColorPink"))
                                    )
                            }
                            
                        }
                        
                        Spacer()
                    }
                    .frame(minWidth: 280, idealWidth: 280, maxWidth: 320, minHeight: 260, idealHeight: 280, maxHeight: 320, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color("ColorTransparentBlack"), radius: 6, x: 0, y: 8)
                    .opacity($animatingModal.wrappedValue ? 1 : 0)
                    .offset(y: $animatingModal.wrappedValue ? 0 : -100)
                    .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0))
                    .onAppear(
                        perform: {
                            self.animatingModal = true
                        }
                    )
                }
            }
            
        }// ZSTACK
        
        // MARK: - infoview
        .sheet(isPresented: $showingfInfoView){
            InfoView()
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
