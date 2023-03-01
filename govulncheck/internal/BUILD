load("@bazel_skylib//:bzl_library.bzl", "bzl_library")
load("@io_bazel_rules_govulncheck//govulncheck/internal:toolchain.bzl", "declare_toolchains")
load("@io_bazel_rules_govulncheck//govulncheck/internal:platforms.bzl", "declare_platforms")

package(
    default_visibility = [
        "//govulncheck:__subpackages__",
    ],
)

exports_files(
    glob([
        "*.bat",
        "*.sh",
        "*.sh.tpl",
    ]),
    visibility = ["//visibility:public"],
)

exports_files([
    "govulncheck.bzl",
    "providers.bzl",
    "platforms.bzl",
    "toolchain.bzl",
    "repositories.bzl",
    "toolchain.bzl",
])

bzl_library(
    name = "govulncheck",
    srcs = ["govulncheck.bzl"],
    deps = [":toolchain"],
)

bzl_library(
    name = "providers",
    srcs = ["providers.bzl"],
)

bzl_library(
    name = "defaults",
    srcs = ["defaults.bzl"],
    deps = [
        ":providers",
    ],
)

bzl_library(
    name = "platforms",
    srcs = ["platforms.bzl"],
    deps = [
        ":defaults",
    ],
)

bzl_library(
    name = "toolchain",
    srcs = ["toolchain.bzl"],
    deps = [
        ":defaults",
        ":providers",
    ],
)

bzl_library(
    name = "repositories",
    srcs = ["repositories.bzl"],
    deps = [
        ":defaults",
        ":providers",
    ],
)

declare_platforms()

declare_toolchains()
