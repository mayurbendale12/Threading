import Foundation

class CustomOperation: Operation, @unchecked Sendable {
    override func main() {
        for i in 0 ... 10 {
            print(i)
        }
    }
}
