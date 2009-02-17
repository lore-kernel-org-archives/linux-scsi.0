From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] ses: code_set == 1 is tested twice
Date: Tue, 17 Feb 2009 16:59:24 +0100
Message-ID: <499ADEDC.108@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:36422 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbZBQP70 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Feb 2009 10:59:26 -0500
Received: by bwz5 with SMTP id 5so4239953bwz.13
        for <linux-scsi@vger.kernel.org>; Tue, 17 Feb 2009 07:59:24 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Maybe double check whether something else is missing instead?
Otherwise feel free to ignore.
--------------------------->8-------------8<------------------------------
code_set == 1 is tested twice.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index e946e05..a3da4ce 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -393,7 +393,7 @@ static void ses_match_to_enclosure(struct enclosure_device *edev,
 		u8 type = desc[1] & 0x0f;
 		u8 len = desc[3];
 
-		if (piv && code_set == 1 && assoc == 1 && code_set == 1
+		if (piv && code_set == 1 && assoc == 1
 		    && proto == SCSI_PROTOCOL_SAS && type == 3 && len == 8)
 			efd.addr = (u64)desc[4] << 56 |
 				(u64)desc[5] << 48 |
