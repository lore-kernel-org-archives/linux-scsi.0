From: "John W. Linville" <linville@tuxdriver.com>
Subject: [patch] 2.4 -- add IOI Media Bay to SCSI quirk list
Date: Thu, 12 Aug 2004 17:37:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408122137.i7CLbTa13693@ra.tuxdriver.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from apollo.tuxdriver.com ([24.172.12.4]:53777 "EHLO
	ra.tuxdriver.com") by vger.kernel.org with ESMTP id S268847AbUHLWk6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Aug 2004 18:40:58 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

diff -urNp linux-2.4.orig/drivers/scsi/scsi_scan.c linux-2.4/drivers/scsi/scsi_scan.c
--- linux-2.4.orig/drivers/scsi/scsi_scan.c	2004-08-12 18:31:17.592759000 -0400
+++ linux-2.4/drivers/scsi/scsi_scan.c	2004-08-12 18:33:35.847741768 -0400
@@ -189,6 +189,7 @@ static struct dev_info device_list[] =
 	{"HITACHI", "DF500", "*", BLIST_SPARSELUN},
 	{"HITACHI", "DF600", "*", BLIST_SPARSELUN},
 	{"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"IOI", "Media Bay", "*", BLIST_FORCELUN},
 	{"HITACHI", "OPEN-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},  /* HITACHI XP Arrays */
 	{"HITACHI", "DISK-SUBSYSTEM", "*", BLIST_SPARSELUN | BLIST_LARGELUN},  /* HITACHI 9960 */
 	{"WINSYS","FLASHDISK G6", "*", BLIST_SPARSELUN},
