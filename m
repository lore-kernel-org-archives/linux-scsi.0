From: Ralf Baechle <ralf@linux-mips.org>
Subject: [SCSI] Make sgiwd93_detect and sgiwd93_detect static.
Date: Thu, 9 Mar 2006 14:35:13 +0000
Message-ID: <20060309143513.GA11531@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ftp.linux-mips.org ([194.74.144.162]:30903 "EHLO
	ftp.linux-mips.org") by vger.kernel.org with ESMTP id S1751939AbWCIOfT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Mar 2006 09:35:19 -0500
Received: from localhost.localdomain ([127.0.0.1]:37268 "EHLO bacchus.dhis.org")
	by ftp.linux-mips.org with ESMTP id S8133477AbWCIO0j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2006 14:26:39 +0000
Received: from denk.linux-mips.net (denk.linux-mips.net [127.0.0.1])
	by bacchus.dhis.org (8.13.4/8.13.4) with ESMTP id k29EZE7I013265
	for <linux-scsi@vger.kernel.org>; Thu, 9 Mar 2006 14:35:14 GMT
Received: (from ralf@localhost)
	by denk.linux-mips.net (8.13.4/8.13.4/Submit) id k29EZDHO013264
	for linux-scsi@vger.kernel.org; Thu, 9 Mar 2006 14:35:13 GMT
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Nothing outside sgiwd93.c references them.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index bf2ceb5..7cd366f 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -265,7 +265,7 @@ out_unregister:
 	return NULL;
 }
 
-int __init sgiwd93_detect(struct scsi_host_template *SGIblows)
+static int __init sgiwd93_detect(struct scsi_host_template *SGIblows)
 {
 	int found = 0;
 
@@ -288,7 +288,7 @@ int __init sgiwd93_detect(struct scsi_ho
 	return found;
 }
 
-int sgiwd93_release(struct Scsi_Host *instance)
+static int sgiwd93_release(struct Scsi_Host *instance)
 {
 	struct ip22_hostdata *hdata = HDATA(instance);
 	int irq = 0;
