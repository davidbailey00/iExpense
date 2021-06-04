//
//  AddView.swift
//  iExpense
//
//  Created by David Bailey on 03/06/2021.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expenses: Expenses

    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    @State private var showingAlert = false
    static let types = ["Business", "Personal"]

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)

                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }

                HStack {
                    Text("£")
                    TextField("Amount", text: $amount)
                        .keyboardType(.numberPad)
                        .labelsHidden()
                }
            }
            .navigationTitle("Add new expense")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let actualAmount = Int(self.amount) {
                            let item = ExpenseItem(
                                name: name,
                                type: type,
                                amount: actualAmount
                            )
                            expenses.items.append(item)
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            showingAlert = true
                        }
                    }
                    .disabled(name.isEmpty || amount.isEmpty)
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Amount must be a number"))
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
