package REST.datas;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class Word {
    private String actualWord;
    private String definition;

    public Word(){}

    public Word(String w, String d){
        actualWord = w;
        definition = d;
    }

    public String getActualWord(){
        return actualWord;
    }

    public void setActualWord(String w){
        actualWord = w;
    }

    public String getDefinition(){
        return definition;
    }

    public void setDefinition(String d){
        definition = d;
    }

}
