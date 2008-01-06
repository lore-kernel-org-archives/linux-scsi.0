From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: [PATCH 27/33][SCSI] nsp32_debug: Convert 'Scsi_Cmnd' to 'struct scsi_cmnd'
Date: Sun, 6 Jan 2008 04:05:07 +0100 (MET)
Message-ID: <20080106030507.30002.6529.sendpatchset@thinktank.campus.ltu.se>
References: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:54026 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbYAFDFU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jan 2008 22:05:20 -0500
In-Reply-To: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>

Convert the typedef'ed 'Scsi_Cmnd' to 'struct scsi_cmnd'.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Last item before 'drivers/scsi/scsi_typedefs.h' can be removed.


diff --git a/drivers/scsi/nsp32_debug.c b/drivers/scsi/nsp32_debug.c
index ef3c59c..96cce0b 100644
--- a/drivers/scsi/nsp32_debug.c
+++ b/drivers/scsi/nsp32_debug.c
@@ -137,7 +137,7 @@ static void print_commandk (unsigned char *command)
 	printk("\n");
 }
 
-static void show_command(Scsi_Cmnd *SCpnt)
+static void show_command(struct scsi_cmnd *SCpnt)
 {
 	print_commandk(SCpnt->cmnd);
 }
