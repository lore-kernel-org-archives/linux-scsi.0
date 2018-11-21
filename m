From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 0/3]  hisi_sas: DIF/DIX support
Date: Wed, 21 Nov 2018 22:24:30 +0800
Message-ID: <1542810273-134731-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@infradead.org, maier@linux.ibm.com, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset introduces support to the driver for DIF/DIX (or PI -
protection information).

We will only support PI in v3 hw at the moment, even though previous hw
versions also support it.

The series is broken down as follows:
- Tidy sg table size config
- Some tidy-up to accept PI support
- Add components for PI support for main and v3 driver

Difference v1->v2:
- drop scsi_prot_op_normal()

Xiang Chen (3):
  scsi: hisi_sas: Relocate some code to reduce complexity
  scsi: hisi_sas: Make sg_tablesize consistent value
  scsi: hisi_sas: Add support for DIF/DIX feature for v3 hw

 drivers/scsi/hisi_sas/hisi_sas.h       |  18 +++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 242 ++++++++++++++++++++++++---------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |   2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |   2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 192 +++++++++++++++++++++++++-
 5 files changed, 380 insertions(+), 76 deletions(-)

-- 
1.9.1
