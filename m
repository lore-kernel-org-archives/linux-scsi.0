From: michaelc@cs.wisc.edu
Subject: [PATCH 3/5] newline in iscsi printk
Date: Sun, 17 Dec 2006 12:10:26 -0600
Message-ID: <11663790313961-git-send-email-michaelc@cs.wisc.edu>
References: <1166379028772-git-send-email-michaelc@cs.wisc.edu> <11663790303684-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932236AbWLQSKo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Dec 2006 13:10:44 -0500
In-Reply-To: <11663790303684-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Meelis Roos <mroos@linux.ee>, Mike Christie <michaelc@cs.wisc.edu>

From: Meelis Roos <mroos@linux.ee>

This patch against 2.6.19 cures two runtogether printk messages in iSCSI
driver.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 9b25124..2648dbd 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1414,7 +1414,7 @@ static __init int iscsi_transport_init(v
 {
 	int err;
 
-	printk(KERN_INFO "Loading iSCSI transport class v%s.",
+	printk(KERN_INFO "Loading iSCSI transport class v%s.\n",
 		ISCSI_TRANSPORT_VERSION);
 
 	err = class_register(&iscsi_transport_class);
-- 
1.4.1.1

