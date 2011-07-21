From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 062/103] target/pscsi: Unused param for pscsi_get_bio()
Date: Thu, 21 Jul 2011 00:11:45 -0700
Message-ID: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm2-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.127]:22238 "HELO
	nm2-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752030Ab1GUHGl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:06:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

pdv unused.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pscsi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 5df329c..3574c52 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1051,7 +1051,7 @@ static void pscsi_bi_endio(struct bio *bio, int error)
 	bio_put(bio);
 }
 
-static inline struct bio *pscsi_get_bio(struct pscsi_dev_virt *pdv, int sg_num)
+static inline struct bio *pscsi_get_bio(int sg_num)
 {
 	struct bio *bio;
 	/*
@@ -1124,7 +1124,7 @@ static int __pscsi_map_task_SG(
 				/*
 				 * Calls bio_kmalloc() and sets bio->bi_end_io()
 				 */
-				bio = pscsi_get_bio(pdv, nr_vecs);
+				bio = pscsi_get_bio(nr_vecs);
 				if (!(bio))
 					goto fail;
 
-- 
1.7.6

