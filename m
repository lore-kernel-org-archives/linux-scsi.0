From: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
Subject: [PATCH 1/1] lpfc cleanups
Date: Mon, 09 Nov 2009 14:52:45 +0900
Message-ID: <4AF7AE2D.3060703@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33310 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbZKIFu4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2009 00:50:56 -0500
Received: from m4.gw.fujitsu.co.jp ([10.0.50.74])
	by fgwmail5.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id nA95p0U2028578
	for <linux-scsi@vger.kernel.org> (envelope-from kusumi.tomohiro@jp.fujitsu.com);
	Mon, 9 Nov 2009 14:51:00 +0900
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id EE64045DE6E
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2009 14:50:59 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 953C445DE60
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2009 14:50:59 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 378B0E18005
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2009 14:50:59 +0900 (JST)
Received: from m023.s.css.fujitsu.com (m023.s.css.fujitsu.com [10.0.81.63])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 430C31DB803B
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2009 14:50:57 +0900 (JST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

This patch is just cleanups.
It corrects a typo in lpfc_sli.c, and also removes linux/kthread.h from lpfc_debugfs.c.

  Tomohiro Kusumi


Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
---


 drivers/scsi/lpfc/lpfc_debugfs.c |    1 -
 drivers/scsi/lpfc/lpfc_sli.c     |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 8d0f0de..3c72664 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -23,7 +23,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/idr.h>
 #include <linux/interrupt.h>
-#include <linux/kthread.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
 #include <linux/ctype.h>
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 43cbe33..429bd88 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2716,7 +2716,7 @@ lpfc_sli_sp_handle_rspiocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	list_add_tail(&rspiocbp->list, &(pring->iocb_continueq));
 	pring->iocb_continueq_cnt++;
 
-	/* Now, determine whetehr the list is completed for processing */
+	/* Now, determine whether the list is completed for processing */
 	irsp = &rspiocbp->iocb;
 	if (irsp->ulpLe) {
 		/*
