						########### MANDATORY PROJECT 2 ###########

use ig_clone

alter table users                  ######## I have renamed the Attributes as per my suitability
rename column id to user_id               -- to solve all the Tasks ########
alter table photos
rename column id to photo_id
alter table tags
rename column id to tag_id
alter table comments
rename column id to comment_id

##Task 1 ||Create an ER diagram or draw a schema for the given database.||
        
	  

##Task 2 ||We want to reward the user who has been around the longest, Find the 5 oldest users.||
	     
         with
             oldest_users as(select user_id,username,created_at as date_of_join from users 
             order by created_at asc
             limit 5)
             select*from oldest_users

##Task 3 ||To target inactive users in an email ad campaign, find the users
		 -- who have never posted a photo.||
	
		with
	        users_activity as (select user_id,username,
		case
			when user_id not in (select user_id from photos) then 'inactive'
            else 'active'
			end as user_status from users)
            select*from users_activity where user_status='inactive'
        

##Task 4 ||Suppose you are running a contest to find out who got the most likes on a photo. 
           -- Find out who won?||
		
        select photo_id,count(user_id)from likes group by photo_id order by count(user_id)desc;

    with
	most_liked_photo as 
	  (select users.user_id,username, likes.photo_id,count(likes.user_id) as user_like_count from likes
       inner join photos on likes.photo_id=photos.photo_id
	   inner join users on photos.user_id=users.user_id
       group by photo_id having likes.photo_id=145)
       select * from most_liked_photo
           
##Task 5 ||The investors want to know how many times does the average user post.||

           select max(photo_id) from photos;
           select max(user_id) from users;

       with
           average_posts as(select users.user_id,username,count(photo_id) as total_posts,
           ceil(257/100) as avg_post from users
           inner join photos
           on users.user_id=photos.user_id
           group by user_id)
           select * from average_posts


##Task 6 ||A brand wants to know which hashtag to use on a post, and find the top 5 most used hashtags.||
      
      select tag_id,count(photo_id) from photo_tags group by tag_id order by count(photo_id)desc;
     
     with
         top_5_hashtags as (select tags.tag_id,tag_name,count(photo_id) as most_used_hashtags from tags
         inner join photo_tags
         on tags.tag_id=photo_tags.tag_id
         group by tag_id order by count(photo_id)desc
         limit 7)
         select*from top_5_hashtags 
         
##Task 7 ||To find out if there are bots, find users who have liked every single photo on the site.||
          
          select users.user_id,username,max(photo_id),count(photo_id) as user_liked_photos from users
          inner join likes
          on users.user_id=likes.user_id
          group by user_id having count(photo_id)=257 

##Task 8 ||Find the users who have created instagramid in may and select top 5 newest joinees from it?||

         with
            newest_joinees as (select user_id,username,created_at as date_of_join from users 
			where month(created_at)=5 order by created_at desc
            limit 5)
            select*from newest_joinees

##Task 9 ||Can you help me find the users whose name starts with c and 
	     -- ends with any number and have posted the photos as well as liked the photos?||
     
      create temporary table 
      c_users as (select user_id,username from users where username regexp'^c.*[0123456789]$')
      
      create temporary table 
      users_posts as(select users.user_id,count(photo_id) as photo_posted from users
      inner join photos
      on users.user_id=photos.user_id group by user_id)
     
     create temporary table 
      users_likes as (select users.user_id, count(photo_id) as photo_liked from users
      inner join likes
      on users.user_id=likes.user_id group by user_id)
      
      select c_users.user_id,username,photo_posted,photo_liked from c_users
      inner join users_posts on c_users.user_id=users_posts.user_id
      inner join users_likes on users_posts.user_id=users_likes.user_id
      

##Task 10 ||Demonstrate the top 30 usernames to the company who have posted photos 
          -- in the range of 3 to 5.||
         
         with
          users_postings as (select users.user_id,username,count(photo_id) as photo_posted from users
          inner join photos
          on users.user_id=photos.user_id
          group by user_id having count(photo_id) between 3 and 5
          order by count(photo_id) desc
          limit 30)
          select*from users_postings
          