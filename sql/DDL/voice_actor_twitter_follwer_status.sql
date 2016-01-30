CREATE TABLE `voice_actor_twitter_follwer_status` (
  `voice_actor_master_id` int(11) NOT NULL,
  `follower` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `favourites_count` int(11) DEFAULT NULL,
  `friends_count` int(11) DEFAULT NULL,
  `listed_count` int(11) DEFAULT NULL,
  `screen_name` varchar(255) DEFAULT NULL,
  `profile_image_url` varchar(255) DEFAULT NULL,
  `statuses_count` int(11) DEFAULT NULL,
  `raw_data` text,
  PRIMARY KEY (`voice_actor_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;