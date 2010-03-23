From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: Add missing command definitions
Date: Tue, 23 Mar 2010 01:13:28 -0400
Message-ID: <yq1fx3rhb7r.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:37585 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab0CWFO5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Mar 2010 01:14:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Douglas Gilbert <dgilbert@interlog.com>


Add definitions for VERIFY(12) and VERIFY(32).

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 8b4deca..651ec0f 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -114,6 +114,7 @@ struct scsi_cmnd;
 #define READ_12               0xa8
 #define WRITE_12              0xaa
 #define WRITE_VERIFY_12       0xae
+#define VERIFY_12	      0xaf
 #define SEARCH_HIGH_12        0xb0
 #define SEARCH_EQUAL_12       0xb1
 #define SEARCH_LOW_12         0xb2
@@ -134,6 +135,7 @@ struct scsi_cmnd;
 #define MO_SET_TARGET_PGS     0x0a
 /* values for variable length command */
 #define READ_32		      0x09
+#define VERIFY_32	      0x0a
 #define WRITE_32	      0x0b
 #define WRITE_SAME_32	      0x0d
 
