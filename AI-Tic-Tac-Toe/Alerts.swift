//
//  Alerts.swift
//  AI-Tic-Tac-Toe
//
//  Created by Jonathan T. Nielsen on 15/03/2022.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin        = AlertItem(title: Text("you win!"),
                                           message: Text("You're Smart"),
                                           buttonTitle: Text("All i do is win"))
    
    static let computerWin     = AlertItem(title: Text("you Lost!"),
                                           message: Text("You're not Smart"),
                                           buttonTitle: Text("rematch"))
    
    static let draw            = AlertItem(title: Text("you drawed!"),
                                           message: Text("You're sad"),
                                           buttonTitle: Text("try again"))
    
}
