From: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
Subject: [patch] qlogic: force can_queue
Date: Thu, 23 Oct 2003 23:11:09 -0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031024011109.GD474@cathedrallabs.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Clx92ZfkiYIKRjnr"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from panda.sul.com.br ([200.219.150.4]:61452 "EHLO panda.sul.com.br")
	by vger.kernel.org with ESMTP id S261890AbTJXBMM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Oct 2003 21:12:12 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>


--Clx92ZfkiYIKRjnr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

-- 
aris


--Clx92ZfkiYIKRjnr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="qlogic-force_can_queue.patch"

--- linux/drivers/scsi/qlogicfas.c.orig	2003-10-20 21:12:09.000000000 -0200
+++ linux/drivers/scsi/qlogicfas.c	2003-10-20 21:12:17.000000000 -0200
@@ -793,7 +793,7 @@
 	.eh_device_reset_handler= qlogicfas_device_reset,
 	.eh_host_reset_handler	= qlogicfas_host_reset,
 	.bios_param		= qlogicfas_biosparam,
-	.can_queue		= 0,
+	.can_queue		= 1,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= 1,

--Clx92ZfkiYIKRjnr--
