import SwiftUI

@main
struct TodoAppApp: App {
    // アプリ全体でTodoStoreを共有する（EnvironmentObject）
    @StateObject private var store = TodoStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
