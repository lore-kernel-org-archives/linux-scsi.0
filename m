From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [RFC PATCH 12/13] dm-mpath: add hw-handler interface
Date: Wed, 19 Mar 2008 18:11:53 -0500 (EST)
Message-ID: <20080319.181153.66055860.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com, michaelc@cs.wisc.edu, hare@suse.de, agk@redhat.com, linux-kernel@vger.kernel.org
Cc: j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com, dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch adds a hw-handler interface for request-based dm-multipath.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm-hw-handler.h |    1 +
 1 files changed, 1 insertion(+)

Index: 2.6.25-rc5/drivers/md/dm-hw-handler.h
===================================================================
--- 2.6.25-rc5.orig/drivers/md/dm-hw-handler.h
+++ 2.6.25-rc5/drivers/md/dm-hw-handler.h
@@ -35,6 +35,7 @@ struct hw_handler_type {
 	void (*pg_init) (struct hw_handler *hwh, unsigned bypassed,
 			 struct dm_path *path);
 	unsigned (*error) (struct hw_handler *hwh, struct bio *bio);
+	unsigned (*error_rq) (struct hw_handler *hwh, struct request *rq);
 	int (*status) (struct hw_handler *hwh, status_type_t type,
 		       char *result, unsigned int maxlen);
 };
