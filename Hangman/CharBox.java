import javafx.scene.Scene;
import javafx.scene.layout.StackPane;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Font;
import javafx.scene.text.FontPosture;
import javafx.scene.text.FontWeight;
import javafx.scene.text.Text;
import java.util.ArrayList;

public class CharBox{

    Scene scene;

    public  CharBox(Scene scene){
        this.scene = scene;
    }


    public ArrayList<StackPane> createAlphabetBox(){
        ArrayList<StackPane> charbox = new ArrayList();

        for(int i = 'A'; i <= 'Z'; i++){
            StackPane charBt = new StackPane();
            Rectangle rec = new Rectangle(30,40);
            rec.widthProperty().bind(scene.widthProperty().divide(40));
            rec.heightProperty().bind(scene.heightProperty().divide(15));
            rec.setStroke(Color.BLACK);
            rec.setFill(Color.LIGHTGREEN);
            charBt.getChildren().add(rec);
            char c = (char)i;
            Text t = new Text(Character.toString(c));
            t.setFill(Color.ALICEBLUE);
            t.setFont(Font.font("Alegreya", FontWeight.BOLD, FontPosture.REGULAR, 30));
            charBt.getChildren().add(t);
            charbox.add(charBt);
        }
        return charbox;
    }


    public StackPane setUpABox(char c,boolean show){
        Rectangle rec = new Rectangle(30,40);
        rec.widthProperty().bind(scene.widthProperty().divide(40));
        rec.heightProperty().bind(scene.heightProperty().divide(15));
        rec.setFill(Color.ANTIQUEWHITE);
        Text t = new Text(String.valueOf(c));
        t.setFill(Color.RED);
        t.setFont(Font.font("Alegreya", FontWeight.BOLD, FontPosture.REGULAR, 30));
        t.setVisible(show);
        StackPane pane = new StackPane();
        pane.getChildren().addAll(rec,t);
        return pane;
    }

}
