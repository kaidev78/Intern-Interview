/*
Name: Kaiwen Chen
ID: 111968628
NETID: KAIWECHEN
 */

import javafx.application.Application;
import javafx.stage.Stage;
import java.io.IOException;
import java.net.URISyntaxException;

public class Hangman extends Application {

    public static void main(String[] args) {
        launch(args);
    }

    @Override
    public void start(Stage primaryStage) throws IOException, URISyntaxException {
        Model m = new Model();
        View v = new View();
        Controller c = new Controller(m,v);
        v.setController(c);
        v.initializeStageView(primaryStage,"HangMan");
        primaryStage.show();
    }
}
