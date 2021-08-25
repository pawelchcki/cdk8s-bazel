load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
http_archive(
    name = "rules_python",
    url = "https://github.com/bazelbuild/rules_python/releases/download/0.2.0/rules_python-0.2.0.tar.gz",
    sha256 = "778197e26c5fbeb07ac2a2c5ae405b30f6cb7ad1f5510ea6fdac03bded96cc6f",
)

load("deps.bzl", "cdk8s_init")

cdk8s_init()

http_archive(
    name = "build_bazel_rules_nodejs",
    sha256 = "0fa2d443571c9e02fcb7363a74ae591bdcce2dd76af8677a95965edf329d778a",
    urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/3.6.0/rules_nodejs-3.6.0.tar.gz"],
)

load("@build_bazel_rules_nodejs//:index.bzl", "node_repositories", "npm_install")

node_repositories(
    node_version = "12.13.0",
    package_json = ["//ts:package.json"],
    yarn_version = "1.13.0",
)

npm_install(
    name = "npm",
    package_json = "//ts:package.json",
    symlink_node_modules = False,
    package_lock_json = "//ts:package-lock.json",
)

# load("@npm_bazel_typescript//:index.bzl", "ts_setup_workspace")

# ts_setup_workspace()
