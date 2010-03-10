From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH 1/2 resend] scsi: fix/convert scsi_scan.c kernel-doc
Date: Wed, 10 Mar 2010 12:00:16 -0800
Message-ID: <20100310120016.b49077c8.randy.dunlap@oracle.com>
References: <1268242604.22601.25.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:28212 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379Ab0CJUBV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2010 15:01:21 -0500
In-Reply-To: <1268242604.22601.25.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>, torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, James Bottomley <James.Bottomley@suse.de>

From: Randy Dunlap <randy.dunlap@oracle.com>

scsi_scan.c: fix incorrectly formatted kernel-doc notation
& convert documentation of 2 functions into kernel-doc.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/scsi_scan.c |   26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

--- linux-2.6.33-rc8-git6.orig/drivers/scsi/scsi_scan.c
+++ linux-2.6.33-rc8-git6/drivers/scsi/scsi_scan.c
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
@@ -1874,12 +1874,9 @@ void scsi_forget_host(struct Scsi_Host *
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
@@ -1892,7 +1889,7 @@ void scsi_forget_host(struct Scsi_Host *
  *
  *	Note - this device is not accessible from any high-level
  *	drivers (including generics), which is probably not
- *	optimal.  We can add hooks later to attach 
+ *	optimal.  We can add hooks later to attach.
  */
 struct scsi_device *scsi_get_host_dev(struct Scsi_Host *shost)
 {
@@ -1919,18 +1916,13 @@ struct scsi_device *scsi_get_host_dev(st
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
