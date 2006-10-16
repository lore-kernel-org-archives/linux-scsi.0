From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] add can_queue to host parameters
Date: Mon, 16 Oct 2006 10:06:27 -0500
Message-ID: <1161011187.3433.12.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:9674 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932113AbWJPPG3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Oct 2006 11:06:29 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k9GF6R115649
	for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2006 11:06:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Debugging TCQ issues has shown me this is a very useful parameter to be
able to view.  Add it to he host class parameters.

James

Index: BUILD-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_sysfs.c	2006-10-16 08:50:48.000000000 -0500
+++ BUILD-2.6/drivers/scsi/scsi_sysfs.c	2006-10-16 08:56:54.000000000 -0500
@@ -192,6 +192,7 @@ static CLASS_DEVICE_ATTR(state, S_IRUGO 
 shost_rd_attr(unique_id, "%u\n");
 shost_rd_attr(host_busy, "%hu\n");
 shost_rd_attr(cmd_per_lun, "%hd\n");
+shost_rd_attr(can_queue, "%hd\n");
 shost_rd_attr(sg_tablesize, "%hu\n");
 shost_rd_attr(unchecked_isa_dma, "%d\n");
 shost_rd_attr2(proc_name, hostt->proc_name, "%s\n");
@@ -200,6 +201,7 @@ static struct class_device_attribute *sc
 	&class_device_attr_unique_id,
 	&class_device_attr_host_busy,
 	&class_device_attr_cmd_per_lun,
+	&class_device_attr_can_queue,
 	&class_device_attr_sg_tablesize,
 	&class_device_attr_unchecked_isa_dma,
 	&class_device_attr_proc_name,


