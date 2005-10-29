From: James.Smart@Emulex.Com
Subject: [PATCH 12/15]  lpfc 8.1.0 : Remove unneeded IOCB_t * cast
Date: Fri, 28 Oct 2005 20:29:56 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276A5B@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:7633 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S1750936AbVJ2A37 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 20:29:59 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j9T0TvDp018548
	for <linux-scsi@vger.kernel.org>; Fri, 28 Oct 2005 17:29:58 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Remove unneeded IOCB_t * cast from lpfc_sli_handle_fast_ring_event


Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -936,7 +936,7 @@ lpfc_sli_handle_fast_ring_event(struct l
 		 * structure.  The copy involves a byte-swap since the
 		 * network byte order and pci byte orders are different.
 		 */
-		entry = (IOCB_t *) IOCB_ENTRY(pring->rspringaddr, pring->rspidx);
+		entry = IOCB_ENTRY(pring->rspringaddr, pring->rspidx);
 		lpfc_sli_pcimem_bcopy((uint32_t *) entry,
 				      (uint32_t *) &rspiocbq.iocb,
 				      sizeof (IOCB_t));
