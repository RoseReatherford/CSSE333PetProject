<!DOCTYPE html> 

<?php
// Open a connection to the database
// (display an error if the connection fails)
#$conn = mysqli_connect('localhost', 'root', '') or die(mysqli_error());
#mysqli_select_db($conn, 'petProject') or die(mysqli_error());
?>

<html>
 
<html> 
<head> 
<title>Welcome!</title> 
</head> 
<body> 
 
<h1>Welcome to the Pet Project!</h1> 
 
<ul> 
 <li><a href="/Project/write_article.php">Write an article</a></li> 
 <li><a href="/Project/create_account.php">Create an account</a></li> 
</ul> 
 
<h2>Articles</h2> 


<?php
# Select the 30 most recent posts from our friendly posts view
#$posts = mysqli_query($conn, "SELECT user_name, post_body ".
#"FROM friendly_posts ".
#"ORDER BY created_at DESC ".
#"LIMIT 30");

# Display each post
#while ($row = mysqli_fetch_array($posts)) {
#echo '<p><strong>' . htmlspecialchars($row[0], ENT_QUOTES) . '</strong>: ' . htmlspecialchars($row[1], ENT_QUOTES) . '</p>';
//}
#?>
 
</body> 
</html> 
