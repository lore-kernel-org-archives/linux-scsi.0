From: John Garry <john.garry@huawei.com>
Subject: [PATCH 3/3] hisi_sas: update driver version to 1.2
Date: Thu, 4 Feb 2016 02:26:10 +0800
Message-ID: <1454523970-118251-4-git-send-email-john.garry@huawei.com>
References: <1454523970-118251-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:43042 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965168AbcBCSOv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2016 13:14:51 -0500
In-Reply-To: <1454523970-118251-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
---
 drivers/scsi/hisi_sas/hisi_sas.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 5b8affd..02da7e4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -23,7 +23,7 @@
 #include <scsi/sas_ata.h>
 #include <scsi/libsas.h>
 
-#define DRV_VERSION "v1.1"
+#define DRV_VERSION "v1.2"
 
 #define HISI_SAS_MAX_PHYS	9
 #define HISI_SAS_MAX_QUEUES	32
-- 
1.9.1

