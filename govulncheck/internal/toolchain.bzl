load("@io_bazel_rules_govulncheck//govulncheck/internal:providers.bzl", "GoVulnCheckInfo")
load("@io_bazel_rules_govulncheck//govulncheck/internal:defaults.bzl", "DEFAULT_GOVULNCHECK_PACKAGE_INFO")

GoVulnCheckToolchainInfo = provider(
    doc = "GoVulnCheck Toolchain metadata, contains govulncheck's necessary data",
    fields = {
        "name": "Label name of the toolchain",
        "govulncheck": "GoVulnCheckInfo provider",
    },
)

def _govulncheck_toolchain_impl(ctx):
    """Toolchain main implementation function"""
    return [
        platform_common.ToolchainInfo(
            govulncheckToolchainInfo = GoVulnCheckToolchainInfo(
                name = ctx.label.name,
                govulncheck = GoVulnCheckInfo(
                    tool = ctx.attr.govulncheck,
                    template = ctx.attr.govulncheck_executor_template,
                ),
            ),
        ),
    ]

govulncheck_toolchain = rule(
    implementation = _govulncheck_toolchain_impl,
    doc = "GoVulnCheck toolchain implements main instruments of this rule set",
    attrs = {
        # explanation on cfg https://docs.bazel.build/versions/main/skylark/rules.html#configurations
        "govulncheck": attr.label(mandatory = True, allow_single_file = True, executable = True, cfg = "exec"),
        "govulncheck_executor_template": attr.label(mandatory = True, allow_single_file = True),
    },
    provides = [platform_common.ToolchainInfo],
)

def declare_toolchains(name = "declare_toolchains", _govulncheck_package_info = DEFAULT_GOVULNCHECK_PACKAGE_INFO):
    """
        Create govulncheck_toolchain rules for every supported platform and link toolchains to them

    Args:
        name: name of the macro
        _govulncheck_package_info: pre-built GoVulnCheckPackageInfo provider
            with info all available os+architectures,
            expected versions and available binaries of govulncheck and alertmanager
    """

    for platform in _govulncheck_package_info.platforms_info.available_platforms:
        platform_info = getattr(_govulncheck_package_info.platforms_info.platforms, platform)

        govulncheck_toolchain(
            name = "govulncheck_{platform}".format(platform = platform),
            govulncheck = "@govulncheck_{platform}//:govulncheck".format(platform = platform),
            govulncheck_executor_template = "@io_bazel_rules_govulncheck//govulncheck/internal:govulncheck.sh.tpl",

            # https://docs.bazel.build/versions/main/be/common-definitions.html#common.tags
            # exclude toolchain from expanding on wildcard
            # so you won't download all dependencies for all platforms
            tags = ["manual"],
        )

        native.toolchain(
            name = "govulncheck_toolchain_{platform}".format(platform = platform),
            target_compatible_with = platform_info.os_constraints + platform_info.cpu_constraints,
            exec_compatible_with = platform_info.os_constraints + platform_info.cpu_constraints,
            toolchain = ":govulncheck_{platform}".format(platform = platform),
            toolchain_type = "@io_bazel_rules_govulncheck//govulncheck:toolchain",
        )

def _link_toolchain_to_govulncheck_toolchain(arch):
    return "@io_bazel_rules_govulncheck//govulncheck/internal:govulncheck_toolchain_%s" % arch

def build_toolchains(architectures, toolchain_linker = _link_toolchain_to_govulncheck_toolchain):
    return [
        toolchain_linker(arch)
        for arch in architectures
    ]

def _govulncheck_register_toolchains(toolchains):
    """Register all toolchains"""
    native.register_toolchains(*toolchains)

def govulncheck_toolchains(
        name = "govulncheck_register_toolchains",
        _govulncheck_package_info = DEFAULT_GOVULNCHECK_PACKAGE_INFO):
    _govulncheck_register_toolchains(
        toolchains =
            build_toolchains(_govulncheck_package_info.platforms_info.available_platforms),
    )
