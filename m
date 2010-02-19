From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: [patch 2/9] ipr: define new offsets to registers for the next generation
 chip
Date: Fri, 19 Feb 2010 13:23:51 -0800
Message-ID: <4B7F0167.1040304@linux.vnet.ibm.com>
References: <20100219210900.066268168@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53462 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925Ab0BSVXx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Feb 2010 16:23:53 -0500
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e2.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o1JLDm9m009429
	for <linux-scsi@vger.kernel.org>; Fri, 19 Feb 2010 16:13:48 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o1JLNqdC134292
	for <linux-scsi@vger.kernel.org>; Fri, 19 Feb 2010 16:23:52 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o1JLNq0I022928
	for <linux-scsi@vger.kernel.org>; Fri, 19 Feb 2010 19:23:52 -0200
In-Reply-To: <20100219210900.066268168@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>

This patch adds the entry to the ipr_chip_cfg array that defines the register
offsets for the next generation 64 bit IOA PCI interface chip.

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2010-02-04 08:45:04.000000000 -0800
+++ b/drivers/scsi/ipr.c	2010-02-04 08:45:20.000000000 -0800
@@ -128,6 +128,21 @@ static const struct ipr_chip_cfg_t ipr_c
 			.clr_uproc_interrupt_reg = 0x00294
 		}
 	},
+	{ /* CRoC */
+		.mailbox = 0x00040,
+		.cache_line_size = 0x20,
+		{
+			.set_interrupt_mask_reg = 0x00010,
+			.clr_interrupt_mask_reg = 0x00018,
+			.sense_interrupt_mask_reg = 0x00010,
+			.clr_interrupt_reg = 0x00008,
+			.sense_interrupt_reg = 0x00000,
+			.ioarrin_reg = 0x00070,
+			.sense_uproc_interrupt_reg = 0x00020,
+			.set_uproc_interrupt_reg = 0x00020,
+			.clr_uproc_interrupt_reg = 0x00028
+		}
+	},
 };

 static const struct ipr_chip_t ipr_chip[] = {

