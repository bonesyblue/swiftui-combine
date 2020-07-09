//
//  ContentView.swift
//  FirebaseSwfitUI
//
//  Created by Jonathan Bones on 09.07.20.
//  Copyright © 2020 bonesyblue. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        SignUpForm(viewModel: UserViewModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
