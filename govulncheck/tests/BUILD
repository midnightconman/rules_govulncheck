load("@bazel_skylib//rules:analysis_test.bzl", "analysis_test")
load("@bazel_skylib//rules:build_test.bzl", "build_test")

package(
    default_visibility = [
        "//govulncheck/tests:__subpackages__",
    ],
)

analysis_test(
    name = "test_tools_analysed",
    targets = [
        "@io_bazel_rules_govulncheck//govulncheck:defs",
    ],
)

build_test(
    name = "test_main_tools_building",
    targets = [
        "@io_bazel_rules_govulncheck//govulncheck:defs",
    ],
)

test_suite(
    name = "all_tests",
    tests = [
        ":test_main_tools_building",
        ":test_tools_analysed",
    ],
)
