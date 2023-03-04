workspace(name = "io_bazel_rules_govulncheck")

# all dependencies are called from there
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

http_archive(
    name = "io_bazel_stardoc",
    sha256 = "c9794dcc8026a30ff67cf7cf91ebe245ca294b20b071845d12c192afe243ad72",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/stardoc/releases/download/0.5.0/stardoc-0.5.0.tar.gz",
        "https://github.com/bazelbuild/stardoc/releases/download/0.5.0/stardoc-0.5.0.tar.gz",
    ],
)

maybe(
    http_archive,
    name = "io_bazel_rules_go",
    sha256 = "685052b498b6ddfe562ca7a97736741d87916fe536623afb7da2824c0211c369",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.33.0/rules_go-v0.33.0.zip",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.33.0/rules_go-v0.33.0.zip",
    ],
)

load("@//:go_deps.bzl", "go_deps")

go_deps()

load("@//:deps.bzl", "rules_govulncheck_repositories", "rules_govulncheck_toolchains")

# this downloads dependencies required for govulncheck to work
rules_govulncheck_repositories()

# this downloads govulncheck blobs and registers toolchain
rules_govulncheck_toolchains()

load("@io_bazel_stardoc//:setup.bzl", "stardoc_repositories")

stardoc_repositories()

# https://docs.bazel.build/versions/main/workspace-log.html skylib import fails somewhere, should debug
load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()
