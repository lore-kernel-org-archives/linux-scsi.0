From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] scsi_dev_flags must be __initdata, not __init
Date: Wed, 2 Jun 2004 10:01:17 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040602080117.GA20604@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:47834 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265187AbUFBIBV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2004 04:01:21 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

__init is only for functions


--- 1.14/drivers/scsi/scsi_devinfo.c	2004-05-29 19:09:05 +02:00
+++ edited/drivers/scsi/scsi_devinfo.c	2004-05-31 23:05:51 +02:00
@@ -27,7 +27,7 @@
 static const char spaces[] = "                "; /* 16 of them */
 static unsigned scsi_default_dev_flags;
 static LIST_HEAD(scsi_dev_info_list);
-static __init char scsi_dev_flags[256];
+static __initdata char scsi_dev_flags[256];
 
 /*
  * scsi_static_device_list: deprecated list of devices that require
