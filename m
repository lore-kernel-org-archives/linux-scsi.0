From: Joe Perches <joe@perches.com>
Subject: [PATCH 10/12] scsi: Use DECLARE_BITMAP
Date: Tue, 19 May 2015 18:37:58 -0700
Message-ID: <8854fb0135507c40546bd0c9a7890efbb38a9c96.1432085659.git.joe@perches.com>
References: <cover.1432085659.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1432085659.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use the generic mechanism to declare a bitmap instead of unsigned long.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/sr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 8bd54a6..f40c957 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -99,7 +99,7 @@ static struct scsi_driver sr_template = {
 	.done			= sr_done,
 };
 
-static unsigned long sr_index_bits[SR_DISKS / BITS_PER_LONG];
+static DECLARE_BITMAP(sr_index_bits, SR_DISKS);
 static DEFINE_SPINLOCK(sr_index_lock);
 
 /* This semaphore is used to mediate the 0->1 reference get in the
-- 
2.1.2
