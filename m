From: akpm@linux-foundation.org
Subject: [patch 22/28] scsi: fix/convert scsi_scan.c kernel-doc
Date: Tue, 27 Apr 2010 14:23:04 -0700
Message-ID: <201004272123.o3RLN5w4020844@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757104Ab0D0V1q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2010 17:27:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, randy.dunlap@oracle.com

From: Randy Dunlap <randy.dunlap@oracle.com>

scsi_scan.c: fix incorrectly formatted kernel-doc notation & convert
documentation of 2 functions into kernel-doc.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_scan.c |   26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff -puN drivers/scsi/scsi_scan.c~scsi-fix-convert-scsi_scanc-kernel-doc drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c~scsi-fix-convert-scsi_scanc-kernel-doc
+++ a/drivers/scsi/scsi_scan.c
@@ -1220,7 +1220,7 @@ static void scsi_sequential_lun_scan(str
 }
 
 /**
- * scsilun_to_int: convert a scsi_lun to an int
+ * scsilun_to_int - convert a scsi_lun to an int
  * @scsilun:	struct scsi_lun to be converted.
  *
  * Description:
@@ -1252,7 +1252,7 @@ int scsilun_to_int(struct scsi_lun *scsi
 EXPORT_SYMBOL(scsilun_to_int);
 
 /**
- * int_to_scsilun: reverts an int into a scsi_lun
+ * int_to_scsilun - reverts an int into a scsi_lun
  * @lun:        integer to be reverted
  * @scsilun:	struct scsi_lun to be set.
  *
@@ -1876,12 +1876,9 @@ void scsi_forget_host(struct Scsi_Host *
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
-/*
- * Function:    scsi_get_host_dev()
- *
- * Purpose:     Create a scsi_device that points to the host adapter itself.
- *
- * Arguments:   SHpnt   - Host that needs a scsi_device
+/**
+ * scsi_get_host_dev - Create a scsi_device that points to the host adapter itself
+ * @shost: Host that needs a scsi_device
  *
  * Lock status: None assumed.
  *
@@ -1894,7 +1891,7 @@ void scsi_forget_host(struct Scsi_Host *
  *
  *	Note - this device is not accessible from any high-level
  *	drivers (including generics), which is probably not
- *	optimal.  We can add hooks later to attach 
+ *	optimal.  We can add hooks later to attach.
  */
 struct scsi_device *scsi_get_host_dev(struct Scsi_Host *shost)
 {
@@ -1920,18 +1917,13 @@ struct scsi_device *scsi_get_host_dev(st
 }
 EXPORT_SYMBOL(scsi_get_host_dev);
 
-/*
- * Function:    scsi_free_host_dev()
- *
- * Purpose:     Free a scsi_device that points to the host adapter itself.
- *
- * Arguments:   SHpnt   - Host that needs a scsi_device
+/**
+ * scsi_free_host_dev - Free a scsi_device that points to the host adapter itself
+ * @sdev: Host device to be freed
  *
  * Lock status: None assumed.
  *
  * Returns:     Nothing
- *
- * Notes:
  */
 void scsi_free_host_dev(struct scsi_device *sdev)
 {
_
