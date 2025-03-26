# script to install EFS utilities and automatically mounts the EFS storage at /mnt/efs.
 #!/bin/bash
    sudo yum install -y amazon-efs-utils
    mkdir -p /mnt/efs
    mount -t efs ${aws_efs_file_system.efs.id}:/ /mnt/efs