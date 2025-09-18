const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {

    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    const root_module = b.createModule(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addLibrary(.{
        .name = "mage",
        // In this case the main source file is merely a path, however, in more
        // complicated build scripts, this could be a generated file.
        .linkage = .static,
        .root_module = root_module,
    });

    // This declares intent for the library to be installed into the standard
    // location when the user invokes the "install" step (the default step when
    // running `zig build`).
    b.installArtifact(lib);

    // Debug build options
    // This adds the option to have conditional execution of code based on the
    // presence of the debug option:
    // zig build -Ddebug=true
    const build_options = b.addOptions();
    build_options.addOption(bool, "debug", b.option(bool, "debug", "Builds in Debug Mode") orelse false);

    const exe = b.addExecutable(.{
        .name = "mage",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    exe.root_module.addOptions("build_options", build_options);

    // This declares intent for the executable to be installed into the
    // standard location when the user invokes the "install" step (the default
    // step when running `zig build`).
    b.installArtifact(exe);

    // This *creates* a Run step in the build graph, to be executed when another
    // step is evaluated that depends on it. The next line below will establish
    // such a dependency.
    const run_cmd = b.addRunArtifact(exe);

    // By making the run step depend on the install step, it will be run from the
    // installation directory rather than directly from within the cache directory.
    // This is not necessary, however, if the application depends on other installed
    // files, this ensures they will be present and in the expected location.
    run_cmd.step.dependOn(b.getInstallStep());

    // This allows the user to pass arguments to the application in the build
    // command itself, like this: `zig build run -- arg1 arg2 etc`
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    // This creates a build step. It will be visible in the `zig build --help` menu,
    // and can be selected like this: `zig build run`
    // This will evaluate the `run` step rather than the default, which is "install".
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    // Creates a step for unit testing. This only builds the test executable
    // but does not run it.
    const lib_unit_tests = b.addTest(.{
        .root_module = root_module,
    });
    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);
    run_lib_unit_tests.skip_foreign_checks = true;

    // setup exe tests stuff
    const tests_module = b.createModule(.{
        .root_source_file = b.path("src/tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    const exe_unit_tests = b.addTest(.{
        .root_module = tests_module,
    });
    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    // Similar to creating the run step earlier, this exposes a `test` step to
    // the `zig build --help` menu, providing a way for the user to request
    // running the unit tests.
    const test_step = b.step("tests", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
    test_step.dependOn(&run_exe_unit_tests.step);

    // individual unit tests
    // const vm_test_step = b.step("test:vm", "Tests the vm.zig file through src/test/test_vm.zig");
    // const vm_unit_tests = b.addTest(.{
    //     .root_source_file = b.path("src/vm.zig"),
    //     .target = target,
    //     .optimize = optimize,
    // });
    // const run_vm_unit_tests = b.addRunArtifact(vm_unit_tests);
    // vm_test_step.dependOn(&run_lib_unit_tests.step);
    // vm_test_step.dependOn(&run_vm_unit_tests.step);
//
    // // individual unit tests
    // const value_test_step = b.step("test:value", "Tests the value.zig file through src/test/test_value.zig");
    // const value_unit_tests = b.addTest(.{
    //     .root_source_file = b.path("src/value.zig"), .target = target, .optimize = optimize,
    // });
    // const run_value_unit_tests = b.addRunArtifact(value_unit_tests);
    // value_test_step.dependOn(&run_lib_unit_tests.step);
    // value_test_step.dependOn(&run_value_unit_tests.step);
}
