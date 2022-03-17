//
//  GameView.swift
//  AI-Tic-Tac-Toe
//
//  Created by Jonathan T. Nielsen on 15/03/2022.
//

import SwiftUI


struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()

    fileprivate func extractedFunc() -> Circle {
        return Circle()
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                Spacer()
                LazyVGrid(columns: viewModel.columns, spacing: 5){
                    ForEach(0..<9) { i in
                        ZStack(){
                            extractedFunc()
                                .foregroundColor(.red)
                                .opacity(0.5)
                                .frame(width: geometry.size.width/3 - 15,
                                       height: geometry.size.width/3 - 15)
                            
                            Image(systemName: viewModel.moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.green)
                        }
                        .onTapGesture {
                            viewModel.processPlayerMove(for: i)
                            }
                        }
                    }
                }
            Spacer()
            }
        .disabled(viewModel.isGameboardDisabled)
            .padding()
            .alert(item: $viewModel.alertItem, content: { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle, action: {viewModel.resetGame()}))
        })
    }
}
enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
