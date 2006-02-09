From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [Fwd: [SCSI] jazz_esp: Delete useless prototype]
Date: Thu, 09 Feb 2006 11:15:49 -0500
Message-ID: <1139501750.3275.20.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:52116 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932583AbWBIQP5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Feb 2006 11:15:57 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k19GFp222301
	for <linux-scsi@vger.kernel.org>; Thu, 9 Feb 2006 11:15:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

-------- Forwarded Message --------
From: Ralf Baechle <ralf@linux-mips.org>
To: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [SCSI] jazz_esp: Delete useless prototype
Date: Wed, 8 Feb 2006 22:44:43 +0000

---
 drivers/scsi/jazz_esp.c |    1 -
 1 files changed, 1 deletion(-)

Index: upstream-linus.git/drivers/scsi/jazz_esp.c
===================================================================
--- upstream-linus.git.orig/drivers/scsi/jazz_esp.c
+++ upstream-linus.git/drivers/scsi/jazz_esp.c
@@ -52,7 +52,6 @@ static volatile unsigned char cmd_buffer
 				 * via PIO.
 				 */
 
-int jazz_esp_detect(struct scsi_host_template *tpnt);
 static int jazz_esp_release(struct Scsi_Host *shost)
 {
 	if (shost->irq)

