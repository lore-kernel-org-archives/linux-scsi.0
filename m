From: John Garry <john.garry@huawei.com>
Subject: [PATCH 00/13] hisi_sas: Misc fixes and other more minor patches
Date: Fri, 25 Jan 2019 22:22:26 +0800
Message-ID: <1548426159-225679-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This series includes a misc assortment of fixes found during testing.

Also includes is some debugfs tidy-up and a patch missed from original
upstreaming.

John Garry (5):
  scsi: hisi_sas: No need to check return value of debugfs_create
    functions
  scsi: hisi_sas: Fix type casting and missing static qualifier in
    debugfs code
  scsi: hisi_sas: Some misc tidy-up
  scsi: hisi_sas: Fix to only call scsi_get_prot_op() for non-NULL
    scsi_cmnd
  scsi: hisi_sas: Add missing seq_printf() call in
    hisi_sas_show_row_32()

Luo Jiaxing (3):
  scsi: hisi_sas: Add debugfs ITCT file and add file operations
  scsi: hisi_sas: Reject setting programmed minimum linkrate > 1.5G
  scsi: hisi_sas: Correct memory allocation size for DQ debugfs

Xiang Chen (4):
  scsi: hisi_sas: send primitive NOTIFY to SSP situation only
  scsi: hisi_sas: shutdown axi bus to avoid exception CQ returned
  scsi: hisi_sas: remove the check of sas_dev status in
    hisi_sas_I_T_nexus_reset()
  scsi: hisi_sas: Remove unused parameter of function hisi_sas_alloc()

Xiaofei Tan (1):
  scsi: hisi_sas: Fix losing directly attached disk when hot-plug

 drivers/scsi/hisi_sas/hisi_sas.h       |  19 ++--
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 199 ++++++++++++++++++++-------------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |   4 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  13 ++-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  48 +++++---
 5 files changed, 179 insertions(+), 104 deletions(-)

-- 
1.9.1
