public class Reservations {
    //class to represent the only show the theatre is offering
    int totalSeats;
    int reservedSeats;

    public Reservations(int totalSeats){
        this.totalSeats = totalSeats;
        this.reservedSeats = 0;
    }

    //returns the number of booked seats
    public int checkFreeSeats(){
        synchronized(this){
            if(totalSeats - reservedSeats > 0){ //if there are free seats
                System.out.println("reserved = " + reservedSeats);
                return reservedSeats;   //return the number of reserved seats
            }else{
                return 0;
            }

        }
    }

    //the integer represent the ith seat taken. if it is -1, the ticket was not bought.
    public int buyTicket(){
        synchronized(this){
            //if there are free seats...
            if(checkFreeSeats() >= 0 && (totalSeats != reservedSeats)){
                reservedSeats++;
                System.out.println("Updated to: " + reservedSeats);
                return reservedSeats;
            }else{
                return -1;
            }
        }
    }


}
