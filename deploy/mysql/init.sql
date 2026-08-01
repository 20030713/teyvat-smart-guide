CREATE TABLE IF NOT EXISTS t_region (id BIGINT PRIMARY KEY,code VARCHAR(32) NOT NULL UNIQUE,name VARCHAR(64) NOT NULL,subtitle VARCHAR(128) NOT NULL,theme_color VARCHAR(16) NOT NULL,sort_order INT NOT NULL);
CREATE TABLE IF NOT EXISTS t_location (id BIGINT PRIMARY KEY,region_code VARCHAR(32) NOT NULL,name VARCHAR(80) NOT NULL,category VARCHAR(32) NOT NULL,description VARCHAR(512) NOT NULL,image_url VARCHAR(1024) NOT NULL,score DECIMAL(3,1) NOT NULL,distance_km DECIMAL(6,1) NOT NULL,tags VARCHAR(255) NOT NULL,featured BOOLEAN NOT NULL DEFAULT FALSE);
CREATE TABLE IF NOT EXISTS t_note (id BIGINT AUTO_INCREMENT PRIMARY KEY,user_name VARCHAR(64) NOT NULL,avatar VARCHAR(255),location_name VARCHAR(80) NOT NULL,title VARCHAR(120) NOT NULL,content VARCHAR(1000) NOT NULL,image_url VARCHAR(1024),liked INT NOT NULL DEFAULT 0,created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS t_supply_voucher (id BIGINT PRIMARY KEY,title VARCHAR(120) NOT NULL,location_name VARCHAR(80) NOT NULL,stock INT NOT NULL,total INT NOT NULL,end_at TIMESTAMP NOT NULL);
CREATE TABLE IF NOT EXISTS t_supply_order (id BIGINT AUTO_INCREMENT PRIMARY KEY,user_id BIGINT NOT NULL,voucher_id BIGINT NOT NULL,created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,UNIQUE KEY uk_order_user_voucher(user_id,voucher_id));

INSERT IGNORE INTO t_region VALUES (1,'mondstadt','蒙德','风与自由的诗篇','#68b9b0',1),(2,'liyue','璃月','山海契约与灯火','#c99352',2),(3,'inazuma','稻妻','雷光映照的群岛','#9b78bc',3),(4,'sumeru','须弥','雨林与沙海的智慧','#6f9d63',4),(5,'fontaine','枫丹','水都、艺术与律法','#5d95c9',5);
INSERT IGNORE INTO t_location VALUES
(101,'mondstadt','风起原野','秘境','沿着湖风穿过高地，适合日落前抵达。','https://images.pexels.com/photos/7232/pexels-photo.jpg?auto=compress&cs=tinysrgb&w=1400',4.9,2.4,'风景,徒步,日落',TRUE),
(102,'liyue','云来山径','地标','层峦与云海交叠的古道，晨雾时最有层次。','https://images.pexels.com/photos/9024240/pexels-photo-9024240.jpeg?auto=compress&cs=tinysrgb&w=1400',4.8,6.8,'云海,古道,摄影',TRUE),
(103,'inazuma','鸣霞森社','人文','被古木包围的静谧参道，雨后灯影尤其动人。','https://images.pexels.com/photos/9972602/pexels-photo-9972602.jpeg?auto=compress&cs=tinysrgb&w=1400',4.7,8.1,'神社,森林,文化',FALSE),
(104,'sumeru','赤砂绿洲','秘境','越过沙丘后出现的水与绿荫，是旅途中的惊喜。','https://images.pexels.com/photos/13921909/pexels-photo-13921909.jpeg?auto=compress&cs=tinysrgb&w=1400',4.9,12.6,'沙海,绿洲,探险',TRUE),
(105,'fontaine','白露水庭','观景','湖畔聚落与远山相映，清晨水面如镜。','https://images.pexels.com/photos/414491/pexels-photo-414491.jpeg?auto=compress&cs=tinysrgb&w=1400',4.6,4.3,'湖泊,小镇,漫步',FALSE),
(106,'mondstadt','苍风高地','营地','开阔的山脊营地，夜晚可见清晰星空。','https://images.pexels.com/photos/29053372/pexels-photo-29053372.jpeg?auto=compress&cs=tinysrgb&w=1400',4.5,14.2,'露营,星空,高地',FALSE);
INSERT IGNORE INTO t_note(id,user_name,location_name,title,content,image_url,liked) VALUES
(1,'空谷来客','云来山径','云海散开前的十分钟','六点从山脚出发，穿过石阶后正好遇见第一束光。建议带一壶热茶，风很大，但景色值得。','https://images.pexels.com/photos/9024240/pexels-photo-9024240.jpeg?auto=compress&cs=tinysrgb&w=900',328),
(2,'薄荷团子','风起原野','在风里收集一整个下午','沿湖的小路几乎没有难度，适合慢慢走。傍晚草坡的颜色会变成金绿色。','https://images.pexels.com/photos/7232/pexels-photo.jpg?auto=compress&cs=tinysrgb&w=900',214);
INSERT IGNORE INTO t_supply_voucher VALUES (1,'冒险家早餐补给','风起原野',36,100,DATE_ADD(NOW(),INTERVAL 3 DAY)),(2,'云来山径向导券','云来山径',12,50,DATE_ADD(NOW(),INTERVAL 2 DAY));

