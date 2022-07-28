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

Setup contents
```
❯ tree
.
├── index.md
└── vss (executable)

❯ cat index.md
# Open Sea

A static site generator

- [GitHub](https://github.com/zztkm)

```

Build your site
```
vss
```

Output
```
❯ tree
.
├── dist
│   └── index.html
├── index.md
└── vss

1 directory, 3 files

❯ cat dist/index.html 
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