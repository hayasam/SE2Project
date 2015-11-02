/*
reservation can't have same destination and origin
taxi driver must be in a queue if he is available. must not be in a queue if is not availble
*/

sig Passenger {
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

sig TaxiZone {
hasQueue: one TaxiQueue,
}

sig TaxiQueue {
contains: set TaxiDriver
}


//taxi queue must be in one taxi zone
fact queueInZone {
	all q: TaxiQueue | one z: TaxiZone | q in z.hasQueue
}

//taxi driver only one queue
fact taxiDriverOnlyOneQueue {
	all d: TaxiDriver | one q:TaxiQueue | d in q.contains
}

fact taxiDriverAvailableInQueue {
	all d: TaxiDriver | AvailabilityStatus.Available in d.AvailabilityStatus | one q:TaxiQueue | d in q.contains
}

pred show { 
#TaxiZone > 5
#Passenger > 5
#TaxiDriver > 5
}

run show for 50
