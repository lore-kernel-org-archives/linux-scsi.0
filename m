From: James Bottomley <James.Bottomley@steeleye.com>
Subject: RE: patch for scsi_devinfo.c
Date: 21 Jun 2004 15:23:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087849435.2079.82.camel@mulgrave>
References: <A8B003DDA3332A479C0ECCA641F47E6503BE69FA@tayexc13.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:55744 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266455AbUFUUYF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 16:24:05 -0400
In-Reply-To: <A8B003DDA3332A479C0ECCA641F47E6503BE69FA@tayexc13.americas.cpqcorp.net>
List-Id: linux-scsi@vger.kernel.org
To: "Dupuis, Chad" <chad.dupuis@hp.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-06-21 at 15:16, Dupuis, Chad wrote:
> It does respond to report LUN.

OK, so this should be the patch.  Could you make sure it actually does
work?

Thanks,

James

===== drivers/scsi/scsi_devinfo.c 1.21 vs edited =====
--- 1.21/drivers/scsi/scsi_devinfo.c	2004-06-19 09:48:22 -05:00
+++ edited/drivers/scsi/scsi_devinfo.c	2004-06-21 15:22:17 -05:00
@@ -129,7 +129,7 @@
 	{"COMPAQ", "CR3500", NULL, BLIST_FORCELUN},
 	{"COMPAQ", "MSA1000", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
 	{"COMPAQ", "MSA1000 VOLUME", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
-	{"COMPAQ", "HSV110", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
+	{"COMPAQ", "HSV110", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
 	{"DDN", "SAN DataDirector", "*", BLIST_SPARSELUN},
 	{"DEC", "HSG80", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
 	{"DELL", "PV660F", NULL, BLIST_SPARSELUN},
@@ -151,7 +151,7 @@
 	{"HP", "A6189A", NULL, BLIST_SPARSELUN | BLIST_LARGELUN},	/* HP VA7400 */
 	{"HP", "OPEN-", "*", BLIST_SPARSELUN | BLIST_LARGELUN}, /* HP XP Arrays */
 	{"HP", "NetRAID-4M", NULL, BLIST_FORCELUN},
-	{"HP", "HSV100", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
+	{"HP", "HSV100", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
 	{"HP", "C1557A", NULL, BLIST_FORCELUN},
 	{"IBM", "AuSaV1S2", NULL, BLIST_FORCELUN},
 	{"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},

