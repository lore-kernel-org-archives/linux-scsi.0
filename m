From: John Garry <john.garry@huawei.com>
Subject: [PATCH 19/19] scsi: hisi_sas: remove driver versioning
Date: Fri, 11 Aug 2017 00:09:44 +0800
Message-ID: <1502381384-219889-20-git-send-email-john.garry@huawei.com>
References: <1502381384-219889-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502381384-219889-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, bianpan2016@163.com, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

The driver version is not updated with changes to the driver,
so it has no value, so just get rid of it.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       | 2 --
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 3 ---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 1 -
 3 files changed, 6 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 4c393cd..07f4a4c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -26,8 +26,6 @@
 #include <scsi/sas_ata.h>
 #include <scsi/libsas.h>
 
-#define DRV_VERSION "v1.6"
-
 #define HISI_SAS_MAX_PHYS	9
 #define HISI_SAS_MAX_QUEUES	32
 #define HISI_SAS_QUEUE_SLOTS 512
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 9427835..bdef111 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2013,8 +2013,6 @@ int hisi_sas_remove(struct platform_device *pdev)
 
 static __init int hisi_sas_init(void)
 {
-	pr_info("hisi_sas: driver version %s\n", DRV_VERSION);
-
 	hisi_sas_stt = sas_domain_attach_transport(&hisi_sas_transport_ops);
 	if (!hisi_sas_stt)
 		return -ENOMEM;
@@ -2030,7 +2028,6 @@ static __exit void hisi_sas_exit(void)
 module_init(hisi_sas_init);
 module_exit(hisi_sas_exit);
 
-MODULE_VERSION(DRV_VERSION);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("John Garry <john.garry@huawei.com>");
 MODULE_DESCRIPTION("HISILICON SAS controller driver");
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index a20e354..2e5fa97 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2005,7 +2005,6 @@ enum {
 
 module_pci_driver(sas_v3_pci_driver);
 
-MODULE_VERSION(DRV_VERSION);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("John Garry <john.garry@huawei.com>");
 MODULE_DESCRIPTION("HISILICON SAS controller v3 hw driver based on pci device");
-- 
1.9.1
