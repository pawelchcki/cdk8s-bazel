"""
Macros for defining build of k8s yamls
"""
load("@rules_python//python:defs.bzl", "py_binary")
load("@cdk8s_py_deps//:requirements.bzl", "requirement")
load("//rules:gen_k8s_file.bzl", "gen_k8s_file")

def cdk8s_yaml(name, main = "", srcs = [], deps = []):
    py_binary(
        name = name + ".gen.tool",
        srcs = [main] + srcs,
        main = main,
        deps = [
            requirement("constructs"),
            requirement("cdk8s"),
            requirement("cdk8s-plus-17"),
            "@bazel_cdk8s//cdk8s_py/api/k8s"
        ] + deps, 
    )

    gen_k8s_file(name = name, tool = name + ".gen.tool")