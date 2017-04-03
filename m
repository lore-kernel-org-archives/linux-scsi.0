From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] sas: remove sas_domain_release_transport
Date: Mon,  3 Apr 2017 16:32:50 +0200
Message-ID: <20170403143250.14125-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

sas_domain_release_transport is unused since at least v3.13, remove it.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/libsas/sas_init.c | 7 -------
 include/scsi/libsas.h          | 1 -
 2 files changed, 8 deletions(-)

diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 15ef8e2..64e9cdd 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -566,13 +566,6 @@ sas_domain_attach_transport(struct sas_domain_function_template *dft)
 }
 EXPORT_SYMBOL_GPL(sas_domain_attach_transport);
 
-
-void sas_domain_release_transport(struct scsi_transport_template *stt)
-{
-	sas_release_transport(stt);
-}
-EXPORT_SYMBOL_GPL(sas_domain_release_transport);
-
 /* ---------- SAS Class register/unregister ---------- */
 
 static int __init sas_class_init(void)
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index dae99d7..dd0f72c 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -693,7 +693,6 @@ extern int sas_bios_param(struct scsi_device *,
 			  sector_t capacity, int *hsc);
 extern struct scsi_transport_template *
 sas_domain_attach_transport(struct sas_domain_function_template *);
-extern void sas_domain_release_transport(struct scsi_transport_template *);
 
 int  sas_discover_root_expander(struct domain_device *);
 
-- 
2.10.2
