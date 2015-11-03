/*
taxi driver must be in a queue if he is available. must not be in a queue if is not availble
*/

sig Passenger {
	username: one Username,
	password: one Password 
}

sig TaxiDriver {
status: one AvailabilityStatus,
isLocatedIn: lone Position
}

enum AvailabilityStatus {
Available, Busy, NotAvailable
}

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

sig Username {
}

sig Password {
}

sig TaxiZone {
hasQueue: one TaxiQueue,
}

sig TaxiQueue {
contains: set TaxiDriver
}

//two passenger can't have the same username
fact passengerDifferentUsername {
	no disj p1, p2: Passenger | p1.username = p2.username
}

//taxi queue must be in one taxi zone
fact queueInZone {
	all q: TaxiQueue | one z: TaxiZone | q in z.hasQueue
}

//taxi driver only one queue
fact taxiDriverOnlyOneQueue {
	all d: TaxiDriver | one q:TaxiQueue | d in q.contains
}

//taxi drivers are in a queue only if available
fact taxiDriverAvailableInQueue {
	all q: TaxiQueue, d: q.contains | d.status = Available
}

//in within a reservation, origin and destination must differ
fact originNotEqualToDestination {
	all r: Reservation | r.origin != r.destination
}

pred show {	
#Passenger > 1
#TaxiDriver > 1
#TaxiZone > 1
}

run show for 5
