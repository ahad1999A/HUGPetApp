//
//  TabBarViews.swift
//  HUGPETGITHUB
//
//  Created by Ahad Obaid Albaqami on 29/03/1444 AH.
//

import SwiftUI
import FirebaseAuth

enum TabPressed{
    case services
    case order
    case orderList
}

struct TabBarViews: View {
    @State var tabSelected : TabPressed = .services

    var body: some View {
        if Auth.auth().currentUser != nil {
          
            
        } else {
            PhoneAuthView()
                .environmentObject(AuthMangerViewModel())
        }
    }
}

struct TabBarViews_Previews: PreviewProvider {
    static var previews: some View {
        TabBarViews()
    }
}
