From: michaelc@cs.wisc.edu
Subject: [PATCH 1/4] scsi_devinfo: add EMC Invista
Date: Sat, 30 Sep 2006 20:42:28 -0400
Message-ID: <11596633523779-git-send-email-michaelc@cs.wisc.edu>
References: <11596633513659-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:25537 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1751999AbWJABmg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Sep 2006 21:42:36 -0400
In-Reply-To: <11596633513659-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This is from RHEL4. This box can support
scsi2 and can also support BLIST_SPARSELUN | BLIST_LARGELUN.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_devinfo.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 3d0429b..cbf733b 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -150,6 +150,7 @@ static struct {
 	{"DELL", "PERCRAID", NULL, BLIST_FORCELUN},
 	{"DGC", "RAID", NULL, BLIST_SPARSELUN},	/* Dell PV 650F, storage on LUN 0 */
 	{"DGC", "DISK", NULL, BLIST_SPARSELUN},	/* Dell PV 650F, no storage on LUN 0 */
+	{"EMC",  "Invista", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"EMC", "SYMMETRIX", NULL, BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_FORCELUN},
 	{"EMULEX", "MD21/S2     ESDI", NULL, BLIST_SINGLELUN},
 	{"FSC", "CentricStor", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-- 
1.4.1

