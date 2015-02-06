From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 25/36] aha1542: fix include guard and remove useless changelog
Date: Fri,  6 Feb 2015 23:11:46 +0100
Message-ID: <1423260717-15944-26-git-send-email-linux@rainbow-software.org>
References: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56968 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755797AbbBFWQE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2015 17:16:04 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YJr8H-0006fF-A5
	for linux-scsi@vger.kernel.org; Fri, 06 Feb 2015 23:12:13 +0100
In-Reply-To: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix include guard in header file and remove useless changelog

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.h |   36 +++---------------------------------
 1 file changed, 3 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/aha1542.h b/drivers/scsi/aha1542.h
index f58792b..0fe9bae 100644
--- a/drivers/scsi/aha1542.h
+++ b/drivers/scsi/aha1542.h
@@ -1,35 +1,5 @@
-#ifndef _AHA1542_H
-
-/* $Id: aha1542.h,v 1.1 1992/07/24 06:27:38 root Exp root $
- *
- * Header file for the adaptec 1542 driver for Linux
- *
- * $Log: aha1542.h,v $
- * Revision 1.1  1992/07/24  06:27:38  root
- * Initial revision
- *
- * Revision 1.2  1992/07/04  18:41:49  root
- * Replaced distribution with current drivers
- *
- * Revision 1.3  1992/06/23  23:58:20  root
- * Fixes.
- *
- * Revision 1.2  1992/05/26  22:13:23  root
- * Changed bug that prevented DMA above first 2 mbytes.
- *
- * Revision 1.1  1992/05/22  21:00:29  root
- * Initial revision
- *
- * Revision 1.1  1992/04/24  18:01:50  root
- * Initial revision
- *
- * Revision 1.1  1992/04/02  03:23:13  drew
- * Initial revision
- *
- * Revision 1.3  1992/01/27  14:46:29  tthorn
- * *** empty log message ***
- *
- */
+#ifndef _AHA1542_H_
+#define _AHA1542_H_
 
 #include <linux/types.h>
 
@@ -129,4 +99,4 @@ struct ccb {		/* Command Control Block 5.3 */
 #define AHA1542_REGION_SIZE 4
 #define AHA1542_MAILBOXES 8
 
-#endif
+#endif /* _AHA1542_H_ */
-- 
Ondrej Zary

