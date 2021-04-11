import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.stage.Modality;
import javafx.stage.Stage;



public class DialogWindow {
    Stage stage = new Stage();
    private String title;
    private String message;
    private Scene scene;
    VBox box = new VBox();

    public DialogWindow(String title,String message){
        this.title = title;
        this.message = message;
    }
    public void initialWindow(){
        stage.initModality(Modality.APPLICATION_MODAL);
        setStageProp(title,300,200);
        setDialog();
    }

    public void setStageProp(String title, int width, int height){
        stage.setTitle(title);
        stage.setMinWidth(width);
        stage.setMinHeight(height);
    }

    public void setDialog(){
        Label label = new Label();
        label.setText(message);
        Button btOk = new Button("CLOSE");
        btOk.setOnAction(e -> stage.close());
        box.getChildren().addAll(label,btOk);
        box.setAlignment(Pos.CENTER);
        scene = new Scene(box);
        stage.setScene(scene);
    }

    public void initializeSaveWindow(){
        stage.initModality(Modality.APPLICATION_MODAL);
        setStageProp(title,300,200);
        dialogForSave();
    }

    public void dialogForSave(){
        box.getChildren().removeAll();
        Label label = new Label();
        label.setText(message);
        Button btOk = new Button("Yes");
        Button btNo = new Button("No");
        Button btCancel = new Button("Cancel");
        btCancel.setOnAction(e -> stage.close());
        HBox buttonHolder = new HBox();
        buttonHolder.getChildren().addAll(btOk,btNo,btCancel);
        buttonHolder.setTranslateY(25);
        buttonHolder.setTranslateX(25);
        box.getChildren().addAll(label,buttonHolder);
        box.setAlignment(Pos.CENTER);
        buttonHolder.setAlignment(Pos.CENTER);
        scene = new Scene(box);
        stage.setScene(scene);
    }


}
