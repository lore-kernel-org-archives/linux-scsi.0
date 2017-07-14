From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 0/4] constify scsi attribute_group structures.
Date: Fri, 14 Jul 2017 13:53:26 +0530
Message-ID: <1500020610-15973-1-git-send-email-arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: lduncan@suse.com, cleech@redhat.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

attribute_groups are not supposed to change at runtime.
So mark the non-const structs as const.

Arvind Yadav (4):
  [PATCH 1/4] scsi: scsi_transport_iscsi: constify attribute_group structures.
  [PATCH 2/4] scsi: iscsi_boot_sysfs: constify attribute_group structures.
  [PATCH 3/4] scsi: scsi_transport_fc: constify attribute_group structures.
  [PATCH 4/4] scsi: scsi_transport_spi: constify attribute_group structures.

 drivers/scsi/iscsi_boot_sysfs.c     | 10 +++++-----
 drivers/scsi/scsi_transport_fc.c    |  2 +-
 drivers/scsi/scsi_transport_iscsi.c | 12 ++++++------
 drivers/scsi/scsi_transport_spi.c   |  4 ++--
 include/linux/iscsi_boot_sysfs.h    |  2 +-
 5 files changed, 15 insertions(+), 15 deletions(-)

-- 
1.9.1
