CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20) UNIQUE
);

CREATE TABLE Posts (
    post_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    caption TEXT,
    image_url VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id));

CREATE TABLE Comments (
    comment_id SERIAL PRIMARY KEY,
    post_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    comment_text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Likes (
    like_id SERIAL PRIMARY KEY,
    post_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Followers (
    follower_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    follower_user_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (follower_user_id) REFERENCES Users(user_id)
);


INSERT INTO Users (name, email, phone_number)
VALUES
    ('John Smith', 'johnsmith@gmail.com', '1234567890'),
    ('Jane Doe', 'janedoe@yahoo.com', '0987654321'),
    ('Bob Johnson', 'bjohnson@gmail.com', '1112223333'),
    ('Alice Brown', 'abrown@yahoo.com', NULL),
    ('Mike Davis', 'mdavis@gmail.com', '5556667777');

-- Inserting into Posts table
INSERT INTO Posts (user_id, caption, image_url)
VALUES
    (1, 'Beautiful sunset', '<https://www.example.com/sunset.jpg>'),
    (2, 'My new puppy', '<https://www.example.com/puppy.jpg>'),
    (3, 'Delicious pizza', '<https://www.example.com/pizza.jpg>'),
    (4, 'Throwback to my vacation', '<https://www.example.com/vacation.jpg>'),
    (5, 'Amazing concert', '<https://www.example.com/concert.jpg>');

-- Inserting into Comments table
INSERT INTO Comments (post_id, user_id, comment_text)
VALUES
    (1, 2, 'Wow! Stunning.'),
    (1, 3, 'Beautiful colors.'),
    (2, 1, 'What a cutie!'),
    (2, 4, 'Aww, I want one.'),
    (3, 5, 'Yum!'),
    (4, 1, 'Looks like an awesome trip.'),
    (5, 3, 'Wish I was there!');

-- Inserting into Likes table
INSERT INTO Likes (post_id, user_id)
VALUES
    (1, 2),
    (1, 4),
    (2, 1),
    (2, 3),
    (3, 5),
    (4, 1),
    (4, 2),
    (4, 3),
    (5, 4),
    (5, 5);

-- Inserting into Followers table
INSERT INTO Followers (user_id, follower_user_id)
VALUES
    (1, 2),
    (2, 1),
    (1, 3),
    (3, 1),
    (1, 4),
    (4, 1),
    (1, 5),
    (5, 1);
	
SELECT * FROM  comments
SELECT * FROM  followers
SELECT * FROM  likes
SELECT * FROM  posts
SELECT * FROM  users

--Updating the caption of post_id
UPDATE posts
SET caption = 'best life ever'
WHERE user_id = 3

-- Selecting all the posts where user_id is 1

SELECT * FROM posts
WHERE user_id = 1

-- Selecting all the posts and ordering them by created_at in descending order

SELECT * FROM posts
ORDER BY created_at DESC;

-- Counting the number of likes for each post 
--and showing only the posts with more than 2 likes

SELECT 
p.post_id,
COUNT (l.like_id)
FROM posts as p
JOIN likes as l on l.post_id = p.post_id
GROUP BY (p.post_id)
HAVING COUNT(l.like_id) >2; 

-- Finding the total number of likes for all posts

SELECT SUM(num_likes) AS total_likes
FROM (
    SELECT COUNT(Likes.like_id) AS num_likes
    FROM Posts
    LEFT JOIN Likes ON Posts.post_id = Likes.post_id
    GROUP BY Posts.post_id
) AS likes_by_post;

-- Finding all the users who have commented on post_id 1
SELECT 
name 
from users
join comments on comments.user_id = users.user_id
where post_id =1;

  --writing it in another way (subquery)

SELECT name
FROM Users
WHERE user_id IN (
    SELECT user_id
    FROM Comments
    WHERE post_id = 1
);

-- Ranking the posts based on the number of likes
select post_id , likes_count, RANK() OVER (ORDER BY likes_count DESC)
FROM (SELECT 
post_id,
count(like_id) as likes_count
FROM likes
GROUP BY post_id) AS likes_by_post
;


-- Finding all the posts and their comments using a Common Table Expression (CTE)
WITH all_posts as (
SELECT *
FROM posts as p
LEFT JOIN comments as c on c.post_id= p.post_id)

SELECT * FROM all_posts


-- Categorizing the posts based on the number of likes

SELECT 
post_id,
CASE 
WHEN likes_count = 0 THEN 'no likes'
WHEN likes_count between 0 and 2 THEN 'few likes'
WHEN likes_count between 2 and 6 THEN 'many likes'
ELSE 'lot'
END AS category
FROM (SELECT 
post_id,
count(like_id) as likes_count
FROM likes
GROUP BY post_id) AS likes_by_post;

--Which users have liked post_id 2?
SELECT name FROM users WHERE user_id in (SELECT user_id
FROM likes
WHERE post_id = 2)

--Which posts have no comments

SELECT Posts.caption
FROM Posts
LEFT JOIN Comments ON Posts.post_id = Comments.post_id
WHERE Comments.comment_id IS NULL;

--Which posts were created by users who have no followers
SELECT Posts.caption
FROM Posts
JOIN Users ON Posts.user_id = Users.user_id
LEFT JOIN Followers ON Users.user_id = Followers.user_id
WHERE Followers.follower_id IS NULL;

--How many likes does each post have?

select p.caption, l.total
from posts as p
join (SELECT post_id, count(user_id) as total
from likes  
GROUP BY post_id) as l
ON p.post_id = l.post_id
;

--What is the average number of likes per post?

SELECT AVG(num_likes) AS avg_likes
FROM (
    SELECT COUNT(Likes.like_id) AS num_likes
    FROM Posts
    LEFT JOIN Likes ON Posts.post_id = Likes.post_id
    GROUP BY Posts.post_id
) AS likes_by_post;

--Which user has the most followers?
SELECT 
u.name,
count(f.follower_user_id) as total_follow
from users as u
join followers as f on f.user_id = u.user_id
group by u.name
order by total_follow DESC
LIMIT 1;

--Rank the users by the number of posts they have created.
with total_posts as
(SELECT 
u.name,
count(p.post_id) as total_posts
from users as u
join posts as p on p.user_id = u.user_id
group by u.name)

select 
name,
total_posts,
rank() over(order by total_posts) as ranking
from total_posts;

--Rank the posts based on the number of likes.

SELECT post_id, no_of_likes, RANK() OVER (ORDER BY no_of_likes DESC) AS rank
from (
SELECT 
l.post_id,
count(l.user_id) as no_of_likes
from likes as l
join posts as p on p.user_id = l.user_id
group by l.post_id) as xxx
;

--Find the cumulative number of likes for each post.


SELECT post_id, num_likes, SUM(num_likes) OVER (ORDER BY created_at) AS cumulative_likes
FROM (
    SELECT Posts.post_id, COUNT(Likes.like_id) AS num_likes, Posts.created_at
    FROM Posts
    LEFT JOIN Likes ON Posts.post_id = Likes.post_id
    GROUP BY Posts.post_id
) AS likes_by_post;

--Find all the comments and their users using a Common Table Expression (CTE)
WITH comment_users AS (
    SELECT Comments.comment_text, Users.name
    FROM Comments
    JOIN Users ON Comments.user_id = Users.user_id
)
SELECT *
FROM comment_users;

--Find all the followers and their follower users using a CTE.
WITH follower_users AS (
    SELECT Users.name AS follower, follower_users.name AS user_followed
    FROM Users
    JOIN Followers ON Users.user_id = Followers.follower_user_id
    JOIN Users AS follower_users ON Followers.user_id = follower_users.user_id
)
SELECT *
FROM follower_users;

--Find all the posts and their comments using a CTE.
WITH post_comments AS (
    SELECT Posts.caption, Comments.comment_text
    FROM Posts
    LEFT JOIN Comments ON Posts.post_id = Comments.post_id
)
SELECT *
FROM post_comments;

--Categorize the posts based on the number of likes.
SELECT
    post_id,
    CASE
        WHEN num_likes = 0 THEN 'No likes'
        WHEN num_likes < 5 THEN 'Few likes'
        WHEN num_likes < 10 THEN 'Some likes'
        ELSE 'Lots of likes'
    END AS like_category
FROM (
    SELECT Posts.post_id, COUNT(Likes.like_id) AS num_likes
    FROM Posts
    LEFT JOIN Likes ON Posts.post_id = Likes.post_id
    GROUP BY Posts.post_id
) AS likes_by_post;

--Categorize the users based on the number of comments they have made.
SELECT
    Users.name,
    CASE
        WHEN num_comments = 0 THEN 'No comments'
        WHEN num_comments < 5 THEN 'Few comments'
        WHEN num_comments < 10 THEN 'Some comments'
        ELSE 'Lots of comments'
    END AS comment_category
FROM Users
LEFT JOIN (
    SELECT user_id, COUNT(comment_id) AS num_comments
    FROM Comments
    GROUP BY user_id
) AS comments_by_user ON Users.user_id = comments_by_user.user_id;

--Categorize the posts based on their age.

SELECT
    post_id,
    CASE
        WHEN age_in_days < 7 THEN 'New post'
        WHEN age_in_days < 30 THEN 'Recent post'
        ELSE 'Old post'
    END AS age_category
FROM (
    SELECT post_id, CURRENT_DATE - created_at::DATE AS age_in_days
    FROM Posts
) AS post_ages;