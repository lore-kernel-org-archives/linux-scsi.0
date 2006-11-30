From: Meelis Roos <mroos@linux.ee>
Subject: [PATCH] newline in iscsi printk
Date: Thu, 30 Nov 2006 13:38:09 +0200 (EET)
Message-ID: <Pine.SOC.4.61.0611301336530.23558@math.ut.ee>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from math.ut.ee ([193.40.36.2]:983 "EHLO math.ut.ee")
	by vger.kernel.org with ESMTP id S935650AbWK3LiM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Nov 2006 06:38:12 -0500
Received: from math.ut.ee (localhost [IPv6:::1])
	by math.ut.ee (8.12.8+Sun/8.12.8/math-1.2) with ESMTP id kAUBc928028716
	for <linux-scsi@vger.kernel.org>; Thu, 30 Nov 2006 13:38:09 +0200 (EET)
Received: from localhost (mroos@localhost)
	by math.ut.ee (8.12.8+Sun/8.12.2/Submit) with ESMTP id kAUBc98i028711
	for <linux-scsi@vger.kernel.org>; Thu, 30 Nov 2006 13:38:09 +0200 (EET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch against 2.6.19 cures two runtogether printk messages in iSCSI 
driver.

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 9b25124..2648dbd 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1414,7 +1414,7 @@ static __init int iscsi_transport_init(void)
 {
 	int err;
 
-	printk(KERN_INFO "Loading iSCSI transport class v%s.",
+	printk(KERN_INFO "Loading iSCSI transport class v%s.\n",
 		ISCSI_TRANSPORT_VERSION);
 
 	err = class_register(&iscsi_transport_class);

-- 
Meelis Roos (mroos@linux.ee)
