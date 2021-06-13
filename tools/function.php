<?php

// サニタイジング用関数
function h($str)
{
  return htmlspecialchars($str, ENT_QUOTES, "UTF-8");
}