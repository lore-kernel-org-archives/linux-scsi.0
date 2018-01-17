From: John Garry <john.garry@huawei.com>
Subject: [PATCH 0/3] hisi_sas: v2 hw LED support
Date: Thu, 18 Jan 2018 00:46:51 +0800
Message-ID: <1516207614-159721-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, robh+dt@kernel.org, mark.rutland@arm.com
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset includes SGPIO support for
driving LEDs for boards including a SoC (like
hip07) with v2 hw.

The SGPIO interface is realised with a CPLD on
the D05 board which inludes hip07.

Also included in the patchset is a small bug fix
for device removal.

Xiang Chen (1):
  scsi: hisi_sas: fix a bug in hisi_sas_dev_gone()

Xiaofei Tan (2):
  devicetree: bindings: scsi: hisi_sas: add LED feature for v2 hw
  scsi: hisi_sas: directly attached disk LED feature for v2 hw

 .../devicetree/bindings/scsi/hisilicon-sas.txt     |  5 ++-
 drivers/scsi/hisi_sas/hisi_sas.h                   |  3 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c              | 21 +++++++++++-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             | 39 ++++++++++++++++++++++
 4 files changed, 66 insertions(+), 2 deletions(-)

-- 
1.9.1
