import Foundation

class PrintNumbersOperation: AsyncOperation, @unchecked Sendable {
    var range: Range<Int>

    init(range: Range<Int>) {
        self.range = range
    }

    override func main() {
        DispatchQueue.global().async { [weak self] in
            guard let self: PrintNumbersOperation = self else { return }
            for i in self.range {
                print(i)
            }
            self.state = .isFinished
        }
    }
}
