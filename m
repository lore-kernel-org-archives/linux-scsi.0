From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] add a missing extern to scsi_priv.h
Date: Mon, 25 Aug 2003 14:23:00 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030825122300.GD15506@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:54427 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261808AbTHYMXD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2003 08:23:03 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

scsi_scan_host_selected was the only prototype without 'extern'


diff -Nru a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
--- a/drivers/scsi/scsi_priv.h	Mon Aug 25 13:37:25 2003
+++ b/drivers/scsi/scsi_priv.h	Mon Aug 25 13:37:25 2003
@@ -126,8 +126,8 @@
 #endif /* CONFIG_PROC_FS */
 
 /* scsi_scan.c */
-int scsi_scan_host_selected(struct Scsi_Host *, unsigned int, unsigned int,
-			    unsigned int, int);
+extern int scsi_scan_host_selected(struct Scsi_Host *, unsigned int,
+				   unsigned int, unsigned int, int);
 extern void scsi_forget_host(struct Scsi_Host *);
 extern void scsi_free_sdev(struct scsi_device *);
 extern void scsi_rescan_device(struct device *);
