load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies", "go_repository")

_cue_runtimes = {
    "0.7.1": [
        {
            "os": "linux",
            "arch": "x86_64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.7.1/cue_v0.7.1_linux_amd64.tar.gz",
            "sha256": "dbd548ff02567881cf81834d0e9e035c86a287c887587b9abfd119763ebb9aea",
        },
        {
            "os": "darwin",
            "arch": "x86_64",
            "url": "https://github.com/cue-lang/cue/releases/download/v0.7.1/cue_v0.7.1_darwin_amd64.tar.gz",
            "sha256": "8bc701670dfd72d009239605c45973dfd95b7bdaaf55b5eb923c1909058b09e4",
        }
    ]
}

def cue_register_toolchains(version = "0.7.1"):
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
