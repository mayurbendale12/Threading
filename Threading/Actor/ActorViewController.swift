import UIKit

class ActorViewController: UIViewController {
    @IBOutlet private weak var seatLabel: UILabel!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        createDataRaceWhichLeadsDataInconsistency()

        // Even we book seat, it shows in available seats
        // This can be fix by introducing barrierQueue in Flight Model where availableSeats is
        // shared resources access by two threads, one thread is writing and one thread is reading
//        solveDataRaceWhichLeadsDataInconsistencyWithBarrierQueue()

//        solveDataRaceUsingActors()
    }

    private func createDataRaceWhichLeadsDataInconsistency() {
        let queue1 = DispatchQueue(label: "queue1")
        let queue2 = DispatchQueue(label: "queue2")

        let flight = Flight()

        queue1.async {
            let bookedSeat = flight.bookSeat()
            print("Booked seat is \(bookedSeat)")
        }

        queue2.async {
            let availableSeats = flight.getAvailableSeats()
            print("Available seats \(availableSeats)")
        }
    }

    private func solveDataRaceWhichLeadsDataInconsistencyWithBarrierQueue() {
        let queue1 = DispatchQueue(label: "queue1")
        let queue2 = DispatchQueue(label: "queue2")

        let flight = FlightWithBarrierQueue()

        queue1.async {
            let bookedSeat = flight.bookSeat()
            print("Booked seat is \(bookedSeat)")
        }

        queue2.async {
            let availableSeats = flight.getAvailableSeats()
            print("Available seats \(availableSeats)")
        }
    }

    //Avoid mixing actors with DispatchQueue
    private func solveDataRaceUsingActors() {
        let flight = FlightActor()

        Task {
            // Booking a seat
            let bookedSeat = await flight.bookSeat()
            print("Booked seat is \(bookedSeat)")
            self.updateSeat(seat: bookedSeat)

            // Checking available seats after booking
            let availableSeats = await flight.getAvailableSeats()
            print("Available seats \(availableSeats)")
        }
    }

    //MainActor: This is introduced newly which moves the context on main thread we don't have to use DispatchQueue.asyn.main to update UI on main thread. By using MainActor we can safely call this function from background thread or asynchronous block of code.
    @MainActor
    private func updateSeat(seat: String) {
        seatLabel.text = seat
    }
}
