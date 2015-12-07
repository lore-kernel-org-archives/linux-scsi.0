From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/13] irq_poll: remove unused data and max fields
Date: Mon,  7 Dec 2015 12:51:45 -0800
Message-ID: <1449521512-22921-7-git-send-email-hch@lst.de>
References: <1449521512-22921-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449521512-22921-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: sagig@dev.mellanox.co.il, bart.vanassche@sandisk.com, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/irq_poll.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/irq_poll.h b/include/linux/irq_poll.h
index ce9e1db..7527c03 100644
--- a/include/linux/irq_poll.h
+++ b/include/linux/irq_poll.h
@@ -7,9 +7,7 @@ typedef int (irq_poll_fn)(struct irq_poll *, int);
 struct irq_poll {
 	struct list_head list;
 	unsigned long state;
-	unsigned long data;
 	int weight;
-	int max;
 	irq_poll_fn *poll;
 };
 
-- 
1.9.1
