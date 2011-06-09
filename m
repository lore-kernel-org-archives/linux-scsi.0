From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH] aha152x: add missing ISA PNP IDs
Date: Thu, 9 Jun 2011 21:21:23 +0200
Message-ID: <201106092121.27196.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "Juergen E. Fischer" <fischer@norbit.de>
Cc: linux-scsi@vger.kernel.org, Kernel development list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Add ISA PNP IDs of the following cards to aha152x driver:
AVA-1502
AVA-1505
AHA-1510
AVA-1515
AHA-1520
AHA-1522
AHA-1530
AHA-1532
AIC-6360
(list from SCSI.INF file)

This makes my AHA-1530P card (has ADP3015 ID) work automatically.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.39-rc2-orig/drivers/scsi/aha152x.c	2011-04-06 03:30:43.000000000 +0200
+++ linux-2.6.39-rc2/drivers/scsi/aha152x.c	2011-06-09 21:11:47.000000000 +0200
@@ -422,10 +422,19 @@ MODULE_PARM_DESC(aha152x1, "parameters f
 
 #ifdef __ISAPNP__
 static struct isapnp_device_id id_table[] __devinitdata = {
-	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,
-		ISAPNP_VENDOR('A','D','P'), ISAPNP_FUNCTION(0x1505), 0 },
-	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,
-		ISAPNP_VENDOR('A','D','P'), ISAPNP_FUNCTION(0x1530), 0 },
+	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,	ISAPNP_VENDOR('A', 'D', 'P'), ISAPNP_FUNCTION(0x1502), 0 },
+	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,	ISAPNP_VENDOR('A', 'D', 'P'), ISAPNP_FUNCTION(0x1505), 0 },
+	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,	ISAPNP_VENDOR('A', 'D', 'P'), ISAPNP_FUNCTION(0x1510), 0 },
+	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,	ISAPNP_VENDOR('A', 'D', 'P'), ISAPNP_FUNCTION(0x1515), 0 },
+	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,	ISAPNP_VENDOR('A', 'D', 'P'), ISAPNP_FUNCTION(0x1520), 0 },
+	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,	ISAPNP_VENDOR('A', 'D', 'P'), ISAPNP_FUNCTION(0x2015), 0 },
+	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,	ISAPNP_VENDOR('A', 'D', 'P'), ISAPNP_FUNCTION(0x1522), 0 },
+	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,	ISAPNP_VENDOR('A', 'D', 'P'), ISAPNP_FUNCTION(0x2215), 0 },
+	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,	ISAPNP_VENDOR('A', 'D', 'P'), ISAPNP_FUNCTION(0x1530), 0 },
+	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,	ISAPNP_VENDOR('A', 'D', 'P'), ISAPNP_FUNCTION(0x3015), 0 },
+	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,	ISAPNP_VENDOR('A', 'D', 'P'), ISAPNP_FUNCTION(0x1532), 0 },
+	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,	ISAPNP_VENDOR('A', 'D', 'P'), ISAPNP_FUNCTION(0x3215), 0 },
+	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,	ISAPNP_VENDOR('A', 'D', 'P'), ISAPNP_FUNCTION(0x6360), 0 },
 	{ ISAPNP_DEVICE_SINGLE_END, }
 };
 MODULE_DEVICE_TABLE(isapnp, id_table);


-- 
Ondrej Zary
