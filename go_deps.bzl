load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")

def go_deps(go_version = "1.18.3"):
    go_rules_dependencies()
    if go_version:
        go_register_toolchains(go_version)
