From: John Garry <john.garry@huawei.com>
Subject: [PATCH 00/11] hisi_sas: some fixes, improvements, and new features
Date: Mon, 7 Nov 2016 20:48:29 +0800
Message-ID: <1478522920-108145-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, john.garry2@mail.dcu.ie, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset introduces some misc bug fixes, improvements,
and new features to the HiSilicon SAS driver.

The new features include:
- ECC and AXI bus fatal error handling for v2 hw
- PHY (min and max) linkrate setting

John Garry (1):
  hisi_sas: use atomic64_t for hisi_sas_device.running_req

Xiang Chen (10):
  hisi_sas: add v2 hw support for ECC and AXI bus fatal error
  hisi_sas: alloc queue id of slot according to device id
  hisi_sas: only process broadcast change in phy_bcast_v2_hw()
  hisi_sas: fix port form bug in hisi_sas_port_notify_formed()
  hisi_sas: replace WARN_ON() with dev_warn() for internal abort
  hisi_sas: modify return value of hisi_sas_query_task()
  hisi_sas: delete repeated configuration in free_device_v2_hw()
  hisi_sas: modify some values in get_ata_protocol()
  hisi_sas: check SATA FIS when directly attaching SATA device
  hisi_sas: add PHY set linkrate support for v1 and v2 hw

 drivers/scsi/hisi_sas/hisi_sas.h       |   9 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  37 ++-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  79 +++--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 539 +++++++++++++++++++++++++++++++--
 4 files changed, 599 insertions(+), 65 deletions(-)

-- 
1.9.1
