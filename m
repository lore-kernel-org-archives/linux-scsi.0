From: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
Subject: [patch] qlogic: don't use qinfo as name
Date: Thu, 23 Oct 2003 23:10:17 -0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031024011017.GC474@cathedrallabs.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="qlTNgmc+xy1dBmNv"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from panda.sul.com.br ([200.219.150.4]:59148 "EHLO panda.sul.com.br")
	by vger.kernel.org with ESMTP id S261827AbTJXBLT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Oct 2003 21:11:19 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

-- 
aris


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="qlogic-dont_use_qinfo.patch"

--- linux/drivers/scsi/qlogicfas.c.orig	2003-10-17 16:47:54.000000000 -0200
+++ linux/drivers/scsi/qlogicfas.c	2003-10-17 16:48:30.000000000 -0200
@@ -665,7 +665,6 @@
 	sprintf(qinfo,
 		"Qlogicfas Driver version 0.46, chip %02X at %03X, IRQ %d, TPdma:%d",
 		qltyp, qbase, qlirq, QL_TURBO_PDMA);
-	host->name = qinfo;
 
 	return hreg;
 

--qlTNgmc+xy1dBmNv--
