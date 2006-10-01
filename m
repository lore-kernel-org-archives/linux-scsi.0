From: michaelc@cs.wisc.edu
Subject: [PATCH 4/4] scsi_devinfo: scsi2 HP and Hitachi entries
Date: Sat, 30 Sep 2006 20:42:31 -0400
Message-ID: <1159663354778-git-send-email-michaelc@cs.wisc.edu>
References: <11596633513659-git-send-email-michaelc@cs.wisc.edu> <11596633523779-git-send-email-michaelc@cs.wisc.edu> <11596633523617-git-send-email-michaelc@cs.wisc.edu> <11596633533246-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:27329 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1752001AbWJABmi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Sep 2006 21:42:38 -0400
In-Reply-To: <11596633533246-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

>From RHEL4: This is a bulk addition of several HP and Hitachi entries.
When SCSI-2 they can support luns past 7 and sparse luns.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_devinfo.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index dc1e1eb..ce63044 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -162,6 +162,11 @@ static struct {
 	{"HITACHI", "DF600", "*", BLIST_SPARSELUN},
 	{"HITACHI", "DISK-SUBSYSTEM", "*", BLIST_ATTACH_PQ3 | BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"HITACHI", "OPEN-E", "*", BLIST_ATTACH_PQ3 | BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"HITACHI", "OP-C-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"HITACHI", "3380-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"HITACHI", "3390-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"HITACHI", "6586-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"HITACHI", "6588-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"HP", "A6189A", NULL, BLIST_SPARSELUN | BLIST_LARGELUN},	/* HP VA7400 */
 	{"HP", "OPEN-", "*", BLIST_REPORTLUN2}, /* HP XP Arrays */
 	{"HP", "NetRAID-4M", NULL, BLIST_FORCELUN},
@@ -169,6 +174,14 @@ static struct {
 	{"HP", "C1557A", NULL, BLIST_FORCELUN},
 	{"HP", "C3323-300", "4269", BLIST_NOTQ},
 	{"HP", "C5713A", NULL, BLIST_NOREPORTLUN},
+	{"HP", "DF400", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"HP", "DF500", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"HP", "DF600", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"HP", "OP-C-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"HP", "3380-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"HP", "3390-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"HP", "6586-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"HP", "6588-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"IBM", "AuSaV1S2", NULL, BLIST_FORCELUN},
 	{"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"IBM", "2105", NULL, BLIST_RETRY_HWERROR},
-- 
1.4.1

