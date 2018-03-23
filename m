From: John Garry <john.garry@huawei.com>
Subject: [PATCH 0/8] hisi_sas: some misc changes
Date: Sat, 24 Mar 2018 00:05:07 +0800
Message-ID: <1521821115-120040-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset introduces some minor, more trivial patches,
some of which have been sitting on our internal dev branch
for a while.

The only bug fixes (hw workaround or sw) are the IPTT range
check fix and a timer fix for module removal. Others are
trivial.

John Garry (2):
  scsi: hisi_sas: print device id for errors
  scsi: hisi_sas: remove some unneeded structure members

Xiang Chen (3):
  scsi: hisi_sas: make SAS address of SATA disks unique
  scsi: hisi_sas: delete timer when removing hisi_sas driver
  scsi: hisi_sas: use dma_zalloc_coherent()

Xiaofei Tan (3):
  scsi: hisi_sas: update RAS feature for later revision of v3 HW
  scsi: hisi_sas: consolidate command check in
    hisi_sas_get_ata_protocol()
  scsi: hisi_sas: check IPTT is valid before using it for v3 hw

 drivers/scsi/hisi_sas/hisi_sas.h       |  3 --
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 53 +++++++++-------------
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  8 ++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 81 +++++++++++++++++++++++++++++-----
 4 files changed, 94 insertions(+), 51 deletions(-)

-- 
1.9.1
