From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [18/21] SCSI-ISA-DMA: Remove unchecked_isa_dma from sysfs
Date: Thu,  2 Oct 2008 09:58:56 +0200 (CEST)
Message-ID: <20081002075856.7375A3E6A07@basil.firstfloor.org>
References: <20081002958.641114646@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:57120 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbYJBH65 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2008 03:58:57 -0400
In-Reply-To: <20081002958.641114646@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, axboe@kernel.dk


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
--- linux.orig/drivers/scsi/scsi_sysfs.c
+++ linux/drivers/scsi/scsi_sysfs.c
@@ -248,7 +248,6 @@ shost_rd_attr(host_busy, "%hu\n");
 shost_rd_attr(cmd_per_lun, "%hd\n");
 shost_rd_attr(can_queue, "%hd\n");
 shost_rd_attr(sg_tablesize, "%hu\n");
-shost_rd_attr(unchecked_isa_dma, "%d\n");
 shost_rd_attr(prot_capabilities, "%u\n");
 shost_rd_attr(prot_guard_type, "%hd\n");
 shost_rd_attr2(proc_name, hostt->proc_name, "%s\n");
@@ -259,7 +258,6 @@ static struct attribute *scsi_sysfs_shos
 	&dev_attr_cmd_per_lun.attr,
 	&dev_attr_can_queue.attr,
 	&dev_attr_sg_tablesize.attr,
-	&dev_attr_unchecked_isa_dma.attr,
 	&dev_attr_proc_name.attr,
 	&dev_attr_scan.attr,
 	&dev_attr_hstate.attr,
