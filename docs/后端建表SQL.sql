-- 用户表
CREATE TABLE user (
    id INT PRIMARY KEY AUTO_INCREMENT,
    phone VARCHAR(20) UNIQUE NOT NULL,
    username VARCHAR(32) UNIQUE,
    password VARCHAR(128) NOT NULL,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 订单表
CREATE TABLE `order` (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_no VARCHAR(32) UNIQUE NOT NULL,
    user_id INT NOT NULL,
    price DECIMAL(10,2),
    config_file TEXT,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(id)
);

-- 中断步骤表
CREATE TABLE interrupt_step (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    step_info TEXT,
    interrupt_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES `order`(id)
);

-- 画廊表
CREATE TABLE gallery (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(64),
    preview_img VARCHAR(128),
    config_file TEXT
);
