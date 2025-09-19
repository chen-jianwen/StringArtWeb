# 后端建表SQL使用说明

本文件为 StringArtWeb 项目后端 MySQL 数据库建表脚本，适用于新建数据库时初始化表结构。

## 一、准备工作
1. 安装 MySQL 数据库（推荐 5.7 及以上版本）。
2. 使用数据库管理工具（如 Navicat、DBeaver、命令行等）连接到你的 MySQL 服务器。
3. 新建数据库，例如：
   ```sql
   CREATE DATABASE stringartweb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   USE stringartweb;
   ```

## 二、执行建表脚本
1. 打开《后端建表SQL.sql》文件，复制全部内容。
2. 在数据库管理工具或命令行窗口粘贴并执行。
3. 若无报错，四张表（user、order、interrupt_step、gallery）将自动创建。

## 三、字段说明
- 所有主键均为自增。
- 用户表与订单表通过 user_id 外键关联（一对多）。
- 订单表与中断步骤表通过 order_id 外键关联（一对多）。
- 画廊表为独立表，存储预设作品。

## 四、常用操作示例
- 插入用户：
  ```sql
  INSERT INTO user (phone, username, password) VALUES ('13800000000', 'testuser', 'your_password_hash');
  ```
- 插入订单：
  ```sql
  INSERT INTO `order` (order_no, user_id, price, config_file) VALUES ('ORD20250919001', 1, 99.00, '{"shape":"circle"}');
  ```
- 插入中断步骤：
  ```sql
  INSERT INTO interrupt_step (order_id, step_info) VALUES (1, '{"step":10}');
  ```
- 插入画廊作品：
  ```sql
  INSERT INTO gallery (title, preview_img, config_file) VALUES ('作品A', '/img/a.png', '{"shape":"circle"}');
  ```

## 五、注意事项
- 密码字段建议存储加密后的哈希值。
- 外键约束如遇报错，请确保插入数据时先插入主表（如 user），再插入子表（如 order）。
- 如需批量导入数据，可使用 MySQL 的导入工具或脚本。

---
如需更多 SQL 示例或数据初始化脚本，请随时补充需求。