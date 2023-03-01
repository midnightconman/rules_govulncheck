load("@io_bazel_rules_govulncheck//govulncheck/internal:defaults.bzl", "DEFAULT_GOVULNCHECK_PACKAGE_INFO")
load("@io_bazel_rules_govulncheck//govulncheck/internal:providers.bzl", "HttpArchiveInfo")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

_GOVULNCHECK_BUILD_FILE_CONTENT = """
exports_files([
    "govulncheck",
])
"""

HTTP_ARCHIVE_EXTENSION = "tar.gz"

def _http_archive_provider_factory(
        binary,
        os,
        cpu,
        version,
        sha256,
        build_file_content,
        archive_extension = HTTP_ARCHIVE_EXTENSION):
    return HttpArchiveInfo(
        name = "{binary}_{os}-{cpu}".format(
            binary = binary,
            os = os,
            cpu = cpu,
        ),
        sha256 = sha256,
        version = version,
        urls = [(
            "https://github.com/midnightconman/vuln/releases/download/" +
            "{version}/{binary}-{version}.{os}-{cpu}.{archive_extension}".format(
                version = version,
                os = os,
                cpu = cpu,
                binary = binary,
                archive_extension = archive_extension,
            )
        )],
        build_file_content = build_file_content,
    )

def _http_archive_factory(ctx):
    """build http_archive objects from context"""
    return http_archive(
        name = ctx.name,
        sha256 = ctx.sha256,
        urls = ctx.urls,
        build_file_content = ctx.build_file_content,
    )

def _build_http_archives(
        govulncheck_package_info,
        http_archive_info = _http_archive_provider_factory,
        http_archive_factory = _http_archive_factory,
        govulncheck_build_file_content = _GOVULNCHECK_BUILD_FILE_CONTENT):
    """Factory will build a set of http_archive objects for bazel's toolchain consumption

    Args:
        govulncheck_package_info: govulncheck package metadata provider
        http_archive_info: factory function which builds HttpArchiveInfo objects
        http_archive_factory: factory function which builds http_archive bazel rules
        govulncheck_build_file_content: BUILD file content for resulting bazel repository
    """

    for platform in govulncheck_package_info.platforms_info.available_platforms:
        http_archive_factory(http_archive_info(
            binary = "govulncheck",
            os = getattr(govulncheck_package_info.platforms_info.platforms, platform).os,
            cpu = getattr(govulncheck_package_info.platforms_info.platforms, platform).cpu,
            version = govulncheck_package_info.govulncheck_binary_info.version,
            build_file_content = govulncheck_build_file_content,
            sha256 = govulncheck_package_info.govulncheck_binary_info.available_binaries[(
                govulncheck_package_info.govulncheck_binary_info.version,
                platform,
            )],
        ))

def _govulncheck_repositories_impl(
        http_archives_factory = _build_http_archives,
        _govulncheck_package_info = DEFAULT_GOVULNCHECK_PACKAGE_INFO):
    """govulncheck_repositories main implementation function

    Args:
        http_archives_factory: http_archive(s) factory function
        _govulncheck_package_info: pre-built GoVulnCheckPackageInfo provider with info all available os+architectures,
                                  expected versions and available binaries of govulncheck
    """

    """Consumers should call this function to download dependencies for rules to work"""

    # maybe = don't download if already present
    # https://docs.bazel.build/versions/main/repo/utils.html#maybe
    # so dependencies are overridable

    maybe(
        http_archive,
        name = "platforms",
        sha256 = "079945598e4b6cc075846f7fd6a9d0857c33a7afc0de868c2ccb96405225135d",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/platforms/releases/download/0.0.4/platforms-0.0.4.tar.gz",
            "https://github.com/bazelbuild/platforms/releases/download/0.0.4/platforms-0.0.4.tar.gz",
        ],
    )
    maybe(
        http_archive,
        name = "bazel_skylib",
        sha256 = "c6966ec828da198c5d9adbaa94c05e3a1c7f21bd012a0b29ba8ddbccb2c93b0d",
        urls = [
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.1.1/bazel-skylib-1.1.1.tar.gz",
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.1.1/bazel-skylib-1.1.1.tar.gz",
        ],
    )

    http_archives_factory(
        govulncheck_package_info = _govulncheck_package_info,
    )

def govulncheck_repositories():
    """Download dependency tools and initialize toolchains

    Args:
        govulncheck_version: GoVulnCheck package version to download from source repositories if supported by reposiory
        alertmanager_version: Alertmanager package version to download from source repositories if supported by reposiory
    """

    # TODO add custom version support
    _govulncheck_repositories_impl()
