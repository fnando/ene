# Rationale

NPM can be installed as:

- folder
- git url
- NPM package (`package` and `@org/package`)
- NPM package from custom registry

## Versioning

https://docs.npmjs.com/misc/semver

| NPM             | Rubygems         | Description
|-----------------|------------------|--------------------------------------
| 1.1.0           | 1.1.0            | Use specific version
| ^1.0.0          | ~>1.0            | Caret upgrade all components but major
| ^1.1            | ~>1.1            | 
| ^1.1            | ~>1.1            | 
| ~1.0.0          | ~>1.0.0          | Tilde upgrade only last component
| ~1.1            | ~>1.1.0          | 
| 1.0.x           | ~>1.0.0          | `x` upgrade the specific component
| *               | >=0              | Any version
| >=1.1.0         | >=1.1.0          |
| >1.1.0          | >1.1.0           |
| <=1.1.0         | <=1.1.0          |
| =1.1.0          | 1.1.0            |
| v1.1.0          | 1.1.0            |
| _empty string_  | >=0              |
| 1.2.3 - 2.3.4   | >=1.2.3, <=2.3.4 |
| 1.2.3 - 2       | >=1.2.3, <2.4    |
| 1.1.0 || 2.1.0  | unavailable      |
