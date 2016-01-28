From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: [PATCH v2 15/15] megaraid_sas: driver version upgrade
Date: Thu, 28 Jan 2016 21:04:36 +0530
Message-ID: <1453995276-24955-16-git-send-email-sumit.saxena@avagotech.com>
References: <1453995276-24955-1-git-send-email-sumit.saxena@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34662 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967066AbcA1PgO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2016 10:36:14 -0500
Received: by mail-pa0-f50.google.com with SMTP id uo6so25323908pac.1
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jan 2016 07:36:10 -0800 (PST)
In-Reply-To: <1453995276-24955-1-git-send-email-sumit.saxena@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com, thenzl@redhat.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 3e92f20..b6fdb48 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -35,8 +35,8 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"06.808.16.00-rc1"
-#define MEGASAS_RELDATE				"Oct. 8, 2015"
+#define MEGASAS_VERSION				"06.810.09.00-rc1"
+#define MEGASAS_RELDATE				"Jan. 28, 2016"
 
 /*
  * Device IDs
-- 
1.8.3.1

