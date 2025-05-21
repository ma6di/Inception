-- Create the WordPress DB if not already done
CREATE DATABASE IF NOT EXISTS wordpress;

-- Create additional user (non-admin)
INSERT INTO wordpress.wp_users (
    user_login, user_pass, user_nicename, user_email,
    user_registered, user_status, display_name
)
VALUES (
    'editor', MD5('editorpass'), 'editor', 'editor@example.com',
    NOW(), 0, 'Editor'
)
ON DUPLICATE KEY UPDATE user_login=user_login;

-- Link role in wp_usermeta
-- WordPress auto-increments IDs; let's assume ID = 2, or use subqueries
INSERT INTO wordpress.wp_usermeta (user_id, meta_key, meta_value)
SELECT ID, 'wp_capabilities', 'a:1:{s:6:"editor";b:1;}' FROM wordpress.wp_users WHERE user_login = 'editor'
ON DUPLICATE KEY UPDATE meta_value=meta_value;

INSERT INTO wordpress.wp_usermeta (user_id, meta_key, meta_value)
SELECT ID, 'wp_user_level', '7' FROM wordpress.wp_users WHERE user_login = 'editor'
ON DUPLICATE KEY UPDATE meta_value=meta_value;
