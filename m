From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] make scsi_priv.h includable standalone
Date: Mon, 25 Aug 2003 14:19:15 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030825121915.GA15484@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:45979 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261729AbTHYMTj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2003 08:19:39 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

diff -Nru a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
--- a/drivers/scsi/scsi_priv.h	Mon Aug 25 13:37:02 2003
+++ b/drivers/scsi/scsi_priv.h	Mon Aug 25 13:37:02 2003
@@ -1,6 +1,17 @@
 #ifndef _SCSI_PRIV_H
 #define _SCSI_PRIV_H
 
+#include <linux/config.h>
+#include <linux/device.h>
+
+struct request_queue;
+struct scsi_cmnd;
+struct scsi_device;
+struct scsi_host_template;
+struct scsi_request;
+struct Scsi_Host;
+
+
 /*
  * These are the values that the owner field can take.
  * They are used as an indication of who the command belongs to.
