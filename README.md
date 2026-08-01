# 提瓦特智游 · Teyvat Smart Guide

一个以奇幻开放世界旅行为主题的本地探索与内容社区。项目参考“黑马点评”的业务链路，使用 Vue 3 + Spring Boot + MySQL + Redis 实现地点发现、冒险笔记、限量补给、签到与智能路线规划。

> 非官方学习项目，不使用《原神》官方美术资产，也不代表或暗示与米哈游存在合作关系。

## 已实现

- 响应式发现首页：地区筛选、搜索、地点卡片与详情弹窗
- 冒险笔记：热门列表、点赞接口与发布接口
- 限量补给：数据库条件扣减、单用户唯一约束与事务回滚
- 签到：Redis Hash 路径，Redis 不可用时自动回退本地演示状态
- 派蒙路线助手：路线规划 API、加载状态、抽屉式时间轴和收藏反馈
- H2 零依赖演示、MySQL/Redis Docker Compose 生产近似环境
- Actuator 健康检查与 CI（Java 21 / Node 24）

## 技术栈

- 前端：Vue 3、TypeScript、Vite、Pinia、Lucide
- 后端：Java 21、Spring Boot 4.1、Spring JDBC、Spring Data Redis
- 数据：MySQL 8.4、Redis 8；本地默认 H2
- 工程：Docker Compose、GitHub Actions

## 本地启动

无需数据库即可启动演示：

```bash
cd backend
mvn spring-boot:run
```

另开终端：

```bash
cd frontend
npm install
npm run dev
```

打开 <http://localhost:5173>。后端 API 位于 <http://localhost:8080/api>，健康检查位于 <http://localhost:8080/actuator/health>。

完整容器环境：

```bash
cd deploy
docker compose up --build
```

## 验证

```bash
cd backend && mvn test
cd frontend && npm run build
```

## 项目结构

```text
backend/      Spring Boot API 与测试
frontend/     Vue 3 Web 应用
deploy/       MySQL、Redis、前后端容器编排
docs/         视觉边界、素材来源与后续设计文档
performance/  后续 JMeter 计划与报告
```

## 下一阶段

当前版本是文档蓝图的可运行第一里程碑。后续按 M1–M9 继续加入验证码登录与分布式会话、Cache Aside/逻辑过期、Redis GEO、Bitmap、HyperLogLog、Redis Stream 秒杀订单、Feed 流、SSE 对话、RAG 和 JMeter 性能门禁。

素材与许可见 [docs/credits.md](docs/credits.md)，视觉边界见 [docs/brand-spec.md](docs/brand-spec.md)。
