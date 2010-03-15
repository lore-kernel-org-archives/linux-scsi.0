From: Dan Carpenter <error27@gmail.com>
Subject: [patch] libsrp: remove dead code
Date: Mon, 15 Mar 2010 11:25:56 +0300
Message-ID: <20100315082556.GI18181@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:54778 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759866Ab0COI0I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2010 04:26:08 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@suse.de>

There was a stray kfree() left over from:
4546548789 kfifo: move struct kfifo in place

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
index 2277516..c06eaeb 100644
--- a/drivers/scsi/libsrp.c
+++ b/drivers/scsi/libsrp.c
@@ -67,7 +67,6 @@ static int srp_iu_pool_alloc(struct srp_queue *q, size_t max,
 	}
 	return 0;
 
-	kfree(q->items);
 free_pool:
 	kfree(q->pool);
 	return -ENOMEM;
