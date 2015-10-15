From: sumit.saxena@avagotech.com
Subject: [PATCH 11/12] megaraid_sas : Driver version upgrade
Date: Thu, 15 Oct 2015 13:41:04 +0530
Message-ID: <201510150818.t9F8INIa029677@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rndsmtp1.avagotech.com ([202.86.248.48]:60969 "EHLO
	rndsmtp1.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbbJOIUt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Oct 2015 04:20:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, kiran-kumar.kasturi@avagotech.com
Cc: uday.lingala@avagotech.com


Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 7c14a20..9b918ab 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -35,8 +35,8 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"06.808.14.00-rc1"
-#define MEGASAS_RELDATE				"Jul 31, 2015"
+#define MEGASAS_VERSION				"06.808.16.00-rc1"
+#define MEGASAS_RELDATE				"Oct. 8, 2015"
 
 /*
  * Device IDs
-- 
1.7.1

