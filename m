From: "Czerkowicz, John" <john.czerkowicz@hp.com>
Subject: [PATCH] 2.4.26 scsi_scan.c Blacklist Entries
Date: Fri, 16 Apr 2004 16:29:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <F65B33CAD23A284EAE6E4AE353BF94DC031A44CC@tayexc13.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.zma.compaq.com ([161.114.64.105]:28679 "EHLO
	zmamail05.zma.compaq.com") by vger.kernel.org with ESMTP
	id S263697AbUDPUaI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Apr 2004 16:30:08 -0400
Received: from tayexg11.americas.cpqcorp.net (tayexg11.americas.cpqcorp.net [16.103.130.96])
	by zmamail05.zma.compaq.com (Postfix) with ESMTP id C9C3619B5
	for <linux-scsi@vger.kernel.org>; Fri, 16 Apr 2004 16:30:06 -0400 (EDT)
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

The following HP DAT autoloaders have devices at LUN 1:

HP SureStore DAT8x6
HP SureStore DAT24x6
HP SureStore DAT40x6
HP StorageWorks DAT72x6

The DAT24x6 is already present in scsi_scan.c.  The patch below (against
2.4.26) adds the others.

Many thanks!
John

--- linux-2.4.26/drivers/scsi/scsi_scan.c	2004-04-14
09:05:31.000000000
-0400
+++ linux/drivers/scsi/scsi_scan.c	2004-04-16 12:41:59.000000000
-0400
@@ -208,6 +208,9 @@
 	{"SMSC", "USB 2 HS", "*", BLIST_SPARSELUN | BLIST_LARGELUN}, 
 	{"XYRATEX", "RS", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"NEC", "iStorage", "*", BLIST_SPARSELUN | BLIST_LARGELUN |
BLIST_FORCELUN},
+	{"HP", "C1553A", "*", BLIST_FORCELUN},		/* HP SureStore
DAT8x6 */
+	{"HP", "C5713A", "*", BLIST_FORCELUN},		/* HP SureStore
DAT40x6 */
+	{"HP", "DAT72X6", "*", BLIST_FORCELUN},		/* HP
StorageWorks DAT72x6 */
 
 	/*
 	 * Must be at end of list...


