import Foundation

// タスク一覧の管理とUserDefaultsへの保存・読み込みを担当するクラス
class TodoStore: ObservableObject {
    // @Published をつけるとリスト変更時にViewが自動で再描画される
    @Published var items: [TodoItem] = []

    private let saveKey = "todo_items"

    init() {
        load()
    }

    // タスクを追加する
    func add(title: String) {
        let trimmed = title.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        items.append(TodoItem(title: trimmed))
        save()
    }

    // タスクの完了/未完了を切り替える
    func toggle(_ item: TodoItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isDone.toggle()
            save()
        }
    }

    // 指定インデックスのタスクを削除する（スワイプ削除用）
    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    // UserDefaultsにJSONとして保存する
    private func save() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    // UserDefaultsからJSONを読み込む
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: saveKey),
              let saved = try? JSONDecoder().decode([TodoItem].self, from: data) else {
            return
        }
        items = saved
    }
}
