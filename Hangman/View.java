import javafx.beans.binding.Bindings;
import javafx.beans.property.DoubleProperty;
import javafx.beans.property.SimpleDoubleProperty;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.*;
import javafx.scene.text.Font;
import javafx.scene.text.FontPosture;
import javafx.scene.text.FontWeight;
import javafx.scene.text.Text;
import javafx.stage.Stage;
import java.io.File;
import java.io.IOException;
import java.io.Serializable;
import java.net.URISyntaxException;
import java.util.ArrayList;

public class View implements Serializable {
        private Controller c;
        private CharBox charBox;
        private HangManFigure figure;
        HBox scoreHolder = new HBox(20);
        HBox answerbox;
        Button btplay = new Button("Start Play!!");
        Button newbt;
        Button loadbt;
        Button savebt;
        Button exitbt;
        Stage primaryStage;
        ArrayList<StackPane> alphabetBox;
        Scene scene;
        GridPane root;
        VBox charBoxHolder;
        HBox remainBox;
        HBox guessBox;
        VBox charBoard;
        DoubleProperty headingFontSize = new SimpleDoubleProperty(50);
    public View(){

        }


        public void setController(Controller c){
            this.c = c;
        }

    public void initializeStageView(Stage primaryStage, String title){
        this.primaryStage = primaryStage;
        primaryStage.setTitle(title);
        primaryStage.getIcons().add(new Image("./image/hangman.png"));
        root = new GridPane();
        scene = new Scene(root, 1200, 600);
        charBox = new CharBox(scene);
        figure = new HangManFigure(scene);
        primaryStage.setScene(scene);
        setUpGameField();
        root.setStyle("-fx-background-color: gray;");
    }

    public HBox makeToolBox(Stage primaryStage){
        HBox toolbox = new HBox();
        int height = 50;
        int width = 80;
        newbt = makeBt(new Image("./image/New.png"),width,height);
        loadbt = makeBt(new Image("./image/Load.png"),width,height);
        savebt = makeBt(new Image("./image/Save.png"),width,height);
        exitbt = makeBt(new Image("./image/Exit.png"),width,height);
        toolbox.getChildren().addAll(newbt,loadbt,savebt,exitbt);
        return toolbox;
    }


    public Button makeBt(Image icon,int width,int height){
        Button bt = new Button();
        bt.setGraphic(new ImageView(icon));
        bt.setPrefWidth(width);
        bt.setPrefHeight(height);
        return bt;
    }

    public void setUpGameField(){
        setUpToolBox();
        setUpGameHeading();
        setUpFigure();
        setUpCharBox();
        setUpStartGame();
        setUpButtons();
    }

    public void setUpToolBox(){
        HBox toolbox = makeToolBox(primaryStage);
        HBox toolboxBackground = new HBox();
        root.add(toolboxBackground,0,0);
        hboxLineUpWithWindow(toolbox,toolboxBackground,"-fx-background-color: black;");
        root.add(toolbox,0,0);
        GridPane.setMargin(toolbox,new Insets(20,10,10,10));
    }

    public VBox setUpAlphabetBox(){
        VBox charBoard = new VBox();
        setUpScoreBoard();
        charBoard.getChildren().add(scoreHolder);
        alphabetBox = charBox.createAlphabetBox();
        c.setScenePressed(scene,alphabetBox);
        answerbox = setUpAnswerBox();
        charBoard.getChildren().add(answerbox);
        HBox box = new HBox(5);
        int row = -1;
        for(StackPane h : alphabetBox){
            row += 1;
            if(row%10 == 0){
                charBoard.getChildren().add(box);
                box = new HBox(5);
            }
            box.getChildren().add(h);
        }
        charBoard.getChildren().add(box);
        charBoard.setAlignment(Pos.CENTER_RIGHT);
        charBoard.setTranslateX(600);
        charBoard.translateXProperty().bind(scene.widthProperty().divide(2));
        charBoard.translateYProperty().bind(scene.heightProperty().divide(16).add(-50));
        return charBoard;
    }

    public void setUpGameHeading(){
        HBox text = new HBox();
        root.add(text,0,1);
        text.prefWidthProperty().bind(primaryStage.widthProperty());
        Text gameName = new Text("Hangman");
        gameName.setFont(Font.font("Alegreya", FontWeight.BOLD, FontPosture.REGULAR, 50));
        headingFontSize.bind(scene.widthProperty().divide(25));
        gameName.styleProperty().bind(Bindings.concat("-fx-font-size: ", headingFontSize.asString(), ";"));
        text.setAlignment(Pos.CENTER);
        text.getChildren().add(gameName);
        text.setVisible(false);
    }


    public void setUpCharBox(){
        charBoxHolder =  setUpAlphabetBox();
        c.initializeClickedBoolean();
        root.add(charBoxHolder,0,2);
        charBoxHolder.setVisible(false);
    }

    public void setUpFigure(){
        Pane figurePane = new Pane();
        figure.createHangMan();
        root.add(figurePane,0,2);
        for(int i = 0; i < figure.hangman.size();i++){
            figurePane.getChildren().add((figure.hangman.get(i)));
            figure.hangman.get(i).setVisible(false);
        }
        figurePane.translateXProperty().bind(scene.widthProperty().divide(16).add(-100));
        figurePane.translateYProperty().bind(scene.heightProperty().divide(16).add(-50));
        figurePane.setVisible(false);
    }

    public HBox setUpAnswerBox(){
            int answerSize = c.getAnswer().length();
            HBox ab = new HBox(5);
            for(int i = 0; i < answerSize; i++){
                char ch = c.getAnswer().charAt(i);
               StackPane sp = charBox.setUpABox(ch,false);
               ab.getChildren().add(sp);
            }
            return ab;
    }

    public void setUpScoreBoard(){
            guessBox = new HBox();
            Text guessScore = new Text("Guess: " + c.getGuess());
            guessBox.getChildren().add(guessScore);
            remainBox = new HBox();
            Text remaining =  new Text("Remaining: " + c.getRemain());
            guessScore.setFont(Font.font("Alegreya", FontWeight.BOLD, FontPosture.REGULAR, 15));;
            remaining.setFont(Font.font("Alegreya", FontWeight.BOLD, FontPosture.REGULAR, 15));
            remainBox.getChildren().add(remaining);
            scoreHolder.getChildren().addAll(guessBox,remainBox);
    }

    public void setUpStartGame(){
            HBox startPlay = new HBox();;
            startPlay.setAlignment(Pos.CENTER);
            startPlay.getChildren().add(btplay);
            root.add(startPlay,0,3);
            startPlay.setTranslateY(50);
            startPlay.translateXProperty().bind(scene.widthProperty().divide(16).add(-75));
            startPlay.translateYProperty().bind(scene.heightProperty().divide(8));
            startPlay.setVisible(false);
    }

    public void hboxLineUpWithWindow(HBox box,HBox backGround, String color){
        box.prefHeightProperty().bind(box.heightProperty().multiply(0.1));
        box.prefWidthProperty().bind(box.widthProperty());
        backGround.setStyle(color);
    }

    public void updateGuess(){
            scoreHolder.getChildren().remove(guessBox);
            guessBox = new HBox();
            Text newGuess = new Text("Guess: " + c.getGuess());
            newGuess.setFont(Font.font("Alegreya", FontWeight.BOLD, FontPosture.REGULAR, 15));
            guessBox.getChildren().add(newGuess);
            scoreHolder.getChildren().add(0,guessBox);
    }

    public void updateRemaining(){
            scoreHolder.getChildren().remove(remainBox);
            remainBox = new HBox();
            Text newRemaining = new Text("Remain: " + c.getRemain());
            newRemaining.setFont(Font.font("Alegreya", FontWeight.BOLD, FontPosture.REGULAR, 15));
            remainBox.getChildren().add(newRemaining);
            scoreHolder.getChildren().add(1,remainBox);
    }

    public void setUpButtons(){
        btplay.setOnAction(e -> {
            c.startPlay();
            c.m.setGameEnd(false);
            btplay.setDisable(true);
        });

        newbt.setOnAction((e -> {
            try {
                if (c.m.isGameEnd()) {
                    resetView();
                    root.getChildren().stream().forEach(x -> x.setVisible(true));
                } else {
                    if(savebt.isDisable())
                        resetView();
                    else
                        displaySaveWindow();
                }
            }catch (IOException ex) {
                ex.printStackTrace();
            } catch (URISyntaxException ex) {
                ex.printStackTrace();
            }
        }));

        savebt.setOnAction(e ->{
            try {
                c.saveGame();
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        });
        savebt.setDisable(true);

        loadbt.setOnAction(e -> {
            try {
                File file = c.loadFile();
                if(file != null)
                    reloadView();
            } catch (IOException ex) {
                ex.printStackTrace();
            } catch (ClassNotFoundException ex) {
                ex.printStackTrace();
            }
        });

        exitbt.setOnAction(e ->{
            if(savebt.isDisable())
                System.exit(0);
            else
                displayExitWindow();
        });
    }

    public void reloadView(){
            scoreHolder.getChildren().removeAll(guessBox,remainBox);
            answerbox = setUpAnswerBox(); //Create new answer box
            root.getChildren().remove(charBoxHolder);
            charBoxHolder = setUpAlphabetBox();
            c.reloadBoxes();
            root.add(charBoxHolder,0,2);
            reloadHangman();
            c.m.setPlaying(true);
            btplay.setDisable(true);
            savebt.setDisable(true);
            root.getChildren().stream().forEach(x -> x.setVisible(true));
    }


    public void reloadHangman(){
        int bound = figure.hangman.size();
        for(int i = 0; i < bound; i++){
            figure.hangman.get(i).setVisible(false);
        }
        int lifeleft = 10 - c.getGuess();
        for(int i = 0; i < lifeleft; i++){
            figure.hangman.get(i).setVisible(true);
        }
    }

    public void resetView() throws IOException, URISyntaxException {
        scoreHolder.getChildren().removeAll(guessBox,remainBox);
        c.newGame();
        root.getChildren().remove(charBoxHolder);
        charBoxHolder = setUpAlphabetBox();
        c.resetClickedBoolean();
        root.add(charBoxHolder,0,2);
        reloadHangman();
        savebt.setDisable(true);
        btplay.setDisable(false);
        c.m.setGameEnd(true);
        c.m.setPlaying(false);
    }

    public void displayLosingWindow(){
            DialogWindow loseWindow = new DialogWindow("GAME OVER!","You Lose! Answer(" + c.getAnswer() + ")"  );
            loseWindow.initialWindow();
            loseWindow.stage.show();
    }

    public void displayWinningWindow(){
        DialogWindow winningWindow = new DialogWindow("GAME OVER!","You won!!!!");
        winningWindow.initialWindow();
        winningWindow.stage.show();
    }

    public void displaySaveWindow(){
        DialogWindow saveWindow = new DialogWindow("New Game?", "Do you want to save this game?");
        saveWindow.initializeSaveWindow();
        HBox buttonHolder = (HBox) saveWindow.box.getChildren().get(1);
        Button btOk = (Button) buttonHolder.getChildren().get(0);
        btOk.setOnAction( e -> {
            try {
                c.saveGame();
                resetView();
                saveWindow.stage.close();
            } catch (IOException | URISyntaxException ex) {
                ex.printStackTrace();
            }
        });
        Button btNo = (Button) buttonHolder.getChildren().get(1);
        btNo.setOnAction(e -> {
            try {
                resetView();
                c.m.setPlaying(false);
                saveWindow.stage.close();
            } catch (IOException | URISyntaxException ex) {
                ex.printStackTrace();
            }
        });
        saveWindow.stage.show();
    }


    public void displayExitWindow(){
        DialogWindow saveWindow = new DialogWindow("Exit", "Do you want to save this game?");
        saveWindow.initializeSaveWindow();
        HBox buttonHolder = (HBox) saveWindow.box.getChildren().get(1);
        Button btOk = (Button) buttonHolder.getChildren().get(0);
        btOk.setOnAction( e -> {
            try {
                c.saveGame();
                System.exit(0);
                saveWindow.stage.close();
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        });
        Button btNo = (Button) buttonHolder.getChildren().get(1);
        btNo.setOnAction(e -> {
            System.exit(0);
        });
        saveWindow.stage.show();
    }



    public HangManFigure getFigure() {
        return figure;
    }
}
