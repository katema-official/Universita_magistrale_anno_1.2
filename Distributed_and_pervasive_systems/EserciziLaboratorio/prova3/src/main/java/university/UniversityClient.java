package university;
//si tratta dell'esercizio 1 lezione 3, "students stat with protocol buffers"
import proto.classes.StudentOuterClass.Student;

import java.io.IOException;
import java.net.Socket;

public class UniversityClient {
    public static void main(String argv[]) throws IOException {
        Socket clientSocket = new Socket("localhost", 9999);
        Student s = Student.newBuilder()
                .setName("Pippo")
                .setSurname("Baudo")
                .setYearOfBirth(1999)
                .setLocation(Student.placeOfResidence.newBuilder()
                        .setCountry("Italy")
                        .setStreet("Via Dante Alighieri")
                        .setNumber(34)
                        .setCap(50405).build())
                .addExams(Student.Exam.newBuilder()
                        .setName("Svigruppo")
                        .setMark(28)
                        .setDateOfVerbalization("29/01/2022").build())
                .addExams(Student.Exam.newBuilder()
                        .setName("AIVG")
                        .setMark(30)
                        .setDateOfVerbalization("16/02/2022").build())
                .addExams(Student.Exam.newBuilder()
                        .setName("Progetto di Sistemi a Sensore")
                        .setMark(32)
                        .setDateOfVerbalization("23/01/2022").build()).build();

        s.writeTo(clientSocket.getOutputStream());

        clientSocket.close();
    }
}
