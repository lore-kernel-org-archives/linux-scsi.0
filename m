From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 9/12] mpt2sas v00.100.11.15 : Makefile
Date: Mon, 9 Mar 2009 01:26:31 -0600
Message-ID: <20090309072629.GJ18720@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og107.obsmtp.com ([64.18.2.167]:46984 "EHLO
	exprod7og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbZCIVGJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Mar 2009 17:06:09 -0400
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
+++ b/drivers/scsi/mpt2sas/Makefile	2009-03-09 14:36:42.000000000 -0600
@@ -0,0 +1,7 @@
+# mpt2sas makefile
+obj-$(CONFIG_SCSI_MPT2SAS) += mpt2sas.o
+mpt2sas-y +=  mpt2sas_base.o        \
+		mpt2sas_config.o    \
+		mpt2sas_scsih.o     \
+		mpt2sas_transport.o \
+		mpt2sas_ctl.o
