From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 0/5] libsas: Some logging tidy-up
Date: Thu, 15 Nov 2018 18:20:27 +0800
Message-ID: <1542277232-135789-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: hare@suse.com, yanaijie@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, joe@perches.com, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset presents some logging tidy-up, namely removing the printk
wrappers and using pr_XXX() instead.

In addition, some log levels are revised, as previous levels (generally
debug) were too low.

Finally a referece to "pci" is removed from a log, and unreferenced dump
files are deleted.

Differences v1->v2:
- Reunited strings to a single line
- fixed "sas: sas:" prefix in messages

John Garry (5):
  scsi: libsas: Delete sas_dump.{c, h}
  scsi: libsas: Use pr_fmt(fmt)
  scsi: libsas: Drop sas_printk()
  scsi: libsas: Drop SAS_DPRINTK() and revise logs levels
  scsi: libsas: Remove pcidev reference

 drivers/scsi/libsas/Makefile        |   3 +-
 drivers/scsi/libsas/sas_ata.c       |  26 ++--
 drivers/scsi/libsas/sas_discover.c  |  33 +++--
 drivers/scsi/libsas/sas_dump.c      |  63 ----------
 drivers/scsi/libsas/sas_dump.h      |  29 -----
 drivers/scsi/libsas/sas_event.c     |   1 -
 drivers/scsi/libsas/sas_expander.c  | 236 +++++++++++++++++-------------------
 drivers/scsi/libsas/sas_init.c      |  10 +-
 drivers/scsi/libsas/sas_internal.h  |  16 ++-
 drivers/scsi/libsas/sas_phy.c       |   8 +-
 drivers/scsi/libsas/sas_port.c      |  23 ++--
 drivers/scsi/libsas/sas_scsi_host.c | 123 +++++++++----------
 drivers/scsi/libsas/sas_task.c      |  10 +-
 13 files changed, 233 insertions(+), 348 deletions(-)
 delete mode 100644 drivers/scsi/libsas/sas_dump.c
 delete mode 100644 drivers/scsi/libsas/sas_dump.h

-- 
1.9.1
