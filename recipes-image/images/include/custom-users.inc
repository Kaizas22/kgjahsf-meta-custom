inherit extrausers

EXTRA_USERS_PARAMS = ""

EXTRA_USERS_PARAMS += "\
                       usermod -P root root; \
                       useradd -P admin admin; \
                      "

#allow_rootLogin_via_ssh() {
#   sed "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g" ${IMAGE_ROOTFS}/etc/ssh/#sshd_config
#}


#ROOTFS_POSTPROCESS_COMMAND += "\
#                               allow_rootLogin_via_ssh; \
#                              "
