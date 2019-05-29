From: John Garry <john.garry@huawei.com>
Subject: [PATCH 0/6] hisi_sas: Some misc patches
Date: Wed, 29 May 2019 17:58:41 +0800
Message-ID: <1559123927-160502-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset introduces some misc patches for the driver. Nothing
particularly stands out, maybe apart from a patch to delete a PHY's
timer when necessary.

John Garry (1):
  scsi: hisi_sas: Reduce HISI_SAS_SGE_PAGE_CNT in size

Luo Jiaxing (1):
  scsi: hisi_sas: Ignore the error code between phy down to phy up

Xiang Chen (3):
  scsi: hisi_sas: Delete PHYs' timer when rmmod or probe failed
  scsi: hisi_sas: Change the type of some numbers to unsigned
  scsi: hisi_sas: Disable stash for v3 hw

Xiaofei Tan (1):
  scsi: hisi_sas: Fix the issue of argument mismatch of printing ecc
    errors

 drivers/scsi/hisi_sas/hisi_sas.h       |  4 +--
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  8 +++++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 46 ++++++++++++++------------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 46 ++++++++++++++++++--------
 4 files changed, 66 insertions(+), 38 deletions(-)

-- 
2.17.1
