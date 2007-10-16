From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH 1/4] docbook: fix kernel-api content
Date: Mon, 15 Oct 2007 17:29:33 -0700
Message-ID: <20071015172933.80ab7d1d.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:44625 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbXJPA3w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 20:29:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>, akpm <akpm@linux-foundation.org>, Eric.Moore@lsi.com, scsi <linux-scsi@vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-api docbook warnings.

Warning(linux-2.6.23-git8//drivers/message/fusion/mptscsih.c:2618): No description found for parameter 'sc'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/message/fusion/mptscsih.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- linux-2.6.23-git8.orig/drivers/message/fusion/mptscsih.c
+++ linux-2.6.23-git8/drivers/message/fusion/mptscsih.c
@@ -2605,14 +2605,10 @@ mptscsih_set_scsi_lookup(MPT_ADAPTER *io
 }
 
 /**
- * SCPNT_TO_LOOKUP_IDX
- *
- * search's for a given scmd in the ScsiLookup[] array list
- *
+ * SCPNT_TO_LOOKUP_IDX - searches for a given scmd in the ScsiLookup[] array list
  * @ioc: Pointer to MPT_ADAPTER structure
- * @scmd: scsi_cmnd pointer
- *
- **/
+ * @sc: scsi_cmnd pointer
+ */
 static int
 SCPNT_TO_LOOKUP_IDX(MPT_ADAPTER *ioc, struct scsi_cmnd *sc)
 {
