<?php

class Connection
{
    public PDO $pdo;

    public function __construct()
    {
        $this->pdo = new PDO('mysql:server=localhost;dbname=name', 'username', 'password');
    }

    public function getUsers()
    {
        $statement = $this->pdo->prepare("SELECT username,password FROM server_user");
        $statement->execute();
        return $statement->fetchAll(PDO::FETCH_ASSOC);
    }


    public function register($user){
        $statement = $this->pdo->prepare("INSERT INTO server_user (username, password, type)
                                                VALUES (:username, :password, :type)");
        $statement->bindValue('username', $user->getUsername());
        $statement->bindValue('password', $user->getPassword());
        $statement->bindValue('type', $user->getType());
        return $statement->execute();
    }

    public function getAdmins(){
        $statement = $this->pdo->prepare("SELECT username,password FROM server_user WHERE type='super'");
        $statement->execute();
        return $statement->fetchAll(PDO::FETCH_ASSOC);
    }

}