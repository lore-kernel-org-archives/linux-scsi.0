From: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Subject: [PATCH] Add Hitachi 9960 Storage on SCSI devlist as
 BLIST_SPARSELUN|BLIST_LARGELUN
Date: Thu, 19 Feb 2004 17:32:25 -0300 (BRT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58L.0402191726570.7378@logos.cnet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from intra.cyclades.com ([64.186.161.6]:15069 "EHLO
	intra.cyclades.com") by vger.kernel.org with ESMTP id S267502AbUBSTm2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Feb 2004 14:42:28 -0500
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>, linux-scsi@vger.kernel.org


Hi Andrew,

This patch has been applied to 2.4 BK tree today, 2.6 also wants it.

>From Giuseppe Furlan

I cannot see luns > 8(0-7). This patch resolves problems regarding LUN
visibility using Hitachi 9960 Storage.

My configuration:
Sun Fire V65x with LP9002L-E Emulex
Hitachi 9960 Storage (scsi-2 protocol)
Inrage FC switch (Fabric)

Against 2.6.2

--- linux.orig/drivers/scsi/scsi_devinfo.c.orig	2004-02-19
17:18:20.000000000 -0300
+++ linux/drivers/scsi/scsi_devinfo.c	2004-02-19 17:18:25.000000000
-0300
@@ -151,6 +151,7 @@
 	{"EMC", "SYMMETRIX", NULL, BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_FORCELUN},
 	{"HP", "A6189A", NULL, BLIST_SPARSELUN | BLIST_LARGELUN},	/* HP VA7400 */
 	{"HP", "OPEN-", "*", BLIST_SPARSELUN | BLIST_LARGELUN}, /* HP XP Arrays */
+	{"HITACHI", "DISK-SUBSYSTEM", "*", BLIST_SPARSELUN | BLIST_LARGELUN},  /* HITACHI 9960 */
 	{"CMD", "CRA-7280", NULL, BLIST_SPARSELUN},	/* CMD RAID Controller */
 	{"CNSI", "G7324", NULL, BLIST_SPARSELUN},	/* Chaparral G7324 RAID */
 	{"CNSi", "G8324", NULL, BLIST_SPARSELUN},	/* Chaparral G8324 RAID */
