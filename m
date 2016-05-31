From: John Garry <john.garry@huawei.com>
Subject: [PATCH 0/3] hisi_sas: v2 hw ACPI support and fix lock
Date: Tue, 31 May 2016 20:38:48 +0800
Message-ID: <1464698331-228732-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:30452 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbcEaMZ5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2016 08:25:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>

This patchset introduces 2 separate features/fixes:
- v2 hw ACPI support: implemented the same as v1 hw
- fix inconsistent lock: remove unnecessary spinlock_irqsave()
  in broadcast interrupt handler

John Garry (3):
  hisi_sas: add v2 hw ACPI support
  hisi_sas: fix the inconsistent lock issue reported by
    CONFIG_PROVE_LOCKING
  hisi_sas: update driver version to 1.5

 drivers/scsi/hisi_sas/hisi_sas.h       |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 73 ++++++++++++++++++++--------------
 2 files changed, 44 insertions(+), 31 deletions(-)

-- 
1.9.1

