From: scameron@beardog.cca.cpqcorp.net
Subject: [patch 1/1] scsi: fix a few misleading comments in scsi.c
Date: Fri, 26 Oct 2007 08:42:17 -0500
Message-ID: <20071026134217.GA16709@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel11.hp.com ([156.153.255.246]:40318 "EHLO palrel11.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbXJZN4w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Oct 2007 09:56:52 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix a few misleading comments in scsi.c

Signed-off-by: Stephen M. Cameron <steve.cameron@hp.com>

---


diff -puN linux-2.6.24-rc1/drivers/scsi/scsi.c~fix_scsi_comments linux-2.6.24-rc1/drivers/scsi/scsi.c
--- dynamic_scsi/linux-2.6.24-rc1/drivers/scsi/scsi.c~fix_scsi_comments	2007-10-25 08:52:01.000000000 -0400
+++ dynamic_scsi-root/linux-2.6.24-rc1/drivers/scsi/scsi.c	2007-10-25 08:53:45.000000000 -0400
@@ -897,7 +897,7 @@ EXPORT_SYMBOL(__scsi_iterate_devices);
  * @starget:	target whose devices we want to iterate over.
  *
  * This traverses over each devices of @shost.  The devices have
- * a reference that must be released by scsi_host_put when breaking
+ * a reference that must be released by scsi_device_put when breaking
  * out of the loop.
  */
 void starget_for_each_device(struct scsi_target *starget, void * data,
@@ -949,7 +949,7 @@ EXPORT_SYMBOL(__scsi_device_lookup_by_ta
  *
  * Looks up the scsi_device with the specified @channel, @id, @lun for a
  * give host.  The returned scsi_device has an additional reference that
- * needs to be release with scsi_host_put once you're done with it.
+ * needs to be release with scsi_device_put once you're done with it.
  **/
 struct scsi_device *scsi_device_lookup_by_target(struct scsi_target *starget,
 						 uint lun)
@@ -1008,7 +1008,7 @@ EXPORT_SYMBOL(__scsi_device_lookup);
  *
  * Looks up the scsi_device with the specified @channel, @id, @lun for a
  * give host.  The returned scsi_device has an additional reference that
- * needs to be release with scsi_host_put once you're done with it.
+ * needs to be release with scsi_device_put once you're done with it.
  **/
 struct scsi_device *scsi_device_lookup(struct Scsi_Host *shost,
 		uint channel, uint id, uint lun)
_
