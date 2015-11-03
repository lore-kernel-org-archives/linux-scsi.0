From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: [PATCH v2 5/5] ipr: Driver version 2.6.3.
Date: Tue,  3 Nov 2015 16:26:10 -0200
Message-ID: <1446575170-18656-5-git-send-email-krisman@linux.vnet.ibm.com>
References: <1446575170-18656-1-git-send-email-krisman@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:43891 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249AbbKCS03 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2015 13:26:29 -0500
Received: from /spool/local
	by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
	Tue, 3 Nov 2015 16:26:28 -0200
Received: from d24relay03.br.ibm.com (d24relay03.br.ibm.com [9.13.184.25])
	by d24dlp01.br.ibm.com (Postfix) with ESMTP id 6E7F7352006E
	for <linux-scsi@vger.kernel.org>; Tue,  3 Nov 2015 13:25:15 -0500 (EST)
Received: from d24av05.br.ibm.com (d24av05.br.ibm.com [9.18.232.44])
	by d24relay03.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tA3IOaKK55378170
	for <linux-scsi@vger.kernel.org>; Tue, 3 Nov 2015 16:24:36 -0200
Received: from d24av05.br.ibm.com (localhost [127.0.0.1])
	by d24av05.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tA3IQPHR025442
	for <linux-scsi@vger.kernel.org>; Tue, 3 Nov 2015 13:26:25 -0500
In-Reply-To: <1446575170-18656-1-git-send-email-krisman@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, manoj@linux.vnet.ibm.com, Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>

Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index b16bcd1..a34c7a5 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -39,8 +39,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.6.2"
-#define IPR_DRIVER_DATE "(June 11, 2015)"
+#define IPR_DRIVER_VERSION "2.6.3"
+#define IPR_DRIVER_DATE "(October 17, 2015)"
 
 /*
  * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstanding
-- 
2.1.0

