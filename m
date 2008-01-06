From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: [PATCH 12/33][SCSI] dtc: Convert 'Scsi_Cmnd' to 'struct scsi_cmnd'
Date: Sun, 6 Jan 2008 04:03:51 +0100 (MET)
Message-ID: <20080106030351.30002.15698.sendpatchset@thinktank.campus.ltu.se>
References: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:53912 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbYAFDEE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jan 2008 22:04:04 -0500
In-Reply-To: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: kernel-janitors@vger.kernel.org, trivial@kernel.org, linux-scsi@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>

Convert the typedef'ed 'Scsi_Cmnd' to 'struct scsi_cmnd'.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Last item before 'drivers/scsi/scsi_typedefs.h' can be removed.


diff --git a/drivers/scsi/dtc.h b/drivers/scsi/dtc.h
index 0b205f8..524b711 100644
--- a/drivers/scsi/dtc.h
+++ b/drivers/scsi/dtc.h
@@ -32,12 +32,12 @@
 #define DTCDEBUG_INIT	0x1
 #define DTCDEBUG_TRANSFER 0x2
 
-static int dtc_abort(Scsi_Cmnd *);
+static int dtc_abort(struct scsi_cmnd *);
 static int dtc_biosparam(struct scsi_device *, struct block_device *,
 		         sector_t, int*);
 static int dtc_detect(struct scsi_host_template *);
-static int dtc_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
-static int dtc_bus_reset(Scsi_Cmnd *);
+static int dtc_queue_command(struct scsi_cmnd *, void (*done)(struct scsi_cmnd *));
+static int dtc_bus_reset(struct scsi_cmnd *);
 
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2
