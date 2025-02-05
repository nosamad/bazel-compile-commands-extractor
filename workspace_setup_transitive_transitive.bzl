# Do not change the filename; it is part of the user interface.


load("@python_3_11//:defs.bzl", "interpreter")
load("@rules_python//python:pip.bzl", "pip_parse")


def hedron_compile_commands_setup_transitive_transitive(module_ctx = None):
    """Part 3 of setting up a WORKSPACE to have hedron_compile_commands used within it.

    module_ctx is for automatic-implicit use by bzlmod only.

    Sorry it can't be unified with hedron_compile_commands_setup(). Bazel implementation restrictions.
    """

    # Below the interface boundary:
    # This is needed to get transitive dependencies of transitive dependencies--by calling their deps functions.

    # Why?
    # Bazel doesn't let you call a load except at the top level after v3 or so :/, so you have to resort to calling waves of workspace functions, one per each additional layer of transitive dependencies.
    # For more info see:
        # https://bazel.build/external/overview#shortcomings_of_the_workspace_system
        # https://github.com/bazelbuild/bazel/issues/1550
        # https://github.com/bazelbuild/bazel/issues/5815
        # https://github.com/hedronvision/bazel-make-cc-https-easy/issues/14

    # Unified setup for users' WORKSPACES and this workspace when used standalone.
    # See invocations in:
    #     README.md (for WORKSPACE users)
    #     MODULE.bazel (for bzlmod users and for working on this repo standalone)

    if not module_ctx:
        pip_parse(
            name = "hedron_compile_commands_pip",
            python_interpreter_target = interpreter,
            requirements_lock = "@hedron_compile_commands//:requirements.txt",
        )


hedron_compile_commands_extension = module_extension( # Note: Doesn't break loading from WORKSPACE as far back as Bazel 5.0.0
    implementation = hedron_compile_commands_setup_transitive_transitive,
    # This extension is automatically loaded when using bzlmod (from MODULE.bazel) and will run the same function as WORKSPACE,
    # but passes in a module_ctx object for advanced context of the whole project, allowing for complex, project wide modifiying extensions and distinguishing between WORKSPACE and bzlmod setups.
)
