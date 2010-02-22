From: Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH v2] scsi: fix kernel-doc, add kernel-doc
Date: Mon, 22 Feb 2010 08:28:05 -0800
Message-ID: <4B82B095.4070803@xenotime.net>
References: <20100221194751.64b00c90.rdunlap@xenotime.net> <4B826FBD.7020000@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.64.118]:56697 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751171Ab0BVQ2G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Feb 2010 11:28:06 -0500
Received: from chimera.site ([71.245.98.113]) by xenotime.net for <linux-scsi@vger.kernel.org>; Mon, 22 Feb 2010 08:28:05 -0800
In-Reply-To: <4B826FBD.7020000@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: scsi <linux-scsi@vger.kernel.org>, james.bottomley@suse.de

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

-- 
~Randy
