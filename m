From: Olaf Hering <olh@suse.de>
Subject: [PATCH] uninline exported ata_host_intr
Date: Fri, 5 Aug 2005 19:03:49 +0200
Message-ID: <20050805170349.GA6065@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:14004 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S263076AbVHERDv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Aug 2005 13:03:51 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org


ata_host_intr cant be either inline or exported.

Signed-off-by: Olaf Hering <olh@suse.de>

Index: linux-2.6.12/drivers/scsi/libata-core.c
===================================================================
--- linux-2.6.12.orig/drivers/scsi/libata-core.c
+++ linux-2.6.12/drivers/scsi/libata-core.c
@@ -3487,7 +3487,7 @@ void ata_bmdma_stop(struct ata_port *ap)
  *	One if interrupt was handled, zero if not (shared irq).
  */
 
-inline unsigned int ata_host_intr (struct ata_port *ap,
+unsigned int ata_host_intr (struct ata_port *ap,
 				   struct ata_queued_cmd *qc)
 {
 	u8 status, host_stat;
