# Bazel wrapper for cdk8s

This bazel repository contains simple wrappers around [cdk8s](https://github.com/cdk8s-team/cdk8s) Python library.

It allows building Kubernetes configuration using Python objects, which might be prefferable over templating
yaml using text templating language.

## Usage
See: examples folder

### WORKSPACE
```python
## TODO: replace with http_repository once release is up
git_repository(name = "bazel_cdk8s", remote="https://github.com/pawelchcki/cdk8s-bazel.git")

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
from constructs import Construct, MetadataEntry
from cdk8s import App, Chart
from cdk8s_py.api import k8s

class MyChart(Chart):
    def __init__(self, scope: Construct, id: str):
        super().__init__(scope, id)

        label = {"app": id}
        hello_kubernetes = k8s.Container(
            name='hello-kubernetes',
            image='paulbouwer/hello-kubernetes:1.7',
            ports=[k8s.ContainerPort(container_port=8080)]
        )

        k8s.KubeStatefulSet(self, 'app-set',
                            spec=k8s.StatefulSetSpec(
                                replicas=1,
                                service_name=id,
                                selector=k8s.LabelSelector(match_labels=label),
                                template=k8s.PodTemplateSpec(
                                    metadata=k8s.ObjectMeta(labels=label),
                                    spec=k8s.PodSpec(
                                        containers=[hello_kubernetes]))))

app = App()
MyChart(app, "sample")
app.synth()
```

### Output:

```yaml
# $ bazel build :simple.yaml
# $ cat bazel-bin/sample.yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: sample-app-set-c8800f2b
spec:
  replicas: 1
  selector:
    matchLabels:
      app: sample
  serviceName: sample
  template:
    metadata:
      labels:
        app: sample
    spec:
      containers:
        - image: paulbouwer/hello-kubernetes:1.7
          name: hello-kubernetes
          ports:
            - containerPort: 8080
```