<?php
    include "./authenticate.php";
    require_once './Server_Constant.php';
    // $my_storage_path = MY_STORAGE_PATH . '/' .$_SESSION['username'];
    $my_storage_path = "./test_storage/" . $_SESSION['username'];
    $my_download_path = "./storage_scripts/download.php?file=";
    if(!file_exists($my_storage_path)){
        mkdir($my_storage_path, 0777, true);
    }
    $files = scandir($my_storage_path);

    // if(array_key_exists('file_delete', $_POST)){
    //     header('Location: ./storage_scripts/delete.php');
    // }
?>


<!doctype html>
<html lang="en">
  <head>
    <title>Kai Server</title>

    <!-- Bootstrap core CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-giJF6kkoqNQ00vy+HMDP7azOuL0xtbfIcaT9wjKHr8RbDVddVHyTfAAsrekwKmP1" crossorigin="anonymous">

    <!-- Custom styles for this template -->
    <link href="./css/storage.css" rel="stylesheet">

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>

  </head>

    <form class="upload_box" method="POST" enctype="multipart/form-data" action="./storage_scripts/upload.php">
        <input type="file" name="file">
        <input type="submit" value="upload">
        <input type="hidden" value="<?php echo $_SESSION['username'] ?>">
    </form>

    <div class="file_list">
        <ul class="no-bullets">
            <?php for($i = 2; $i < count($files); $i++){ ?>
                <li>
                    <a href="<?php echo $my_download_path . urlencode($files[$i]) ?>" ><?php echo $files[$i] ?></a>
                    <form action='./storage_scripts/delete.php' method="POST">
                        <input type="hidden" name="owner" value="<?php echo $_SESSION['username'] ?>">
                        <input type="hidden" name="file" value="<?php echo urlencode($files[$i]) ?>">
                        <button class="file_delete" type="submit"  name="file_delete">delete</button>
                    </form>
                </li>
            <?php }?>
        </ul>
    </div>
    
</html>