//
//  ContentView.swift
//  HighRollers
//
//  Created by Daniel Freire on 3/31/24.
//

import SwiftUI

struct ContentView: View {
    let diceTypes = [4, 6, 8, 10, 12, 20, 100]

    @AppStorage("selectedDiceType") var selectedDiceType = 6
    @AppStorage("numberToRoll") var numberToRoll = 4

    @State private var currentResult = DiceResult(type: 0, number: 0)

    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var stoppedDice = 0

    let columns: [GridItem] = [
        .init(.adaptive(minimum: 60))
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Type of dice", selection: $selectedDiceType) {
                        ForEach(diceTypes, id: \.self) { type in
                            Text("D\(type)")
                        }
                    }
                    .pickerStyle(.segmented)

                    Stepper("Number of dice: \(numberToRoll)", value: $numberToRoll, in: 1 ... 20)

                    Button("Roll them!", action: rollDice)
                } footer: {
                    LazyVGrid(columns: columns) {
                        ForEach(0 ..< currentResult.rolls.count, id: \.self) { rollNumber in
                            Text(String(currentResult.rolls[rollNumber]))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .aspectRatio(1, contentMode: .fit)
                                .foregroundStyle(Color.primary)
                                .background(.background)
                                .clipShape(.rect(cornerRadius: 10))
                                .shadow(color: Color.primary, radius: 3)
                                .font(.title)
                                .padding(5)
                        }
                    }
                }
                .disabled(stoppedDice < currentResult.rolls.count)
            }
            .navigationTitle("High Rollers")
            .onReceive(timer) { _ in
                updateDice()
            }
        }
    }

    func rollDice() {
        currentResult = DiceResult(type: selectedDiceType, number: numberToRoll)
        stoppedDice = -20
    }

    func updateDice() {
        guard stoppedDice < currentResult.rolls.count else { return }

        for i in stoppedDice ..< numberToRoll {
            if i < 0 { continue }
            currentResult.rolls[i] = Int.random(in: 1 ... selectedDiceType)
        }

        stoppedDice += 1
    }
}

#Preview {
    ContentView()
}
