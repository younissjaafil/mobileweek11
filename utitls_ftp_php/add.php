<?php
// CORS headers to allow cross-origin requests
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");
header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");

$name = addslashes(strip_tags($_GET['name']));
$quantity = addslashes(strip_tags($_GET['quantity']));
$price = addslashes(strip_tags($_GET['price']));
$cid = addslashes(strip_tags($_GET['cid']));

$con=mysqli_connect("fdb1032.awardspace.net", "4716334_productsdb", "youniss12345", "4716334_productsdb");

// Check connection
if (mysqli_connect_errno())
  {
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
  exit();
  }

// Insert the new product
$sql = "INSERT INTO products (name, quantity, price, cid) VALUES ('$name', $quantity, $price, $cid)";

if (mysqli_query($con, $sql))
  {
  $new_pid = mysqli_insert_id($con);
  echo json_encode(array("success" => true, "message" => "Product added successfully", "pid" => $new_pid));
  }
else
  {
  echo json_encode(array("success" => false, "message" => "Error adding product: " . mysqli_error($con)));
  }

mysqli_close($con);

?>
