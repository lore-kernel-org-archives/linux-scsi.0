From: michaelc@cs.wisc.edu
Subject: [PATCH 3/4] scsi_devinfo: add nec istorage
Date: Sat, 30 Sep 2006 20:42:30 -0400
Message-ID: <11596633533246-git-send-email-michaelc@cs.wisc.edu>
References: <11596633513659-git-send-email-michaelc@cs.wisc.edu> <11596633523779-git-send-email-michaelc@cs.wisc.edu> <11596633523617-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:26561 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1751999AbWJABmh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Sep 2006 21:42:37 -0400
In-Reply-To: <11596633523617-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

>From RHEL4: NEC iStorage devices are SCSI-2 devices but they
support the report luns opcode.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_devinfo.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index f6aadbd..dc1e1eb 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -189,6 +189,7 @@ static struct {
 	{"NAKAMICH", "MJ-4.8S", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"NAKAMICH", "MJ-5.16S", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"NEC", "PD-1 ODX654P", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
+	{"NEC", "iStorage", NULL, BLIST_REPORTLUN2},
 	{"NRC", "MBR-7", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"NRC", "MBR-7.4", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"PIONEER", "CD-ROM DRM-600", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-- 
1.4.1

