import Foundation

// タスク1件を表すデータモデル
struct TodoItem: Identifiable, Codable {
    var id: UUID          // 一意のID（自動生成）
    var title: String     // タスクのタイトル
    var isDone: Bool      // 完了かどうか

    init(title: String) {
        self.id = UUID()
        self.title = title
        self.isDone = false
    }
}
