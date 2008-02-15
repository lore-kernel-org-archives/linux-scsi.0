From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [APPENDIX PATCH 12/13] dm-mpath: add hw-handler interface
Date: Fri, 15 Feb 2008 17:33:27 -0500 (EST)
Message-ID: <20080215.173327.118951012.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764001AbYBOWdV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2008 17:33:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com

This patch adds a hw-handler interface for request-based dm-multipath.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm-hw-handler.h |    1 +
 1 files changed, 1 insertion(+)

Index: 2.6.25-rc1/drivers/md/dm-hw-handler.h
===================================================================
--- 2.6.25-rc1.orig/drivers/md/dm-hw-handler.h
+++ 2.6.25-rc1/drivers/md/dm-hw-handler.h
@@ -35,6 +35,7 @@ struct hw_handler_type {
 	void (*pg_init) (struct hw_handler *hwh, unsigned bypassed,
 			 struct dm_path *path);
 	unsigned (*error) (struct hw_handler *hwh, struct bio *bio);
+	unsigned (*error_rq) (struct hw_handler *hwh, struct request *rq);
 	int (*status) (struct hw_handler *hwh, status_type_t type,
 		       char *result, unsigned int maxlen);
 };
