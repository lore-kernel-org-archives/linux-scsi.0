From: Leo Zhang <nguzcf@gmail.com>
Subject: [PATCH] target/iscsi: fix error msg typo when create lio_qr_cache failed
Date: Mon, 24 Dec 2018 00:18:27 +0800
Message-ID: <1545581907-920233-1-git-send-email-nguzcf@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <mchristi@redhat.com>, Bart Van Assche <bvanassche@acm.org>, Matthew Wilcox <willy@infradead.org>, Sagi Grimberg <sagi@grimberg.me>, Colin Ian King <colin.king@canonical.com>, Laura Abbott <labbott@redhat.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, Leo Zhang <nguzcf@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Leo Zhang <nguzcf@gmail.com>
---
 drivers/target/iscsi/iscsi_target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index c1d5a17..780a914 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -714,7 +714,7 @@ static int __init iscsi_target_init_module(void)
 			sizeof(struct iscsi_queue_req),
 			__alignof__(struct iscsi_queue_req), 0, NULL);
 	if (!lio_qr_cache) {
-		pr_err("nable to kmem_cache_create() for"
+		pr_err("Unable to kmem_cache_create() for"
 				" lio_qr_cache\n");
 		goto bitmap_out;
 	}
-- 
1.8.3.1
