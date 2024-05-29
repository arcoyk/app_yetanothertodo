import SwiftUI

struct ToDoListView: View {
  @State private var toDoItems: [ToDoItem] = []
  @State private var newItemText = ""
  @AppStorage("isDarkMode") private var isDarkMode = false

  var body: some View {
    NavigationView {
      VStack {
        // Dark Mode Toggle Button
        HStack {
          Spacer()
          Button(action: {
            isDarkMode.toggle()
          }) {
            Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
              .font(.title2)
              .padding()
              .foregroundColor(.gray)
          }
          .buttonStyle(.plain)
        }

        // Title (Empty for now)
        Text("")
          .font(.title)
          .padding()

        // List of To-Do Items
        List {
          if toDoItems.filter({ !$0.isCompleted }).isEmpty {
            Text("なにもないです")
              .foregroundColor(.gray)
          } else {
            ForEach($toDoItems) { $item in
              if !item.isCompleted {
                ToDoItemRow(item: $item)
              }
            }
            .onDelete(perform: deleteItems)
          }
        }

        Spacer() // Push the input area to the bottom

        // Add New Item (modified HStack)
        HStack {
          Button(action: addItem) {
            Image(systemName: "plus.circle.fill")
              .foregroundColor(.white)
          }
          .buttonStyle(.borderedProminent)
          .tint(.blue)
          .padding(.trailing, 8)

          TextField("あたらしいTODO", text: $newItemText)
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal)
        }
        .padding(.bottom)
        .background(Color(.systemGray6))

        // Navigation Link to Done Items
        NavigationLink(destination: DoneView(toDoItems: $toDoItems)) {
          Text("おわったTODO")
            .foregroundColor(.gray)
        }
      } // End of VStack
      .navigationTitle("")
      .preferredColorScheme(isDarkMode ? .dark : .light)
      .ignoresSafeArea(.keyboard, edges: .bottom) // Optional: Keyboard avoidance
    }
  }

  // Functions
  func addItem() {
    if !newItemText.isEmpty {
      toDoItems.append(ToDoItem(text: newItemText, isCompleted: false))
      newItemText = ""
    }
  }

  func deleteItems(at offsets: IndexSet) {
    toDoItems.remove(atOffsets: offsets)
  }
}

// ToDoItem Row View
struct ToDoItemRow: View {
  @Binding var item: ToDoItem

  var body: some View {
    HStack {
      Button(action: { item.isCompleted.toggle() }) {
        Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
          .foregroundColor(.gray)
      }
      Text(item.text)
    }
  }
}

// View for Completed Items
struct DoneView: View {
  @Binding var toDoItems: [ToDoItem]

  var body: some View {
    VStack {
      Text("おつかれさまでした")
        .font(.title)
        .padding()

      List {
        if toDoItems.filter({ $0.isCompleted }).isEmpty {
          Text("すべておわりです！")
            .foregroundColor(.gray)
        } else {
          ForEach(toDoItems) { item in
            if item.isCompleted {
              HStack {
                Text(item.text)
              }
            }
          }
        }
      }
    }
  }
}

// Data Model for a To-Do Item
struct ToDoItem: Identifiable {
  let id = UUID()
  var text: String
  var isCompleted: Bool
}

