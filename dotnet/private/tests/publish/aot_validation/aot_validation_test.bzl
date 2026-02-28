"""Test that publish_binary(aot=True) rejects non-AOT-compatible binaries."""

load("@bazel_skylib//lib:unittest.bzl", "analysistest", "asserts")

def _aot_validation_test_impl(ctx):
    env = analysistest.begin(ctx)
    asserts.expect_failure(env, "is_aot_compatible=True")
    return analysistest.end(env)

aot_validation_test = analysistest.make(
    _aot_validation_test_impl,
    expect_failure = True,
)
