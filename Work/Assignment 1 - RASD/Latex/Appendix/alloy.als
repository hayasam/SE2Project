/*
	ALLOY MODEL
	myTaxiService
*/

/*Passenger*/
sig Passenger {
}

/*TaxiDriver*/
sig TaxiDriver {
status: one AvailabilityStatus,
isLocatedIn: lone Position
}

enum AvailabilityStatus {
Available, Busy, NotAvailable
}

/*Types of rides*/
abstract sig Ride {
owner: one Passenger,
origin: one Position,
isServedBy: lone TaxiDriver
}

sig Request extends Ride {
}

sig Reservation extends Ride {
destination: one Position
}

sig Position {
}

/*Taxi zones and relative taxi queues*/
sig TaxiZone {
hasQueue: one TaxiQueue,
}

sig TaxiQueue {
contains: set TaxiDriver
}

/*FACTS ---> Requirements*/

//taxi queue must be in one taxi zone
fact queueInZone {
	all q: TaxiQueue | one z: TaxiZone | q in z.hasQueue
}

//taxi driver only one queue
fact taxiDriverOnlyOneQueue {
	all d: TaxiDriver | lone q:TaxiQueue | d in q.contains
}
//all the taxi driver in each queue are Available
fact onlyAvailableTaxiDriverInQueue{
	all q: TaxiQueue {all d: q.contains | d.status = Available}
}
//in within a reservation, origin and destination must differ
fact originNotEqualToDestination {
	all r: Reservation | r.origin != r.destination
}

//rides served only by busy taxi drivers
fact ridesOnlyBusyTaxiDrivers {
	all r: Ride | r.isServedBy.status = Busy
}

pred show {	
#Passenger > 1
#TaxiDriver > 1
#TaxiZone > 1
}

assert noBusyTaxiDriverInQueue {
	no q: TaxiQueue {some d: q.contains | d.status = Busy}
}

assert noNotAvailableTaxiDriverInQueue {
	no q: TaxiQueue {some d: q.contains | d.status = NotAvailable}
}

check noBusyTaxiDriverInQueue for 5
check noNotAvailableTaxiDriverInQueue for 5

run show for 5
