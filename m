From: John Garry <john.garry@huawei.com>
Subject: [PATCH 0/9] hisi_sas: Some misc patches
Date: Thu, 11 Apr 2019 20:46:35 +0800
Message-ID: <1554986804-233706-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

The patchset introduces improvements, more minor fixes, and new features
for the driver, including:
- Host reset interface
- Switch all HW error handling to MSI
- Give SATA disk unique (fake) SAS address for v3 hw
- Some error handling fixes
- Some tidy-up

It is based on Martin's 5.2/scsi-queue branch plus patch 0e83fc61eee6
("scsi: hisi_sas: Add softreset in hisi_sas_I_T_nexus_reset()").

John Garry (1):
  scsi: hisi_sas: Fix for setting the PHY linkrate when disconnected

Luo Jiaxing (2):
  scsi: hisi_sas: Don't hard reset disk during controller reset
  scsi: hisi_sas: Don't fail IT nexus reset for Open Reject timeout

Xiang Chen (5):
  scsi: hisi_sas: add host reset interface for test
  scsi: hisi_sas: Remedy inconsistent PHY down state in software
  scsi: hisi_sas: Adjust the printk format of functions
    hisi_sas_init_device()
  scsi: hisi_sas: allocate different SAS address for directly attached
    situation
  scsi: hisi_sas: Some misc tidy-up

Xiaofei Tan (1):
  scsi: hisi_sas: Support all RAS events with MSI interrupts

 drivers/scsi/hisi_sas/hisi_sas.h       |   3 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 104 ++++--
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  21 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  49 ++-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 473 +++++++++++++++----------
 5 files changed, 380 insertions(+), 270 deletions(-)

-- 
2.17.1
