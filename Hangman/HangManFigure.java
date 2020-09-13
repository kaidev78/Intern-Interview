import javafx.beans.property.DoubleProperty;
import javafx.beans.property.SimpleDoubleProperty;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.shape.Circle;
import javafx.scene.shape.Line;
import java.util.ArrayList;

public class HangManFigure{
    DoubleProperty LINEX = new SimpleDoubleProperty();
    DoubleProperty LINESY = new SimpleDoubleProperty();
    DoubleProperty LINEEY = new SimpleDoubleProperty();
    ArrayList<Node> hangman = new ArrayList();
    Scene scene;

    public HangManFigure(Scene scene){
        this.scene = scene;
    }

    public void createHangMan(){
        bindPoints();
        Circle head = new Circle(20);
        head.setTranslateX(LINEX.getValue());
        head.setTranslateY(LINESY.getValue());
        head.translateXProperty().bind(LINEX);
        head.translateYProperty().bind(LINESY);
        Line hanger1 = new Line();
        bindLinePrperty(hanger1,-150,75,50,75);
        hanger1.startYProperty().bind(LINEEY.add(75));
        Line hanger2 = new Line();
        bindLinePrperty(hanger2,-150,75,-150,-75);
        hanger2.startYProperty().bind(LINEEY.add(75));
        hanger2.endYProperty().bind(LINESY.add(-75));
        Line hanger3 = new Line();
        bindLinePrperty(hanger3,-150,-75,0,-75);
        hanger3.endYProperty().bind(LINESY.add(-75));
        Line hanger4 = new Line();
        bindLinePrperty(hanger4,0,-75,0,-20);
        hanger4.endYProperty().bind(LINESY.add(-20));
        Line body = new Line();
        bindLinePrperty(body,0,0,0,0);
        Line leftHand = new Line();
        bindLinePrperty(leftHand,0,35,-40,85);
        leftHand.endYProperty().bind(LINESY.add(85));
        Line rightHand = new Line();
        bindLinePrperty(rightHand,0,35,40,85);
        rightHand.endYProperty().bind(LINESY.add(85));
        Line leftFeet = new Line();
        bindLinePrperty(leftFeet,0,0,-40,50);
        leftFeet.startYProperty().bind(LINEEY);
        Line rightFeet = new Line();
        bindLinePrperty(rightFeet,0,0,40,50);
        rightFeet.startYProperty().bind(LINEEY);
        hangman.add(hanger1);
        hangman.add(hanger2);
        hangman.add(hanger3);
        hangman.add(hanger4);
        hangman.add(head);
        hangman.add(body);
        hangman.add(leftHand);
        hangman.add(rightHand);
        hangman.add(leftFeet);
        hangman.add(rightFeet);
    }


    public void bindPoints(){
        LINEX.bind(scene.widthProperty().divide(3.4));
        LINESY.bind(scene.heightProperty().divide(4));
        LINEEY.bind(scene.heightProperty().divide(2.4));
    }

    public void bindLinePrperty(Line line, double sx, double sy, double ex, double ey){
        line.startXProperty().bind(LINEX.add(sx));
        line.endXProperty().bind(LINEX.add(ex));
        line.startYProperty().bind(LINESY.add(sy));
        line.endYProperty().bind(LINEEY.add(ey));
    }


}
