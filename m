From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH] mptlan: Remove linux/miscdevice.h from mptlan.h
Date: Thu, 15 Dec 2016 15:12:16 +0100
Message-ID: <20161215141216.2021-1-clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Corentin Labbe <clabbe.montjoie@gmail.com>
List-Id: linux-scsi@vger.kernel.org

This patch remove linux/miscdevice.h from mptlan.h since mptlan.h does
not contain any miscdevice.
The only user of it is mptctl.c which already include linux/miscdevice.h
So no need to include it twice.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/message/fusion/mptlan.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/message/fusion/mptlan.h b/drivers/message/fusion/mptlan.h
index 69e9d54..694b475 100644
--- a/drivers/message/fusion/mptlan.h
+++ b/drivers/message/fusion/mptlan.h
@@ -65,7 +65,6 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/miscdevice.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/delay.h>
-- 
2.10.2
