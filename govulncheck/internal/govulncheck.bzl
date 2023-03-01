def _govulncheck_test_impl(ctx):
    """govulncheck_test implementation: we spawn test runner task from template and provide required tools and actions from toolchain"""

    # To ensure the files needed by the script are available, we put them in
    # the runfiles.
    govulncheck_info = (
        ctx.toolchains["@io_bazel_rules_govulncheck//govulncheck:toolchain"]
            .govulncheckToolchainInfo
            .govulncheck
    )
    govulncheck_test_runner_template = govulncheck_info.template.files.to_list()[0]

    runfiles = ctx.runfiles(
        files = ctx.files.srcs,
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
            "%srcs%": " ".join([_file.short_path for _file in ctx.files.srcs]),
            "%tool_path%": "%s" % govulncheck_info.tool.files_to_run.executable.short_path,
            #"%warn%": ctx.attr.warn,
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
        "warn": attr.bool(default = False),
        "srcs": attr.label_list(
            mandatory = True,
            allow_files = True,
            cfg = "target",
            doc = "List of go source test file targets",
        ),
    },
    toolchains = ["@io_bazel_rules_govulncheck//govulncheck:toolchain"],
)
