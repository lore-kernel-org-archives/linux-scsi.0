From: Al Viro <viro@www.linux.org.uk>
Subject: [PATCH] qla trivial iomem annotation
Date: Tue, 26 Apr 2005 07:40:13 +0100
Message-ID: <E1DQJjx-00036A-4F@parcelfarce.linux.theplanet.co.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:22990 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261354AbVDZGj5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2005 02:39:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@osdl.org
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
----
diff -urN RC12-rc3-oprofile/drivers/scsi/qla2xxx/qla_sup.c RC12-rc3-qla/drivers/scsi/qla2xxx/qla_sup.c
--- RC12-rc3-oprofile/drivers/scsi/qla2xxx/qla_sup.c	Fri Mar 11 15:54:52 2005
+++ RC12-rc3-qla/drivers/scsi/qla2xxx/qla_sup.c	Tue Apr 26 01:43:29 2005
@@ -85,7 +85,7 @@
 void
 qla2x00_release_nvram_protection(scsi_qla_host_t *ha)
 {
-	device_reg_t *reg;
+	device_reg_t __iomem *reg;
 	uint32_t word;
 
 	reg = ha->iobase;
