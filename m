From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: [PATCH 6/8] kernel-doc: fix scsi docbook
Date: Sun, 3 Feb 2008 15:06:36 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0802031445490.3021@shark.he.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:34493 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755252AbYBCXGj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 3 Feb 2008 18:06:39 -0500
Received: from shark.he.net ([66.160.160.2]) by xenotime.net for <linux-scsi@vger.kernel.org>; Sun, 3 Feb 2008 15:06:36 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, akpm@linux-foundation.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add missing function parameter descriptions.
Make function short description fit on one line as required.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
  drivers/scsi/scsi.c |    5 +++--
  1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-2.6.24-git12.orig/drivers/scsi/scsi.c
+++ linux-2.6.24-git12/drivers/scsi/scsi.c
@@ -969,9 +969,10 @@ void starget_for_each_device(struct scsi
  EXPORT_SYMBOL(starget_for_each_device);

  /**
- * __starget_for_each_device  -  helper to walk all devices of a target
- *				 (UNLOCKED)
+ * __starget_for_each_device - helper to walk all devices of a target (UNLOCKED)
   * @starget:	target whose devices we want to iterate over.
+ * @data:	parameter for callback @fn()
+ * @fn:		callback function that is invoked for each device
   *
   * This traverses over each device of @starget.  It does _not_
   * take a reference on the scsi_device, so the whole loop must be
