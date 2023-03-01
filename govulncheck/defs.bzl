load(
    "@io_bazel_rules_govulncheck//govulncheck/internal:repositories.bzl",
    _govulncheck_repositories = "govulncheck_repositories",
)
load(
    "@io_bazel_rules_govulncheck//govulncheck/internal:govulncheck.bzl",
    _govulncheck_test = "govulncheck_test",
)
load(
    "@io_bazel_rules_govulncheck//govulncheck/internal:toolchain.bzl",
    _govulncheck_toolchains = "govulncheck_toolchains",
)

govulncheck_toolchains = _govulncheck_toolchains
govulncheck_repositories = _govulncheck_repositories
govulncheck_test = _govulncheck_test
