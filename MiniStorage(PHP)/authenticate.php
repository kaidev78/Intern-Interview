<?php
    session_start();

    if(!isset($_SESSION['authenticate']) || !$_SESSION['authenticate']){
        header('Location: index.php');
        exit();
    }
?>