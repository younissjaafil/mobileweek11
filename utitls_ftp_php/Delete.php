<?php
// CORS headers to allow cross-origin requests
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");
header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");

$pid = addslashes(strip_tags($_GET['pid']));

$con=mysqli_connect("fdb1032.awardspace.net", "4716334_productsdb", "youniss12345", "4716334_productsdb");

// Check connection
if (mysqli_connect_errno())
  {
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
  exit();
  }

// Delete the product with the given pid
$sql = "DELETE FROM products WHERE pid = $pid";

if (mysqli_query($con, $sql))
  {
  if (mysqli_affected_rows($con) > 0) {
    echo json_encode(array("success" => true, "message" => "Product deleted successfully"));
  } else {
    echo json_encode(array("success" => false, "message" => "Product not found"));
  }
  }
else
  {
  echo json_encode(array("success" => false, "message" => "Error deleting product: " . mysqli_error($con)));
  }

mysqli_close($con);

?>
