CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(30) UNIQUE NOT NULL,
    password_hash VARCHAR(100) NOT NULL,
    bio VARCHAR(160) NULL,
    profile_picture_url VARCHAR(255) NULL,
    website VARCHAR(255) NULL,
    location VARCHAR(100) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Tweets (
    tweet_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    content TEXT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    likes_count INT DEFAULT 0,
    retweets_count INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

CREATE TABLE Followers (
    follower_id INT NOT NULL,
    followed_id INT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (follower_id, followed_id),
    FOREIGN KEY (follower_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (followed_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

CREATE TABLE Likes (
    like_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    tweet_id INT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (tweet_id) REFERENCES Tweets(tweet_id) ON DELETE CASCADE
);

CREATE TABLE Retweets (
    retweet_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    tweet_id INT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (tweet_id) REFERENCES Tweets(tweet_id) ON DELETE CASCADE
);

CREATE TABLE Comments (
    comment_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    tweet_id INT NOT NULL,
    content TEXT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (tweet_id) REFERENCES Tweets(tweet_id) ON DELETE CASCADE
);

CREATE TABLE Hashtags (
    hashtag_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(25) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Tweets_Hashtags (
    tweet_id INT NOT NULL,
    hashtag_id INT NOT NULL,
    PRIMARY KEY (tweet_id, hashtag_id),
    FOREIGN KEY (tweet_id) REFERENCES Tweets(tweet_id) ON DELETE CASCADE,
    FOREIGN KEY (hashtag_id) REFERENCES Hashtags(hashtag_id) ON DELETE CASCADE
);

CREATE TABLE Messages (
    message_id INT PRIMARY KEY AUTO_INCREMENT,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    content VARCHAR(248) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

CREATE TABLE Notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    notification_type ENUM('like', 'retweet', 'comment', 'follow', 'mention', 'message') NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

CREATE TABLE Advertisements (
    ad_id INT PRIMARY KEY AUTO_INCREMENT,
    advertiser_id INT NOT NULL,
    tweet_id INT NULL,
    budget DECIMAL(10,6) CHECK (budget >= 0),
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    FOREIGN KEY (advertiser_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (tweet_id) REFERENCES Tweets(tweet_id) ON DELETE SET NULL
);

CREATE TABLE Roles (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE User_Roles (
    user_id INT NOT NULL,
    role_id INT NOT NULL,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES Roles(role_id) ON DELETE CASCADE
);

CREATE TABLE Reports (
    report_id INT PRIMARY KEY AUTO_INCREMENT,
    reporter_id INT NOT NULL,
    reported_user_id INT NULL,
    reported_tweet_id INT NULL,
    reason TEXT NOT NULL,
    status ENUM('en attente', 'validé', 'rejeté') DEFAULT 'en attente',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reporter_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (reported_user_id) REFERENCES Users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (reported_tweet_id) REFERENCES Tweets(tweet_id) ON DELETE SET NULL
);

CREATE TABLE Moderation_Action (
    action_id INT PRIMARY KEY AUTO_INCREMENT,
    moderator_id INT NOT NULL,
    report_id INT NOT NULL,
    action_taken ENUM('avertissement', 'suspension', 'bannissement', 'suppression') NOT NULL,
    details TEXT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (moderator_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (report_id) REFERENCES Reports(report_id) ON DELETE CASCADE
);

CREATE TABLE User_Statistics (
    user_id INT PRIMARY KEY,
    tweets_count INT DEFAULT 0,
    likes_received INT DEFAULT 0,
    retweets_received INT DEFAULT 0,
    followers_count INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

CREATE TABLE Platform_Analytics (
    date DATE PRIMARY KEY,
    total_users INT NOT NULL,
    total_tweets INT NOT NULL,
    total_likes INT NOT NULL,
    total_retweets INT NOT NULL,
    total_reports INT NOT NULL
);

CREATE TABLE Developer_Application (
    app_id INT PRIMARY KEY AUTO_INCREMENT,
    developer_id INT NOT NULL,
    app_name VARCHAR(20) UNIQUE NOT NULL,
    api_key VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (developer_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

CREATE TABLE API_Usage_Logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    app_id INT NOT NULL,
    endpoint VARCHAR(255) NOT NULL,
    request_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    response_time_ms INT CHECK (response_time_ms >= 0),
    FOREIGN KEY (app_id) REFERENCES Developer_Application(app_id) ON DELETE CASCADE
);

CREATE TABLE User_Activity_Log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    action_type ENUM('connexion', 'changement de mot de passe', 'tentative échouée') NOT NULL,
    ip_address VARCHAR(45) NOT NULL,
    device_info TEXT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

CREATE TABLE Privacy_Settings (
    user_id INT PRIMARY KEY,
    profile_visibility ENUM('public', 'privé', 'amis') DEFAULT 'public',
    tweet_visibility ENUM('public', 'privé', 'amis') DEFAULT 'public',
    allow_follow_requests BOOLEAN DEFAULT TRUE,
    show_activity_status BOOLEAN DEFAULT TRUE,
    receive_messages_from_anyone BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);
