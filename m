From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH v2 0/5] TCMU Enable Reconfiguration Patches
Date: Tue, 30 May 2017 13:31:15 -0500
Message-ID: <1496169080-58746-1-git-send-email-bryantly@linux.vnet.ibm.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org, mchristi@redhat.com
Cc: seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

This patch consists of adding a netlink to allow for reconfiguration
of a device in tcmu.

It also changes and adds some attributes that are reconfigurable:
write_cache, device size, and device path.

Bryant G. Ly (5):
  tcmu: Support emulate_write_cache
  tcmu: Add netlink for device reconfiguration
  tcmu: Make dev_size configurable via userspace
  tcmu: Make dev_config configurable
  tcmu: Add Type of reconfig into netlink

 drivers/target/target_core_user.c     | 159 ++++++++++++++++++++++++++++++++--
 include/uapi/linux/target_core_user.h |   2 +
 2 files changed, 155 insertions(+), 6 deletions(-)

-- 
2.5.4 (Apple Git-61)
