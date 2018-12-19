From: John Garry <john.garry@huawei.com>
Subject: [PATCH 0/8] hisi_sas: debugfs support
Date: Wed, 19 Dec 2018 23:56:38 +0800
Message-ID: <1545235006-151716-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset adds debugfs support for capturing driver state for
particular times when the HW has malfunctioned (and we must reset the HW).

Every controller HW version has had bugs. These bugs have been very
painful to debug. One useful tool to debug these is being able to capture
and export HW registers and driver control structures at point of failure.

This feature has been maintained out-of-tree for some time, so add it now.

Luo Jiaxing (8):
  scsi: hisi_sas: Create root and device debugfs directories
  scsi: hisi_sas: Alloc debugfs snapshot buffer memory for all registers
  scsi: hisi_sas: Take debugfs snapshot for all regs
  scsi: hisi_sas: Debugfs global register create file and add file
    operations
  scsi: hisi_sas: Add debugfs for port registers
  scsi: hisi_sas: Add debugfs CQ file and add file operations
  scsi: hisi_sas: Add debugfs DQ file and add file operations
  scsi: hisi_sas: Add debugfs IOST file and add file operations

 drivers/scsi/hisi_sas/hisi_sas.h       |  47 ++-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 508 +++++++++++++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |   9 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 174 ++++++++++-
 4 files changed, 732 insertions(+), 6 deletions(-)

-- 
1.9.1
