load("@io_bazel_rules_go//go:def.bzl", "go_context")

def _govulncheck_test_impl(ctx):
    """govulncheck_test implementation: we spawn test runner task from template and provide required tools and actions from toolchain"""

    go = go_context(ctx)

    # To ensure the files needed by the script are available, we put them in
    # the runfiles.
    govulncheck_info = (
        ctx.toolchains["@io_bazel_rules_govulncheck//govulncheck:toolchain"]
            .govulncheckToolchainInfo
            .govulncheck
    )
    govulncheck_test_runner_template = govulncheck_info.template.files.to_list()[0]

    runfiles = ctx.runfiles(
        files = ctx.files.srcs + [go.go] + ctx.files.deps,
        transitive_files = govulncheck_info.tool.files,
    )

    test = ctx.actions.declare_file("%s.out.sh" % ctx.label.name)

    warn = "False"
    if ctx.attr.warn:
        warn = "True"

    ctx.actions.expand_template(
        template = govulncheck_test_runner_template,
        output = test,
        is_executable = True,
        substitutions = {
            "%go_root%": go.root,
            "%srcs%": " ".join([_file.short_path for _file in ctx.files.srcs]),
            "%tool_path%": "%s" % govulncheck_info.tool.files_to_run.executable.short_path,
            "%warn%": warn,
        },
    )
    return [DefaultInfo(runfiles = runfiles, executable = test)]

govulncheck_test = rule(
    implementation = _govulncheck_test_impl,
    doc = """
Run "govulncheck" against binary test targets

Example:
```
//examples:govulncheck

load("//govulncheck:defs.bzl", "govulncheck_test")
govulncheck_test(
  name = "govulncheck",
  srcs = [
    "binary_label",
  ],
)
```

```bash
bazel test //examples:govulncheck
```

""",
    test = True,
    attrs = {
        "deps": attr.label(default = "@vulndb//:files"),
        "srcs": attr.label_list(
            mandatory = True,
            allow_files = True,
            cfg = "target",
            doc = "List of go source test file targets",
        ),
        "warn": attr.bool(default = False),
        "_go_context_data": attr.label(
            default = "@io_bazel_rules_go//:go_context_data",
        ),
    },
    toolchains = [
        "@io_bazel_rules_govulncheck//govulncheck:toolchain",
        "@io_bazel_rules_go//go:toolchain",
    ],
)
