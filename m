From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill some sysfs left-overs in st
Date: Fri, 6 Jun 2003 16:30:24 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030606143024.GA23377@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:36309 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261704AbTFFOQy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2003 10:16:54 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

diff -Nru a/drivers/scsi/st.c b/drivers/scsi/st.c
--- a/drivers/scsi/st.c	Thu Jun  5 18:39:47 2003
+++ b/drivers/scsi/st.c	Thu Jun  5 18:39:47 2003
@@ -3674,22 +3674,6 @@
 
 #endif
 
-/* Driverfs file support */
-static ssize_t st_device_kdev_read(struct device *dev, char *page)
-{
-	kdev_t kdev; 
-	kdev.value=(unsigned long)dev->driver_data;
-	return sprintf(page, "%x\n",kdev.value);
-}
-static DEVICE_ATTR(kdev,S_IRUGO,st_device_kdev_read,NULL);
-
-static ssize_t st_device_type_read(struct device *ev, char * page)
-{
-	return sprintf (page, "CHR\n");
-}
-static DEVICE_ATTR(type,S_IRUGO,st_device_type_read,NULL);
-
-
 static struct file_operations st_fops =
 {
 	.owner =	THIS_MODULE,
