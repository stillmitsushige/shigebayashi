# vss

Easy-to-use static site generator

![CI](https://github.com/zztkm/vss/workflows/CI/badge.svg)

## Caution

vss is still under development and the API is not stable.
Be aware that destructive changes will be made if you use it!

## Feature

- Easy to use
- Create site content with markdown

## Installation

### Get the binary
Download from [Releases](https://github.com/zztkm/vss/releases)

### Build from source

```
git clone https://github.com/zztkm/vss.git
cd vss

v install markdown

v . -o vss
```

## Usage

### Setup contents

Currently, be sure to configure the following

```
❯ tree  
.
├── about.md
├── config.toml
├── dist
│   ├── css
│   │   └── main.css
│   └── js
│       └── main.js
├── index.md
├── layouts
│   └── index.html
└── static
    ├── css
    │   └── main.css
    └── js
        └── main.js

```

❯ cat index.md
```markdown
# Open Sea

A static site generator

- [GitHub](https://github.com/zztkm)

[about page](./about.md)
```

❯ cat config.toml 
```toml
title = "Open Sea"
description = "Takumi Tsuruta's home page"
baseUrl = 'https://zztkm.github.io/vss/'
```

❯ cat layouts/index.html 
```html
<!DOCTYPE html>

<head>
    <meta charset="utf-8">
    <title>@title</title>
    <base href="@baseUrl">
    <meta name="description" content="@description" />
</head>

<body>
    @contents
</body>
```

Build your site
```
vss build
```

Output
```
❯ tree dist
dist
├── about.html
├── css
│   └── main.css
├── index.html
└── js
    └── main.js
```

❯ cat dist/index.html 
```html
<!DOCTYPE html>

<head>
    <meta charset="utf-8">
    <title>Open Sea</title>
    <base href="https://zztkm.github.io/vss/">
    <meta name="description" content="Takumi Tsuruta's home page" />
</head>

<body>
    <h1>Open Sea</h1>
<p>A static site generator</p>
<ul>
<li><a href="https://github.com/zztkm">GitHub</a></li>
</ul>
<p><a href="./about.html">about page</a></p>
</body>
```

## Example

Examples can be found at the [example](https://github.com/zztkm/vss/tree/main/example) directory.
