From: John Garry <john.garry@huawei.com>
Subject: [PATCH 00/19] hisi_sas: misc fixes, improvements, and new features
Date: Fri, 11 Aug 2017 00:09:25 +0800
Message-ID: <1502381384-219889-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, bianpan2016@163.com, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset introduces an array of misc changes, most
significantly including:
- v2 hw reset function
- core driver reset handler fixes
- DFX feature
- some interrupt/tasklet/probe+removal error path cleanup

John Garry (4):
  scsi: hisi_sas: use array for v2 hw ECC errors
  scsi: hisi_sas: remove phy_down_v3_hw() res variable
  scsi: hisi_sas: replace kfree with scsi_host_put
  scsi: hisi_sas: remove driver versioning

Xiang Chen (12):
  scsi: hisi_sas: avoid potential v2 hw interrupt issue
  scsi: hisi_sas: fix v2 hw underflow residual value
  scsi: hisi_sas: remove repeated device config in v2 hw
  scsi: hisi_sas: add irq and tasklet cleanup in v2 hw
  scsi: hisi_sas: service interrupt ITCT_CLR interrupt in v2 hw
  scsi: hisi_sas: add status and command buffer for internal abort
  scsi: hisi_sas: Modify v3 hw STP_LINK_TIMER setting
  scsi: hisi_sas: fix v3 hw channel interrupt processing
  scsi: hisi_sas: kill tasklet when destroying irq in v3 hw
  scsi: hisi_sas: update some v3 register init settings
  scsi: hisi_sas: add reset handler for v3 hw
  scsi: hisi_sas: add phy_set_linkrate_v3_hw()

Xiaofei Tan (3):
  scsi: hisi_sas: fix reset and port ID refresh issues
  scsi: hisi_sas: add v2 hw DFX feature
  scsi: hisi_sas: support zone management commands

 drivers/scsi/hisi_sas/hisi_sas.h       |  18 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 196 +++++++----
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 605 +++++++++++++++++----------------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 237 +++++++++++--
 4 files changed, 656 insertions(+), 400 deletions(-)

-- 
1.9.1
