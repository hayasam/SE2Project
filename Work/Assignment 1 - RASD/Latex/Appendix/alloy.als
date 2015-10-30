/*
taxi driver only one queue
reservation can't have same destination and origin
taxi queue must have a taxi zone
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
has: one TaxiQueue
}

sig TaxiQueue {
contains: set TaxiDriver
}

pred show { }

run show
