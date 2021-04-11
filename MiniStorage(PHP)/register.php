<?php
    require_once './Connection.php';
    require_once './User.php';
    $error;

    session_start();
    $_SESSION['from'] = 'register';

    if(isset($_POST['password']) && isset($_POST['username'])){
        if(!username_validation($_POST['username'])){
            $error = "username already created";
        }
        else if(!password_validation($_POST['password'], $_POST['confirmPassword'])){
            $error = "passwords aren't matched";
        }
        else{
            $connection = new Connection();
            $newUser = new User($_POST['username'],password_hash($_POST['password'], PASSWORD_DEFAULT), 'normal');
            if($connection->register($newUser)){
                header('Location: index.php');
                exit();
            }
            else{
                $error = "server error: fail to create user";
            }
        }
    }

    function password_validation($pwd1, $pwd2){
        //simple check
        if($pwd1 != $pwd2){
            return false;
        }
        return true;
    }

    function username_validation($username){
        $connection = new Connection();
        $users = $connection->getUsers();
        foreach($users as $user){
            if($user['username'] == $username)return false;
        }

        return true;
    }

    if(array_key_exists('login', $_POST)){
        header('Location: index.php');
    }

?>


<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="Mark Otto, Jacob Thornton, and Bootstrap contributors">
    <meta name="generator" content="Hugo 0.79.0">
    <!-- <title>Signin Template · Bootstrap v5.0</title> -->
    <title>Kai Server</title>

    <!-- css -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-giJF6kkoqNQ00vy+HMDP7azOuL0xtbfIcaT9wjKHr8RbDVddVHyTfAAsrekwKmP1" crossorigin="anonymous">

    <!-- js -->
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>

    
    <!-- Custom styles for this template -->
    <link href="./css/register.css" rel="stylesheet">
  </head>
  <body class="register">
    <?php if(isset($error)){ ?>
        <div class="alert alert-warning" style= "visibility: visible">
    <?php }else{ ?>
        <div class="alert alert-warning" style= "visibility: hidden">
    <?php }; ?>
        <!-- Passwords doesn't match -->
            <?php echo $error ?>
        </div>

    <div class="form-signin">
        <form action="" method="post">
            <h1 class="h3 mb-3 fw-normal">Register Here</h1>
            <label for="inputEmail" class="visually-hidden">Email address</label>
            <input type="username" name='username' id="inputUsername" class="form-control" placeholder="Username"  required autofocus>
            <label for="inputPassword" class="visually-hidden">Password</label>
            <input type="password" name="password" id="inputPassword" class="form-control" placeholder="Password" required>
            <label for="inputConfirmPassword" class="visually-hidden">Confirm Password</label>
            <input type="password" name="confirmPassword" id="inputConfirmPassword" class="form-control" placeholder="Confirm Password" required>
            <button class="w-100 corner-button" type="submit">
                <span class="button-letter">Register</span>
            </button>
            <!-- <p class="mt-5 mb-3 text-muted">&copy; 2017-2020</p> -->
        </form>

        <form class="login_redirect" method="post">
            <button class="w-100 corner-button" type="submit" name="login">
                <span class="button-letter">Back</span>
            </button>
        </form>
    </div>
  </body>

</html>