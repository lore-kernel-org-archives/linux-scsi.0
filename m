From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 0/8] hisi_sas internal abort support
Date: Wed, 24 Aug 2016 19:05:46 +0800
Message-ID: <1472036754-156813-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset introduces support for the internal abort
feature for the HiSilicon SAS controller.

The internal abort feature allows commands which are active
in the controller to be aborted before being sent to the
slave device.

Only support will be added for v2 HW since v1 HW has issues
in supporting internal abort feature.

Differences to v1 patchset:
- Add MACRO for internal abort mode and description
  of internal abort API

John Garry (8):
  hisi_sas: add internal abort main code
  hisi_sas: for internal abort in hisi_sas_dev_gone()
  hisi_sas: add internal abort to hisi_sas_abort_task()
  hisi_sas: add prep_abort_v2_hw()
  hisi_sas: add v2 hw slot complete internal abort support
  hisi_sas: fail tmf task prep when port detached
  hisi_sas: add TMF success check
  hisi_sas: update version to 1.6

 drivers/scsi/hisi_sas/hisi_sas.h       |  10 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 190 +++++++++++++++++++++++++++++++--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  64 +++++++++++
 3 files changed, 256 insertions(+), 8 deletions(-)

-- 
1.9.1
