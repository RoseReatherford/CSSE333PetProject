<!DOCTYPE html> 
 
<?php
// Open a connection to the database
// (display an error if the connection fails)
#$conn = mysqli_connect('localhost', 'root', '') or die(mysqli_error());
#mysqli_select_db($conn, 'petProject') or die(mysqli_error());
?>
 
<html> 
<head> 
<title>New Article</title> 
</head> 
<body> 
 
<h1>New Article</h1> 
 
 <?php 
#if ($_SERVER['REQUEST_METHOD'] == 'POST') { 
 
# $username = $_POST['username']; 
# $password = $_POST['password']; 
# $post_body = $_POST['postbody']; 
 
# if (empty($post_body)) { 
# echo '<ul><li>You must post something!</li></ul>'; 
# } else { 
# $result = mysqli_query($conn, "CALL createPost('" . $username . "', 
# '" . $password . "', '" . $post_body . 
#"')"); 
# $row = mysqli_fetch_array($result); 
# $status = $row[0]; 
 
# echo '<ul><li>' . $status . '</li></ul>'; 
# } 
#} 
?> 

 
<form action="" method="post"> 
 <label for="username">Username</label><br/> 
 <input type="text" name="username"/><br/> 
 <label for="article_name">Article name</label><br/> 
 <input type="text" name="article_name"/><br/> 
 <label for="password">Password</label><br/>
 <input type="password" name="password"/><br/> 
 <label for="content">Article</label><br/> 
 <textarea name="content"></textarea><br/> 
 <input type="submit" value="Post"/><br/> 
</form> 
 
</body> 
</html> 