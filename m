From: John Garry <john.garry@huawei.com>
Subject: [PATCH 23/23] hisi_sas: update driver version to 1.1
Date: Fri, 8 Jan 2016 22:15:42 +0800
Message-ID: <1452262542-64589-24-git-send-email-john.garry@huawei.com>
References: <1452262542-64589-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452262542-64589-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, devicetree@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index f00b55b..9f08c0c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -21,7 +21,7 @@
 #include <scsi/sas_ata.h>
 #include <scsi/libsas.h>
 
-#define DRV_VERSION "v1.0"
+#define DRV_VERSION "v1.1"
 
 #define HISI_SAS_MAX_PHYS	9
 #define HISI_SAS_MAX_QUEUES	32
-- 
1.9.1
