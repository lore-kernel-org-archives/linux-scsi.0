From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 10/12] mpt2sas - Makefile
Date: Mon, 3 Nov 2008 01:41:24 -0700
Message-ID: <20081103084122.GB3394@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:40649 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341AbYKCWfI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Nov 2008 17:35:08 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id mA3MTwcG019592
	for <linux-scsi@vger.kernel.org>; Mon, 3 Nov 2008 14:29:59 -0800 (PST)
Received: from localhost (emoore-test1.co.lsil.com [172.21.46.33])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id mA3MZ7ag008407
	for <linux-scsi@vger.kernel.org>; Mon, 3 Nov 2008 14:35:07 -0800
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is the driver makefile.

Signed-off-by: Eric Moore <eric.moore@lsi.com>

--- a/drivers/scsi/mpt2sas/Makefile	1969-12-31 17:00:00.000000000 -0700
+++ b/drivers/scsi/mpt2sas/Makefile	2008-11-03 11:37:19.000000000 -0700
@@ -0,0 +1,7 @@
+# mpt2sas makefile
+obj-$(CONFIG_SCSI_MPT2SAS) += mpt2sas.o
+mpt2sas-y +=  mpt2sas_base.o        \
+		mpt2sas_config.o    \
+		mpt2sas_scsih.o     \
+		mpt2sas_transport.o \
+		mpt2sas_ctl.o
