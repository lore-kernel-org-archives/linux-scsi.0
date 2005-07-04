From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/9] qla1280: remove SG_SEGMENTS
Date: Mon, 4 Jul 2005 17:48:41 +0200
Message-ID: <20050704154841.GF30435@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:52940 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261324AbVGDPsq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2005 11:48:46 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, jes@trained-monkey.org
Cc: linux-scsi@vger.kernel.org, ths@linux-mips.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Thiemo Seufer <ths@linux-mips.org>

Index: linux-2.6/drivers/scsi/qla1280.h
===================================================================
--- linux-2.6.orig/drivers/scsi/qla1280.h	2005-06-19 21:14:52.000000000 +0200
+++ linux-2.6/drivers/scsi/qla1280.h	2005-06-19 21:16:23.000000000 +0200
@@ -94,9 +94,6 @@
 #define REQUEST_ENTRY_CNT		256 /* Number of request entries. */
 #define RESPONSE_ENTRY_CNT		16  /* Number of response entries. */
 
-/* Number of segments 1 - 65535 */
-#define SG_SEGMENTS			32  /* Cmd entry + 6 continuations */
-
 /*
  * SCSI Request Block structure  (sp)  that is placed
  * on cmd->SCp location of every I/O
