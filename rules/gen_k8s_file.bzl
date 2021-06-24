def _gen_k8s_file(ctx):
    odir = ctx.actions.declare_directory("tmp")
    ctx.actions.run(
        inputs = [],
        outputs = [odir],
        arguments = [],
        progress_message = "Converting",
        env = {
            "CDK8S_OUTDIR": odir.path,
        },
        executable = ctx.executable.tool,
        tools = [ctx.executable.tool],
    )

    gen_to_stdout = ctx.actions.declare_file("gen_to_stdout")
    runfiles = ctx.runfiles(
        files = [odir],
    )
    
    base_gen_cmd = "set -e; for i in %s/*; do cat \"$i\"; echo '---'; done"

    ctx.actions.write(
        output = gen_to_stdout,
        content = base_gen_cmd % odir.short_path,
        is_executable = True,
    )

    gen_to_file = ctx.actions.declare_file("gen_to_file")
    ctx.actions.write(
        output = gen_to_file,
        content = (base_gen_cmd + "> %s") % (odir.path, ctx.outputs.out.path),
        is_executable = True,
    )
   
    ctx.actions.run(
        inputs = [odir, gen_to_stdout],
        executable = gen_to_file,
        outputs = [ctx.outputs.out],
    )

    return [DefaultInfo(
        files = depset([ctx.outputs.out]),
        runfiles = runfiles,
        executable = gen_to_stdout,
    )]

gen_k8s_file = rule(
    _gen_k8s_file,
    attrs = {
        "tool": attr.label(
            executable = True,
            allow_files = True,
            cfg = "exec",
        ),
    },
    executable = True,
    outputs = {
        "out": "%{name}.yaml", 
    },
)
