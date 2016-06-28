CREATE TABLE `voice_actor_follow_exchange_hisories` (
  `twitter_account` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `friend_account` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `note` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `get_date` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  KEY `twitter_account` (`twitter_account`),
  KEY `friend_account` (`friend_account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;