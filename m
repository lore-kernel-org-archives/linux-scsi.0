From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH 4/4] megaraid_sas: driver version upgrade
Date: Fri, 15 Apr 2016 00:23:33 -0700
Message-ID: <1460705013-6482-5-git-send-email-sumit.saxena@broadcom.com>
References: <1460705013-6482-1-git-send-email-sumit.saxena@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:32948 "EHLO
	mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbcDOHYK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Apr 2016 03:24:10 -0400
Received: by mail-pf0-f173.google.com with SMTP id 184so54562978pff.0
        for <linux-scsi@vger.kernel.org>; Fri, 15 Apr 2016 00:24:10 -0700 (PDT)
In-Reply-To: <1460705013-6482-1-git-send-email-sumit.saxena@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, hch@infradead.org, thenzl@redhat.com
Cc: kashyap.desai@broadcom.com, linux-scsi@vger.kernel.org, sumit.saxena@broadcom.com

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 1784b09..ca86c88 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -35,8 +35,8 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"06.810.09.00-rc1"
-#define MEGASAS_RELDATE				"Jan. 28, 2016"
+#define MEGASAS_VERSION				"06.811.02.00-rc1"
+#define MEGASAS_RELDATE				"April 12, 2016"
 
 /*
  * Device IDs
-- 
2.4.11

