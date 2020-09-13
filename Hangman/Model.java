import java.io.*;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Random;

public class Model implements Serializable {

    private int guessleft = 10;
    private int remaining;
    private boolean playing = false;
    private  ArrayList<String> wordList = new ArrayList<>();
    private String answer;
    private HashSet<Character> uniqueChar = new HashSet<>();
    private ArrayList<Boolean> clicked = new ArrayList<>();
    private boolean gameEnd = true;

    public Model(){
    }

    public int getGuessleft() {
        return guessleft;
    }

    public void setGuessleft(int guessleft) {
        this.guessleft = guessleft;
    }

    public String getAnswer(){
        return answer;
    }

    public boolean getPlaying(){
        return playing;
    }

    public void setPlaying(boolean playing) {
        this.playing = playing;
    }


    public int getRemaining() {
        return remaining;
    }

    public void setRemaining(int remaining) {
        this.remaining = remaining;
    }

    public ArrayList<Boolean> getClciked() {
        return clicked;
    }

    public boolean isGameEnd() {
        return gameEnd;
    }

    public void setGameEnd(boolean gameEnd) {
        this.gameEnd = gameEnd;
    }

    public ArrayList<String> loadWordList() throws IOException, URISyntaxException {
        URL filepath = getClass().getResource("words.txt");
        File f = new File(filepath.toURI());
        BufferedReader br = new BufferedReader(new FileReader(f));
        String s = "";
        while((s = br.readLine()) != null){
            wordList.add(s);
        }
        return wordList;
    }

    public void loadAnswer(){
        Random rand = new Random();
        int rand_int = rand.nextInt(wordList.size());
        answer = wordList.get(rand_int).toUpperCase();
        int length = answer.length();
        uniqueChar.clear();
        for(int i = 0; i < length; i++)
            uniqueChar.add(answer.charAt(i));
        remaining = answer.length();
    }

    public void resetGuess(){
        guessleft = wordList.size();
    }

    public void createAnswer() throws IOException, URISyntaxException {
        loadWordList();
        loadAnswer();
    }


}
