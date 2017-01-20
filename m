From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 0/7] hisi_sas: SATA IO workaround and other misc patches
Date: Fri, 20 Jan 2017 20:45:17 +0800
Message-ID: <1484916324-211630-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jthumshirn@suse.de, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset introduces some misc fixes and improvements.

Most signifigantly this patchset includes a workaround
for a SATA IO issue on v2 hw (hip06/7).

Differences v1->v2:
- Add macro for SMP TIMEOUT in ITCT struct

John Garry (2):
  scsi: hisi_sas: downgrade refclk message
  scsi: hisi_sas: downgrade internal abort exit print

Xiang Chen (5):
  scsi: hisi_sas: workaround v2 hw SATA IO timeout issue
  scsi: hisi_sas: modify some values of ITCT table
  scsi: hisi_sas: modify hard reset for directed-attached disk
  scsi: hisi_sas: fix probe ordering problem
  scsi: hisi_sas: decrease running_req in hisi_sas_slot_task_free()

 drivers/scsi/hisi_sas/hisi_sas_main.c  |  20 +++---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 109 +++++++++++++++++++++++++++++----
 2 files changed, 106 insertions(+), 23 deletions(-)

-- 
1.9.1
