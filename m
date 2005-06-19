From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH, scsi-block-2.6] don't export bio_map_kern
Date: Sun, 19 Jun 2005 11:31:13 +0200
Message-ID: <20050619093113.GB16872@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:2218 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262222AbVFSJbR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Jun 2005 05:31:17 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Modules should use the higher-level blk_rq_map_kern, which they
currently do anyway.


Index: linux-2.6/fs/bio.c
===================================================================
--- linux-2.6.orig/fs/bio.c	2005-06-18 17:26:42.000000000 +0200
+++ linux-2.6/fs/bio.c	2005-06-18 17:49:31.000000000 +0200
@@ -1201,7 +1201,6 @@
 EXPORT_SYMBOL(bio_add_page);
 EXPORT_SYMBOL(bio_get_nr_vecs);
 EXPORT_SYMBOL(bio_unmap_user);
-EXPORT_SYMBOL(bio_map_kern);
 EXPORT_SYMBOL(bio_pair_release);
 EXPORT_SYMBOL(bio_split);
 EXPORT_SYMBOL(bio_split_pool);
