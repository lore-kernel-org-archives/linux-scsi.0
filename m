From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 5/7] scsi: hisi_sas: downgrade internal abort exit print
Date: Fri, 20 Jan 2017 20:45:22 +0800
Message-ID: <1484916324-211630-6-git-send-email-john.garry@huawei.com>
References: <1484916324-211630-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:12515 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751834AbdATMSx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jan 2017 07:18:53 -0500
In-Reply-To: <1484916324-211630-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jthumshirn@suse.de, John Garry <john.garry@huawei.com>

Downgrade the exit print in hisi_sas_internal_task_abort()
to dbg level, as info is not required.

Signed-off-by: John Garry <john.garry@huawei.com>
Reviewed-by: Xiang Chen <chenxiang66@hisilicon.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index eee7ae2..b2782ce 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1121,7 +1121,7 @@ static int hisi_sas_query_task(struct sas_task *task)
 	}
 
 exit:
-	dev_info(dev, "internal task abort: task to dev %016llx task=%p "
+	dev_dbg(dev, "internal task abort: task to dev %016llx task=%p "
 		"resp: 0x%x sts 0x%x\n",
 		SAS_ADDR(device->sas_addr),
 		task,
-- 
1.9.1

