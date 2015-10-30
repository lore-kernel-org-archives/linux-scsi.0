From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: [PATCH 5/5] ipr: Driver version 2.6.3.
Date: Fri, 30 Oct 2015 14:49:09 -0200
Message-ID: <1446223749-17416-5-git-send-email-krisman@linux.vnet.ibm.com>
References: <1446223749-17416-1-git-send-email-krisman@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:53568 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbbJ3Qtd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2015 12:49:33 -0400
Received: from /spool/local
	by e24smtp02.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
	Fri, 30 Oct 2015 14:49:30 -0200
Received: from d24relay01.br.ibm.com (d24relay01.br.ibm.com [9.8.31.16])
	by d24dlp01.br.ibm.com (Postfix) with ESMTP id 5E914352007E
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 12:48:17 -0400 (EDT)
Received: from d24av01.br.ibm.com (d24av01.br.ibm.com [9.8.31.91])
	by d24relay01.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9UGnvW35107898
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 14:49:57 -0200
Received: from d24av01.br.ibm.com (localhost [127.0.0.1])
	by d24av01.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9UGnQSB015691
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 14:49:27 -0200
In-Reply-To: <1446223749-17416-1-git-send-email-krisman@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>

Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index aab5c6d..ce49ca9 100644
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

