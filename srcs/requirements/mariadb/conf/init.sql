-- ~/inception/srcs/requirements/mariadb/conf/init.sql

USE wordpress;
CREATE TABLE IF NOT EXISTS test (
    id INT AUTO_INCREMENT PRIMARY KEY,
    value VARCHAR(255) NOT NULL
);

