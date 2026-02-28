"""
Rule for compiling and running test binaries.

This rule can be used to compile and run any C# binary and run it as
a Bazel test.
"""

load("@bazel_skylib//rules:common_settings.bzl", "BuildSettingInfo")
load(
    "//dotnet/private:common.bzl",
    "get_toolchain",
    "is_debug",
)
load("//dotnet/private/rules/common:attrs.bzl", "CSHARP_BINARY_COMMON_ATTRS")
load("//dotnet/private/rules/common:binary.bzl", "build_binary")
load("//dotnet/private/rules/csharp/actions:csharp_assembly.bzl", "AssemblyAction")
load("//dotnet/private/transitions:tfm_transition.bzl", "tfm_transition")

def _get_illink_analyzers(ctx, tfm):
    """Returns ILLink analyzer files for the given TFM when is_aot_compatible."""
    if not ctx.attr.is_aot_compatible:
        return []
    if tfm.startswith("net10."):
        return ctx.files._illink_analyzers_net10
    elif tfm.startswith("net9."):
        return ctx.files._illink_analyzers_net9
    else:
        return ctx.files._illink_analyzers_net8

def _get_aot_analyzer_config(ctx):
    """Generates a .globalconfig that enables ILLink AOT/trim analyzers."""
    if not ctx.attr.is_aot_compatible:
        return []
    config = ctx.actions.declare_file(ctx.label.name + ".aot.globalconfig")
    ctx.actions.write(config, "\n".join([
        "is_global = true",
        "build_property.EnableAotAnalyzer = true",
        "build_property.EnableTrimAnalyzer = true",
        "build_property.EnableSingleFileAnalyzer = true",
        "",
    ]))
    return [config]

def _compile_action(ctx, tfm):
    toolchain = get_toolchain(ctx)

    return AssemblyAction(
        ctx.actions,
        ctx.executable._compiler_wrapper_bat if ctx.target_platform_has_constraint(ctx.attr._windows_constraint[platform_common.ConstraintValueInfo]) else ctx.executable._compiler_wrapper_sh,
        label = ctx.label,
        additionalfiles = ctx.files.additionalfiles,
        direct_analyzers = ctx.attr.analyzers,
        debug = is_debug(ctx),
        override_debug = getattr(ctx.attr, "override_debug", False),
        defines = ctx.attr.defines,
        deps = ctx.attr.deps,
        exports = [],
        targeting_pack = ctx.attr._targeting_pack[0],
        internals_visible_to = ctx.attr.internals_visible_to,
        cls_compliant = ctx.attr.cls_compliant,
        assembly_version = ctx.attr.assembly_version,
        keyfile = ctx.file.keyfile,
        langversion = ctx.attr.langversion if ctx.attr.langversion != "" else toolchain.dotnetinfo.csharp_default_version,
        resources = ctx.files.resources,
        resource_logical_names = getattr(ctx.attr, "resource_logical_names", {}),
        srcs = ctx.files.srcs,
        data = ctx.files.data,
        appsetting_files = ctx.files.appsetting_files,
        compile_data = ctx.files.compile_data,
        out = ctx.attr.out,
        target = "exe",
        target_name = ctx.attr.name,
        target_framework = tfm,
        toolchain = toolchain,
        strict_deps = toolchain.strict_deps[BuildSettingInfo].value,
        generate_documentation_file = ctx.attr.generate_documentation_file,
        include_host_model_dll = False,
        treat_warnings_as_errors = ctx.attr.treat_warnings_as_errors,
        warnings_as_errors = ctx.attr.warnings_as_errors,
        warnings_not_as_errors = ctx.attr.warnings_not_as_errors,
        warning_level = ctx.attr.warning_level,
        nowarn = ctx.attr.nowarn,
        project_sdk = ctx.attr.project_sdk,
        allow_unsafe_blocks = ctx.attr.allow_unsafe_blocks,
        nullable = ctx.attr.nullable,
        run_analyzers = ctx.attr.run_analyzers,
        is_analyzer = False,
        is_language_specific_analyzer = False,
        analyzer_configs = ctx.files.analyzer_configs + _get_aot_analyzer_config(ctx),
        compiler_options = ctx.attr.compiler_options,
        ref_assembly = False,
        is_windows = ctx.target_platform_has_constraint(ctx.attr._windows_constraint[platform_common.ConstraintValueInfo]),
        shared_compilation_worker = ctx.executable.shared_compilation_worker if ctx.attr.use_shared_compilation else None,
        use_shared_compilation = ctx.attr.use_shared_compilation,
        extra_analyzers_csharp = _get_illink_analyzers(ctx, tfm),
    )

def _csharp_test_impl(ctx):
    return build_binary(ctx, _compile_action)

csharp_test = rule(
    _csharp_test_impl,
    doc = """Compiles a C# executable and runs it as a test""",
    attrs = CSHARP_BINARY_COMMON_ATTRS,
    test = True,
    toolchains = [
        "//dotnet:toolchain_type",
    ],
    cfg = tfm_transition,
)
