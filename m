From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 3/3] scsi: arcmsr: Update driver version to
 v1.40.00.03-20171121
Date: Thu, 23 Nov 2017 09:34:38 +0800
Message-ID: <1511400878.9832.26.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:37722 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751842AbdKWJeq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Nov 2017 04:34:46 -0500
Received: by mail-io0-f174.google.com with SMTP id v21so26091677ioi.4
        for <linux-scsi@vger.kernel.org>; Thu, 23 Nov 2017 01:34:46 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jthumshirn@suse.de, hare@suse.de, dan.carpenter@oracle.com, hch@infradead.org

From: Ching Huang <ching2048@areca.com.tw>

Update driver version to v1.40.00.03-20171121

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h	2017-11-23 14:29:46.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr.h	2017-11-23 16:12:54.000000000 +0800
@@ -54,7 +54,7 @@ struct device_attribute;
 #endif
 #define ARCMSR_DEFAULT_OUTSTANDING_CMD	128
 #define ARCMSR_MIN_OUTSTANDING_CMD	32
-#define ARCMSR_DRIVER_VERSION		"v1.40.00.02-20171011"
+#define ARCMSR_DRIVER_VERSION		"v1.40.00.03-20171121"
 #define ARCMSR_SCSI_INITIATOR_ID	255
 #define ARCMSR_MAX_XFER_SECTORS		512
 #define ARCMSR_MAX_XFER_SECTORS_B	4096
