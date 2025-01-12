import UIKit

class DispatchQueueGCDViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let customThread = CustomThread()
        customThread.createThread()

//        testHowQueueWorks()

//        checkQueueExecutionThread()

//        testingGlobalQueues()

//        customQueue()

//        doAsyncTaskInSerialQueue()

//        doSyncTaskInSerialQueue()

//        doAsyncTaskInConcurrentQueue()

//        doSyncTaskInConcurrentQueue()

//        testDispatchQueue()

//        testDispatchWorkItem1()

//        testDispatchWorkItem2()

//        testDispatchConcurrentPerform()

//        testDispatchGroup1()

//        testDispatchGroup2()

//        testDispatchGroup3()

//        testDispatchSemaphore()

//        testDeadlock()
    }

    //Create Thread Manually
    class CustomThread {
        func createThread() {
            let thread: Thread = Thread(target: self, selector: #selector(threadSelector), object: nil)
            thread.start()
        }

        @objc private func threadSelector() {
            print("Custom Thread in action")
        }
    }

    //How Queue works
    func testHowQueueWorks() {
        var counter = 1

        //Serial, async Queue
        DispatchQueue.main.async {
            for i in 0...3 {
                counter = i
                print("\(counter)")
            }
        }

        for i in 4...6 {
            counter = i
            print("\(counter)")
        }

        //Serial, async Queue
        DispatchQueue.main.async {
            counter = 9
            print(counter)
        }
    }

    //Check global queue if perform on Main Thread or not
    func checkQueueExecutionThread() {
        DispatchQueue.main.async {
            print(Thread.isMainThread ? "Execution on Main Thread" : "Execution on some other Thread")
        }

        DispatchQueue.global().async {
            print(Thread.isMainThread ? "Execution on Main Thread" : "Execution on global concurrent queue")
        }
    }

    //QOS
    func testingGlobalQueues() {
        DispatchQueue.global(qos: .background).async {
            for i in 11...21 {
                print(i)
            }

            print("background queue: Finished")
        }

        DispatchQueue.global(qos: .userInteractive).async {
            for i in 0...10 {
                print(i)
            }

            print("UserInteractive queue: Finished")
        }
    }

    //Creating custom queue
    func customQueue() {
        //attributes =>
            //concurrent: creates concurrent queue, be default custom queue is serial
            //initiallyInactive: creates inactive queue, later on you can activate it
        //autoreleaseFrequency => Constants indicating the frequency with which a dispatch queue autoreleases objects.
            //inherit: inherit autorelease frequency from its target queue
            //workItem: individual auto release pool will be setup before execution of block and releases object when block finishes executing
            //never: never setup auto release pool
        //target => A queue that your custom queue will use behind the scenes. A dispatch queue's priority is inherited from its target queue. If we don't specify target queue, its "default priority global queue" by default.
    //    let customQueue = DispatchQueue(label: "com.msb.customqueue",
    //                                    qos: .userInteractive,
    //                                    attributes: .concurrent,
    //                                    autoreleaseFrequency: .never,
    //                                    target: <#T##DispatchQueue?#>)

        let a = DispatchQueue(label: "A")
        let b = DispatchQueue(label: "B", attributes: .concurrent, target: a)

        a.async {
            for i in 0...5 {
                print(i)
            }
        }

        a.async {
            for i in 6...10 {
                print(i)
            }
        }

        b.async {
            for i in 11...15 {
                print(i)
            }
        }

        b.async {
            for i in 16...20 {
                print(i)
            }
        }

        //Activate queue later
        let c = DispatchQueue(label: "C", attributes: [.concurrent, .initiallyInactive])
        //if we don't use "initiallyInactive" attribute then setting target queue "a" will crash as target will only be set during initialisation or before activating queue.
        c.setTarget(queue: a)
        c.async {
            print("Checking queue Activation/deactivation")
        }
        c.activate()
    }

    func doAsyncTaskInSerialQueue() {
        var value = 20
        let serialQueue = DispatchQueue(label: "com.msb.serialQueue")

        for i in 1...3 {
            serialQueue.async {
                if Thread.isMainThread {
                    print("Task running in Main thread")
                } else {
                    print("Task running in Other thread")
                }
                let imageURL = URL(string: "https://picsum.photos/200")!
                let _ = try! Data(contentsOf: imageURL)
                print("\(i) finished downloading")
            }
        }

        serialQueue.async {
            for i in 0...3 {
                value = i
                print("\(value) 😃")
            }
        }

        print("Last line")
    }

    func doSyncTaskInSerialQueue() {
        var value = 20
        let serialQueue = DispatchQueue(label: "com.msb.serialQueue")

        for i in 1...3 {
            serialQueue.sync {
                if Thread.isMainThread {
                    print("Task running in Main thread")
                } else {
                    print("Task running in Other thread")
                }
                let imageURL = URL(string: "https://picsum.photos/200")!
                let _ = try! Data(contentsOf: imageURL)
                print("\(i) finished downloading")
            }
        }

        serialQueue.async {
            for i in 0...3 {
                value = i
                print("\(value) 😃")
            }
        }

        print("Last line")
    }

    func doAsyncTaskInConcurrentQueue() {
        var value = 20
        let concurrentQueue = DispatchQueue(label: "com.msb.concurrentQueue", attributes: .concurrent)

        for i in 1...3 {
            concurrentQueue.async {
                if Thread.isMainThread {
                    print("Task running in Main thread")
                } else {
                    print("Task running in Other thread")
                }
                let imageURL = URL(string: "https://picsum.photos/200")!
                let _ = try! Data(contentsOf: imageURL)
                print("\(i) finished downloading")
            }
        }

        concurrentQueue.async {
            for i in 0...3 {
                value = i
                print("\(value) 😃")
            }
        }

        print("Last line")
    }

    func doSyncTaskInConcurrentQueue() {
        var value = 20
        let concurrentQueue = DispatchQueue(label: "com.msb.concurrentQueue", attributes: .concurrent)

        for i in 1...3 {
            concurrentQueue.sync {
                if Thread.isMainThread {
                    print("Task running in Main thread")
                } else {
                    print("Task running in Other thread")
                }
                let imageURL = URL(string: "https://picsum.photos/200")!
                let _ = try! Data(contentsOf: imageURL)
                print("\(i) finished downloading")
            }
        }

        concurrentQueue.async {
            for i in 0...3 {
                value = i
                print("\(value) 😃")
            }
        }

        print("Last line")
    }

    //DispatchQueue
    func testDispatchQueue() {
        // Serial + sync => ordered
        // Serial + async => ordered
        // Concurrent + sync => ordered
        // Concurrent + async => unordered

        let queue1 = DispatchQueue(label: "Queue1", attributes: .concurrent)
    //    let queue2 = DispatchQueue(label: "Queue2", attributes: .concurrent)

        queue1.async {
            print("Task 1 started")
            for i in 0...5 {
                print("Task 1 Completed: \(i)")
            }
            print("Task 1 finished")
        }

        queue1.async {
            print("Task 2 started")
            for i in 0...7 {
                print("Task 2 Completed: \(i)")
            }
            print("Task 2 finished")
        }
    }

    func testDispatchWorkItem1() {
        var number = 15

        let workItem = DispatchWorkItem {
            number += 5
        }

        workItem.notify(queue: .main) {
            print("Increment number completed, new value: \(number)")
        }

        let queue = DispatchQueue.global(qos: .utility)
        queue.async(execute: workItem)
    }

    func testDispatchWorkItem2() {
        var workItem: DispatchWorkItem!
        workItem = DispatchWorkItem {
            for i in 0..<10 {
                if workItem.isCancelled {
                    print("WorkItem is cancelled")
                    break
                }
                print("\(i)")
                sleep(1)
            }
        }

        workItem.notify(queue: .main) {
            print("Printing numbers completed")
        }

        let queue = DispatchQueue.global(qos: .utility)
        queue.async(execute: workItem)

        queue.asyncAfter(deadline: .now() + 3) {
            workItem.cancel()
        }
    }

    //DispatchBarrier
    func testDispatchBarrier() {
        DispatchQueue.global().async(flags: .barrier) {

        }
    }

    func testDispatchConcurrentPerform() {
        DispatchQueue.concurrentPerform(iterations: 2) { index in
            for i in 1 ... 3 {
                print(index * i)
            }
            Thread.sleep(forTimeInterval: 3)
        }
    }

    // DispatchGroup
    func testDispatchGroup1() {
        let urls = ["https://api.google.com/1",
                    "https://api.google.com/1",
                    "https://api.google.com/1"]

        let group = DispatchGroup()
        for url in urls {
            guard let url = URL(string: url) else {
                continue
            }

            group.enter()
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                group.leave()
            }
            task.resume()
        }

        group.notify(queue: .main) {
            // Update user interface
            print("Group notify")
        }
    }

    func testDispatchGroup2() {
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.msb.queue")
        let someOtherQueue = DispatchQueue(label: "com.msb.someotherqueue")

        queue.async(group: group) {
            for i in 0...25 {
                print("Queue: Task \(i) is Running")
            }
        }

        queue.async(group: group) {
            for i in 25...40 {
                print("Queue: Task \(i) is Running")
            }
        }

        someOtherQueue.async(group: group) {
            for i in 0...25 {
                print("SomeOtherQueue: Task \(i) is Running")
            }
        }

        group.notify(queue: .main) {
            print("All Tasks are completed")
        }
    }

    func testDispatchGroup3() {
        let group = DispatchGroup()
        let queue = DispatchQueue.global(qos: .userInitiated)

        queue.async(group: group) {
            print("Task 1 started")
            Thread.sleep(until: Date().addingTimeInterval(10))
            print("Task 1 finished")
        }

        queue.async(group: group) {
            print("Task 2 started")
            Thread.sleep(until: Date().addingTimeInterval(2))
            print("Task 2 finished")
        }

        let waitResult: DispatchTimeoutResult = group.wait(timeout: .now() + .seconds(5))

        switch waitResult {
        case .success:
            print("Success")
        case .timedOut:
            print("TimedOut")
        }
    }

    func testDispatchSemaphore() {
        let higherPriority = DispatchQueue.global(qos: .userInitiated)
        let lowerPriority = DispatchQueue.global(qos: .utility)

        let semaphore = DispatchSemaphore(value: 1)

        func asyncPrint(queue: DispatchQueue, symbol: String) {
          queue.async {
            print("\(symbol) waiting")
            semaphore.wait()  // requesting the resource

            for i in 0...10 {
              print(symbol, i)
            }

            print("\(symbol) signal")
            semaphore.signal() // releasing the resource
          }
        }

        asyncPrint(queue: lowerPriority, symbol: "🔵")
        asyncPrint(queue: higherPriority, symbol: "🔴")
    }

    func testDeadlock() {
        let q = DispatchQueue(label: "myQueue")

        q.async {
            print("work async start")
            q.sync {
                print("work sync in async")
            }
            print("work async end")
        }

        q.sync {
            print("work sync")
        }

        print("done")
    }
}
