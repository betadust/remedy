# remedy · B 站信息提醒备忘录

一个聚合展示 B 站个人关注信息的 Flutter 备忘录应用。定位是「信息提醒」而非「第三方客户端」——它帮你汇总特别关注的动态、收藏和稍后再看，点击内容跳转到 B 站查看，本身不承载播放、弹幕、评论等 B 站原生功能。

## 功能

- **扫码登录**：B 站二维码登录，自动轮询扫码状态并维护登录会话（Cookie）
- **首页信息流**：聚合特别关注 UP 主的动态，按「视频 / 动态」分类展示，支持视频、文字、图片三种动态类型
- **稍后再看**：每日随机推荐若干稍后再看视频（数量可配置），两列网格展示
- **收藏**：展示公开收藏夹（可展开浏览），并每日随机推荐一个收藏的视频
- **设置**：稍后再看推荐数量、首页动态显示天数，本地持久化
- **点击跳转**：所有视频 / 动态点击后跳转到 B 站对应页面

## 技术栈

- **Flutter / Dart**（跨平台，Android + iOS）
- **Provider**：全局状态管理
- **网络**：dio、bilibili_api、自封装 B 站 Web 私有接口
- **本地存储**：shared_preferences
- **其他**：qr_flutter（二维码）、url_launcher（跳转）
- **CI**：GitHub Actions 远程 iOS 构建（Windows 本地开发 + macOS 云端打包）

## 架构

采用分层架构，各层职责单一、解耦：

```
lib/
├── api/          # 网络请求封装（登录、收藏夹、稍后再看、特别关注）
├── stores/       # 全局状态（UserStore、SettingsStore）
├── models/       # 数据模型
├── components/   # 页面子组件（按页面分子目录）
├── pages/        # 页面（Home / Favorite / Profile / Login / Settings）
├── routes/       # 路由
├── constants/    # 颜色等常量
├── theme/        # 全局主题（B 站风格）
└── utils/        # 工具（网络重试等）
```

## 技术要点

- **自封装 B 站私有 Web 接口**：收藏夹、稍后再看、特别关注、动态 feed 等接口均无官方 SDK，通过逆向分析 B 站 Web API 自行封装
- **防御式 JSON 解析**：B 站接口字段类型不稳定（如 `pub_ts` 可能为 int 或 String），统一做类型兼容处理，规避第三方解析库的强转崩溃
- **网络重试机制**：对抖动导致的请求失败自动重试
- **多类型动态解析**：动态 feed 中的视频 / 文字 / 图片三种类型统一解析为结构化模型

## 构建

```bash
# 本地开发（Android 模拟器）
flutter run

# iOS 远程构建（Windows 环境，通过 builder CLI 触发 GitHub Actions）
builder ios build
```

> 未签名的 IPA 需通过 AltStore / Sideloadly 等工具侧载。
