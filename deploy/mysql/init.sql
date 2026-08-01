CREATE TABLE IF NOT EXISTS t_region (id BIGINT PRIMARY KEY,code VARCHAR(32) NOT NULL UNIQUE,name VARCHAR(64) NOT NULL,subtitle VARCHAR(128) NOT NULL,theme_color VARCHAR(16) NOT NULL,sort_order INT NOT NULL);
CREATE TABLE IF NOT EXISTS t_location (id BIGINT PRIMARY KEY,region_code VARCHAR(32) NOT NULL,name VARCHAR(80) NOT NULL,category VARCHAR(32) NOT NULL,description VARCHAR(512) NOT NULL,image_url VARCHAR(1024) NOT NULL,score DECIMAL(3,1) NOT NULL,distance_km DECIMAL(6,1) NOT NULL,tags VARCHAR(255) NOT NULL,featured BOOLEAN NOT NULL DEFAULT FALSE);
CREATE TABLE IF NOT EXISTS t_note (id BIGINT AUTO_INCREMENT PRIMARY KEY,user_name VARCHAR(64) NOT NULL,avatar VARCHAR(255),location_name VARCHAR(80) NOT NULL,title VARCHAR(120) NOT NULL,content VARCHAR(1000) NOT NULL,image_url VARCHAR(1024),liked INT NOT NULL DEFAULT 0,created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS t_supply_voucher (id BIGINT PRIMARY KEY,title VARCHAR(120) NOT NULL,location_name VARCHAR(80) NOT NULL,stock INT NOT NULL,total INT NOT NULL,end_at TIMESTAMP NOT NULL);
CREATE TABLE IF NOT EXISTS t_supply_order (id BIGINT AUTO_INCREMENT PRIMARY KEY,user_id BIGINT NOT NULL,voucher_id BIGINT NOT NULL,created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,UNIQUE KEY uk_order_user_voucher(user_id,voucher_id));

INSERT IGNORE INTO t_region VALUES (1,'mondstadt','蒙德','风与自由','#61b6aa',1),(2,'liyue','璃月','山海契约','#c99b52',2),(3,'inazuma','稻妻','雷光群岛','#9a79c7',3),(4,'sumeru','须弥','智慧之国','#72a34f',4),(5,'fontaine','枫丹','水都律法','#5c9dd2',5),(6,'natlan','纳塔','火与竞技','#d5654d',6);
INSERT IGNORE INTO t_location VALUES
(101,'mondstadt','明冠山地','观景点','在风与自由的国度，越过高地遥望蒙德城与苍蓝湖泊。','/assets/genshin/mondstadt.png',4.9,2.4,'风元素,观景,宝箱',TRUE),
(102,'liyue','璃月港夜景','地标','万家灯火映着海面，千帆与霄灯共同守望契约之城。','/assets/genshin/liyue.png',4.9,1.8,'岩元素,霄灯,摄影',TRUE),
(103,'inazuma','鸣神岛','人文','穿过绯樱飘落的参道，登上影向山感受雷光与永恒。','/assets/genshin/inazuma.png',4.8,3.6,'雷元素,绯樱,神社',FALSE),
(104,'sumeru','须弥雨林','秘境','巨木与智慧之城相映，在兰那罗的故乡寻找森林回声。','/assets/genshin/sumeru.png',4.8,5.2,'草元素,雨林,解谜',TRUE),
(105,'fontaine','枫丹廷','水都','乘上巡轨船穿越水道，欣赏正义之国宏伟的机械都市。','/assets/genshin/fontaine.png',4.7,2.1,'水元素,巡轨船,潜水',FALSE),
(106,'natlan','纳塔原野','探索','与龙同行越过炽热原野，在竞技与火焰中书写新的传奇。','/assets/genshin/natlan.png',4.9,6.4,'火元素,龙伙伴,竞技',TRUE);
INSERT IGNORE INTO t_note(id,user_name,location_name,title,content,image_url,liked) VALUES
(1,'空谷来客','璃月港','海灯亮起时，整座港口都在发光','从玉京台一路走到码头，恰好赶上霄灯升空。带一份杏仁豆腐，会是很璃月的夜晚。','/assets/genshin/liyue.png',328),
(2,'薄荷团子','鸣神岛','在绯樱树下等一场雷雨','沿参道慢慢登山，雨后的绯樱格外明亮。记得顺路采集绯樱绣球。','/assets/genshin/inazuma.png',214);
INSERT IGNORE INTO t_supply_voucher VALUES (1,'冒险阅历补给','每日委托',36,100,DATE_ADD(NOW(),INTERVAL 3 DAY)),(2,'传送锚点勘测券','七国通用',12,50,DATE_ADD(NOW(),INTERVAL 2 DAY));
