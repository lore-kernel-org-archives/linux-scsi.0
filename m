From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 11/14] sg_io: mark blk_set_cmd_filter_defaults as __init
Date: Wed,  6 Feb 2013 16:15:58 +0100
Message-ID: <1360163761-8541-12-git-send-email-pbonzini@redhat.com>
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/scsi_ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 4942314..3830faf 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -113,7 +113,7 @@ static int sg_emulated_host(struct request_queue *q, int __user *p)
 	return put_user(1, p);
 }
 
-static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
+static void __init blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 {
 #define sgio_bitmap_set(cmd, mask, rw) \
 	filter->rw##_ok[(cmd)] |= (mask);
-- 
1.7.1
