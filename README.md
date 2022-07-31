# vss

A static site generator

## Caution

vss is still under development and the API is not stable.
Be aware that destructive changes will be made if you use it!


## Install

```
git clone https://github.com/zztkm/vss.git
cd vss

v vss.v
```

## Usage

### Setup contents

Currently, be sure to configure the following

```
❯ tree  
.
├── config.toml
├── dist
│   └── index.html
├── index.md
└── layouts
    └── _index.html
```

❯ cat index.md
```markdown
# Open Sea

A static site generator

- [GitHub](https://github.com/zztkm)
```

❯ cat config.toml 
```toml
title = "Open Sea"
```

❯ cat layouts/_index.html 
```html
<!DOCTYPE html>

<head>
    <meta charset="utf-8">
    <title>@title</title>
</head>
<body>
    @contents
</body>
```

Build your site
```
vss
```

### Output

```
❯ tree
.
├── dist
│   └── index.html
├── index.md
└── vss
```

❯ cat dist/index.html 
```html
<!DOCTYPE html>

<head>
    <meta charset="utf-8">
    <title>tsurutatakumi.info</title>
</head>
<body>
    <h1>Open Sea</h1>
<p>A static site generator</p>
<ul>
<li><a href="https://github.com/zztkm">GitHub</a></li>
</ul>
</body>
```