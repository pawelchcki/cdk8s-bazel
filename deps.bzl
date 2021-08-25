"""
Holds dependencies of cdk8s-bazel-py
"""
load("@rules_python//python:pip.bzl", "pip_install")

def cdk8s_init():
    pip_install(
        name = "cdk8s_py_deps",
        requirements = "@bazel_cdk8s//cdk8s_py:requirements.txt",
    )
