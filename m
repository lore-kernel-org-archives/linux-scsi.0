From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH, scsi-block-2.6] comment cleanup for spi_execute
Date: Sun, 19 Jun 2005 11:32:53 +0200
Message-ID: <20050619093253.GD16872@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:5034 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262225AbVFSJc4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Jun 2005 05:32:56 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Index: linux-2.6/drivers/scsi/scsi_transport_spi.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_transport_spi.c	2005-06-18 17:15:20.000000000 +0200
+++ linux-2.6/drivers/scsi/scsi_transport_spi.c	2005-06-18 17:35:35.000000000 +0200
@@ -106,8 +106,6 @@
 	return result;
 }
 
-/* Modification of scsi_wait_req that will clear UNIT ATTENTION conditions
- * resulting from (likely) bus and device resets */
 static int spi_execute(struct scsi_device *sdev, const void *cmd,
 		       enum dma_data_direction dir,
 		       void *buffer, unsigned bufflen,
@@ -117,8 +115,6 @@
 	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
 
 	for(i = 0; i < DV_RETRIES; i++) {
-
-		/* FIXME: need to set REQ_FAILFAST */
 		result = scsi_execute(sdev, cmd, dir, buffer, bufflen,
 				      sense, DV_TIMEOUT, /* retries */ 1,
 				      REQ_FAILFAST);
