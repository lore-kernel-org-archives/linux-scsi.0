From: John Garry <john.garry@huawei.com>
Subject: [PATCH 6/6] hisi_sas: update driver version to 1.3
Date: Tue, 16 Feb 2016 20:22:31 +0800
Message-ID: <1455625351-165881-7-git-send-email-john.garry@huawei.com>
References: <1455625351-165881-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455625351-165881-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index a05ce71..beb7318 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -23,7 +23,7 @@
 #include <scsi/sas_ata.h>
 #include <scsi/libsas.h>
 
-#define DRV_VERSION "v1.2"
+#define DRV_VERSION "v1.3"
 
 #define HISI_SAS_MAX_PHYS	9
 #define HISI_SAS_MAX_QUEUES	32
-- 
1.9.1
