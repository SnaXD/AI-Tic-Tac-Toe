//
//  GameViewModel.swift
//  AI-Tic-Tac-Toe
//
//  Created by Jonathan T. Nielsen on 15/03/2022.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    //For MVVM @State = @Published
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameboardDisabled = false
    @Published var alertItem: AlertItem?
    
    func processPlayerMove(for position: Int) {
        if isSquareOccupied(in: moves, forIndex: position) { return }
        moves[position] = Move(player: .human, boardIndex: position)
        
        
        if checkWinCondtion(for: .human, in: moves){
            alertItem = AlertContext.humanWin
            return
        }
        
        if checkForDraw(in: moves) {
            print("draw")
            return
        }
        
        isGameboardDisabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerPosition = determineComputerMovePosition(in: moves)
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            isGameboardDisabled = false
            
            if checkWinCondtion(for: .computer, in: moves){
                AlertContext.computerWin
            }
            
            if checkForDraw(in: moves) {
                AlertContext.draw
            }
        }
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index})
    }
    
    
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        
        //If AI can win then win
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let computerMoves = moves.compactMap{ $0 }.filter{ $0.player == .computer }
        let computerPositions = Set(computerMoves.map{ $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPositions)
            
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
            
                if isAvailable { return winPositions.first!}
            }
        }
        
        // If AI Can't win then block
        
        let humanMoves = moves.compactMap{ $0 }.filter{ $0.player == .human }
        let humanPositions = Set(humanMoves.map{ $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPositions)
            
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
            
                if isAvailable { return winPositions.first!}
            }
        }
        
        // If AI cant block take the middle square
        let centerSquare = 4
        if !isSquareOccupied(in: moves, forIndex: centerSquare) {
            return centerSquare
        }
        
        // If AI Cant take the middle square take random square
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forIndex: movePosition){
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }
    
    func checkWinCondtion(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let playerMoves = moves.compactMap{ $0 }.filter{ $0.player == player }
        let playerPositions = Set(playerMoves.map{ $0.boardIndex })
        for pattern in winPatterns where pattern.isSubset(of: playerPositions){ return true }
        return false
        
    }

    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap{ $0 }.count == 9
    }
    
    func resetGame(){
        moves = Array(repeating: nil, count: 9)
    }
    
}
