import UIKit

class OperationViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        testOperation()
        
//        testCustomOperation()

//        operationDependancyAsyncProblem()

//        operationDependancyAsyncSolution()
    }

    //: Operation
    func testOperation() {
        print("About to begin operation")
        //Block operation are synchronous
        let operation1 = BlockOperation {
            print("First test")
            sleep(3)
        }
        operation1.start()
        print("Operation completed")

        let operation = BlockOperation()
    //    operation.qualityOfService = .utility
        operation.addExecutionBlock {
            print("Hello1")
        }

        operation.addExecutionBlock {
            print("Hello2")
        }

        operation.addExecutionBlock {
            print("Hello3")
        }

//        operation.start()
        let anotherBlockOperation = BlockOperation()
        anotherBlockOperation.addExecutionBlock {
            print("Another block operation")
        }

        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .utility
    //    operation.addDependency(anotherBlockOperation)
    //    operationQueue.addOperation(operation)
    //    operationQueue.addOperation(anotherBlockOperation)
        operationQueue.addOperations([operation, anotherBlockOperation], waitUntilFinished: false)
        operationQueue.maxConcurrentOperationCount = 2 // 1 : to make serial

        operation.isReady
        operation.isFinished
        operation.isCancelled
        operation.isExecuting

        operation.completionBlock = {
            print("Completion Block")
        }

        print("Operation Execution block is completed")
    }

    func testCustomOperation() {
        let customOperation = CustomOperation()
        customOperation.start()
    }

    //Even though we have added dependency, both operation are executing concurrently, to solve this we have to use the different states operation has like isReady, isExecuting, follow the code below to handle this
    func operationDependancyAsyncProblem() {
        let operationQueue = OperationQueue()
        let operation1 = BlockOperation(block: printOneToTen)
        let operation2 = BlockOperation(block: printElevenToTwenty)
        operation1.addDependency(operation2)
        operationQueue.addOperation(operation1)
        operationQueue.addOperation(operation2)

        func printOneToTen() {
            DispatchQueue.global().async {
                for i in 1 ... 10 {
                    print(i)
                }
            }
        }

        func printElevenToTwenty() {
            DispatchQueue.global().async {
                for i in 11 ... 20 {
                    print(i)
                }
            }
        }

        print("Custom operation Executed")
    }

    func operationDependancyAsyncSolution() {
        let operationQueue = OperationQueue()
        let operation1 = PrintNumbersOperation(range: Range(0 ... 25))
        let operation2 = PrintNumbersOperation(range: Range(26 ... 50))
        operation2.addDependency(operation1)
        operationQueue.addOperation(operation1)
        operationQueue.addOperation(operation2)

        func printOneToTen() {
            DispatchQueue.global().async {
                for i in 1 ... 10 {
                    print(i)
                }
            }
        }

        func printElevenToTwenty() {
            DispatchQueue.global().async {
                for i in 11 ... 20 {
                    print(i)
                }
            }
        }

        print("Custom operation Executed")
    }
}
