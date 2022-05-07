package REST.datas;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import java.util.HashMap;

@XmlRootElement
@XmlAccessorType(XmlAccessType.FIELD)
public class Dictionary {

    @XmlElement(name = "dictionary")
    private HashMap<String, String> actualDictionary;

    private static Dictionary instance;

    public Dictionary(){
        actualDictionary = new HashMap<String, String>();
    }
    public Dictionary(HashMap<String, String> dict){
        actualDictionary = dict;
    }

    public synchronized static Dictionary getInstance(){
        if(instance==null){
            instance = new Dictionary();
        }
        return instance;
    }

    public int addWord(String w, String d){
        synchronized (this) {   //necessary, otherwise we could have inconsistencies
            if (actualDictionary.containsKey(w)) {
                return -1;  //error, the key is already present
            } else {
                actualDictionary.put(w, d);
                System.out.println("aggiunta la parola " + w);
                System.out.println("la sua definizione è " + actualDictionary.get(w));
                return 0;
            }
        }
    }

    public int changeWordDefinition(String w, String d){
        synchronized (this) {   //necessary since two request could come at the same time
            if (!actualDictionary.containsKey(w)) {
                return -1;  //error, the word is not present, so you can't change the definition
            } else {
                actualDictionary.replace(w, d);
                return 0;
            }
        }
    }

    public String viewDefinition(String w){
        if(!actualDictionary.containsKey(w)){
            System.out.println("la definizione di " + w + " non c'è ");
            System.out.println("siamo sicuri? : " + actualDictionary.get(w));
            return null;  //can't view the definition of a word that doesn't exist
        }else{
            System.out.println("la definizione di " + w + " è " + actualDictionary.get(w));
            return actualDictionary.get(w);
        }
    }

    public void deleteWord(String w){
        actualDictionary.remove(w);
    }

}
