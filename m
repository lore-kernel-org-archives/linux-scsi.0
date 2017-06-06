From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH v4 0/5] tcmu: Add Type of reconfig into netlink
Date: Tue,  6 Jun 2017 09:28:47 -0500
Message-ID: <1496759332-35216-1-git-send-email-bryantly@linux.vnet.ibm.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org, mchristi@redhat.com
Cc: seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bgly@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

From: "Bryant G. Ly" <bgly@us.ibm.com>

This patch consists of adding a netlink to allow for reconfiguration
of a device in tcmu.

It also changes and adds some attributes that are reconfigurable:
write_cache, device size, and device path.

V2 - Fixes kfree in tcmu: Make dev_config configurable
V3 - Fixes spelling error
V4 - change strcpy to strlcpy for tcmu_dev_path_store and move
     tcmu_reconfig_type into target_core_user.h


Bryant G. Ly (5):
  tcmu: Support emulate_write_cache
  tcmu: Add netlink for device reconfiguration
  tcmu: Make dev_size configurable via userspace
  tcmu: Make dev_config configurable
  tcmu: Add Type of reconfig into netlink

 drivers/target/target_core_user.c     | 152 ++++++++++++++++++++++++++++++++--
 include/uapi/linux/target_core_user.h |   9 ++
 2 files changed, 155 insertions(+), 6 deletions(-)

-- 
2.5.4 (Apple Git-61)
