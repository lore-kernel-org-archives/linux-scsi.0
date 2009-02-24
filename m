From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 9/11] mpt2sas: Makefile
Date: Tue, 24 Feb 2009 02:38:58 -0700
Message-ID: <20090224093856.GI11813@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og103.obsmtp.com ([64.18.2.159]:44283 "EHLO
	exprod7og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbZBXXUc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Feb 2009 18:20:32 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com

Makefile

mpt2sas driver Makefile.

Signed-off-by: Eric Moore <eric.moore@lsi.com>
---

--- a/drivers/scsi/mpt2sas/Makefile	1969-12-31 17:00:00.000000000 -0700
+++ b/drivers/scsi/mpt2sas/Makefile	2009-02-24 14:17:02.000000000 -0700
@@ -0,0 +1,7 @@
+# mpt2sas makefile
+obj-$(CONFIG_SCSI_MPT2SAS) += mpt2sas.o
+mpt2sas-y +=  mpt2sas_base.o        \
+		mpt2sas_config.o    \
+		mpt2sas_scsih.o     \
+		mpt2sas_transport.o \
+		mpt2sas_ctl.o
