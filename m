From: John Garry <john.garry@huawei.com>
Subject: [PATCH 0/6] libsas: Some minor improvements and tidy-up
Date: Fri, 12 Apr 2019 16:57:51 +0800
Message-ID: <1555059478-36224-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, yanaijie@huawei.com, chenxiang66@hisilicon.com, luojiaxing@huawei.com, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset introduces some minor improvements and tidy-up, including:
- fix PHY info in sysfs for PHY events
- min pathway rate programming improvement
- some other tidy-up and neatening

John Garry (6):
  scsi: libsas: Stop hardcoding SAS address length
  scsi: libsas: Try to retain programmed min linkrate for SATA min
    pathway unmatch fixing
  scsi: libsas: Improve vague log in SAS rediscovery
  scsi: libsas: Inject revalidate event for root port event
  scsi: libsas: Do discovery on empty PHY to update PHY info
  scsi: libsas: Print expander PHY indexes in decimal

 drivers/scsi/libsas/sas_ata.c      |  2 +-
 drivers/scsi/libsas/sas_expander.c | 83 ++++++++++++++++++------------
 drivers/scsi/libsas/sas_init.c     | 42 ++++++++-------
 drivers/scsi/libsas/sas_phy.c      |  7 ++-
 drivers/scsi/libsas/sas_port.c     | 24 +++++++--
 include/scsi/libsas.h              | 13 +++--
 6 files changed, 108 insertions(+), 63 deletions(-)

-- 
2.17.1
