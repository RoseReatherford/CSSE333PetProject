
CREATE TABLE Users(
	userID INT NOT NULL AUTO_INCREMENT,
	username VARCHAR(20) NOT NULL,
	hashed_password BINARY(20) NOT NULL,
	email VARCHAR(50) NOT NULL,
	title VARCHAR(10),
	verified BINARY(1) NOT NULL,
	PRIMARY KEY (usedID),
	UNIQUE KEY username (username),
	UNIQUE KEY hashed_password (hashed_password)
);

CREATE TABLE Articles(
	articleID INT NOT NULL AUTO_INCREMENT,
	article_name VARCHAR(60) NOT NULL,
	verify_status BINARY(1) NOT NULL,
	post_date DATETIME NOT NULL,
	author VARCHAR(20) NOT NULL,
	content TEXT NOT NULL,
	PRIMARY KEY (articleID),
	FOREIGN KEY (author) REFERENCES Users(userID)
);

CREATE TABLE Pets(
	petID INT NOT NULL AUTO_INCREMENT,
	rehome BINARY(1) NOT NULL,
	PRIMARY KEY (petID)
);

CREATE TABLE Species(
	scientific_name VARCHAR(60) NOT NULL,
	common_name VARCHAR(30) NOT NULL,
	animal_type VARCHAR(30) NOT NULL,
	coloration TEXT,
	PRIMARY KEY(scientific_name, animal_type)
);

CREATE TABLE PetPages(
	pet_name VARCHAR(30) NOT NULL,
	picture BLOB,
	info TEXT,
	breed_name VARCHAR(40),
	petID INT NOT NULL,
	PRIMARY KEY(petID),
	FOREIGN KEY(petID) REFERENCES Pets(petID)
);

CREATE TABLE Profiles(
	name VARCHAR(30) NOT NULL,
	location VARCHAR(40),
	bio TEXT,
	visible_email BINARY(1),
	userID INT NOT NULL,
	PRIMARY KEY(userID),
	FOREIGN KEY(userID) REFERENCES Users(userID)
);

CREATE TABLE Owners(
	userID INT NOT NULL,
	petID INT NOT NULL,
	PRIMARY KEY(userID, petID),
	FOREIGN KEY(userID) REFERENCES Users(userID),
	FOREIGN KEY(petID) REFERENCES Pets(petID)
);


--Password hashing function--
CREATE FUNCTION saltedHash(username VARCHAR(20), user_password VARCHAR(20))
RETURNS BINARY(20) DETERMINISTIC
RETURN UNHEX(SHA1(CONCAT(username, user_password)));

--Procedure to create an article
CREATE PROCEDURE createArticle(IN inUsername VARCHAR(20), IN inPassword VARCHAR(20), IN inArticleName VARCHAR(60), IN inContent TEXT)
BEGIN
	DECLARE UserID INT;
	DECLARE result VARCHAR(225);

	SELECT userID
	FROM Users
	WHERE username = inUsername
	AND hashed_password  = saltedHash(inUsername, inPassword)
	LIMIT 1
	INTO UserID

	IF UserID IS NULL THEN
		SET result = 'Invalid credentials';
	ELSE
		INSERT
			INTO Articles(article_name, verify_status, post_date, content, author)
			VALUES (inArticleName, NO, NOW(), inContent, inUsername);
			SET result = 'Post created!';
	END IF;

	SELECT result;
END