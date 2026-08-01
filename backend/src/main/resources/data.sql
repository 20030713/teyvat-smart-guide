MERGE INTO t_region KEY(id) VALUES
 (1,'mondstadt','蒙德','风与自由的诗篇','#68b9b0',1),
 (2,'liyue','璃月','山海契约与灯火','#c99352',2),
 (3,'inazuma','稻妻','雷光映照的群岛','#9b78bc',3),
 (4,'sumeru','须弥','雨林与沙海的智慧','#6f9d63',4),
 (5,'fontaine','枫丹','水都、艺术与律法','#5d95c9',5);
MERGE INTO t_location KEY(id) VALUES
 (101,'mondstadt','风起原野','秘境','沿着湖风穿过高地，适合日落前抵达。','https://images.pexels.com/photos/7232/pexels-photo.jpg?auto=compress&cs=tinysrgb&w=1400',4.9,2.4,'风景,徒步,日落',TRUE),
 (102,'liyue','云来山径','地标','层峦与云海交叠的古道，晨雾时最有层次。','https://images.pexels.com/photos/9024240/pexels-photo-9024240.jpeg?auto=compress&cs=tinysrgb&w=1400',4.8,6.8,'云海,古道,摄影',TRUE),
 (103,'inazuma','鸣霞森社','人文','被古木包围的静谧参道，雨后灯影尤其动人。','https://images.pexels.com/photos/9972602/pexels-photo-9972602.jpeg?auto=compress&cs=tinysrgb&w=1400',4.7,8.1,'神社,森林,文化',FALSE),
 (104,'sumeru','赤砂绿洲','秘境','越过沙丘后出现的水与绿荫，是旅途中的惊喜。','https://images.pexels.com/photos/13921909/pexels-photo-13921909.jpeg?auto=compress&cs=tinysrgb&w=1400',4.9,12.6,'沙海,绿洲,探险',TRUE),
 (105,'fontaine','白露水庭','观景','湖畔聚落与远山相映，清晨水面如镜。','https://images.pexels.com/photos/414491/pexels-photo-414491.jpeg?auto=compress&cs=tinysrgb&w=1400',4.6,4.3,'湖泊,小镇,漫步',FALSE),
 (106,'mondstadt','苍风高地','营地','开阔的山脊营地，夜晚可见清晰星空。','https://images.pexels.com/photos/29053372/pexels-photo-29053372.jpeg?auto=compress&cs=tinysrgb&w=1400',4.5,14.2,'露营,星空,高地',FALSE);
MERGE INTO t_note KEY(id) VALUES
 (1,'空谷来客','', '云来山径','云海散开前的十分钟','六点从山脚出发，穿过石阶后正好遇见第一束光。建议带一壶热茶，风很大，但景色值得。','https://images.pexels.com/photos/9024240/pexels-photo-9024240.jpeg?auto=compress&cs=tinysrgb&w=900',328,CURRENT_TIMESTAMP),
 (2,'薄荷团子','', '风起原野','在风里收集一整个下午','沿湖的小路几乎没有难度，适合慢慢走。傍晚草坡的颜色会变成金绿色。','https://images.pexels.com/photos/7232/pexels-photo.jpg?auto=compress&cs=tinysrgb&w=900',214,CURRENT_TIMESTAMP);
MERGE INTO t_supply_voucher KEY(id) VALUES
 (1,'冒险家早餐补给','风起原野',36,100,DATEADD('DAY', 3, CURRENT_TIMESTAMP)),
 (2,'云来山径向导券','云来山径',12,50,DATEADD('DAY', 2, CURRENT_TIMESTAMP));

