From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [16/22] Remove unchecked_isa_dma from sysfs
Date: Mon, 25 Feb 2008 00:35:29 +0100 (CET)
Message-ID: <20080224233529.456981B4183@basil.firstfloor.org>
References: <200802251235.889863872@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:51515 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbYBXXvk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Feb 2008 18:51:40 -0500
In-Reply-To: <200802251235.889863872@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com


I opted to remove it because it's unlikely that user space uses it.

An alternative would be to always make it report 0 now.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 drivers/scsi/scsi_sysfs.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux/drivers/scsi/scsi_sysfs.c
===================================================================
--- linux.orig/drivers/scsi/scsi_sysfs.c
+++ linux/drivers/scsi/scsi_sysfs.c
@@ -237,7 +237,6 @@ shost_rd_attr(host_busy, "%hu\n");
 shost_rd_attr(cmd_per_lun, "%hd\n");
 shost_rd_attr(can_queue, "%hd\n");
 shost_rd_attr(sg_tablesize, "%hu\n");
-shost_rd_attr(unchecked_isa_dma, "%d\n");
 shost_rd_attr2(proc_name, hostt->proc_name, "%s\n");
 
 static struct class_device_attribute *scsi_sysfs_shost_attrs[] = {
@@ -246,7 +245,6 @@ static struct class_device_attribute *sc
 	&class_device_attr_cmd_per_lun,
 	&class_device_attr_can_queue,
 	&class_device_attr_sg_tablesize,
-	&class_device_attr_unchecked_isa_dma,
 	&class_device_attr_proc_name,
 	&class_device_attr_scan,
 	&class_device_attr_state,
