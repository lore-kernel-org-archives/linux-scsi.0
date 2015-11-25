From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH v2 3/3] arcmsr: changes driver version number
Date: Wed, 25 Nov 2015 11:40:54 +0800
Message-ID: <1448422854.4698.38.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34548 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbbKYDk5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2015 22:40:57 -0500
Received: by padhx2 with SMTP id hx2so43013881pad.1
        for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2015 19:40:56 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, thenzl@redhat.com, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de
Cc: hch@lst.de

From: Ching Huang <ching2048@areca.com.tw>

Changes driver version number.

Signed-of-by: Ching Huang <ching2048@areca.com.tw>

---

diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h	2015-11-25 10:52:13.334470000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr.h	2015-10-19 15:57:08.000000000 +0800
@@ -52,7 +52,7 @@ struct device_attribute;
 	#define ARCMSR_MAX_FREECCB_NUM	320
 #define ARCMSR_MAX_OUTSTANDING_CMD	255
 #endif
-#define ARCMSR_DRIVER_VERSION		"v1.30.00.04-20140919"
+#define ARCMSR_DRIVER_VERSION		"v1.30.00.21-20151019"
 #define ARCMSR_SCSI_INITIATOR_ID						255
 #define ARCMSR_MAX_XFER_SECTORS							512
 #define ARCMSR_MAX_XFER_SECTORS_B						4096


