From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] Missing command declarations
Date: Sat, 03 Oct 2009 23:09:14 -0400
Message-ID: <yq17hvbzwh1.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:50331 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756952AbZJDDK0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Oct 2009 23:10:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Douglas Gilbert <dgilbert@interlog.com>


scsi: Add missing command definitions

Add definitions for UNMAP, WRITE SAME{16,32} and GET LBA STATUS
commands.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 34c46ab..8b4deca 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -94,6 +94,7 @@ struct scsi_cmnd;
 #define WRITE_LONG            0x3f
 #define CHANGE_DEFINITION     0x40
 #define WRITE_SAME            0x41
+#define UNMAP		      0x42
 #define READ_TOC              0x43
 #define LOG_SELECT            0x4c
 #define LOG_SENSE             0x4d
@@ -122,9 +123,11 @@ struct scsi_cmnd;
 #define READ_16               0x88
 #define WRITE_16              0x8a
 #define VERIFY_16	      0x8f
+#define WRITE_SAME_16	      0x93
 #define SERVICE_ACTION_IN     0x9e
 /* values for service action in */
 #define	SAI_READ_CAPACITY_16  0x10
+#define SAI_GET_LBA_STATUS    0x12
 /* values for maintenance in */
 #define MI_REPORT_TARGET_PGS  0x0a
 /* values for maintenance out */
@@ -132,6 +135,7 @@ struct scsi_cmnd;
 /* values for variable length command */
 #define READ_32		      0x09
 #define WRITE_32	      0x0b
+#define WRITE_SAME_32	      0x0d
 
 /* Values for T10/04-262r7 */
 #define	ATA_16		      0x85	/* 16-byte pass-thru */
