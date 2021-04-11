<?php

  require_once './Connection.php';
  // $connection = new Connection();
  // echo var_dump($connection->getUsers());
  session_start();


  $error;
  if(isset($_POST['username']) && isset($_POST['password'])){
    $connection = new Connection();
    $users = $connection->getUsers();
    foreach($users as $user){
      if($user['username'] == $_POST['username']){
        if(password_verify($_POST['password'], $user['password'])){
          $_SESSION['authenticate'] = true;
          $_SESSION['username'] = $user['username'];
          header('Location: home.php');
          exit();
        }
      }
    }
    $error = "unvalid account information";
  }





  if(array_key_exists('register', $_POST)){
    header('Location: register.php');
    exit();
  }

  function redirect_register(){
    echo "redirecting to register";
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

    <!-- <link rel="canonical" href="https://getbootstrap.com/docs/5.0/examples/sign-in/"> -->

    

    <!-- Bootstrap core CSS -->
<!-- <link href="../assets/dist/css/bootstrap.min.css" rel="stylesheet"> -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-giJF6kkoqNQ00vy+HMDP7azOuL0xtbfIcaT9wjKHr8RbDVddVHyTfAAsrekwKmP1" crossorigin="anonymous">



    
    <!-- Custom styles for this template -->
    <link href="./css/signin.css" rel="stylesheet">
  </head>



  <body class="text-center">
    <?php if(isset($error)){ ?>
        <div class="alert alert-warning">
        <?php echo $error ?>
        </div>
    <?php }; ?>


    <main class="form-signin">
      <form action="" method="post">
        <h1 class="h3 mb-3 fw-normal">Please sign in</h1>
        <label for="inputEmail" class="visually-hidden">Email address</label>
        <input type="username" name='username' id="inputUsername" class="form-control" placeholder="Username"  required autofocus>
        <label for="inputPassword" class="visually-hidden">Password</label>
        <input type="password" name="password" id="inputPassword" class="form-control" placeholder="Password" required>

        <button class="w-100 corner-button" type="submit">
          <span>Sign in</span>
        </button>
        <!-- <p class="mt-5 mb-3 text-muted">&copy; 2017-2020</p> -->
      </form>
      <form class="register_redirect" method="post">
        <button class="w-100 corner-button" type="submit" name="register">
          <span>Register</span>
        </button>
      </form>
    </main>

  </body>
</html>
