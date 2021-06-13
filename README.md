# cdk8s Bazel repository

The purpose of this repository is to host Bazel helpers for cdk8s kubernetes alternative to
Helm

## Usage
See: examples folder

### WORKSPACE
```python
## TODO: replace with http_repository
git_repository(name = "bazel_cdk8s", remote="https://github.com/pawelchcki/cdk8s-bazel-py.git")

load("@bazel_cdk8s//deps:python.bzl", "cdk8s_rules_python")

cdk8s_rules_python()

load("@bazel_cdk8s//:deps.bzl", "cdk8s_init")
cdk8s_init()
```

### BUILD

```python
load("@bazel_cdk8s//:rules.bzl", "cdk8s_yaml")

cdk8s_yaml(name="simple", main = "simple.py")
```

### simple.py

```python
#!/usr/bin/env python
from constructs import Construct
from cdk8s import App, Chart
from cdk8s_py.api import k8s

class MyChart(Chart):
    def __init__(self, scope: Construct, id: str):
        super().__init__(scope, id)
```

### Output:

```log
$ bazel build :simple.yaml

INFO: Analyzed target //:simple.yaml (0 packages loaded, 0 targets configured).
INFO: Found 1 target...
Target //:simple.yaml up-to-date:
  bazel-bin/simple.yaml
INFO: Elapsed time: 0.116s, Critical Path: 0.00s
INFO: 1 process: 1 internal.
INFO: Build completed successfully, 1 total action
```