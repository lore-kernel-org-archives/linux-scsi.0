From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 9/11] mpt2sas v00.100.11.11 : Makefile
Date: Tue, 3 Mar 2009 22:13:42 -0700
Message-ID: <20090304051340.GK4194@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og103.obsmtp.com ([64.18.2.159]:56174 "EHLO
	exprod7og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579AbZCDSyE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2009 13:54:04 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id n24Is12k006097
	for <linux-scsi@vger.kernel.org>; Wed, 4 Mar 2009 10:54:01 -0800 (PST)
Received: from localhost (emoore-test1.co.lsil.com [172.21.46.33])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id n24Is5hE015499
	for <linux-scsi@vger.kernel.org>; Wed, 4 Mar 2009 10:54:05 -0800
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Makefile

mpt2sas driver Makefile.

Signed-off-by: Eric Moore <eric.moore@lsi.com>
---

--- a/drivers/scsi/mpt2sas/Makefile	1969-12-31 17:00:00.000000000 -0700
+++ b/drivers/scsi/mpt2sas/Makefile	2009-03-03 10:29:13.000000000 -0700
@@ -0,0 +1,7 @@
+# mpt2sas makefile
+obj-$(CONFIG_SCSI_MPT2SAS) += mpt2sas.o
+mpt2sas-y +=  mpt2sas_base.o        \
+		mpt2sas_config.o    \
+		mpt2sas_scsih.o     \
+		mpt2sas_transport.o \
+		mpt2sas_ctl.o
