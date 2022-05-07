package REST.client;

import REST.datas.Word;
import com.google.gson.Gson;
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientHandlerException;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;

public class MyClient {
    public static void main(String[] argv){
        Client client = Client.create();
        String serverAddress = "http://localhost:1337";
        ClientResponse clientResponse = null;

        //POST
        String postPath = "/dictionary/add";
        Word word = new Word("Gatto","l'animale più bello del mondo");
        clientResponse = postRequest(client,serverAddress+postPath,word);
        System.out.println(clientResponse.toString());

        //GET #1
        String getPath = "/dictionary/get/gatto";
        clientResponse = getRequest(client,serverAddress+getPath);
        System.out.println(clientResponse.toString());
        String response = clientResponse.getEntity(String.class);
        System.out.println(response);

        //PUT
        String putPath = "/dictionary/modify";
        word = new Word("Gatto","un felino molto piccino");
        clientResponse = putRequest(client, serverAddress+putPath, word);
        System.out.println(clientResponse.toString());

        //GET #2
        clientResponse = getRequest(client,serverAddress+getPath);
        System.out.println(clientResponse.toString());
        response = clientResponse.getEntity(String.class);
        System.out.println(response);

        //DELETE
        String deletePath = "/dictionary/delete/gatto";
        clientResponse = deleteRequest(client, serverAddress+deletePath);
        System.out.println(clientResponse);

        //GET #3
        clientResponse = getRequest(client,serverAddress+getPath);
        System.out.println(clientResponse.toString());
        response = clientResponse.getEntity(String.class);
        System.out.println(response);
    }

    public static ClientResponse postRequest(Client client, String url, Word w){
        WebResource webResource = client.resource(url);
        String input = new Gson().toJson(w);
        try {
            return webResource.type("application/json").post(ClientResponse.class, input);
        } catch (ClientHandlerException e) {
            System.out.println("Server not available");
            return null;
        }
    }

    public static ClientResponse getRequest(Client client, String url){
        WebResource webResource = client.resource(url);
        try {
            return webResource.get(ClientResponse.class);
        } catch (ClientHandlerException e) {
            System.out.println("Server not available");
            return null;
        }
    }

    public static ClientResponse putRequest(Client client, String url, Word word){
        WebResource webResource = client.resource(url);
        String input = new Gson().toJson(word);
        try {
            return webResource.type("application/json").put(ClientResponse.class, input);
        } catch (ClientHandlerException e) {
            System.out.println("Server not available");
            return null;
        }
    }

    public static ClientResponse deleteRequest(Client client, String url){
        WebResource webResource = client.resource(url);
        try{
            return webResource.delete(ClientResponse.class);
        }catch(ClientHandlerException e){
            System.out.println("Server not available");
            return null;
        }
    }
}
