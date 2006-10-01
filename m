From: michaelc@cs.wisc.edu
Subject: [PATCH 2/4] scsi_devinfo: add Tornado
Date: Sat, 30 Sep 2006 20:42:29 -0400
Message-ID: <11596633523617-git-send-email-michaelc@cs.wisc.edu>
References: <11596633513659-git-send-email-michaelc@cs.wisc.edu> <11596633523779-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:26049 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1751998AbWJABmg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Sep 2006 21:42:36 -0400
In-Reply-To: <11596633523779-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This is from RHEL4. I do not have any info from our bugzilla. All
I could find was something like this thread
http://lkml.org/lkml/2005/1/7/346

Report lun for linux does not work. It may be our lun format code or
it may be the device. It is probably not worth it to add anything
special for this device, so the patch just adds BLIST_NOREPORTLUN.

This patch can be dropped if you feel BLIST_NOREPORTLUN is just
a hack.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_devinfo.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index cbf733b..f6aadbd 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -211,6 +211,7 @@ static struct {
 	{"SUN", "T300", "*", BLIST_SPARSELUN},
 	{"SUN", "T4", "*", BLIST_SPARSELUN},
 	{"TEXEL", "CD-ROM", "1.06", BLIST_BORKEN},
+	{"Tornado-", "F4", "*", BLIST_NOREPORTLUN},
 	{"TOSHIBA", "CDROM", NULL, BLIST_ISROM},
 	{"TOSHIBA", "CD-ROM", NULL, BLIST_ISROM},
 	{"USB2.0", "SMARTMEDIA/XD", NULL, BLIST_FORCELUN | BLIST_INQUIRY_36},
-- 
1.4.1

