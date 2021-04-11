<?php
session_start();
$my_storage_path = "../test_storage/" . $_SESSION['username'] . '/';

//getting user uploaded file
$file = $_FILES['file'];

echo $file["tmp_name"];
echo "<br>";
echo $file['name'];
//saving files in uploads folder
move_uploaded_file($file["tmp_name"], $my_storage_path . $file['name']);
header('Location: ../storage.php');
?>

<!doctype html>
<html lang="en">
  <head>
    <title>Kai Server</title>

    <!-- Bootstrap core CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-giJF6kkoqNQ00vy+HMDP7azOuL0xtbfIcaT9wjKHr8RbDVddVHyTfAAsrekwKmP1" crossorigin="anonymous">

    <!-- Custom styles for this template -->
    <link href="./css/signin.css" rel="stylesheet">
  </head>

  <body>
    UPLOADED

    <a href="../storage.php">return</a>
  </body>

    
</html>