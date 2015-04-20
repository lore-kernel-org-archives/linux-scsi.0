From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH RESEND 7/18] megaraid_sas : Modify driver's meta data to
 reflect Avago
Date: Mon, 20 Apr 2015 18:03:30 +0530
Message-ID: <201504201235.t3KCZgEm016534@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:49041
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755126AbbDTMsw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Apr 2015 08:48:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

This patch will update module parameters and driver name inside SCSI host template to reflect Avago.

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 85feb00..3970780 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -94,8 +94,8 @@ MODULE_PARM_DESC(smp_affinity_enable, "SMP affinity feature enable/disbale Defau
 
 MODULE_LICENSE("GPL");
 MODULE_VERSION(MEGASAS_VERSION);
-MODULE_AUTHOR("megaraidlinux@lsi.com");
-MODULE_DESCRIPTION("LSI MegaRAID SAS Driver");
+MODULE_AUTHOR("megaraidlinux.pdl@avagotech.com");
+MODULE_DESCRIPTION("Avago MegaRAID SAS Driver");
 
 int megasas_transition_to_ready(struct megasas_instance *instance, int ocr);
 static int megasas_get_pd_list(struct megasas_instance *instance);
@@ -2775,7 +2775,7 @@ struct device_attribute *megaraid_host_attrs[] = {
 static struct scsi_host_template megasas_template = {
 
 	.module = THIS_MODULE,
-	.name = "LSI SAS based MegaRAID driver",
+	.name = "Avago SAS based MegaRAID driver",
 	.proc_name = "megaraid_sas",
 	.slave_configure = megasas_slave_configure,
 	.slave_alloc = megasas_slave_alloc,
-- 
1.7.1

