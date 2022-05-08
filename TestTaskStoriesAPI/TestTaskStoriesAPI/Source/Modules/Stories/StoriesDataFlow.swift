import Foundation

enum Stories {
    enum StoriesLoad {
        struct Request { }

        struct Response {
            let result: StepikResult<[Story]>
        }

        struct ViewModel {
            let model: StoriesViewModel
        }
    }
}
