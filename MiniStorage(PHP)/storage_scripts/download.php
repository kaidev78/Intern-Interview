<?php
if(isset($_GET["file"])){
    // Get parameters
    session_start();
    $file = urldecode($_GET["file"]); // Decode URL-encoded string
    $file_url = "../test_storage/" . $_SESSION['username'] . '/' . $file;
    header('Content-Type: application/octet-stream');
    header("Content-Transfer-Encoding: Binary"); 
    header("Content-disposition: attachment; filename=\"" . basename($file_url) . "\""); 
    readfile($file_url); 
    
}
?>