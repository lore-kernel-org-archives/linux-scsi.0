From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] qlogicpti: Add missing parentheses
Date: Wed, 18 Feb 2009 13:48:11 +0100
Message-ID: <499C038B.7050607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:42135 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbZBRMsN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Feb 2009 07:48:13 -0500
Received: by bwz5 with SMTP id 5so5368848bwz.13
        for <linux-scsi@vger.kernel.org>; Wed, 18 Feb 2009 04:48:11 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

Add missing parentheses

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
This was used at drivers/scsi/qlogicpti.c:

946:   host->sg_tablesize = QLOGICPTI_MAX_SG(num_free);
1270:  .sg_tablesize           = QLOGICPTI_MAX_SG(QLOGICPTI_REQ_QUEUE_LEN),

diff --git a/drivers/scsi/qlogicpti.h b/drivers/scsi/qlogicpti.h
index 9c053bb..e3c74d1 100644
--- a/drivers/scsi/qlogicpti.h
+++ b/drivers/scsi/qlogicpti.h
@@ -43,7 +43,7 @@
  * determined for each queue request anew.
  */
 #define QLOGICPTI_REQ_QUEUE_LEN	255	/* must be power of two - 1 */
-#define QLOGICPTI_MAX_SG(ql)	(4 + ((ql) > 0) ? 7*((ql) - 1) : 0)
+#define QLOGICPTI_MAX_SG(ql)	(4 + (((ql) > 0) ? 7*((ql) - 1) : 0))
 
 /* mailbox command complete status codes */
 #define MBOX_COMMAND_COMPLETE		0x4000
