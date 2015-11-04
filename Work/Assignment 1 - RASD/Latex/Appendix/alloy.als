/*
	ALLOY MODEL
	myTaxiService
*/

sig Passenger
{
	hasRequest: lone Request,
	hasReservation: set Reservation
}

sig TaxiDriver
{
	hasStatus: one Status
}

enum Status 
{
	Available, NotAvailable, Busy
}

sig Position
{
}

sig TaxiZone
{
	hasQueue: one TaxiQueue
}

sig TaxiQueue
{
	contains: set TaxiDriver
}

abstract sig Ride
{
	isServedBy: lone TaxiDriver,
	origin: one Position
}

sig Request extends Ride
{
}

sig Reservation extends Ride
{
	destination: one Position
}

//Relation one<-->one between taxiZones and TaxiQueues
fact queueInOnlyOneZone
{
	all q: TaxiQueue {one z: TaxiZone | q in z.hasQueue}
}

//A Taxi Driver can be in only one queue
fact taxiDriverInOnlyOneQueue
{
	all d: TaxiDriver {lone q: TaxiQueue | d in q.contains}
}
//*************************************************
fact allTaxiDriverInQueueAreAvailable
{
	all d: TaxiDriver | {one q: TaxiQueue | d in q.contains} iff d.hasStatus = Available
}

assert availableTaxiDriverInQueue {
	all d: {d1: TaxiDriver | d1.hasStatus = Available } | one q: TaxiQueue | d in q.contains
}

assert queueHasOnlyAvailableTaxiDriver
{
	all q: TaxiQueue {all d: q.contains | d.hasStatus = Available}
}
//************************************************

fact onlyOneRidePerTaxiDriver
{
	all d: TaxiDriver | #{r: Ride | r.isServedBy = d} <= 1
}

fact taxiDriverHasRideOnlyIfBusy
{
	all d:TaxiDriver | { some r:Ride | r.isServedBy = d } iff d.hasStatus = Busy
}

assert allRidesHasBusyTaxiDriver
{
	all r: {r1 : Ride | #(r1.isServedBy) = 1} | r.isServedBy.hasStatus = Busy
}

assert ifTaxiDriverBusyServesRide
{
	all d: {d1: TaxiDriver | d1.hasStatus = Busy} {one r: Ride | r.isServedBy = d}
}

assert onlyOneRidePerTaxiDriver
{
	all d: TaxiDriver | #{r: Ride | r.isServedBy = d} <= 1
}

//*******************************************************

fact requestHasOneOwner 
{
	all r:Request {one p:Passenger | p.hasRequest = r}
	
}

fact reservationHasOneOwner
{
	all r: Reservation | one p:Passenger | p.hasReservation = r
}

assert everyRideHasOwner
{
	all r: Ride | #{p: Passenger | p.hasRequest = r or p.hasReservation = r} =1
}

//*****************************************************

fact originDifferentFromDestination
{
	all r: Reservation | r.origin != r.destination
}

check everyRideHasOwner for 8
check allRidesHasBusyTaxiDriver for 8
check ifTaxiDriverBusyServesRide for 8
check availableTaxiDriverInQueue for 8
check queueHasOnlyAvailableTaxiDriver for 8
check onlyOneRidePerTaxiDriver for 8


pred show 
{
#{d: TaxiDriver | d.hasStatus = Available}>0
#{d: TaxiDriver | d.hasStatus = Busy}>0
#{d: TaxiDriver | d.hasStatus = NotAvailable}>0
}

run show for 5

