From: akpm@linux-foundation.org
Subject: [patch 12/15] scsi: fix func names in kernel-doc
Date: Fri, 18 Sep 2009 12:58:22 -0700
Message-ID: <200909181958.n8IJwME8004414@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757962AbZIRUCB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Sep 2009 16:02:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, randy.dunlap@oracle.com

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix scsi_devinfo.c kernel-doc function names to match actual function
names.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_devinfo.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/scsi_devinfo.c~scsi-fix-func-names-in-kernel-doc drivers/scsi/scsi_devinfo.c
--- a/drivers/scsi/scsi_devinfo.c~scsi-fix-func-names-in-kernel-doc
+++ a/drivers/scsi/scsi_devinfo.c
@@ -454,7 +454,7 @@ int scsi_get_device_flags(struct scsi_de
 
 
 /**
- * get_device_flags_keyed - get device specific flags from the dynamic device list.
+ * scsi_get_device_flags_keyed - get device specific flags from the dynamic device list
  * @sdev:       &scsi_device to get flags for
  * @vendor:	vendor name
  * @model:	model name
@@ -685,7 +685,7 @@ MODULE_PARM_DESC(default_dev_flags,
 		 "scsi default device flag integer value");
 
 /**
- * scsi_dev_info_list_delete - called from scsi.c:exit_scsi to remove the scsi_dev_info_list.
+ * scsi_exit_devinfo - remove /proc/scsi/device_info & the scsi_dev_info_list
  **/
 void scsi_exit_devinfo(void)
 {
_
