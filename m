From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 0/5] scsi: libsas: some code cleanups and bug fixes
Date: Wed, 12 Sep 2018 16:29:41 +0800
Message-ID: <20180912082946.34814-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, miaoxie@huawei.com, Jason Yan <yanaijie@huawei.com>
List-Id: linux-scsi@vger.kernel.org

I split some code cleanups and bug fixes patches from my earlier series:
https://lkml.org/lkml/2018/5/28/2154

These patches are separate to the subject of the earlier series and are just
small fixes. Hope it is much easier to review and test.

Jason Yan (5):
  scsi: libsas: delete dead code in scsi_transport_sas.c
  scsi: libsas: check the lldd callback correctly
  scsi: libsas: always unregister the old device if going to discover
    new
  scsi: libsas: check the ata device status by ata_dev_enabled()
  scsi: libsas: fix a race condition when smp task timeout

 drivers/scsi/hisi_sas/hisi_sas_main.c |  9 ++-------
 drivers/scsi/libsas/sas_ata.c         |  2 +-
 drivers/scsi/libsas/sas_discover.c    |  2 +-
 drivers/scsi/libsas/sas_expander.c    | 22 +++++++++-------------
 drivers/scsi/scsi_transport_sas.c     |  2 --
 5 files changed, 13 insertions(+), 24 deletions(-)

-- 
2.14.4
