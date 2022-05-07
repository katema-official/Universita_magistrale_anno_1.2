package REST.services;



import REST.datas.Dictionary;
import REST.datas.Word;

import javax.ws.rs.*;
import javax.ws.rs.core.Response;
import java.util.Locale;


@Path("dictionary")
public class DictionaryRestService {
    //enter a word and its definition
    @Path("add")
    @POST
    @Consumes({"application/json", "application/xml"})
    public Response addWord(Word w){
        Dictionary dict = Dictionary.getInstance();
        int ret = dict.addWord(w.getActualWord().toLowerCase(), w.getDefinition());
        if(ret == -1){
            return Response.status(Response.Status.NOT_ACCEPTABLE).build();
        }else{
            return Response.ok().build();
        }
    }

    @Path("modify")
    @PUT
    @Consumes({"application/xml", "application/json"})
    public Response changeDefinition(Word w){
        Dictionary dict = Dictionary.getInstance();
        int ret = dict.changeWordDefinition(w.getActualWord().toLowerCase(), w.getDefinition());
        if(ret == -1){
            return Response.status(Response.Status.NOT_FOUND).build();
        }else{
            return Response.ok().build();
        }
    }

    @Path("get/{nameWord}")
    @GET
    @Produces({"text/plain"})
    public String getDefinition(@PathParam("nameWord") String nameWord){
        Dictionary dict = Dictionary.getInstance();
        String ret = dict.viewDefinition(nameWord.toLowerCase());
        if(ret == null){
            return "Word not present in dictionary, sorry";
        }
        return "The definition of " + nameWord + " is " + ret;
    }

    @Path("delete/{nameWord}")
    @DELETE
    public Response deleteWord(@PathParam("nameWord") String nameWord){
        Dictionary dict = Dictionary.getInstance();
        dict.deleteWord(nameWord.toLowerCase());
        return Response.ok().build();
    }



}
