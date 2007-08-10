From: akpm@linux-foundation.org
Subject: [patch 29/30] scsi: ipsc warning fix
Date: Fri, 10 Aug 2007 14:50:52 -0700
Message-ID: <200708102150.l7ALoqwo011407@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42248 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751162AbXHJV4N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Aug 2007 17:56:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org

From: Andrew Morton <akpm@linux-foundation.org>

drivers/scsi/ips.c: In function 'ips_insert_device':
drivers/scsi/ips.c:6957: warning: 'index' may be used uninitialized in this function


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ips.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ips.c~scsi-ipsc-warning-fix drivers/scsi/ips.c
--- a/drivers/scsi/ips.c~scsi-ipsc-warning-fix
+++ a/drivers/scsi/ips.c
@@ -6946,7 +6946,7 @@ module_exit(ips_module_exit);
 static int __devinit
 ips_insert_device(struct pci_dev *pci_dev, const struct pci_device_id *ent)
 {
-	int index;
+	int uninitialized_var(index);
 	int rc;
 
 	METHOD_TRACE("ips_insert_device", 1);
_
