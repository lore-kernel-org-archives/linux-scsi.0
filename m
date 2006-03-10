From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/6] scsi tgt: use the original bio_map_user interface
Date: Fri, 10 Mar 2006 20:48:41 +0900
Message-ID: <20060310204841T.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:50339 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP id S932732AbWCJLuw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Mar 2006 06:50:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

---

 drivers/scsi/scsi_tgt_lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

0968c0f0e985d7700bd877f3a994e1aeb27a462d
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index 8746236..941dd64 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -315,7 +315,7 @@ static int scsi_map_user_pages(struct sc
 
 	while (len > 0) {
 		dprintk("%lx %u\n", (unsigned long) uaddr, len);
-		bio = bio_map_user(q, NULL, (unsigned long) uaddr, len, rw, 1);
+		bio = bio_map_user(q, NULL, (unsigned long) uaddr, len, rw);
 		if (IS_ERR(bio)) {
 			err = PTR_ERR(bio);
 			dprintk("fail to map %lx %u %d %x\n",
-- 
1.1.5
