<?php

namespace App\Tool;

class Session {

  public function __construct() {
    return;
  }

  public function init() {
    // Config before start
    session_start();
  }

  public function regenerate() {
    session_regenerate_id();

    $fingerprint = $this->fingerprint_gen(session_id());
    $this->set("fingerprint", $fingerprint);
  }

  public function terminate() {
    $_SESSION = [];
    if (isset($_COOKIE["PHPSESSID"])) {
      setcookie("PHPSESSID", '', time() - 1800, '/');
    }
    session_destroy();
  }

  public function fingerprint_gen($sess_id) {
    $str = "";
    $str .= $sess_id;
    $str .= $_SERVER["REMOTE_ADDR"];
    return $fingerprint = hash("SHA256", $str);
  }

  public function fingerprint_evaluate($sess_id) {
    $request_fingerprint = $this->fingerprint_gen($sess_id);
    if (!empty($_SESSION["fingerprint"]) && $request_fingerprint === $_SESSION["fingerprint"]) {
      return true;
    } else {
      return false;
    } 
  }

  public function set($key, $val) {
    $_SESSION[$key] = $val;
  }

  public function get($key) {
    return $_SESSION[$key];
  }
}