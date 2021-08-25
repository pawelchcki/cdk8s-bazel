def _gen_k8s_file(ctx):
    odir = ctx.actions.declare_directory(ctx.label.name + "_tmp")
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

    runfiles = ctx.runfiles(
        files = [odir, ctx.executable._concat],
    )

    ctx.actions.run(
        inputs = [odir],
        outputs = [ctx.outputs.out],
        arguments = [odir.path, ctx.outputs.out.path],
        executable = ctx.executable._concat,
        tools = [ctx.executable._concat],
    )
    
    gen_to_stdout = ctx.actions.declare_file(ctx.label.name + ".gen")

    ctx.actions.write(
        output = gen_to_stdout,
        content = "%s %s" % (ctx.executable._concat.short_path, odir.short_path),
        is_executable = True,
    )

    # gen_to_file = ctx.actions.declare_file("gen_to_file")
    # ctx.actions.write(
    #     output = gen_to_file,
    #     content = (base_gen_cmd + "> %s") % (odir.path, ctx.outputs.out.path),
    #     is_executable = True,
    # )
   
    # ctx.actions.run(
    #     inputs = [odir, gen_to_stdout],
    #     executable = gen_to_file,
    #     outputs = [ctx.outputs.out],
    # )

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
        "_concat": attr.label(
            executable = True,
            allow_single_file = True,
            cfg = "exec",
            default = "//rules:concat.sh",
        )
        
    },
    executable = True,
    outputs = {
        "out": "%{name}.yaml", 
    },
)
