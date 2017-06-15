From: Minwoo Im <dn3108@gmail.com>
Subject: [PATCH] scsi_proto.h: ATA_32 added for ata pass-thru(32).
Date: Thu, 15 Jun 2017 20:29:24 +0900
Message-ID: <1497526164-7432-1-git-send-email-dn3108@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34021 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752381AbdFOL3c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jun 2017 07:29:32 -0400
Received: by mail-pf0-f196.google.com with SMTP id d5so1437483pfe.1
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jun 2017 04:29:32 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Minwoo Im <dn3108@gmail.com>

SAT-4(SCSI/ATA Translation Standard) supports a ATA PASS-THROUGH(32)
SCSI command. It uses 7Fh as a operation code which means
variable-length CDB.
It would be great if kernel supports an ata pass-thru(32) command.
Prior to development of ata pass-through in libata level,
the definition of it should be added first.

Signed-off-by: Minwoo Im <dn3108@gmail.com>
---
 include/scsi/scsi_proto.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index ce78ec8..1eb4efd 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -164,6 +164,7 @@
 #define WRITE_SAME_32	      0x0d
 
 /* Values for T10/04-262r7 */
+#define	ATA_32		      0x7F	/* 32-byte pass-thru */
 #define	ATA_16		      0x85	/* 16-byte pass-thru */
 #define	ATA_12		      0xa1	/* 12-byte pass-thru */
 
-- 
1.7.9.5
