# github-workspace-template

一套"多项目 → GitHub"的工作区约定和脚手架：一个目录一个仓库，密钥永不入库，推之前必检。

不依赖任何 API 上传脚本，全程标准 `git` 命令。

## 为什么不用 API 上传

没有 git 的时候，可以用 GitHub REST API 逐文件建 blob、拼 tree、提 commit——能跑通，但：

- 每改一次都得写脚本，没法 `git diff` / `git log` / 回滚
- 容易漏掉 `.gitignore` 规则，把密钥或大文件带上去
- 别人没法直接 clone 协作

装了 git 之后这些都消失。**API 只适合一次性初始化空仓库。**

## 工作区长这样

```
workspace/
├── README.md              约定
├── _template/             新项目模板
│   ├── .gitignore
│   └── README.md
└── my-project/            一个目录一个仓库
```

## 一次性配置

```bash
# 1. 安装 Git（Windows）
winget install --id Git.Git -e --source winget

# 2. 登录 GitHub CLI
gh auth login --web

# 3. 让 git 复用 gh 的凭据（之后 push 不用输密码）
gh auth setup-git
```

或者直接跑本仓库的 `scripts/setup-git.ps1`，它会把身份、默认分支、凭据助手一次配好。

## 新项目

```bash
cp -r _template my-project && cd my-project
# 写代码
git init
git add -A
git commit -m "initial commit"
gh repo create my-project --private --source . --push
```

## 每次提交前

```bash
# 扫密钥
grep -rEn 'sk-[A-Za-z0-9]{16,}|ghp_[A-Za-z0-9]{20,}|ark-[A-Za-z0-9]{8,}' . --exclude-dir=.git

# 确认 .gitignore 生效
git status --short
```

## 必须写进 .gitignore 的东西

| 类别 | 例子 |
|---|---|
| 密钥 | `config.json`、`.env`、`*.key` |
| 依赖 | `node_modules/`、`.venv/` |
| 数据 | `*.db`、`data/` |
| 日志 | `*.log` |
| 个人素材 | 照片、截图、他人版权图 |

## License

MIT
