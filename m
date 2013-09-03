From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] Allow MPT Fusion SAS 3.0 driver to be built into the kernel
Date: Tue, 3 Sep 2013 15:00:11 -0700
Message-ID: <20130903220011.GA20840@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60640 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab3ICWAM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Sep 2013 18:00:12 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com, support@lsi.com, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Right now the Makefile for the mpt3sas driver does not even allow the
driver to be built into the kernel.  So fix that up, as there doesn't
seem to be any obvious reason why this shouldn't be done.

Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: support@lsi.com
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


diff --git a/drivers/scsi/mpt3sas/Makefile b/drivers/scsi/mpt3sas/Makefile
index 4c1d2e7a..efb0c4c2 100644
--- a/drivers/scsi/mpt3sas/Makefile
+++ b/drivers/scsi/mpt3sas/Makefile
@@ -1,5 +1,5 @@
 # mpt3sas makefile
-obj-m += mpt3sas.o
+obj-$(CONFIG_SCSI_MPT3SAS) += mpt3sas.o
 mpt3sas-y +=  mpt3sas_base.o     \
 		mpt3sas_config.o \
 		mpt3sas_scsih.o      \
