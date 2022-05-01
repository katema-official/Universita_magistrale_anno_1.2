package university;

import proto.classes.StudentOuterClass.Student;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

public class UniversityServer {
    public static void main(String argv[]) throws IOException {

        //apro il server
        ServerSocket serverSocket = new ServerSocket(9999);
        System.out.println("awaiting connenction...");
        Socket s = serverSocket.accept();
        System.out.println("connection accepted");


        Student student = Student.parseFrom(s.getInputStream());

        System.out.println("Here are the stats of your student:\n" +
                "Name: " + student.getName() + "\n" +
                "Surname: " + student.getSurname() + "\n" +
                "Year of Birth: " + student.getYearOfBirth() + "\n" +
                "Place of residence: \n" +
                "Country: "+ student.getLocation().getCountry() + "\n" +
                "Street: "+ student.getLocation().getStreet() + "\n" +
                "Number: "+ student.getLocation().getNumber() + "\n" +
                "CAP: " + student.getLocation().getCap() + "\n");

        for(int i = 0; i < student.getExamsCount(); i++){
            System.out.println("Exam " + i + ":\n" +
                    "Name: " + student.getExams(i).getName() + "\n" +
                    "Mark: " + student.getExams(i).getMark() + "\n" +
                    "Date of verbalization: " + student.getExams(i).getDateOfVerbalization() + "\n");
        }

        s.close();
    }
}
