public class TaxiQueue {
	//Usage of the LinkedList implementation of the interface Queue
	//FIFO policy
	Queue<Taxi> queue = new LinkedList<Taxi>();
	
	public void addTaxi(Taxi taxi)
	{
		this.queue.add(taxi);
	}
	//....
}
