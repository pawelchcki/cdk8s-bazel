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
