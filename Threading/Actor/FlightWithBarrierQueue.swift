import Foundation

class FlightWithBarrierQueue {
    private let company = "Vistara"
    private var availableSeats: [String] = ["1A", "1B", "1C"]
    private let barrierQueue = DispatchQueue(label: "barrierQueue", attributes: .concurrent)

    func getAvailableSeats() -> [String] {
        barrierQueue.sync(flags: .barrier) {
            return availableSeats
        }
    }

    func bookSeat() -> String {
        barrierQueue.sync(flags: .barrier) {
            let bookedSeat = availableSeats.first ?? ""
            availableSeats.removeFirst()
            return bookedSeat
        }
    }
}
