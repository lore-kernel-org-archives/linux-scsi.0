From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Announce] Emulex lpfcdriver v8.0.11 available
Date: Mon, 13 Sep 2004 10:34:42 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040913103442.A24839@infradead.org>
References: <0B1E13B586976742A7599D71A6AC733C02F1AC@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:21002 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S266467AbUIMJfG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Sep 2004 05:35:06 -0400
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C02F1AC@xbl3.ma.emulex.com>; from James.Smart@Emulex.Com on Wed, Sep 08, 2004 at 07:34:57PM -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Wed, Sep 08, 2004 at 07:34:57PM -0400, James.Smart@Emulex.Com wrote:
> Christoph,
> 
> FYI - the 8.0.11 lpfc driver has been posted to SourceForge.

Looks good, but I need the following patch to get a clean compile:


diff -uNr lpfcdriver-2.6-8.0.11/lpfc_crtn.h lpfcdriver-2.6-8.0.11-hch/lpfc_crtn.h
--- lpfcdriver-2.6-8.0.11/lpfc_crtn.h	2004-09-08 14:58:22.000000000 +0200
+++ lpfcdriver-2.6-8.0.11-hch/lpfc_crtn.h	2004-09-13 11:15:33.961733048 +0200
@@ -235,8 +235,6 @@
 void *lpfc_mbuf_alloc(struct lpfc_hba *, int, dma_addr_t *);
 void lpfc_mbuf_free(struct lpfc_hba *, void *, dma_addr_t);
 
-void lpfc_set_pkt_len(struct sk_buff *, uint32_t);
-void *lpfc_get_pkt_data(struct sk_buff *);
 int  lpfc_stop_timer(struct lpfc_hba *);
 
 
