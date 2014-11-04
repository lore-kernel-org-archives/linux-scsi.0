From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/11] scsi: remove use_blk_tcq Scsi_Host field
Date: Tue,  4 Nov 2014 08:54:12 +0100
Message-ID: <1415087656-9491-8-git-send-email-hch@lst.de>
References: <1415087656-9491-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:34680 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbaKDHyR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2014 02:54:17 -0500
In-Reply-To: <1415087656-9491-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/scsi/scsi_host.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index f62143a..8bf2cb0 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -642,7 +642,6 @@ struct Scsi_Host {
 	unsigned active_mode:2;
 	unsigned unchecked_isa_dma:1;
 	unsigned use_clustering:1;
-	unsigned use_blk_tcq:1;
 
 	/*
 	 * Host has requested that no further requests come through for the
-- 
1.9.1

