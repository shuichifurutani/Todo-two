import SwiftUI

struct ContentView: View {
    // TodoStoreをEnvironmentObjectとして受け取る
    @EnvironmentObject var store: TodoStore

    // テキストフィールドに入力中のタイトル
    @State private var newTitle: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 入力エリア（テキストフィールド＋追加ボタン）
                HStack {
                    TextField("新しいタスクを入力", text: $newTitle)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.done)
                        .onSubmit(addTask)  // キーボードのDoneキーでも追加

                    Button(action: addTask) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(newTitle.trimmingCharacters(in: .whitespaces).isEmpty ? .gray : .blue)
                    }
                    .disabled(newTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding()

                Divider()

                // タスク一覧
                if store.items.isEmpty {
                    // タスクがないときの案内表示
                    Spacer()
                    Text("タスクがありません")
                        .foregroundColor(.secondary)
                    Spacer()
                } else {
                    List {
                        ForEach(store.items) { item in
                            TaskRow(item: item)
                                .contentShape(Rectangle())  // 行全体をタップ可能にする
                                .onTapGesture {
                                    store.toggle(item)
                                }
                        }
                        // 左スワイプで削除
                        .onDelete(perform: store.delete)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("ToDoリスト")
            .toolbar {
                // 右上に編集ボタンを表示（削除モードの切り替え）
                EditButton()
            }
        }
    }

    // タスクを追加してテキストフィールドをクリアする
    private func addTask() {
        store.add(title: newTitle)
        newTitle = ""
    }
}

// タスク1行のビュー
struct TaskRow: View {
    let item: TodoItem

    var body: some View {
        HStack {
            // 完了状態に応じてチェックマークアイコンを切り替える
            Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                .foregroundColor(item.isDone ? .green : .gray)
                .font(.title3)

            Text(item.title)
                .strikethrough(item.isDone)               // 完了時は取り消し線
                .foregroundColor(item.isDone ? .secondary : .primary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ContentView()
        .environmentObject(TodoStore())
}
