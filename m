From: John Garry <john.garry@huawei.com>
Subject: [PATCH 00/15] hisi_sas misc fixes and minor optimisations
Date: Tue, 6 Sep 2016 23:36:10 +0800
Message-ID: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset introdcues some minor bug fixes and
optimisations for v1+v2 hw.

No new functional features are introduced in this patchset.

John Garry (15):
  hisi_sas: save completion queue read pointer
  hisi_sas: save delivery queue write pointer
  hisi_sas: keep CHL_INT2 masked for v2 HW
  hisi_sas: only zero slot memory when reused
  hisi_sas: use safe BITS_PER_BYTE for slot tag size calculation
  hisi_sas: disable dlvry queues once at reset for v2 hw
  hisi_sas: fix phy8 linkrate calculation in phy_up_v2_hw()
  hisi_sas: fix a potential warning for sata disk ejection
  hisi_sas: set dma mask before allocate DMA memory
  hisi_sas: fix HBA SAS addr endianness for v2 hw
  hisi_sas: fix HBA SAS addr endianness for v1 hw
  hisi_sas: remove init_id_frame_v2_hw()
  hisi_sas: remove init_id_frame_v1_hw()
  hisi_sas: add missing SATA pending device type to v2 hw
  hisi_sas: send three identify before PHY up

 drivers/scsi/hisi_sas/hisi_sas.h       |  8 +++++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 48 ++++++++++---------------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 36 +++++++------------
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 66 ++++++++++++++++------------------
 4 files changed, 70 insertions(+), 88 deletions(-)

-- 
1.9.1
