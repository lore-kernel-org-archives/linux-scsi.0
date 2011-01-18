From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] target: remove EXTRA_CFLAGS
Date: Tue, 18 Jan 2011 21:24:58 +0100
Message-ID: <20110118202458.GB10884@lst.de>
References: <20110118202434.GA10884@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:37251 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079Ab1ARUZC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2011 15:25:02 -0500
Content-Disposition: inline
In-Reply-To: <20110118202434.GA10884@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org

Add the current directory is superflous in general, and no includes in
drivers/scsi are needed either.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/target/Makefile
===================================================================
--- linux-2.6.orig/drivers/target/Makefile	2011-01-18 21:13:15.835261618 +0100
+++ linux-2.6/drivers/target/Makefile	2011-01-18 21:14:31.908284597 +0100
@@ -1,4 +1,3 @@
-EXTRA_CFLAGS += -I$(srctree)/drivers/target/ -I$(srctree)/drivers/scsi/
 
 target_core_mod-y		:= target_core_configfs.o \
 				   target_core_device.o \
