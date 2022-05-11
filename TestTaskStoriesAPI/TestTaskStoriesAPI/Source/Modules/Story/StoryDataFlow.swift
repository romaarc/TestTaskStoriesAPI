import Foundation

enum StoryDataFlow {
    /// Show story
    enum StoryLoad {
        struct Request {}

        struct Response {
            let response: StoriesViewModel
        }

        struct ViewModel {
            let result: StoriesViewModel
        }
    }
}
