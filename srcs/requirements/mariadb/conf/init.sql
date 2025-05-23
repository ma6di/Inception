-- 🔄 Select the WordPress database to operate on
-- ✅ This database should have been created in entrypoint.sh using $DB_NAME
USE wordpress;

-- 🧪 Example: Create a test table if it doesn't exist
-- ✅ This is a placeholder to verify database initialization works
-- ⚠️ You can replace this with actual WordPress-related inserts if needed
CREATE TABLE IF NOT EXISTS test (
    id INT AUTO_INCREMENT PRIMARY KEY,  -- 🔢 Auto-incrementing ID column
    value VARCHAR(255) NOT NULL         -- 📝 Column to store text values (up to 255 characters)
);
