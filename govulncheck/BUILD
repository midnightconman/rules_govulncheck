load("@bazel_skylib//:bzl_library.bzl", "bzl_library")
load("@io_bazel_stardoc//stardoc:stardoc.bzl", "stardoc")

package(default_visibility = ["//visibility:public"])

toolchain_type(
    name = "toolchain",
    visibility = ["//visibility:public"],
)

exports_files([
    "defs.bzl",
])

bzl_library(
    name = "api",
    srcs = [
        "@io_bazel_rules_govulncheck//govulncheck/internal:defaults",
        "@io_bazel_rules_govulncheck//govulncheck/internal:govulncheck",
        "@io_bazel_rules_govulncheck//govulncheck/internal:platforms",
        "@io_bazel_rules_govulncheck//govulncheck/internal:providers",
        "@io_bazel_rules_govulncheck//govulncheck/internal:repositories",
        "@io_bazel_rules_govulncheck//govulncheck/internal:toolchain",
    ],
)

bzl_library(
    name = "defs",
    srcs = ["defs.bzl"],
    visibility = ["//visibility:public"],
    deps = [
        ":api",
    ],
)

# stardoc(
#     name = "docs",
#     out = "docs.md",
#     input = "defs.bzl",
#     symbol_names = [
#         "govulncheck_test",
#     ],
#     deps = [
#         ":defs",
#     ],
# )
