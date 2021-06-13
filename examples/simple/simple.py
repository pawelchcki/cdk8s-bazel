#!/usr/bin/env python
from constructs import Construct
from cdk8s import App, Chart
from cdk8s_py.api import k8s

class MyChart(Chart):
    def __init__(self, scope: Construct, id: str):
        super().__init__(scope, id)

        label = {"app": "hello-k8s"}
        ns = k8s.KubeNamespace(self, id=id, metadata=k8s.ObjectMeta(name=id))
        k8s.KubeStatefulSet(self, 'deployment',
                            metadata=k8s.ObjectMeta(namespace=ns.name),
                            spec=k8s.StatefulSetSpec(
                                replicas=1,
                                service_name=id,
                                selector=k8s.LabelSelector(match_labels=label),
                                template=k8s.PodTemplateSpec(
                                    metadata=k8s.ObjectMeta(labels=label),
                                    spec=k8s.PodSpec(
                                        containers=[
                                            k8s.Container(
                                                name='hello-kubernetes',
                                                image='paulbouwer/hello-kubernetes:1.7',
                                                ports=[k8s.ContainerPort(container_port=8080)])]))))


app = App()
MyChart(app, "sample")
app.synth()
