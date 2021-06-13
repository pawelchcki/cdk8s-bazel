load("@rules_python//python:defs.bzl", "py_binary")
load("@cdk8s_py_deps//:requirements.bzl", "requirement")

py_binary(
  name = "simple",
  srcs = ["simple.py"],
  deps = [
      requirement("constructs"),
      "//cdk8s_py/api/k8s"
  ]
)

genrule(
    name = "mhh",
    srcs = [],
    outs = ["dup.yaml"],
    cmd = "./$(location simple) > \"$@\"",
    tools = ["simple"],
)