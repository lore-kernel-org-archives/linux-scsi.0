From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH v2 10/10] megaraid_sas : Version upgrade
Date: Thu, 20 Aug 2015 18:45:19 +0530
Message-ID: <201508201320.t7KDKruo028848@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bastion.smtp.avagotech.com ([202.86.248.61]:46529 "EHLO
	sgpsmtp1.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbbHTNPc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2015 09:15:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, kiran-kumar.kasturi@avagotech.com
Cc: uday.lingala@avagotech.com

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index ccda60d..fc58ba3 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -35,8 +35,8 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"06.807.10.00-rc1"
-#define MEGASAS_RELDATE				"March 6, 2015"
+#define MEGASAS_VERSION				"06.808.14.00-rc1"
+#define MEGASAS_RELDATE				"Jul 31, 2015"
 
 /*
  * Device IDs
-- 
1.7.1

