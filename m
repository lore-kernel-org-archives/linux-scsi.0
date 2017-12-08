From: John Garry <john.garry@huawei.com>
Subject: [PATCH 00/19] hisi_sas: PM, RAS, and other misc changes
Date: Sat, 9 Dec 2017 01:16:31 +0800
Message-ID: <1512753410-50924-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset contains support for some new
features, and also some modifications and other
fixes.

Headline changes include:
- v3 hw Suspend and Resume support
- v3 hw RAS (PCI AER) support
- v2 hw HW port error handling support
- other misc fixes and tidy-up

Xiang Chen (8):
  scsi: hisi_sas: initialize dq spinlock before use
  scsi: hisi_sas: fix dma_unmap_sg() parameter
  scsi: hisi_sas: modify hisi_sas_dev_gone() for reset
  scsi: hisi_sas: change ncq process for v3 hw
  scsi: hisi_sas: add some print to enhance debugging
  scsi: hisi_sas: fix SAS_QUEUE_FULL problem while running IO
  scsi: hisi_sas: re-add the lldd_port_deformed()
  scsi: hisi_sas: add v3 hw suspend and resume

Xiaofei Tan (11):
  scsi: hisi_sas: relocate clearing ITCT and freeing device
  scsi: hisi_sas: optimise port id refresh function
  scsi: hisi_sas: some optimizations of host controller reset
  scsi: hisi_sas: add an mechanism to do reset work synchronously
  scsi: hisi_sas: add RAS feature for v3 hw
  scsi: hisi_sas: improve int_chnl_int_v2_hw() consistenty with v3 hw
  scsi: hisi_sas: add v2 hw port AXI error handling support
  scsi: hisi_sas: use an general way to delay PHY work
  scsi: hisi_sas: do link reset for some CHL_INT2 ints
  scsi: hisi_sas: judge result of internal abort
  scsi: hisi_sas: add internal abort dev in some places

 drivers/scsi/hisi_sas/hisi_sas.h       |  40 +++-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 222 +++++++++++++++++-----
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |   6 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 153 ++++++++++-----
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 330 ++++++++++++++++++++++++++++-----
 5 files changed, 610 insertions(+), 141 deletions(-)

-- 
1.9.1
