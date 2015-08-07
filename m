From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH 7/7] megaraid_sas : Version upgrade
Date: Fri, 7 Aug 2015 17:54:42 +0530
Message-ID: <201508071230.t77CUx2b021214@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sgpsmtp2.avagotech.com ([199.3.246.86]:60046 "EHLO
	sgpsmtp2.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbbHGMfo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2015 08:35:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, kiran-kumar.kasturi@avagotech.com
Cc: uday.lingala@avagotech.com


Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
---
diff --git a/megaraid_sas.h b/megaraid_sas.h
index ccda60d..b1c605f 100644
--- a/megaraid_sas.h
+++ b/megaraid_sas.h
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
