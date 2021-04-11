import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.layout.HBox;
import javafx.scene.layout.StackPane;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Text;
import javafx.stage.FileChooser;
import java.io.*;
import java.net.URISyntaxException;
import java.util.ArrayList;

public class Controller{

    Model m;
    View v;
    public Controller(Model m, View v) throws IOException, URISyntaxException {
        this.m = m;
        this.v = v;
        this.m.createAnswer();
    }

    public String getAnswer(){
        return m.getAnswer();
    }

    public void setScenePressed(Scene scene,ArrayList<StackPane> alphabetBox){
        scene.setOnKeyPressed(ke ->{
            if(ke.getText().isEmpty())
                return;
            char pressed = Character.toUpperCase(ke.getText().charAt(0));
            if(pressed < 'A' || pressed > 'Z')
                return;
            else{
                if(m.getPlaying()){
                    int index = pressed - 65;
                    if(getBoxColor(alphabetBox,index) == Color.GREY)
                        return;
                    else if(getBoxColor(alphabetBox,index) == Color.LIGHTGREEN) {
                        v.savebt.setDisable(false);
                        m.setGameEnd(false);
                        processKey(alphabetBox,index,pressed);
                    }
                }
            }
        });
    }

    public void processKey(ArrayList<StackPane> alphabetBox, int index,char c){
        Rectangle box = (Rectangle) alphabetBox.get(index).getChildren().get(0);
        box.setFill(Color.GREY);
        matchChar(c,m.getAnswer(),v.answerbox);
    }

    public Color getBoxColor(ArrayList<StackPane> alphabetBox, int index){
        Rectangle box = (Rectangle) alphabetBox.get(index).getChildren().get(0);
        return (Color) box.getFill();
    }

    public void matchChar(char c, String answer, HBox answerBox){
        int index = c - 65;
        m.getClciked().set(index,true);
        if(!answer.contains(String.valueOf(c))){
            nomacth();
            return;
        }
        int bound = answer.length();
        ArrayList<Integer> matches = new ArrayList<>();
        for(int i = 0; i < bound; i++){
            if(c == answer.charAt(i))
                matches.add(i);
        }
        m.setRemaining(m.getRemaining()-matches.size());
        v.updateRemaining();
        matches.forEach(x -> {
            StackPane sp = (StackPane)answerBox.getChildren().get(x);
            sp.getChildren().get(1).setVisible(true);
        });
        if(m.getRemaining() == 0) {
            m.setGameEnd(true);
            gameEnd();
            v.savebt.setDisable(true);
            v.displayWinningWindow();
        }
    }

    public void nomacth(){
        int bodypart = m.getGuessleft();
        m.setGuessleft(bodypart-1);
        v.updateGuess();
        ArrayList<Node> hangman = v.getFigure().hangman;
        hangman.get(10-bodypart).setVisible(true);
        if(m.getGuessleft() == 0) {
            m.setGameEnd(true);
            gameEnd();
            displayRemain();
            v.savebt.setDisable(true);
            v.displayLosingWindow();
        }
    }

    public void saveGame() throws IOException {
        FileChooser fc = new FileChooser();
        FileChooser.ExtensionFilter exf = new FileChooser.ExtensionFilter("Hangman file(.hng)","*.hng");
        fc.getExtensionFilters().add(exf);
        File file = fc.showSaveDialog(v.primaryStage);
        if(file != null) {
            FileOutputStream fos = new FileOutputStream(file);
            ObjectOutputStream oos = new ObjectOutputStream(fos);
            oos.writeObject(this.m);
            fos.close();
            oos.close();
            v.savebt.setDisable(true);
        }
    }

    public File loadFile() throws IOException, ClassNotFoundException {
        FileChooser fc = new FileChooser();
        FileChooser.ExtensionFilter exf = new FileChooser.ExtensionFilter("Hangman file(.hng)","*.hng");
        fc.getExtensionFilters().add(exf);
        File file = fc.showOpenDialog(v.primaryStage);
        if(file != null) {
            FileInputStream fin = new FileInputStream(file);
            ObjectInputStream fins = new ObjectInputStream(fin);
            this.m = (Model) fins.readObject();
            fin.close();
            fins.close();
            v.savebt.setDisable(false);
        }
        return file;
    }

    public void initializeClickedBoolean(){
        for(int i = 0; i < 26; i++)
            m.getClciked().add(false);
    }

    public void resetClickedBoolean(){
        for(int i = 0; i < 26; i++)
            m.getClciked().set(i,false);
    }

    public void reloadBoxes(){
        for(int i = 0; i < 26; i++){
            if(m.getClciked().get(i)){
                StackPane sp = v.alphabetBox.get(i);
                Rectangle rec = (Rectangle) sp.getChildren().get(0);
                rec.setFill(Color.GREY);
                char c = (char) (i + 65);
                checkAnswerBox(c);
            }
        }
    }

    public void checkAnswerBox(char c){
        int bound = m.getAnswer().length();
        for(int i = 0; i < bound; i++){
            if(m.getAnswer().charAt(i) == c){
                StackPane sp = (StackPane)v.answerbox.getChildren().get(i);
                sp.getChildren().get(1).setVisible(true);
            }
        }
    }

    public void newGame() throws IOException, URISyntaxException {
        m.createAnswer();
        m.resetGuess();
        m.setGuessleft(10);
    }

    public void displayRemain(){
        int bound = m.getAnswer().length();
        for(int i = 0 ; i < bound; i++){
            StackPane sp = (StackPane) v.answerbox.getChildren().get(i);
            Rectangle rec = (Rectangle) sp.getChildren().get(0);
            Text t = (Text) sp.getChildren().get(1);
            if(!t.isVisible()){
                t.setVisible(true);
                t.setFill(Color.GREY);
                rec.setFill(Color.LIGHTGRAY);
            }
        }
    }

    public int getGuess(){
        return m.getGuessleft();
    }

    public int getRemain(){
        return m.getRemaining();
    }
    public void startPlay(){
        m.setPlaying(true);
    }

    public void gameEnd() {
        m.setPlaying(false);
    }
}
