From: <Yanqing_Liu@Dell.com>
Subject: [Patch] multipathing-tools: Add Dell 32xx/i support into hardware table
Date: Mon, 24 Aug 2009 11:08:59 -0500
Message-ID: <D00AA2C108EC0346B503219C7565A66FA2A926@ausx3mpc138.aus.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:20405 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbZHXQJV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Aug 2009 12:09:21 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: Babu.Moger@lsi.com

Hello all,

This patch adds Dell MD32xx/i atorage arrays into hardwarae table for
multipathing tool.

Signed-off-by: Yanqing Liu <Yanqing_Liu@Dell.com>
Signed-off-by: Babu Moger  <Babu.Moger@lsi.com>

---

--- multipath-tools/libmultipath/hwtable.c.orig	2009-08-05
17:47:43.000000000 -0500
+++ multipath-tools/libmultipath/hwtable.c	2009-08-05
17:54:11.000000000 -0500
@@ -686,6 +686,38 @@ static struct hwentry default_hw[] = {
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
 	},
+	{
+		/* DELL MD32xx */
+		.vendor        = "DELL",
+		.product       = "MD32xx",
+		.getuid        = DEFAULT_GETUID,
+		.features      = "2 pg_init_retries 50",
+		.hwhandler     = "1 rdac",
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = 15,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = RDAC,
+		.prio_name     = PRIO_RDAC,
+	},
+	{
+		/* DELL MD32xxi */
+		.vendor        = "DELL",
+		.product       = "MD32xxi",
+		.getuid        = DEFAULT_GETUID,
+		.features      = "2 pg_init_retries 50",
+		.hwhandler     = "1 rdac",
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = 15,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = RDAC,
+		.prio_name     = PRIO_RDAC,
+	},
 	/*
 	 * NETAPP controller family
 	 *
