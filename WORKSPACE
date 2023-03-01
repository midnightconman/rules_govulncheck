workspace(name = "io_bazel_rules_govulncheck")

# all dependencies are called from there
load("@//:deps.bzl", "rules_govulncheck_repositories", "rules_govulncheck_toolchains")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "io_bazel_stardoc",
    sha256 = "c9794dcc8026a30ff67cf7cf91ebe245ca294b20b071845d12c192afe243ad72",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/stardoc/releases/download/0.5.0/stardoc-0.5.0.tar.gz",
        "https://github.com/bazelbuild/stardoc/releases/download/0.5.0/stardoc-0.5.0.tar.gz",
    ],
)

# this downloads dependencies required for govulncheck to work
rules_govulncheck_repositories()

# this downloads govulncheck blobs and registers toolchain
rules_govulncheck_toolchains()

load("@io_bazel_stardoc//:setup.bzl", "stardoc_repositories")

stardoc_repositories()

# https://docs.bazel.build/versions/main/workspace-log.html skylib import fails somewhere, should debug
load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()
