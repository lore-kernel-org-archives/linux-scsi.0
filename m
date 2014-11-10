From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/11] scsi: remove use_blk_tcq Scsi_Host field
Date: Mon, 10 Nov 2014 16:56:26 +0100
Message-ID: <1415634990-3023-8-git-send-email-hch@lst.de>
References: <1415634990-3023-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:59157 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbaKJP4g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Nov 2014 10:56:36 -0500
In-Reply-To: <1415634990-3023-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 include/scsi/scsi_host.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 5b03ba9..d6bd652 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -650,7 +650,6 @@ struct Scsi_Host {
 	unsigned active_mode:2;
 	unsigned unchecked_isa_dma:1;
 	unsigned use_clustering:1;
-	unsigned use_blk_tcq:1;
 
 	/*
 	 * Host has requested that no further requests come through for the
-- 
1.9.1

