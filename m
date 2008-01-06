From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: [PATCH 29/33][SCSI] pas16: Convert 'Scsi_Cmnd' to 'struct scsi_cmnd'
Date: Sun, 6 Jan 2008 04:05:18 +0100 (MET)
Message-ID: <20080106030517.30002.66356.sendpatchset@thinktank.campus.ltu.se>
References: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:54037 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbYAFDFa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jan 2008 22:05:30 -0500
In-Reply-To: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>

Convert the typedef'ed 'Scsi_Cmnd' to 'struct scsi_cmnd'.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Last item before 'drivers/scsi/scsi_typedefs.h' can be removed.


diff --git a/drivers/scsi/pas16.h b/drivers/scsi/pas16.h
index 8dc5b1a..dc87366 100644
--- a/drivers/scsi/pas16.h
+++ b/drivers/scsi/pas16.h
@@ -114,12 +114,12 @@
 
 
 #ifndef ASM
-static int pas16_abort(Scsi_Cmnd *);
+static int pas16_abort(struct scsi_cmnd *);
 static int pas16_biosparam(struct scsi_device *, struct block_device *,
 			   sector_t, int*);
 static int pas16_detect(struct scsi_host_template *);
-static int pas16_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
-static int pas16_bus_reset(Scsi_Cmnd *);
+static int pas16_queue_command(struct scsi_cmnd *, void (*done)(struct scsi_cmnd *));
+static int pas16_bus_reset(struct scsi_cmnd *);
 
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2
