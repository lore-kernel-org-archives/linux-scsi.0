From: John Garry <john.garry@huawei.com>
Subject: [PATCH v5 0/2]  hisi_sas: DIF support
Date: Mon, 17 Dec 2018 22:40:06 +0800
Message-ID: <1545057608-89965-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset introduces support to the driver for DIF/DIX.

We are making DIX support as RFC for now, based on issues discussed in the
following:
https://marc.info/?l=linux-scsi&m=154357719329297&w=4 and
https://marc.info/?l=linux-scsi&m=154406987703456&w=2

We will only support PI in v3 hw at the moment, even though previous hw
versions also support it.

Differences:
v4->v5:
- Drop already accepted patches
- Fix comments according to Martin
  - use t10_pi_ref_tag()
  - stop using protection options in LLDD in favour of prot flags
  - allow user to set prot mask

v3->v4:
- re-add DIX support as RFC - do not commit please!
- also DIX support is labelled experimental in the driver

v2->v3:
- fix sparse warnings
- drop DIX support

v1->v2:
- drop scsi_prot_op_normal()
Xiang Chen (2):
  scsi: hisi_sas: Add support for DIF feature for v2 hw
  scsi: hisi_sas: Add support for DIX feature for v3 hw as experimental

 drivers/scsi/hisi_sas/hisi_sas.h       |  28 +++++
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  97 ++++++++++++++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 197 ++++++++++++++++++++++++++++++++-
 3 files changed, 305 insertions(+), 17 deletions(-)

-- 
1.9.1
