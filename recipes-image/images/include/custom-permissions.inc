set_file_permissions() {
   chown root:root ${IMAGE_ROOTFS}/etc/ssh/sshd_config_readonly
   chmod a+x ${IMAGE_ROOTFS}/etc/ssh/sshd_config_readonly
}

ROOTFS_POSTPROCESS_COMMAND += "\
                               set_file_permissions; \
                              "
