python () {
    # Add tasks in the correct order, specifically for archiver to avoid race condition.
    # sstatesig.py:sstate_rundepfilter has special support that excludes this dependency
    # so that do_kernel_configme does not need to run again when do_unpack_and_patch
    # gets added or removed (by adding or removing archiver.bbclass).
    if bb.data.inherits_class('archiver', d):
        bb.build.addtask('do_kernel_configme', 'do_configure', 'do_unpack_and_patch', d)
}
