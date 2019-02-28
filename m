From: John Garry <john.garry@huawei.com>
Subject: [PATCH 0/6] hisi_sas: Some misc patches
Date: Thu, 28 Feb 2019 22:50:56 +0800
Message-ID: <1551365462-128193-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

The patchset contains some misc patches for the driver, including:
- Workaround for acute scenario of SMP/internal IO timeout and reset racing
- Clear Affiliation for STP target port (from Luo Jiaxing and Xiang Chen)
- Fix PHY negotiated linkrate value for when PHY down
- Some init reg config changes
- Add support to coalesce and print PHY errors
- A tidy-up patch

John Garry (1):
  scsi: hisi_sas: Set PHY linkrate when disconnected

Xiang Chen (4):
  scsi: hisi_sas: Change return variable type in phy_up_v3_hw()
  scsi: hisi_sas: Fix a timeout race of driver internal and SMP IO
  scsi: hisi_sas: Send HARD RESET to clear the previous affiliation of
    STP target port
  scsi: hisi_sas: Change SERDES_CFG init value to increase reliability
    of HiLink

Xiaofei Tan (1):
  scsi: hisi_sas: print PHY RX errors count for later revision of v3 hw

 drivers/scsi/hisi_sas/hisi_sas.h       |  8 +++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 57 +++++++++++++++--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  1 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 89 ++++++++++++++++++--------
 4 files changed, 125 insertions(+), 30 deletions(-)

-- 
2.17.1
