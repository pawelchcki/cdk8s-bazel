"""
Macros for defining build of k8s yamls
"""
load("@rules_python//python:defs.bzl", "py_binary")
load("@cdk8s_py_deps//:requirements.bzl", "requirement")

def cdk8s_yaml(name, main = "", srcs = [], deps = []):
    if main == "":
        main = name + ".py"

    py_binary(
        name = name,
        srcs = [main] + srcs,
        deps = [
            requirement("constructs"),
            requirement("cdk8s"),
            "@bazel_cdk8s//cdk8s_py/api/k8s"
        ] + deps, 
    )

    native.genrule(
        name = name + ".yaml.gen",
        srcs = [],
        outs = [name + ".yaml"],
        cmd = "./$(location " + name + "); cat dist/*.yaml > \"$@\"",
        tools = [name],
    )