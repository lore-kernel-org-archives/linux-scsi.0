From: John Garry <john.garry@huawei.com>
Subject: [PATCH 0/5] hisi_sas: v2 hw SATA fixes
Date: Fri, 8 Apr 2016 17:23:10 +0800
Message-ID: <1460107395-24501-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset introduces SATA support fixes for
the HiSilicon v2 hw SAS controller.

Fixes include:
- attach issue for SATA disk attached through expander
- intermittent issue for directly attaching multiple
SATA disks
- add support for directly attaching SATA disk to phy
index 4+
- ITCT config issue

John Garry (5):
  hisi_sas: use device linkrate in MCR for v2 hw
  hisi_sas: fix v2 hw multiple SATA disk issue
  hisi_sas: add v2 hw support for >4 SATA phys
  hisi_sas: for v2 hw only set ITCT qw2 for SAS device
  hisi_sas: update driver version to 1.4

 drivers/scsi/hisi_sas/hisi_sas.h       |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 32 +++++++++++++++++---------------
 2 files changed, 18 insertions(+), 16 deletions(-)

-- 
1.9.1
