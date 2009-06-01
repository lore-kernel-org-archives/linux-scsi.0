From: Takahiro Yasui <tyasui@redhat.com>
Subject: [PATCH] scsi_devinfo: update Hitachi entries
Date: Mon, 01 Jun 2009 12:46:53 -0400
Message-ID: <4A2405FD.3000901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:39899 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbZFAQn7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Jun 2009 12:43:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>

Hi,

This is scsi_devinfo flag updates for the Hitachi storages.

Three models, OPEN-/DF400/DF500, can handle REPORT_LUN, and
the BLIST_REPORTLUN2 flag needs to be set. DF600 returns
ANSI 03h (SPC) and no flag is required.

Thanks,
---
Takahiro Yasui
Hitachi Computer Products (America), Inc.


Signed-off-by: Takahiro Yasui <tyasui@redhat.com>
---
 drivers/scsi/scsi_devinfo.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux-2.6.30-rc7/drivers/scsi/scsi_devinfo.c
===================================================================
--- linux-2.6.30-rc7.orig/drivers/scsi/scsi_devinfo.c
+++ linux-2.6.30-rc7/drivers/scsi/scsi_devinfo.c
@@ -161,11 +161,10 @@ static struct {
 	{"Generic", "USB SD Reader", "1.00", BLIST_FORCELUN | BLIST_INQUIRY_36},
 	{"Generic", "USB Storage-SMC", "0180", BLIST_FORCELUN | BLIST_INQUIRY_36},
 	{"Generic", "USB Storage-SMC", "0207", BLIST_FORCELUN | BLIST_INQUIRY_36},
-	{"HITACHI", "DF400", "*", BLIST_SPARSELUN},
-	{"HITACHI", "DF500", "*", BLIST_SPARSELUN},
-	{"HITACHI", "DF600", "*", BLIST_SPARSELUN},
+	{"HITACHI", "DF400", "*", BLIST_REPORTLUN2},
+	{"HITACHI", "DF500", "*", BLIST_REPORTLUN2},
 	{"HITACHI", "DISK-SUBSYSTEM", "*", BLIST_ATTACH_PQ3 | BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"HITACHI", "OPEN-E", "*", BLIST_ATTACH_PQ3 | BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"HITACHI", "OPEN-", "*", BLIST_REPORTLUN2},
 	{"HITACHI", "OP-C-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"HITACHI", "3380-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"HITACHI", "3390-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},


