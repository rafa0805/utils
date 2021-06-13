<?php

namespace App\Controller;

use App\Tool\Session;
use App\Tool\Token;

class FormController extends \App\Controller {
  
  public function run() {

    // セッションを開始する
    $this->sess = new Session();
    $this->sess->init();

    if ($_SERVER["REQUEST_METHOD"] === "POST") {
      $this->post();
    } else {
      $this->get();
    }

    $token = new Token();
    $this->sess->set("token", $token->generate());
    $this->sess->regenerate();
    return;
  }


  protected function get() {
    return;  
  }


  protected function post() {
    $this->examine();

    // バリデーション管理
    $this->post_data = $_POST;
    $this->post_data = $this->sanitize($this->post_data);
    if (!$this->validate($this->post_data)) {
      return;  
    }

    $this->sess->terminate();
    header('Location: http://my-super-form.com/posted.php');
    exit; 
  }


  protected function examine() {
    // セッションフィンガープリントの確認
    if (empty($_SESSION["fingerprint"]) || !$this->sess->fingerprint_evaluate($_COOKIE["PHPSESSID"])) {
      echo "invalid request!!";
      exit;
    }
    
    // トークン管理
    $token = new Token();
    if (empty($_POST["token"]) || !$token->validate($_POST["token"])) {
      echo "invalid token!!";
      exit;
    }
  }


  protected function sanitize($data) {
    // 作成予定
    return $data;
  }
  

  protected function validate($data) {
    // 作成予定
    return false;
  }
}