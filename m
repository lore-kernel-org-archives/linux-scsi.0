From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 14/14] megaraid_sas: driver version upgrade
Date: Fri,  5 Jan 2018 05:27:49 -0800
Message-ID: <1515158869-26693-15-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1515158869-26693-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:40512 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751720AbeAEN3q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jan 2018 08:29:46 -0500
Received: by mail-pl0-f66.google.com with SMTP id 62so3040226pld.7
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jan 2018 05:29:46 -0800 (PST)
In-Reply-To: <1515158869-26693-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index d557ff03eb1d..ba6503f37756 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -35,8 +35,8 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"07.703.05.00-rc1"
-#define MEGASAS_RELDATE				"October 5, 2017"
+#define MEGASAS_VERSION				"07.704.04.00-rc1"
+#define MEGASAS_RELDATE				"December 7, 2017"
 
 /*
  * Device IDs
-- 
2.14.1
