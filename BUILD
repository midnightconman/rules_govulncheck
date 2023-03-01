load("@io_bazel_rules_govulncheck//govulncheck:defs.bzl", "govulncheck")
load("@bazel_skylib//:bzl_library.bzl", "bzl_library")

package(default_visibility = ["//visibility:public"])

exports_files(["deps.bzl"])

#govulncheck(
#    name = "govulncheck",
#)

bzl_library(
    name = "deps",
    srcs = ["deps.bzl"],
)
