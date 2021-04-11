<?php
if(isset($_POST["file"])){
    // Get parameters
    session_start();
    $file = urldecode($_POST["file"]); // Decode URL-encoded string
    $file_url = "../test_storage/" . $_SESSION['username'] . '/' . $file;
    unlink($file_url);
    header("location: ../storage.php");
}
header("location: ../storage.php");
?>