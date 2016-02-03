From: John Garry <john.garry@huawei.com>
Subject: [PATCH 0/3] HiSilicon SAS ACPI support
Date: Thu, 4 Feb 2016 02:26:07 +0800
Message-ID: <1454523970-118251-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset introduces support for ACPI in the
HiSilicon SAS driver. The driver will support
both device tree and ACPI.
Currently only v1 hw will use ACPI.

John Garry (3):
  hisi_sas: use Unified Device Properties API
  hisi_sas: add v1 hw ACPI support
  hisi_sas: update driver version to 1.2

 drivers/scsi/hisi_sas/hisi_sas.h       |  4 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 41 +++++++++++----------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 67 ++++++++++++++++++++++------------
 3 files changed, 67 insertions(+), 45 deletions(-)

-- 
1.9.1
