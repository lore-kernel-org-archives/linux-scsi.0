From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [18/21] Remove unchecked_isa_dma from sysfs
Date: Sun, 16 Nov 2008 00:11:18 +0100 (CET)
Message-ID: <20081115231118.A60B93E661A@basil.firstfloor.org>
References: <200811161211.212948789@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:44206 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbYKOXLP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Nov 2008 18:11:15 -0500
In-Reply-To: <200811161211.212948789@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, axboe@kernel.dk, linux-scsi@vger.kernel.org


I opted to remove it because it's unlikely that user space uses it.

An alternative would be to always make it report 0 now.

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/scsi/scsi_sysfs.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux/drivers/scsi/scsi_sysfs.c
===================================================================
--- linux.orig/drivers/scsi/scsi_sysfs.c	2008-11-15 22:37:08.000000000 +0100
+++ linux/drivers/scsi/scsi_sysfs.c	2008-11-15 22:37:12.000000000 +0100
@@ -249,7 +249,6 @@
 shost_rd_attr(cmd_per_lun, "%hd\n");
 shost_rd_attr(can_queue, "%hd\n");
 shost_rd_attr(sg_tablesize, "%hu\n");
-shost_rd_attr(unchecked_isa_dma, "%d\n");
 shost_rd_attr(prot_capabilities, "%u\n");
 shost_rd_attr(prot_guard_type, "%hd\n");
 shost_rd_attr2(proc_name, hostt->proc_name, "%s\n");
@@ -260,7 +259,6 @@
 	&dev_attr_cmd_per_lun.attr,
 	&dev_attr_can_queue.attr,
 	&dev_attr_sg_tablesize.attr,
-	&dev_attr_unchecked_isa_dma.attr,
 	&dev_attr_proc_name.attr,
 	&dev_attr_scan.attr,
 	&dev_attr_hstate.attr,
