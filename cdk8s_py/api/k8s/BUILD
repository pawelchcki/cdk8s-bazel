load("@rules_python//python:defs.bzl", "py_library")

py_library(
    name = "k8s",
    srcs = ["__init__.py"],
    data = ["py.typed"],
    visibility = ["//visibility:public"],
    deps = ["//cdk8s_py/api/k8s/_jsii"],
)
