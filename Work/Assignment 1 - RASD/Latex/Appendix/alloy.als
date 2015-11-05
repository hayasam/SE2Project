/*
	ALLOY MODEL
	myTaxiService
*/

/******************ENTITIES****************************/
sig Passenger
{
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
	ownedBy: one Passenger,		
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

/******************FACTS****************************/

//A Passenger can only have one request at a time
fact onlyOneRequestForPassenger
{
	all p: Passenger | lone r: Request | r.ownedBy = p
}

//To one taxi zone correspond exactly one taxi queue
fact queueInOnlyOneZone
{
	all q: TaxiQueue {one z: TaxiZone | q in z.hasQueue}
}

//A Taxi Driver can be in only one queue
fact taxiDriverInOnlyOneQueue
{
	all d: TaxiDriver {lone q: TaxiQueue | d in q.contains}
}
//All the taxi drivers that are in a queue are available and 
//all the taxi that are available are in a taxi queue
fact allTaxiDriverInQueueAreAvailable
{
	all d: TaxiDriver | 
	{one q: TaxiQueue | d in q.contains} iff d.hasStatus = Available
}
//A taxi driver can serve a ride only if he is busy and
//a ride can be served only by a busy taxi driver
fact taxiDriverHasRideOnlyIfBusy
{
	all d:TaxiDriver | 
	{ some r:Ride | r.isServedBy = d } iff d.hasStatus = Busy
}
//A Taxi Driver  can serve only one ride at time
fact onlyOneRidePerTaxiDriver
{
	all d: TaxiDriver | 
	#{r: Ride | r.isServedBy = d} <= 1
}
//The origin and the destination of a reservation must be different
fact originDifferentFromDestination
{
	all r: Reservation | r.origin != r.destination
}



/******************ASSERTIONS****************************/

assert availableTaxiDriverInQueue {
	all d: {d1: TaxiDriver | d1.hasStatus = Available } |
	 one q: TaxiQueue | d in q.contains
}

assert queueHasOnlyAvailableTaxiDriver
{
	all q: TaxiQueue {all d: q.contains | d.hasStatus = Available}
}


assert allRidesHasBusyTaxiDriver
{
	all r: {r1 : Ride | #(r1.isServedBy) = 1} |
	 r.isServedBy.hasStatus = Busy
}

assert ifTaxiDriverBusyServesRide
{
	all d: {d1: TaxiDriver | d1.hasStatus = Busy} {
		one r: Ride | r.isServedBy = d
	}
}

assert onlyOneRidePerTaxiDriver
{
	all d: TaxiDriver | #{r: Ride | r.isServedBy = d} <= 1
}


check allRidesHasBusyTaxiDriver for 8
check ifTaxiDriverBusyServesRide for 8
check availableTaxiDriverInQueue for 8
check queueHasOnlyAvailableTaxiDriver for 8
check onlyOneRidePerTaxiDriver for 8



/******************PREDICATES****************************/

pred show 
{
#Passenger > 1
#TaxiQueue > 1
#Request > 3
#{d: TaxiDriver | d.hasStatus = Available}>0
#{d: TaxiDriver | d.hasStatus = Busy}>0
#{d: TaxiDriver | d.hasStatus = NotAvailable}>0
}

run show for 5
