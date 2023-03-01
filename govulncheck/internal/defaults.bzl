load(
    "@io_bazel_rules_govulncheck//govulncheck/internal:providers.bzl",
    "GoVulnCheckBinaryInfo",
    "GoVulnCheckPackageInfo",
    "GoVulnCheckPlatformInfo",
    "GoVulnCheckPlatformsInfo",
)

_DEFAULT_LIST_OF_PLATFORMS = (
    "darwin-amd64",
    "darwin-arm64",
    "linux-amd64",
    "linux-arm64",
    "windows-amd64",
    "windows-arm64",
)

OsConstraintsInfo = struct(
    darwin = "@platforms//os:osx",
    linux = "@platforms//os:linux",
    windows = "@platforms//os:windows",
)

CpuConstraintsInfo = struct(
    amd64 = "@platforms//cpu:x86_64",
    arm64 = "@platforms//cpu:arm64",
)

DEFAULT_PLATFORMS = GoVulnCheckPlatformsInfo(
    available_platforms = _DEFAULT_LIST_OF_PLATFORMS,
    platforms = struct(**{
        platform: GoVulnCheckPlatformInfo(
            os = platform.partition("-")[0],
            cpu = platform.partition("-")[-1],
            cpu_constraints = [
                getattr(CpuConstraintsInfo, platform.partition("-")[-1]),
            ],
            os_constraints = [
                getattr(OsConstraintsInfo, platform.partition("-")[0]),
            ],
        )
        for platform in _DEFAULT_LIST_OF_PLATFORMS
    }),
)

_DEFAULT_GOVULNCHECK_VERSION = "v0.0.0-20230224180816-edec1fb0a9c7"
_DEFAULT_AVAILABLE_GOVULNCHECK_BINARIES = {
    ("v0.0.0-20230224180816-edec1fb0a9c7", "darwin-amd64"): "90e12ee49ef3ede5c0d03be6ab36b2d13c3a047806bc23b893f92d1101d3be5d",
    ("v0.0.0-20230224180816-edec1fb0a9c7", "darwin-arm64"): "6ebf83231628f5176912680b7ce50d278968b3edb17850b60ec151a8206dc8c7",
    ("v0.0.0-20230224180816-edec1fb0a9c7", "linux-amd64"): "fa50a7b750fe461a30de92e70c979cfb46365fc24391c1b323d6d5074f2fc5e2",
    ("v0.0.0-20230224180816-edec1fb0a9c7", "linux-arm64"): "31a6aa14eb198978146c406acf86aba0077058ad0ed072fc785bba0e3da7dcc2",
    ("v0.0.0-20230224180816-edec1fb0a9c7", "windows-amd64"): "7d477063b7e4ebed1f8001773f0e3e6ea630f052ca8a83c157e5d9f9dbefd249",
    ("v0.0.0-20230224180816-edec1fb0a9c7", "windows-arm64"): "fbefda5979fb7535b69fa3234b41d642f94dfec827ea2d40e9dd2fabb00083bb",
}

_DEFAULT_GOVULNCHECK_BINARY_INFO = GoVulnCheckBinaryInfo(
    version = _DEFAULT_GOVULNCHECK_VERSION,
    available_binaries = _DEFAULT_AVAILABLE_GOVULNCHECK_BINARIES,
)

DEFAULT_GOVULNCHECK_PACKAGE_INFO = GoVulnCheckPackageInfo(
    platforms_info = DEFAULT_PLATFORMS,
    govulncheck_binary_info = _DEFAULT_GOVULNCHECK_BINARY_INFO,
)
