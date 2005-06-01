From: Alex Aizman <itn780@yahoo.com>
Subject: [ANNOUNCE 5/7] Open-iSCSI/Linux-iSCSI-5 High-Performance Initiator:
 iscsi-Makefile.patch
Date: Wed, 01 Jun 2005 13:09:58 -0700
Message-ID: <429E1616.5040107@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp108.mail.sc5.yahoo.com ([66.163.170.6]:30074 "HELO
	smtp108.mail.sc5.yahoo.com") by vger.kernel.org with SMTP
	id S261191AbVFAUKC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Jun 2005 16:10:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>

	iscsi-Makefile.patch - drivers/scsi/Makefile changes.

	Signed-off-by: Alex Aizman <itn780@yahoo.com>
	Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>
	Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

Index: drivers/scsi/Makefile
===================================================================
--- 7570fde464d579ce455c865f07a613e967e9396c/drivers/scsi/Makefile  (mode:100644 sha1:9cb9fe7d623aeda983c2e6b2f4cb57bdca796673)
+++ uncommitted/drivers/scsi/Makefile  (mode:100644)
@@ -30,6 +30,7 @@
 obj-$(CONFIG_SCSI_FC_ATTRS) 	+= scsi_transport_fc.o
 obj-$(CONFIG_SCSI_ISCSI_ATTRS)	+= scsi_transport_iscsi.o
 
+obj-$(CONFIG_ISCSI_TCP) 	+= iscsi_tcp.o
 obj-$(CONFIG_SCSI_AMIGA7XX)	+= amiga7xx.o	53c7xx.o
 obj-$(CONFIG_A3000_SCSI)	+= a3000.o	wd33c93.o
 obj-$(CONFIG_A2091_SCSI)	+= a2091.o	wd33c93.o



