PromtoolInfo = provider(
    doc = "Promtool metadata provider",
    fields = {
        "tool": "Promtool label",
        "template": "Template script that will be filled with execution details",
    },
)

GoVulnCheckInfo = provider(
    doc = "GoVulnCheck server metadata provider",
    fields = {
        "tool": "GoVulnCheck label",
        "template": "Template script that will be filled with execution details",
    },
)

GoVulnCheckPlatformsInfo = provider(
    # this should store os-arch combinations for toolchain generation
    doc = "OS and CPU platforms, constraints and available architectures metadata provider",
    fields = {
        "platforms": "mapping of GoVulnCheckPlatformInfo providers",
        "available_platforms": "list of platforms",
    },
)

GoVulnCheckPlatformInfo = provider(
    # this should store os-arch combinations for toolchain generation
    doc = "OS and CPU platform constraints metadata provider",
    fields = {
        "os": "",
        "cpu": "",
        "os_constraints": "list of os constraints, ex: [@platforms//os:linux]",
        "cpu_constraints": "list of cpu constraints, ex: [@platforms//cpu:x86_64]",
    },
)

GoVulnCheckBinaryInfo = provider(
    doc = "Provides metadata for govulncheck binary",
    fields = {
        "version": "Current version",
        "available_binaries": "list of available binaries represented as a mapping (version, architecture): sha checksum of binary's archive",
    },
)

GoVulnCheckPackageInfo = provider(
    doc = "Provides metadata for building http_archive objects",
    fields = {
        "platforms_info": "metadata providers for os-arch",
        "available_architectures": "list of available architectures",
        "govulncheck_binary_info": "govulncheck binary provider",
        "alertmanager_binary_info": "alertmanager binary provider",
    },
)

HttpArchiveInfo = provider(
    doc = "Blob download info provider",
    fields = {
        "name": "unique name for to-be initialized bazel repository",
        "sha256": "sha256 checksum of the blob",
        "version": "specific version of the binary",
        "urls": "list of urls to download blob from",
        "strip_prefix": "A directory prefix to strip from the extracted files",
        "build_file_content": "bazel build file content after unpacking",
        "archive_extension": "archive extension (tar.gz, zip)",
    },
)
