load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies", "go_repository")

_cue_runtimes = {
    "0.6.0": [
        {
            "os": "linux",
            "arch": "x86_64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.6.0/cue_v0.6.0_linux_amd64.tar.gz",
            "sha256": "3ae7b28e12de2e0554c28d9a9eb3dd919f0640274c925ba0e36de9079af80de2",
        }
    ]
}

def cue_register_toolchains(version = "0.6.0"):
    for platform in _cue_runtimes[version]:
        suffix = "tar.gz"
        if platform["os"] == "Windows":
            suffix = "zip"

        url = "https://github.com/cuelang/cue/releases/download/v%s/cue_%s_%s_%s.%s" % (version, version, platform["os"], platform["arch"], suffix)
        if "url" in platform:
            url = platform["url"]
        http_archive(
            name = "cue_runtime_%s_%s" % (platform["os"].lower(), platform["arch"]),
            build_file_content = """exports_files(["cue"], visibility = ["//visibility:public"])""",
            url = url,
            sha256 = platform["sha256"],
        )
