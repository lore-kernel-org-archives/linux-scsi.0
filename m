From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] missing pci_enable_device in megaraid
Date: Sat, 8 May 2004 18:52:48 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040508165248.GA973@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:23272 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S263205AbUEHQw5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 May 2004 12:52:57 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, Atul.Mukker@lsil.com
Cc: linux-scsi@vger.kernel.org

--- 1.59/drivers/scsi/megaraid.c	Fri Jan 23 06:37:03 2004
+++ edited/drivers/scsi/megaraid.c	Sat Jan 31 06:52:56 2004
@@ -4644,6 +4644,7 @@
 
 	if (pci_enable_device(pdev))
 		goto out;
+	pci_set_master(pdev);
 
 	pci_bus = pdev->bus->number;
 	pci_dev_func = pdev->devfn;
