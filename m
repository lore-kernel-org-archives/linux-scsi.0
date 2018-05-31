From: John Garry <john.garry@huawei.com>
Subject: [PATCH 0/9] hisi_sas: some misc changes
Date: Thu, 31 May 2018 20:50:41 +0800
Message-ID: <1527771050-200916-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset introduces some more minor misc changes to the driver.
Patches of note include:
- Pre-allocate slot DMA buffers
- some fixes for host reset handling

John Garry (2):
  scsi: hisi_sas: Add missing PHY spinlock init
  scsi: hisi_sas: Update a couple of register settings for v3 hw

Xiang Chen (2):
  scsi: hisi_sas: Use dmam_alloc_coherent()
  scsi: hisi_sas: Pre-allocate slot DMA buffers

Xiaofei Tan (5):
  scsi: hisi_sas: Only process broadcast change in phy_bcast_v3_hw()
  scsi: hisi_sas: Fix the conflict between dev gone and host reset
  scsi: hisi_sas: Adjust task reject period during host reset
  scsi: hisi_sas: Add a flag to filter PHY events during reset
  scsi: hisi_sas: Release all remaining resources in clear nexus ha

 drivers/scsi/hisi_sas/hisi_sas.h       |  10 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 214 +++++++++++++++------------------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |   3 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |   3 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  16 ++-
 5 files changed, 122 insertions(+), 124 deletions(-)

-- 
1.9.1
