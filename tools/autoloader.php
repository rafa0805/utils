<?php

spl_autoload_register(function($class) {
  $prefix = "App";

  $str = str_replace("\\", "/", $class);
  if (strpos($str, $prefix) === 0) {
    $str = substr($str, strlen($prefix));
  }
  
  $filepath = __DIR__  . $str . ".php";
  if (file_exists($filepath)) {
    require_once($filepath);
  }
});