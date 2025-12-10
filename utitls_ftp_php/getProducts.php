<?php
// CORS headers to allow cross-origin requests
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");

// Database credentials:
// Host: fdb1032.awardspace.net
// User: 4716334_productsdb
// Pass: youniss12345
// DB Name: 4716334_productsdb (Added as the fourth argument)
$con=mysqli_connect("fdb1032.awardspace.net", "4716334_productsdb", "youniss12345", "4716334_productsdb");

// Check connection
if (mysqli_connect_errno())
  {
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
  // Exit the script if connection fails
  exit(); 
  }

$sql = "select products.pid, products.name, products.quantity, products.price, categories.name category
from products
INNER JOIN categories on products.cid = categories.cid";
if ($result = mysqli_query($con,$sql))
  {
   $emparray = array();
   while($row =mysqli_fetch_assoc($result))
       $emparray[] = $row;

   echo(json_encode($emparray));
   // Free result set
   mysqli_free_result($result);
   mysqli_close($con);
}
// Optional: Add an else block for query failure
else {
    http_response_code(500); // Set status code to Internal Server Error
    echo json_encode(["error" => "Query failed: " . mysqli_error($con)]);
    mysqli_close($con);
}

?>