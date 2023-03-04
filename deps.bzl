load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load(
    "@io_bazel_rules_govulncheck//govulncheck:defs.bzl",
    _govulncheck_repositories = "govulncheck_repositories",
    _govulncheck_toolchains = "govulncheck_toolchains",
)

rules_govulncheck_repositories = _govulncheck_repositories
rules_govulncheck_toolchains = _govulncheck_toolchains
