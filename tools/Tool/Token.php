<?php
namespace App\Tool;

class Token {
  protected $token;

  public function __construct() {
    return;
  }

  // 入力のあるページで実行し、埋め込む
  public function generate() {
    $this->token = bin2hex(openssl_random_pseudo_bytes(32));
    return $this->token;
  }

  // POSTを処理するファイルで実行する
  public function validate($token) {
    $request_token = $_POST["token"];
    if (!empty($_SESSION["token"]) && $request_token === $_SESSION["token"]) {
      return true;
    } else {
      return false;
    } 
    
  }
}