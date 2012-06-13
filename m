From: wfg@linux.intel.com
Subject: drivers/block/xen-blkfront.c:317:11: error: too many arguments to function =?utf-8?Q?=E2=80=98blk=5Frq=5Fmap=5Fsg=E2=80=99?=
Date: Thu, 14 Jun 2012 07:03:51 +0800
Message-ID: <4fd91c57.sFZCIUu/80uN/wFE%wfg@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_4fd91c57.QUPvmKpaiKC7NMbdRYJGnC0mkHZgL2sWbuuLZuxtc33/kohi"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:62888 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648Ab2FMXEJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jun 2012 19:04:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org, virtualization@lists.linux-foundation.org

This is a multi-part message in MIME format.

--=_4fd91c57.QUPvmKpaiKC7NMbdRYJGnC0mkHZgL2sWbuuLZuxtc33/kohi
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

FYI, kernel build failed on

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git multiqueue
head:   e9a6aa8a0b7b93195774a9fcf551632bf3abcd97
commit: 67db7275fa4325d46853a4bfcb79acf32e48eca8 [1/3] multiqueue: a hodge podge of things
config: x86_64-allyesdebian (attached as .config)

All related error/warning messages are:

block/blk-core.c: In function ‘attempt_plug_merge’:
block/blk-core.c:1253:9: error: ‘struct request’ has no member named ‘q’
drivers/block/cpqarray.c:938:2: warning: passing argument 1 of ‘blk_rq_map_sg’ from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected ‘struct request *’ but argument is of type ‘struct request_queue *’
drivers/block/cpqarray.c:938:2: warning: passing argument 2 of ‘blk_rq_map_sg’ from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected ‘struct scatterlist *’ but argument is of type ‘struct request *’
drivers/block/cpqarray.c:938:2: error: too many arguments to function ‘blk_rq_map_sg’
include/linux/blkdev.h:845:12: note: declared here
drivers/block/cciss.c:3339:2: warning: passing argument 1 of ‘blk_rq_map_sg’ from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected ‘struct request *’ but argument is of type ‘struct request_queue *’
drivers/block/cciss.c:3339:2: warning: passing argument 2 of ‘blk_rq_map_sg’ from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected ‘struct scatterlist *’ but argument is of type ‘struct request *’
drivers/block/cciss.c:3339:2: error: too many arguments to function ‘blk_rq_map_sg’
include/linux/blkdev.h:845:12: note: declared here
drivers/block/DAC960.c:3355:5: warning: passing argument 1 of ‘blk_rq_map_sg’ from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected ‘struct request *’ but argument is of type ‘struct request_queue *’
drivers/block/DAC960.c:3355:5: warning: passing argument 2 of ‘blk_rq_map_sg’ from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected ‘struct scatterlist *’ but argument is of type ‘struct request *’
drivers/block/DAC960.c:3355:5: error: too many arguments to function ‘blk_rq_map_sg’
include/linux/blkdev.h:845:12: note: declared here
drivers/block/DAC960.c:3433:3: warning: passing argument 1 of ‘blk_rq_map_sg’ from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected ‘struct request *’ but argument is of type ‘struct request_queue *’
drivers/block/DAC960.c:3433:3: warning: passing argument 2 of ‘blk_rq_map_sg’ from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected ‘struct scatterlist *’ but argument is of type ‘struct request *’
drivers/block/DAC960.c:3433:3: error: too many arguments to function ‘blk_rq_map_sg’
include/linux/blkdev.h:845:12: note: declared here
drivers/block/sx8.c:873:2: warning: passing argument 1 of ‘blk_rq_map_sg’ from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected ‘struct request *’ but argument is of type ‘struct request_queue *’
drivers/block/sx8.c:873:2: warning: passing argument 2 of ‘blk_rq_map_sg’ from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected ‘struct scatterlist *’ but argument is of type ‘struct request *’
drivers/block/sx8.c:873:2: error: too many arguments to function ‘blk_rq_map_sg’
include/linux/blkdev.h:845:12: note: declared here
drivers/block/xen-blkfront.c:317:11: warning: passing argument 2 of ‘blk_rq_map_sg’ from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected ‘struct scatterlist *’ but argument is of type ‘struct request *’
drivers/block/xen-blkfront.c:317:11: error: too many arguments to function ‘blk_rq_map_sg’
include/linux/blkdev.h:845:12: note: declared here
drivers/ide/ide-io.c:229:2: warning: passing argument 1 of ‘blk_rq_map_sg’ from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected ‘struct request *’ but argument is of type ‘struct request_queue *’
drivers/ide/ide-io.c:229:2: warning: passing argument 2 of ‘blk_rq_map_sg’ from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected ‘struct scatterlist *’ but argument is of type ‘struct request *’
drivers/ide/ide-io.c:229:2: error: too many arguments to function ‘blk_rq_map_sg’
include/linux/blkdev.h:845:12: note: declared here
include/linux/blkdev.h:794:30: note: declared here
include/linux/elevator.h:115:13: note: expected ‘struct request *’ but argument is of type ‘struct request_queue *’
include/linux/elevator.h:115:13: note: expected ‘int’ but argument is of type ‘struct request *’
include/linux/elevator.h:115:13: note: declared here
include/linux/elevator.h:115:13: note: expected ‘struct request *’ but argument is of type ‘struct request_queue *’
include/linux/elevator.h:115:13: note: expected ‘int’ but argument is of type ‘struct request *’
include/linux/elevator.h:115:13: note: declared here
drivers/mmc/card/queue.c:391:3: warning: passing argument 1 of ‘blk_rq_map_sg’ from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected ‘struct request *’ but argument is of type ‘struct request_queue *’
drivers/mmc/card/queue.c:391:3: warning: passing argument 2 of ‘blk_rq_map_sg’ from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected ‘struct scatterlist *’ but argument is of type ‘struct request *’
drivers/mmc/card/queue.c:391:3: error: too many arguments to function ‘blk_rq_map_sg’
include/linux/blkdev.h:845:12: note: declared here
drivers/mmc/card/queue.c:395:2: warning: passing argument 1 of ‘blk_rq_map_sg’ from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected ‘struct request *’ but argument is of type ‘struct request_queue *’
drivers/mmc/card/queue.c:395:2: warning: passing argument 2 of ‘blk_rq_map_sg’ from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected ‘struct scatterlist *’ but argument is of type ‘struct request *’
drivers/mmc/card/queue.c:395:2: error: too many arguments to function ‘blk_rq_map_sg’
include/linux/blkdev.h:845:12: note: declared here
drivers/memstick/core/mspro_block.c:711:13: warning: passing argument 2 of ‘blk_rq_map_sg’ from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected ‘struct scatterlist *’ but argument is of type ‘struct request *’
drivers/memstick/core/mspro_block.c:711:13: error: too many arguments to function ‘blk_rq_map_sg’
include/linux/blkdev.h:845:12: note: declared here
drivers/message/i2o/i2o_block.c:324:2: warning: passing argument 2 of ‘blk_rq_map_sg’ from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected ‘struct scatterlist *’ but argument is of type ‘struct request *’
drivers/message/i2o/i2o_block.c:324:2: error: too many arguments to function ‘blk_rq_map_sg’
include/linux/blkdev.h:845:12: note: declared here
include/linux/blkdev.h:645:13: note: declared here
include/linux/blkdev.h:645:13: note: declared here
include/linux/blkdev.h:645:13: note: declared here
include/linux/blkdev.h:645:13: note: declared here
include/linux/blkdev.h:645:13: note: declared here
include/linux/blkdev.h:645:13: note: expected ‘struct request *’ but argument is of type ‘struct request_queue *’
include/linux/blkdev.h:645:13: note: declared here
drivers/scsi/scsi_transport_fc.c: In function ‘fc_bsg_map_buffer’:
drivers/scsi/scsi_transport_fc.c:3674:2: warning: passing argument 1 of ‘blk_rq_map_sg’ from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected ‘struct request *’ but argument is of type ‘struct request_queue *’
drivers/scsi/scsi_transport_fc.c:3674:2: warning: passing argument 2 of ‘blk_rq_map_sg’ from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected ‘struct scatterlist *’ but argument is of type ‘struct request *’
drivers/scsi/scsi_transport_fc.c:3674:2: error: too many arguments to function ‘blk_rq_map_sg’
include/linux/blkdev.h:845:12: note: declared here
drivers/scsi/scsi_transport_fc.c: In function ‘fc_bsg_remove’:
drivers/scsi/scsi_transport_fc.c:4145:14: error: ‘struct request_queue’ has no member named ‘rq’
drivers/scsi/scsi_transport_fc.c:4145:31: error: ‘struct request_queue’ has no member named ‘rq’
drivers/scsi/scsi_transport_fc.c:4146:6: error: ‘struct request_queue’ has no member named ‘rq’
drivers/scsi/scsi_transport_fc.c:4146:25: error: ‘struct request_queue’ has no member named ‘rq’
include/linux/blkdev.h:645:13: note: declared here
include/linux/blkdev.h:645:13: note: declared here

---
0-DAY kernel build testing backend         Open Source Technology Centre
Fengguang Wu <wfg@linux.intel.com>                     Intel Corporation

--=_4fd91c57.QUPvmKpaiKC7NMbdRYJGnC0mkHZgL2sWbuuLZuxtc33/kohi
Content-Type: text/x-diff;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-multiqueue-a-hodge-podge-of-things.patch"

>From 67db7275fa4325d46853a4bfcb79acf32e48eca8 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Fri, 20 Apr 2012 09:08:11 +0200
Subject: [PATCH] multiqueue: a hodge podge of things

Not really interesting yet, this just gets us to the state where
single queue boots on a current kernel.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/Kconfig                    |    5 +
 block/Kconfig.iosched            |    2 +
 block/blk-core.c                 |  427 ++++++++++++++++++--------------------
 block/blk-exec.c                 |   14 +-
 block/blk-flush.c                |   13 +-
 block/blk-map.c                  |    2 +-
 block/blk-merge.c                |   61 +++---
 block/blk-settings.c             |    1 -
 block/blk-softirq.c              |   10 +-
 block/blk-sysfs.c                |   18 +-
 block/blk-tag.c                  |    2 +-
 block/blk-timeout.c              |   45 ++--
 block/blk.h                      |   22 +-
 block/bsg-lib.c                  |    8 +-
 block/elevator.c                 |  290 ++++++++++++++++----------
 block/noop-iosched.c             |   78 +++++--
 drivers/block/nbd.c              |    3 +-
 drivers/block/virtio_blk.c       |    2 +-
 drivers/md/dm.c                  |   11 +-
 drivers/scsi/scsi_error.c        |    5 +-
 drivers/scsi/scsi_lib.c          |   11 +-
 drivers/scsi/scsi_transport_fc.c |    3 +-
 include/linux/blk-mq.h           |   97 +++++++++
 include/linux/blkdev.h           |   44 +---
 include/linux/elevator.h         |   58 +++---
 include/scsi/scsi_device.h       |    1 +
 26 files changed, 715 insertions(+), 518 deletions(-)
 create mode 100644 include/linux/blk-mq.h

diff --git a/block/Kconfig b/block/Kconfig
index 09acf1b..7f6ca35 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -17,18 +17,23 @@ menuconfig BLOCK
 
 	 Also, SCSI character devices and USB storage will be disabled since
 	 they make use of various block layer definitions and facilities.
 
 	 Say Y here unless you know you really don't want to mount disks and
 	 suchlike.
 
 if BLOCK
 
+config MQ
+	bool "Multiqueue support"
+	help
+	  Help catch build/code dependencies
+
 config LBDAF
 	bool "Support for large (2TB+) block devices and files"
 	depends on !64BIT
 	default y
 	help
 	  Enable block devices or files of size 2TB and larger.
 
 	  This option is required to support the full capacity of large
 	  (2TB+) block devices, including RAID, disk, Network Block Device,
diff --git a/block/Kconfig.iosched b/block/Kconfig.iosched
index 3199b76..283945f 100644
--- a/block/Kconfig.iosched
+++ b/block/Kconfig.iosched
@@ -8,29 +8,31 @@ config IOSCHED_NOOP
 	---help---
 	  The no-op I/O scheduler is a minimal scheduler that does basic merging
 	  and sorting. Its main uses include non-disk based block devices like
 	  memory devices, and specialised software or hardware environments
 	  that do their own scheduling and require only minimal assistance from
 	  the kernel.
 
 config IOSCHED_DEADLINE
 	tristate "Deadline I/O scheduler"
+	depends on BLK_MQ=n
 	default y
 	---help---
 	  The deadline I/O scheduler is simple and compact. It will provide
 	  CSCAN service with FIFO expiration of requests, switching to
 	  a new point in the service tree and doing a batch of IO from there
 	  in case of expiry.
 
 config IOSCHED_CFQ
 	tristate "CFQ I/O scheduler"
 	# If BLK_CGROUP is a module, CFQ has to be built as module.
 	depends on (BLK_CGROUP=m && m) || !BLK_CGROUP || BLK_CGROUP=y
+	depends on BLK_MQ=n
 	default y
 	---help---
 	  The CFQ I/O scheduler tries to distribute bandwidth equally
 	  among all processes in the system. It should provide a fair
 	  and low latency working environment, suitable for both desktop
 	  and server systems.
 
 	  This is the default I/O scheduler.
 
diff --git a/block/blk-core.c b/block/blk-core.c
index 1f61b74..e136698 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -121,26 +121,26 @@ struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev)
 	struct backing_dev_info *ret = NULL;
 	struct request_queue *q = bdev_get_queue(bdev);
 
 	if (q)
 		ret = &q->backing_dev_info;
 	return ret;
 }
 EXPORT_SYMBOL(blk_get_backing_dev_info);
 
-void blk_rq_init(struct request_queue *q, struct request *rq)
+void blk_rq_init(struct blk_queue_ctx *ctx, struct request *rq)
 {
 	memset(rq, 0, sizeof(*rq));
 
 	INIT_LIST_HEAD(&rq->queuelist);
 	INIT_LIST_HEAD(&rq->timeout_list);
 	rq->cpu = -1;
-	rq->q = q;
+	rq->queue_ctx = ctx;
 	rq->__sector = (sector_t) -1;
 	INIT_HLIST_NODE(&rq->hash);
 	RB_CLEAR_NODE(&rq->rb_node);
 	rq->cmd = rq->__cmd;
 	rq->cmd_len = BLK_MAX_CDB;
 	rq->tag = -1;
 	rq->ref_count = 1;
 	rq->start_time = jiffies;
 	set_start_time_ns(rq);
@@ -294,18 +294,20 @@ EXPORT_SYMBOL(blk_sync_queue);
  * __blk_run_queue - run a single device queue
  * @q:	The queue to run
  *
  * Description:
  *    See @blk_run_queue. This variant must be called with the queue lock
  *    held and interrupts disabled.
  */
 void __blk_run_queue(struct request_queue *q)
 {
+	lockdep_assert_held(q->queue_lock);
+
 	if (unlikely(blk_queue_stopped(q)))
 		return;
 
 	q->request_fn(q);
 }
 EXPORT_SYMBOL(__blk_run_queue);
 
 /**
  * blk_run_queue_async - run a single device queue in workqueue context
@@ -372,30 +374,30 @@ void blk_drain_queue(struct request_queue *q, bool drain_all)
 		/*
 		 * This function might be called on a queue which failed
 		 * driver init after queue creation.  Some drivers
 		 * (e.g. fd) get unhappy in such cases.  Kick queue iff
 		 * dispatch queue has something on it.
 		 */
 		if (!list_empty(&q->queue_head))
 			__blk_run_queue(q);
 
-		drain |= q->rq.elvpriv;
+		drain |= queue_elvpriv(q);
 
 		/*
 		 * Unfortunately, requests are queued at and tracked from
 		 * multiple places and there's no single counter which can
 		 * be drained.  Check all the queues and counters.
 		 */
 		if (drain_all) {
 			drain |= !list_empty(&q->queue_head);
 			for (i = 0; i < 2; i++) {
-				drain |= q->rq.count[i];
-				drain |= q->in_flight[i];
+				drain |= queue_rq_queued(q);
+				drain |= queue_in_flight(q);
 				drain |= !list_empty(&q->flush_queue[i]);
 			}
 		}
 
 		spin_unlock_irq(q->queue_lock);
 
 		if (!drain)
 			break;
 		msleep(10);
@@ -439,56 +441,78 @@ void blk_cleanup_queue(struct request_queue *q)
 	/* @q won't process any more request, flush async actions */
 	del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer);
 	blk_sync_queue(q);
 
 	/* @q is and will stay empty, shutdown and put */
 	blk_put_queue(q);
 }
 EXPORT_SYMBOL(blk_cleanup_queue);
 
-static int blk_init_free_list(struct request_queue *q)
+static int blk_init_queue_ctx(struct request_queue *q, unsigned int nr_queues)
 {
-	struct request_list *rl = &q->rq;
+	struct blk_queue_ctx *ctx;
+	unsigned int i;
 
-	if (unlikely(rl->rq_pool))
-		return 0;
+	q->nr_queues = nr_queues;
+	queue_for_each_ctx(q, ctx, i) {
+		struct request_list *rl = &ctx->rl;
 
-	rl->count[BLK_RW_SYNC] = rl->count[BLK_RW_ASYNC] = 0;
-	rl->starved[BLK_RW_SYNC] = rl->starved[BLK_RW_ASYNC] = 0;
-	rl->elvpriv = 0;
-	init_waitqueue_head(&rl->wait[BLK_RW_SYNC]);
-	init_waitqueue_head(&rl->wait[BLK_RW_ASYNC]);
+		memset(ctx, 0, sizeof(*ctx));
+		spin_lock_init(&ctx->lock);
+		ctx->queue = q;
+		init_waitqueue_head(&rl->wait[BLK_RW_SYNC]);
+		init_waitqueue_head(&rl->wait[BLK_RW_ASYNC]);
+		INIT_LIST_HEAD(&ctx->timeout_list);
+	}
 
-	rl->rq_pool = mempool_create_node(BLKDEV_MIN_RQ, mempool_alloc_slab,
-				mempool_free_slab, request_cachep, q->node);
+	return 0;
+}
+
+static int blk_init_free_list(struct request_queue *q)
+{
+	if (unlikely(q->rq_pool))
+		return 0;
 
-	if (!rl->rq_pool)
+	q->rq_pool = mempool_create_node(BLKDEV_MIN_RQ, mempool_alloc_slab,
+				mempool_free_slab, request_cachep, q->node);
+	if (!q->rq_pool)
 		return -ENOMEM;
 
 	return 0;
 }
 
 struct request_queue *blk_alloc_queue(gfp_t gfp_mask)
 {
-	return blk_alloc_queue_node(gfp_mask, -1);
+	return blk_alloc_queue_node(gfp_mask, -1, 1);
 }
 EXPORT_SYMBOL(blk_alloc_queue);
 
-struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
+
+struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id,
+					   unsigned int nr_queues)
 {
 	struct request_queue *q;
 	int err;
 
 	q = kmem_cache_alloc_node(blk_requestq_cachep,
 				gfp_mask | __GFP_ZERO, node_id);
 	if (!q)
 		return NULL;
 
+	q->queue_ctx = kmalloc_node(nr_queues * sizeof(struct blk_queue_ctx),
+					GFP_KERNEL, node_id);
+	if (!q->queue_ctx) {
+		kmem_cache_free(blk_requestq_cachep, q);
+		return NULL;
+	}
+
+	blk_init_queue_ctx(q, nr_queues);
+
 	q->id = ida_simple_get(&blk_queue_ida, 0, 0, gfp_mask);
 	if (q->id < 0)
 		goto fail_q;
 
 	q->backing_dev_info.ra_pages =
 			(VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
 	q->backing_dev_info.state = 0;
 	q->backing_dev_info.capabilities = BDI_CAP_MAP_COPY;
 	q->backing_dev_info.name = "block";
@@ -498,19 +522,18 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	if (err)
 		goto fail_id;
 
 	if (blk_throtl_init(q))
 		goto fail_id;
 
 	setup_timer(&q->backing_dev_info.laptop_mode_wb_timer,
 		    laptop_mode_timer_fn, (unsigned long) q);
 	setup_timer(&q->timeout, blk_rq_timed_out_timer, (unsigned long) q);
-	INIT_LIST_HEAD(&q->timeout_list);
 	INIT_LIST_HEAD(&q->icq_list);
 	INIT_LIST_HEAD(&q->flush_queue[0]);
 	INIT_LIST_HEAD(&q->flush_queue[1]);
 	INIT_LIST_HEAD(&q->flush_data_in_flight);
 	INIT_DELAYED_WORK(&q->delay_work, blk_delay_work);
 
 	kobject_init(&q->kobj, &blk_queue_ktype);
 
 	mutex_init(&q->sysfs_lock);
@@ -521,18 +544,19 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	 * override it later if need be.
 	 */
 	q->queue_lock = &q->__queue_lock;
 
 	return q;
 
 fail_id:
 	ida_simple_remove(&blk_queue_ida, q->id);
 fail_q:
+	kfree(q->queue_ctx);
 	kmem_cache_free(blk_requestq_cachep, q);
 	return NULL;
 }
 EXPORT_SYMBOL(blk_alloc_queue_node);
 
 /**
  * blk_init_queue  - prepare a request queue for use with a block device
  * @rfn:  The function to be called to process requests that have been
  *        placed on the queue.
@@ -561,28 +585,36 @@ EXPORT_SYMBOL(blk_alloc_queue_node);
  *    it didn't succeed.
  *
  * Note:
  *    blk_init_queue() must be paired with a blk_cleanup_queue() call
  *    when the block device is deactivated (such as at module unload).
  **/
 
 struct request_queue *blk_init_queue(request_fn_proc *rfn, spinlock_t *lock)
 {
-	return blk_init_queue_node(rfn, lock, -1);
+	return blk_init_queue_node(rfn, lock, -1, 1);
 }
 EXPORT_SYMBOL(blk_init_queue);
 
+struct request_queue *blk_init_queue_mq(request_fn_proc *rfn, spinlock_t *lock,
+					unsigned int nr_queues)
+{
+	return blk_init_queue_node(rfn, lock, -1, nr_queues);
+}
+EXPORT_SYMBOL(blk_init_queue_mq);
+
 struct request_queue *
-blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
+blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id,
+		    unsigned int nr_queues)
 {
 	struct request_queue *uninit_q, *q;
 
-	uninit_q = blk_alloc_queue_node(GFP_KERNEL, node_id);
+	uninit_q = blk_alloc_queue_node(GFP_KERNEL, node_id, nr_queues);
 	if (!uninit_q)
 		return NULL;
 
 	q = blk_init_allocated_queue(uninit_q, rfn, lock);
 	if (!q)
 		blk_cleanup_queue(uninit_q);
 
 	return q;
 }
@@ -631,122 +663,94 @@ bool blk_get_queue(struct request_queue *q)
 	if (likely(!blk_queue_dead(q))) {
 		__blk_get_queue(q);
 		return true;
 	}
 
 	return false;
 }
 EXPORT_SYMBOL(blk_get_queue);
 
-static inline void blk_free_request(struct request_queue *q, struct request *rq)
+static inline void blk_free_request(struct blk_queue_ctx *ctx,
+				    struct request *rq)
 {
+	struct request_queue *q = ctx->queue;
+
 	if (rq->cmd_flags & REQ_ELVPRIV) {
-		elv_put_request(q, rq);
+		elv_put_request(ctx, rq);
 		if (rq->elv.icq)
 			put_io_context(rq->elv.icq->ioc);
 	}
 
-	mempool_free(rq, q->rq.rq_pool);
+	mempool_free(rq, q->rq_pool);
 }
 
 static struct request *
-blk_alloc_request(struct request_queue *q, struct io_cq *icq,
+blk_alloc_request(struct blk_queue_ctx *ctx, struct io_cq *icq,
 		  unsigned int flags, gfp_t gfp_mask)
 {
-	struct request *rq = mempool_alloc(q->rq.rq_pool, gfp_mask);
+	struct request_queue *q = ctx->queue;
+	struct request *rq;
 
+	rq = mempool_alloc(q->rq_pool, gfp_mask);
 	if (!rq)
 		return NULL;
 
-	blk_rq_init(q, rq);
+	blk_rq_init(ctx, rq);
 
 	rq->cmd_flags = flags | REQ_ALLOCED;
 
 	if (flags & REQ_ELVPRIV) {
 		rq->elv.icq = icq;
-		if (unlikely(elv_set_request(q, rq, gfp_mask))) {
-			mempool_free(rq, q->rq.rq_pool);
+		if (unlikely(elv_set_request(ctx, rq, gfp_mask))) {
+			mempool_free(rq, q->rq_pool);
 			return NULL;
 		}
 		/* @rq->elv.icq holds on to io_context until @rq is freed */
 		if (icq)
 			get_io_context(icq->ioc);
 	}
 
 	return rq;
 }
 
-/*
- * ioc_batching returns true if the ioc is a valid batching request and
- * should be given priority access to a request.
- */
-static inline int ioc_batching(struct request_queue *q, struct io_context *ioc)
+static void __freed_request(struct blk_queue_ctx *ctx, int sync)
 {
-	if (!ioc)
-		return 0;
-
-	/*
-	 * Make sure the process is able to allocate at least 1 request
-	 * even if the batch times out, otherwise we could theoretically
-	 * lose wakeups.
-	 */
-	return ioc->nr_batch_requests == q->nr_batching ||
-		(ioc->nr_batch_requests > 0
-		&& time_before(jiffies, ioc->last_waited + BLK_BATCH_TIME));
-}
-
-/*
- * ioc_set_batching sets ioc to be a new "batcher" if it is not one. This
- * will cause the process to be a "batcher" on all queues in the system. This
- * is the behaviour we want though - once it gets a wakeup it should be given
- * a nice run.
- */
-static void ioc_set_batching(struct request_queue *q, struct io_context *ioc)
-{
-	if (!ioc || ioc_batching(q, ioc))
-		return;
-
-	ioc->nr_batch_requests = q->nr_batching;
-	ioc->last_waited = jiffies;
-}
-
-static void __freed_request(struct request_queue *q, int sync)
-{
-	struct request_list *rl = &q->rq;
+	struct request_queue *q = ctx->queue;
+	struct request_list *rl = &ctx->rl;
 
 	if (rl->count[sync] < queue_congestion_off_threshold(q))
 		blk_clear_queue_congested(q, sync);
 
 	if (rl->count[sync] + 1 <= q->nr_requests) {
 		if (waitqueue_active(&rl->wait[sync]))
 			wake_up(&rl->wait[sync]);
 
 		blk_clear_queue_full(q, sync);
 	}
 }
 
 /*
  * A request has just been released.  Account for it, update the full and
- * congestion status, wake up any waiters.   Called under q->queue_lock.
+ * congestion status, wake up any waiters.   Called under ctx->lock.
  */
-static void freed_request(struct request_queue *q, unsigned int flags)
+static void freed_request(struct blk_queue_ctx *ctx, unsigned int flags)
 {
-	struct request_list *rl = &q->rq;
+	struct request_list *rl = &ctx->rl;
 	int sync = rw_is_sync(flags);
 
 	rl->count[sync]--;
 	if (flags & REQ_ELVPRIV)
 		rl->elvpriv--;
 
-	__freed_request(q, sync);
+	__freed_request(ctx, sync);
 
 	if (unlikely(rl->starved[sync ^ 1]))
-		__freed_request(q, sync ^ 1);
+		__freed_request(ctx, sync ^ 1);
 }
 
 /*
  * Determine if elevator data should be initialized when allocating the
  * request associated with @bio.
  */
 static bool blk_rq_should_init_elevator(struct bio *bio)
 {
 	if (!bio)
@@ -766,82 +770,49 @@ static bool blk_rq_should_init_elevator(struct bio *bio)
  * get_request - get a free request
  * @q: request_queue to allocate request from
  * @rw_flags: RW and SYNC flags
  * @bio: bio to allocate request for (can be %NULL)
  * @gfp_mask: allocation mask
  *
  * Get a free request from @q.  This function may fail under memory
  * pressure or if @q is dead.
  *
- * Must be callled with @q->queue_lock held and,
- * Returns %NULL on failure, with @q->queue_lock held.
- * Returns !%NULL on success, with @q->queue_lock *not held*.
+ * Must be callled with @ctx->lock held.
  */
-static struct request *get_request(struct request_queue *q, int rw_flags,
+static struct request *get_request(struct blk_queue_ctx *ctx, int rw_flags,
 				   struct bio *bio, gfp_t gfp_mask)
 {
+	struct request_queue *q = ctx->queue;
+	struct request_list *rl = &ctx->rl;
 	struct request *rq = NULL;
-	struct request_list *rl = &q->rq;
 	struct elevator_type *et;
-	struct io_context *ioc;
 	struct io_cq *icq = NULL;
 	const bool is_sync = rw_is_sync(rw_flags) != 0;
-	bool retried = false;
+	const bool drop_lock = (gfp_mask & __GFP_WAIT) != 0;
+	struct io_context *ioc;
 	int may_queue;
-retry:
+
 	et = q->elevator->type;
 	ioc = current->io_context;
 
 	if (unlikely(blk_queue_dead(q)))
 		return NULL;
 
 	may_queue = elv_may_queue(q, rw_flags);
 	if (may_queue == ELV_MQUEUE_NO)
 		goto rq_starved;
 
 	if (rl->count[is_sync]+1 >= queue_congestion_on_threshold(q)) {
-		if (rl->count[is_sync]+1 >= q->nr_requests) {
-			/*
-			 * We want ioc to record batching state.  If it's
-			 * not already there, creating a new one requires
-			 * dropping queue_lock, which in turn requires
-			 * retesting conditions to avoid queue hang.
-			 */
-			if (!ioc && !retried) {
-				spin_unlock_irq(q->queue_lock);
-				create_io_context(current, gfp_mask, q->node);
-				spin_lock_irq(q->queue_lock);
-				retried = true;
-				goto retry;
-			}
-
-			/*
-			 * The queue will fill after this allocation, so set
-			 * it as full, and mark this process as "batching".
-			 * This process will be allowed to complete a batch of
-			 * requests, others will be blocked.
-			 */
-			if (!blk_queue_full(q, is_sync)) {
-				ioc_set_batching(q, ioc);
-				blk_set_queue_full(q, is_sync);
-			} else {
-				if (may_queue != ELV_MQUEUE_MUST
-						&& !ioc_batching(q, ioc)) {
-					/*
-					 * The queue is full and the allocating
-					 * process is not a "batcher", and not
-					 * exempted by the IO scheduler
-					 */
-					goto out;
-				}
-			}
-		}
 		blk_set_queue_congested(q, is_sync);
+
+		if (rl->count[is_sync]+1 >= q->nr_requests)
+			if (may_queue != ELV_MQUEUE_MUST)
+				goto out;
 	}
 
 	/*
 	 * Only allow batching queuers to allocate up to 50% over the defined
 	 * limit of requests, otherwise we could have thousands of requests
 	 * allocated with any setting of ->nr_requests
 	 */
 	if (rl->count[is_sync] >= (3 * q->nr_requests / 2))
 		goto out;
@@ -863,137 +834,132 @@ retry:
 	    !test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags)) {
 		rw_flags |= REQ_ELVPRIV;
 		rl->elvpriv++;
 		if (et->icq_cache && ioc)
 			icq = ioc_lookup_icq(ioc, q);
 	}
 
 	if (blk_queue_io_stat(q))
 		rw_flags |= REQ_IO_STAT;
-	spin_unlock_irq(q->queue_lock);
+
+	if (drop_lock)
+		spin_unlock_irq(&ctx->lock);
 
 	/* create icq if missing */
 	if ((rw_flags & REQ_ELVPRIV) && unlikely(et->icq_cache && !icq)) {
 		icq = ioc_create_icq(q, gfp_mask);
 		if (!icq)
 			goto fail_icq;
 	}
 
-	rq = blk_alloc_request(q, icq, rw_flags, gfp_mask);
-
+	rq = blk_alloc_request(ctx, icq, rw_flags, gfp_mask);
 fail_icq:
 	if (unlikely(!rq)) {
 		/*
 		 * Allocation failed presumably due to memory. Undo anything
 		 * we might have messed up.
 		 *
 		 * Allocating task should really be put onto the front of the
 		 * wait queue, but this is pretty rare.
 		 */
-		spin_lock_irq(q->queue_lock);
-		freed_request(q, rw_flags);
+		if (drop_lock)
+			spin_lock_irq(&ctx->lock);
+
+		freed_request(ctx, rw_flags);
 
 		/*
 		 * in the very unlikely event that allocation failed and no
 		 * requests for this direction was pending, mark us starved
 		 * so that freeing of a request in the other direction will
 		 * notice us. another possible fix would be to split the
 		 * rq mempool into READ and WRITE
 		 */
 rq_starved:
 		if (unlikely(rl->count[is_sync] == 0))
 			rl->starved[is_sync] = 1;
 
 		goto out;
 	}
 
-	/*
-	 * ioc may be NULL here, and ioc_batching will be false. That's
-	 * OK, if the queue is under the request limit then requests need
-	 * not count toward the nr_batch_requests limit. There will always
-	 * be some limit enforced by BLK_BATCH_TIME.
-	 */
-	if (ioc_batching(q, ioc))
-		ioc->nr_batch_requests--;
-
 	trace_block_getrq(q, bio, rw_flags & 1);
+
+	if (drop_lock)
+		spin_lock_irq(&ctx->lock);
 out:
 	return rq;
 }
 
 /**
  * get_request_wait - get a free request with retry
  * @q: request_queue to allocate request from
  * @rw_flags: RW and SYNC flags
  * @bio: bio to allocate request for (can be %NULL)
  *
  * Get a free request from @q.  This function keeps retrying under memory
  * pressure and fails iff @q is dead.
  *
- * Must be callled with @q->queue_lock held and,
- * Returns %NULL on failure, with @q->queue_lock held.
- * Returns !%NULL on success, with @q->queue_lock *not held*.
+ * Must be callled with @ctx->lock held.
  */
-static struct request *get_request_wait(struct request_queue *q, int rw_flags,
+static struct request *get_request_wait(struct blk_queue_ctx *ctx, int rw_flags,
 					struct bio *bio)
 {
+	struct request_queue *q = ctx->queue;
 	const bool is_sync = rw_is_sync(rw_flags) != 0;
 	struct request *rq;
 
-	rq = get_request(q, rw_flags, bio, GFP_NOIO);
+	rq = get_request(ctx, rw_flags, bio, GFP_NOIO);
 	while (!rq) {
 		DEFINE_WAIT(wait);
-		struct request_list *rl = &q->rq;
+		struct request_list *rl = &ctx->rl;
 
 		if (unlikely(blk_queue_dead(q)))
 			return NULL;
 
 		prepare_to_wait_exclusive(&rl->wait[is_sync], &wait,
 				TASK_UNINTERRUPTIBLE);
 
 		trace_block_sleeprq(q, bio, rw_flags & 1);
 
-		spin_unlock_irq(q->queue_lock);
+		spin_unlock_irq(&ctx->lock);
 		io_schedule();
 
 		/*
 		 * After sleeping, we become a "batching" process and
 		 * will be able to allocate at least one request, and
 		 * up to a big batch of them for a small period time.
 		 * See ioc_batching, ioc_set_batching
 		 */
 		create_io_context(current, GFP_NOIO, q->node);
-		ioc_set_batching(q, current->io_context);
 
-		spin_lock_irq(q->queue_lock);
+		spin_lock_irq(&ctx->lock);
 		finish_wait(&rl->wait[is_sync], &wait);
 
-		rq = get_request(q, rw_flags, bio, GFP_NOIO);
+		rq = get_request(ctx, rw_flags, bio, GFP_NOIO);
 	};
 
 	return rq;
 }
 
 struct request *blk_get_request(struct request_queue *q, int rw, gfp_t gfp_mask)
 {
+	struct blk_queue_ctx *ctx = blk_get_ctx(q, 0);
 	struct request *rq;
 
 	BUG_ON(rw != READ && rw != WRITE);
 
-	spin_lock_irq(q->queue_lock);
+	spin_lock_irq(&ctx->lock);
+
 	if (gfp_mask & __GFP_WAIT)
-		rq = get_request_wait(q, rw, NULL);
+		rq = get_request_wait(ctx, rw, NULL);
 	else
-		rq = get_request(q, rw, NULL, gfp_mask);
-	if (!rq)
-		spin_unlock_irq(q->queue_lock);
-	/* q->queue_lock is unlocked at this point */
+		rq = get_request(ctx, rw, NULL, gfp_mask);
 
+	spin_unlock_irq(&ctx->lock);
 	return rq;
 }
 EXPORT_SYMBOL(blk_get_request);
 
 /**
  * blk_make_request - given a bio, allocate a corresponding struct request.
  * @q: target request queue
  * @bio:  The bio describing the memory mappings that will be submitted for IO.
  *        It may be a chained-bio properly constructed by block/bio layer.
@@ -1066,23 +1032,28 @@ void blk_requeue_request(struct request_queue *q, struct request *rq)
 	if (blk_rq_tagged(rq))
 		blk_queue_end_tag(q, rq);
 
 	BUG_ON(blk_queued_rq(rq));
 
 	elv_requeue_request(q, rq);
 }
 EXPORT_SYMBOL(blk_requeue_request);
 
-static void add_acct_request(struct request_queue *q, struct request *rq,
-			     int where)
+static void add_acct_request(struct request *rq, int where)
 {
+	struct blk_queue_ctx *ctx = rq->queue_ctx;
+
+	BUG_ON(!irqs_disabled());
+
 	drive_stat_acct(rq, 1);
-	__elv_add_request(q, rq, where);
+	spin_lock(&ctx->lock);
+	__elv_add_request(rq, where);
+	spin_unlock(&ctx->lock);
 }
 
 static void part_round_stats_single(int cpu, struct hd_struct *part,
 				    unsigned long now)
 {
 	if (now == part->stamp)
 		return;
 
 	if (part_in_flight(part)) {
@@ -1116,54 +1087,56 @@ void part_round_stats(int cpu, struct hd_struct *part)
 	if (part->partno)
 		part_round_stats_single(cpu, &part_to_disk(part)->part0, now);
 	part_round_stats_single(cpu, part, now);
 }
 EXPORT_SYMBOL_GPL(part_round_stats);
 
 /*
  * queue lock must be held
  */
-void __blk_put_request(struct request_queue *q, struct request *req)
+void __blk_put_request(struct request *req)
 {
-	if (unlikely(!q))
+	struct blk_queue_ctx *ctx = req->queue_ctx;
+
+	if (unlikely(!ctx))
 		return;
 	if (unlikely(--req->ref_count))
 		return;
 
-	elv_completed_request(q, req);
+	elv_completed_request(req);
 
 	/* this is a bio leak */
 	WARN_ON(req->bio != NULL);
 
 	/*
 	 * Request may not have originated from ll_rw_blk. if not,
 	 * it didn't come out of our reserved rq pools
 	 */
 	if (req->cmd_flags & REQ_ALLOCED) {
 		unsigned int flags = req->cmd_flags;
 
 		BUG_ON(!list_empty(&req->queuelist));
 		BUG_ON(!hlist_unhashed(&req->hash));
 
-		blk_free_request(q, req);
-		freed_request(q, flags);
+		blk_free_request(ctx, req);
+		freed_request(ctx, flags);
 	}
 }
 EXPORT_SYMBOL_GPL(__blk_put_request);
 
 void blk_put_request(struct request *req)
 {
+	struct blk_queue_ctx *ctx = req->queue_ctx;
 	unsigned long flags;
-	struct request_queue *q = req->q;
 
-	spin_lock_irqsave(q->queue_lock, flags);
-	__blk_put_request(q, req);
-	spin_unlock_irqrestore(q->queue_lock, flags);
+	spin_lock_irqsave(&ctx->lock, flags);
+	__blk_put_request(req);
+	spin_unlock_irqrestore(&ctx->lock, flags);
 }
 EXPORT_SYMBOL(blk_put_request);
 
 /**
  * blk_add_request_payload - add a payload to a request
  * @rq: request to update
  * @page: page backing the payload
  * @len: length of the payload.
  *
@@ -1187,49 +1160,49 @@ void blk_add_request_payload(struct request *rq, struct page *page,
 	bio->bi_vcnt = 1;
 	bio->bi_phys_segments = 1;
 
 	rq->__data_len = rq->resid_len = len;
 	rq->nr_phys_segments = 1;
 	rq->buffer = bio_data(bio);
 }
 EXPORT_SYMBOL_GPL(blk_add_request_payload);
 
-static bool bio_attempt_back_merge(struct request_queue *q, struct request *req,
+static bool bio_attempt_back_merge(struct blk_queue_ctx *ctx, struct request *req,
 				   struct bio *bio)
 {
 	const int ff = bio->bi_rw & REQ_FAILFAST_MASK;
 
-	if (!ll_back_merge_fn(q, req, bio))
+	if (!ll_back_merge_fn(ctx, req, bio))
 		return false;
 
-	trace_block_bio_backmerge(q, bio);
+	trace_block_bio_backmerge(ctx->queue, bio);
 
 	if ((req->cmd_flags & REQ_FAILFAST_MASK) != ff)
 		blk_rq_set_mixed_merge(req);
 
 	req->biotail->bi_next = bio;
 	req->biotail = bio;
 	req->__data_len += bio->bi_size;
 	req->ioprio = ioprio_best(req->ioprio, bio_prio(bio));
 
 	drive_stat_acct(req, 0);
 	return true;
 }
 
-static bool bio_attempt_front_merge(struct request_queue *q,
+static bool bio_attempt_front_merge(struct blk_queue_ctx *ctx,
 				    struct request *req, struct bio *bio)
 {
 	const int ff = bio->bi_rw & REQ_FAILFAST_MASK;
 
-	if (!ll_front_merge_fn(q, req, bio))
+	if (!ll_front_merge_fn(ctx, req, bio))
 		return false;
 
-	trace_block_bio_frontmerge(q, bio);
+	trace_block_bio_frontmerge(ctx->queue, bio);
 
 	if ((req->cmd_flags & REQ_FAILFAST_MASK) != ff)
 		blk_rq_set_mixed_merge(req);
 
 	bio->bi_next = req->bio;
 	req->bio = bio;
 
 	/*
 	 * may not be valid. if the low level driver said
@@ -1274,28 +1247,28 @@ static bool attempt_plug_merge(struct request_queue *q, struct bio *bio,
 		goto out;
 	*request_count = 0;
 
 	list_for_each_entry_reverse(rq, &plug->list, queuelist) {
 		int el_ret;
 
 		if (rq->q == q)
 			(*request_count)++;
 
-		if (rq->q != q || !blk_rq_merge_ok(rq, bio))
+		if (rq->queue_ctx->queue != q || !blk_rq_merge_ok(rq, bio))
 			continue;
 
 		el_ret = blk_try_merge(rq, bio);
 		if (el_ret == ELEVATOR_BACK_MERGE) {
-			ret = bio_attempt_back_merge(q, rq, bio);
+			ret = bio_attempt_back_merge(rq->queue_ctx, rq, bio);
 			if (ret)
 				break;
 		} else if (el_ret == ELEVATOR_FRONT_MERGE) {
-			ret = bio_attempt_front_merge(q, rq, bio);
+			ret = bio_attempt_front_merge(rq->queue_ctx, rq, bio);
 			if (ret)
 				break;
 		}
 	}
 out:
 	return ret;
 }
 
 void init_request_from_bio(struct request *req, struct bio *bio)
@@ -1303,88 +1276,93 @@ void init_request_from_bio(struct request *req, struct bio *bio)
 	req->cmd_type = REQ_TYPE_FS;
 
 	req->cmd_flags |= bio->bi_rw & REQ_COMMON_MASK;
 	if (bio->bi_rw & REQ_RAHEAD)
 		req->cmd_flags |= REQ_FAILFAST_MASK;
 
 	req->errors = 0;
 	req->__sector = bio->bi_sector;
 	req->ioprio = bio_prio(bio);
-	blk_rq_bio_prep(req->q, req, bio);
+	blk_rq_bio_prep(req->queue_ctx->queue, req, bio);
 }
 
 void blk_queue_bio(struct request_queue *q, struct bio *bio)
 {
 	const bool sync = !!(bio->bi_rw & REQ_SYNC);
+	struct blk_queue_ctx *ctx = blk_get_ctx(q, 0);
 	struct blk_plug *plug;
 	int el_ret, rw_flags, where = ELEVATOR_INSERT_SORT;
 	struct request *req;
 	unsigned int request_count = 0;
 
 	/*
 	 * low level driver can indicate that it wants pages above a
 	 * certain limit bounced to low memory (ie for highmem, or even
 	 * ISA dma in theory)
 	 */
 	blk_queue_bounce(q, &bio);
 
 	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA)) {
-		spin_lock_irq(q->queue_lock);
+		spin_lock_irq(&ctx->lock);
 		where = ELEVATOR_INSERT_FLUSH;
 		goto get_rq;
 	}
 
 	/*
 	 * Check if we can merge with the plugged list before grabbing
 	 * any locks.
 	 */
 	if (attempt_plug_merge(q, bio, &request_count))
 		return;
 
-	spin_lock_irq(q->queue_lock);
+	spin_lock_irq(&ctx->lock);
 
-	el_ret = elv_merge(q, &req, bio);
+	el_ret = elv_merge(ctx, &req, bio);
 	if (el_ret == ELEVATOR_BACK_MERGE) {
-		if (bio_attempt_back_merge(q, req, bio)) {
-			elv_bio_merged(q, req, bio);
-			if (!attempt_back_merge(q, req))
-				elv_merged_request(q, req, el_ret);
-			goto out_unlock;
+		if (bio_attempt_back_merge(ctx, req, bio)) {
+			elv_bio_merged(ctx, req, bio);
+			if (!attempt_back_merge(ctx, req))
+				elv_merged_request(ctx, req, el_ret);
+out_unlock:
+			spin_unlock_irq(&ctx->lock);
+			return;
 		}
 	} else if (el_ret == ELEVATOR_FRONT_MERGE) {
-		if (bio_attempt_front_merge(q, req, bio)) {
-			elv_bio_merged(q, req, bio);
-			if (!attempt_front_merge(q, req))
-				elv_merged_request(q, req, el_ret);
+		if (bio_attempt_front_merge(ctx, req, bio)) {
+			elv_bio_merged(ctx, req, bio);
+			if (!attempt_front_merge(ctx, req))
+				elv_merged_request(ctx, req, el_ret);
 			goto out_unlock;
 		}
 	}
 
 get_rq:
 	/*
 	 * This sync check and mask will be re-done in init_request_from_bio(),
 	 * but we need to set it earlier to expose the sync flag to the
 	 * rq allocator and io schedulers.
 	 */
 	rw_flags = bio_data_dir(bio);
 	if (sync)
 		rw_flags |= REQ_SYNC;
 
 	/*
-	 * Grab a free request. This is might sleep but can not fail.
-	 * Returns with the queue unlocked.
+	 * Grab a free request. Fails if the queue is dead,
+	 * otherwise succeeds. May drop lock, but reacquires it.
 	 */
-	req = get_request_wait(q, rw_flags, bio);
+	req = get_request_wait(ctx, rw_flags, bio);
 	if (unlikely(!req)) {
 		bio_endio(bio, -ENODEV);	/* @q is dead */
 		goto out_unlock;
 	}
 
+	spin_unlock_irq(&ctx->lock);
+
 	/*
 	 * After dropping the lock and possibly sleeping here, our request
 	 * may now be mergeable after it had proven unmergeable (above).
 	 * We don't worry about that case for efficiency. It won't happen
 	 * often, and the elevators are able to handle it.
 	 */
 	init_request_from_bio(req, bio);
 
 	if (test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags))
@@ -1399,33 +1377,32 @@ get_rq:
 		 * note to sort the list before dispatch.
 		 */
 		if (list_empty(&plug->list))
 			trace_block_plug(q);
 		else {
 			if (!plug->should_sort) {
 				struct request *__rq;
 
 				__rq = list_entry_rq(plug->list.prev);
-				if (__rq->q != q)
+				if (__rq->queue_ctx->queue != q)
 					plug->should_sort = 1;
 			}
 			if (request_count >= BLK_MAX_REQUEST_COUNT) {
 				blk_flush_plug_list(plug, false);
 				trace_block_plug(q);
 			}
 		}
 		list_add_tail(&req->queuelist, &plug->list);
 		drive_stat_acct(req, 1);
 	} else {
 		spin_lock_irq(q->queue_lock);
-		add_acct_request(q, req, where);
+		add_acct_request(req, where);
 		__blk_run_queue(q);
-out_unlock:
 		spin_unlock_irq(q->queue_lock);
 	}
 }
 EXPORT_SYMBOL_GPL(blk_queue_bio);	/* for device mapper only */
 
 /*
  * If bio->bi_dev is a partition, remap the location
  */
 static inline void blk_partition_remap(struct bio *bio)
@@ -1796,19 +1773,19 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
 	/*
 	 * Submitting request must be dequeued before calling this function
 	 * because it will be linked to another request_queue
 	 */
 	BUG_ON(blk_queued_rq(rq));
 
 	if (rq->cmd_flags & (REQ_FLUSH|REQ_FUA))
 		where = ELEVATOR_INSERT_FLUSH;
 
-	add_acct_request(q, rq, where);
+	add_acct_request(rq, where);
 	if (where == ELEVATOR_INSERT_FLUSH)
 		__blk_run_queue(q);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(blk_insert_cloned_request);
 
 /**
@@ -1918,19 +1895,19 @@ struct request *blk_peek_request(struct request_queue *q)
 
 	while ((rq = __elv_next_request(q)) != NULL) {
 		if (!(rq->cmd_flags & REQ_STARTED)) {
 			/*
 			 * This is the first time the device driver
 			 * sees this request (possibly after
 			 * requeueing).  Notify IO scheduler.
 			 */
 			if (rq->cmd_flags & REQ_SORTED)
-				elv_activate_rq(q, rq);
+				elv_activate_rq(rq);
 
 			/*
 			 * just mark as started even if we don't start
 			 * it, a request that has been delayed should
 			 * not be passed by new incoming requests
 			 */
 			rq->cmd_flags |= REQ_STARTED;
 			trace_block_rq_issue(q, rq);
 		}
@@ -1991,32 +1968,32 @@ struct request *blk_peek_request(struct request_queue *q)
 		}
 	}
 
 	return rq;
 }
 EXPORT_SYMBOL(blk_peek_request);
 
 void blk_dequeue_request(struct request *rq)
 {
-	struct request_queue *q = rq->q;
+	struct blk_queue_ctx *ctx = rq->queue_ctx;
 
 	BUG_ON(list_empty(&rq->queuelist));
 	BUG_ON(ELV_ON_HASH(rq));
 
 	list_del_init(&rq->queuelist);
 
 	/*
 	 * the time frame between a request being removed from the lists
 	 * and to it is freed is accounted as io that is in progress at
 	 * the driver side.
 	 */
 	if (blk_account_rq(rq)) {
-		q->in_flight[rq_is_sync(rq)]++;
+		ctx->in_flight[rq_is_sync(rq)]++;
 		set_io_start_time_ns(rq);
 	}
 }
 
 /**
  * blk_start_request - start request processing on the driver
  * @req: request to dequeue
  *
  * Description:
@@ -2095,19 +2072,19 @@ EXPORT_SYMBOL(blk_fetch_request);
  **/
 bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 {
 	int total_bytes, bio_nbytes, next_idx = 0;
 	struct bio *bio;
 
 	if (!req->bio)
 		return false;
 
-	trace_block_rq_complete(req->q, req);
+	trace_block_rq_complete(req->queue_ctx->queue, req);
 
 	/*
 	 * For fs requests, rq is just carrier of independent bio's
 	 * and each partial completion should be handled separately.
 	 * Reset per-request error on each partial completion.
 	 *
 	 * TODO: tj: This is too subtle.  It would be better to let
 	 * low level drivers do what they see fit.
 	 */
@@ -2250,72 +2227,75 @@ static bool blk_update_bidi_request(struct request *rq, int error,
 {
 	if (blk_update_request(rq, error, nr_bytes))
 		return true;
 
 	/* Bidi request must be completed as a whole */
 	if (unlikely(blk_bidi_rq(rq)) &&
 	    blk_update_request(rq->next_rq, error, bidi_bytes))
 		return true;
 
-	if (blk_queue_add_random(rq->q))
+	if (blk_queue_add_random(rq->queue_ctx->queue))
 		add_disk_randomness(rq->rq_disk);
 
 	return false;
 }
 
 /**
  * blk_unprep_request - unprepare a request
  * @req:	the request
  *
  * This function makes a request ready for complete resubmission (or
  * completion).  It happens only after all error handling is complete,
  * so represents the appropriate moment to deallocate any resources
  * that were allocated to the request in the prep_rq_fn.  The queue
  * lock is held when calling this.
  */
 void blk_unprep_request(struct request *req)
 {
-	struct request_queue *q = req->q;
+	struct request_queue *q = req->queue_ctx->queue;
 
 	req->cmd_flags &= ~REQ_DONTPREP;
 	if (q->unprep_rq_fn)
 		q->unprep_rq_fn(q, req);
 }
 EXPORT_SYMBOL_GPL(blk_unprep_request);
 
 /*
  * queue lock must be held
  */
 static void blk_finish_request(struct request *req, int error)
 {
+	struct blk_queue_ctx *ctx = req->queue_ctx;
+	struct request_queue *q = ctx->queue;
+
 	if (blk_rq_tagged(req))
-		blk_queue_end_tag(req->q, req);
+		blk_queue_end_tag(q, req);
 
 	BUG_ON(blk_queued_rq(req));
 
 	if (unlikely(laptop_mode) && req->cmd_type == REQ_TYPE_FS)
-		laptop_io_completion(&req->q->backing_dev_info);
+		laptop_io_completion(&q->backing_dev_info);
 
 	blk_delete_timer(req);
 
 	if (req->cmd_flags & REQ_DONTPREP)
 		blk_unprep_request(req);
 
 
 	blk_account_io_done(req);
 
 	if (req->end_io)
 		req->end_io(req, error);
 	else {
 		if (blk_bidi_rq(req))
-			__blk_put_request(req->next_rq->q, req->next_rq);
+			__blk_put_request(req->next_rq);
 
-		__blk_put_request(req->q, req);
+		__blk_put_request(req);
 	}
 }
 
 /**
  * blk_end_bidi_request - Complete a bidi request
  * @rq:         the request to complete
  * @error:      %0 for success, < %0 for error
  * @nr_bytes:   number of bytes to complete @rq
  * @bidi_bytes: number of bytes to complete @rq->next_rq
@@ -2327,27 +2307,27 @@ static void blk_finish_request(struct request *req, int error)
  *     just ignored.
  *
  * Return:
  *     %false - we are done with this request
  *     %true  - still buffers pending for this request
  **/
 static bool blk_end_bidi_request(struct request *rq, int error,
 				 unsigned int nr_bytes, unsigned int bidi_bytes)
 {
-	struct request_queue *q = rq->q;
+	struct blk_queue_ctx *ctx = rq->queue_ctx;
 	unsigned long flags;
 
 	if (blk_update_bidi_request(rq, error, nr_bytes, bidi_bytes))
 		return true;
 
-	spin_lock_irqsave(q->queue_lock, flags);
+	spin_lock_irqsave(&ctx->lock, flags);
 	blk_finish_request(rq, error);
-	spin_unlock_irqrestore(q->queue_lock, flags);
+	spin_unlock_irqrestore(&ctx->lock, flags);
 
 	return false;
 }
 
 /**
  * __blk_end_bidi_request - Complete a bidi request with queue lock held
  * @rq:         the request to complete
  * @error:      %0 for success, < %0 for error
  * @nr_bytes:   number of bytes to complete @rq
@@ -2744,54 +2724,50 @@ void blk_start_plug(struct blk_plug *plug)
 	}
 }
 EXPORT_SYMBOL(blk_start_plug);
 
 static int plug_rq_cmp(void *priv, struct list_head *a, struct list_head *b)
 {
 	struct request *rqa = container_of(a, struct request, queuelist);
 	struct request *rqb = container_of(b, struct request, queuelist);
 
-	return !(rqa->q <= rqb->q);
+	return !(rqa->queue_ctx <= rqb->queue_ctx);
 }
 
 /*
  * If 'from_schedule' is true, then postpone the dispatch of requests
  * until a safe kblockd context. We due this to avoid accidental big
  * additional stack usage in driver dispatch, in places where the originally
  * plugger did not intend it.
  */
 static void queue_unplugged(struct request_queue *q, unsigned int depth,
 			    bool from_schedule)
-	__releases(q->queue_lock)
 {
 	trace_block_unplug(q, depth, !from_schedule);
 
 	/*
 	 * Don't mess with dead queue.
 	 */
-	if (unlikely(blk_queue_dead(q))) {
-		spin_unlock(q->queue_lock);
+	if (unlikely(blk_queue_dead(q)))
 		return;
-	}
 
 	/*
 	 * If we are punting this to kblockd, then we can safely drop
 	 * the queue_lock before waking kblockd (which needs to take
 	 * this lock).
 	 */
-	if (from_schedule) {
-		spin_unlock(q->queue_lock);
+	if (from_schedule)
 		blk_run_queue_async(q);
-	} else {
+	else {
+		spin_lock(q->queue_lock);
 		__blk_run_queue(q);
 		spin_unlock(q->queue_lock);
 	}
-
 }
 
 static void flush_plug_callbacks(struct blk_plug *plug)
 {
 	LIST_HEAD(callbacks);
 
 	if (list_empty(&plug->cb_list))
 		return;
 
@@ -2802,84 +2778,85 @@ static void flush_plug_callbacks(struct blk_plug *plug)
 							  struct blk_plug_cb,
 							  list);
 		list_del(&cb->list);
 		cb->callback(cb);
 	}
 }
 
 void blk_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 {
-	struct request_queue *q;
+	struct blk_queue_ctx *ctx;
 	unsigned long flags;
 	struct request *rq;
 	LIST_HEAD(list);
 	unsigned int depth;
 
 	BUG_ON(plug->magic != PLUG_MAGIC);
 
 	flush_plug_callbacks(plug);
 	if (list_empty(&plug->list))
 		return;
 
 	list_splice_init(&plug->list, &list);
 
 	if (plug->should_sort) {
 		list_sort(NULL, &list, plug_rq_cmp);
 		plug->should_sort = 0;
 	}
 
-	q = NULL;
+	ctx = NULL;
 	depth = 0;
 
 	/*
 	 * Save and disable interrupts here, to avoid doing it for every
 	 * queue lock we have to take.
 	 */
 	local_irq_save(flags);
 	while (!list_empty(&list)) {
 		rq = list_entry_rq(list.next);
 		list_del_init(&rq->queuelist);
-		BUG_ON(!rq->q);
-		if (rq->q != q) {
-			/*
-			 * This drops the queue lock
-			 */
-			if (q)
-				queue_unplugged(q, depth, from_schedule);
-			q = rq->q;
+		BUG_ON(!rq->queue_ctx);
+		if (rq->queue_ctx != ctx) {
+			if (ctx) {
+				spin_unlock(&ctx->lock);
+				queue_unplugged(ctx->queue, depth, from_schedule);
+			}
+			ctx = rq->queue_ctx;
 			depth = 0;
-			spin_lock(q->queue_lock);
+			spin_lock(&ctx->lock);
 		}
 
 		/*
 		 * Short-circuit if @q is dead
 		 */
-		if (unlikely(blk_queue_dead(q))) {
+		if (unlikely(blk_queue_dead(ctx->queue))) {
 			__blk_end_request_all(rq, -ENODEV);
 			continue;
 		}
 
 		/*
 		 * rq is already accounted, so use raw insert
 		 */
 		if (rq->cmd_flags & (REQ_FLUSH | REQ_FUA))
-			__elv_add_request(q, rq, ELEVATOR_INSERT_FLUSH);
+			__elv_add_request(rq, ELEVATOR_INSERT_FLUSH);
 		else
-			__elv_add_request(q, rq, ELEVATOR_INSERT_SORT_MERGE);
+			__elv_add_request(rq, ELEVATOR_INSERT_SORT_MERGE);
 
 		depth++;
 	}
 
 	/*
 	 * This drops the queue lock
 	 */
-	if (q)
-		queue_unplugged(q, depth, from_schedule);
+	if (ctx) {
+		spin_unlock(&ctx->lock);
+		queue_unplugged(ctx->queue, depth, from_schedule);
+	}
 
 	local_irq_restore(flags);
 }
 
 void blk_finish_plug(struct blk_plug *plug)
 {
 	blk_flush_plug_list(plug, false);
 
 	if (plug == current->plug)
diff --git a/block/blk-exec.c b/block/blk-exec.c
index fb2cbd5..0711e01 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -17,19 +17,19 @@
  * blk_end_sync_rq - executes a completion event on a request
  * @rq: request to complete
  * @error: end I/O status of the request
  */
 static void blk_end_sync_rq(struct request *rq, int error)
 {
 	struct completion *waiting = rq->end_io_data;
 
 	rq->end_io_data = NULL;
-	__blk_put_request(rq->q, rq);
+	__blk_put_request(rq);
 
 	/*
 	 * complete last, if this is a stack request the process (and thus
 	 * the rq pointer) could be invalid right after this complete()
 	 */
 	complete(waiting);
 }
 
 /**
@@ -43,33 +43,39 @@ static void blk_end_sync_rq(struct request *rq, int error)
  * Description:
  *    Insert a fully prepared request at the back of the I/O scheduler queue
  *    for execution.  Don't wait for completion.
  */
 void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 			   struct request *rq, int at_head,
 			   rq_end_io_fn *done)
 {
 	int where = at_head ? ELEVATOR_INSERT_FRONT : ELEVATOR_INSERT_BACK;
+	struct blk_queue_ctx *ctx;
 
 	WARN_ON(irqs_disabled());
-	spin_lock_irq(q->queue_lock);
+
+	/* FIXME */
+	ctx = blk_get_ctx(q, 0);
 
 	if (unlikely(blk_queue_dead(q))) {
-		spin_unlock_irq(q->queue_lock);
 		rq->errors = -ENXIO;
 		if (rq->end_io)
 			rq->end_io(rq, rq->errors);
 		return;
 	}
 
 	rq->rq_disk = bd_disk;
 	rq->end_io = done;
-	__elv_add_request(q, rq, where);
+	spin_lock_irq(&ctx->lock);
+	__elv_add_request(rq, where);
+	spin_unlock(&ctx->lock);
+
+	spin_lock(q->queue_lock);
 	__blk_run_queue(q);
 	/* the queue is stopped so it won't be run */
 	if (rq->cmd_type == REQ_TYPE_PM_RESUME)
 		q->request_fn(q);
 	spin_unlock_irq(q->queue_lock);
 }
 EXPORT_SYMBOL_GPL(blk_execute_rq_nowait);
 
 /**
diff --git a/block/blk-flush.c b/block/blk-flush.c
index 720ad60..971a05e 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -138,19 +138,19 @@ static void blk_flush_restore_request(struct request *rq)
  * CONTEXT:
  * spin_lock_irq(q->queue_lock)
  *
  * RETURNS:
  * %true if requests were added to the dispatch queue, %false otherwise.
  */
 static bool blk_flush_complete_seq(struct request *rq, unsigned int seq,
 				   int error)
 {
-	struct request_queue *q = rq->q;
+	struct request_queue *q = rq->queue_ctx->queue;
 	struct list_head *pending = &q->flush_queue[q->flush_pending_idx];
 	bool queued = false;
 
 	BUG_ON(rq->flush.seq & seq);
 	rq->flush.seq |= seq;
 
 	if (likely(!error))
 		seq = blk_flush_cur_seq(rq);
 	else
@@ -187,28 +187,28 @@ static bool blk_flush_complete_seq(struct request *rq, unsigned int seq,
 	default:
 		BUG();
 	}
 
 	return blk_kick_flush(q) | queued;
 }
 
 static void flush_end_io(struct request *flush_rq, int error)
 {
-	struct request_queue *q = flush_rq->q;
+	struct request_queue *q = flush_rq->queue_ctx->queue;
 	struct list_head *running = &q->flush_queue[q->flush_running_idx];
 	bool queued = false;
 	struct request *rq, *n;
 
 	BUG_ON(q->flush_pending_idx == q->flush_running_idx);
 
 	/* account completion of the flush request */
 	q->flush_running_idx ^= 1;
-	elv_completed_request(q, flush_rq);
+	elv_completed_request(flush_rq);
 
 	/* and push the waiting requests to the next stage */
 	list_for_each_entry_safe(rq, n, running, flush.list) {
 		unsigned int seq = blk_flush_cur_seq(rq);
 
 		BUG_ON(seq != REQ_FSEQ_PREFLUSH && seq != REQ_FSEQ_POSTFLUSH);
 		queued |= blk_flush_complete_seq(rq, seq, error);
 	}
 
@@ -240,47 +240,48 @@ static void flush_end_io(struct request *flush_rq, int error)
  *
  * RETURNS:
  * %true if flush was issued, %false otherwise.
  */
 static bool blk_kick_flush(struct request_queue *q)
 {
 	struct list_head *pending = &q->flush_queue[q->flush_pending_idx];
 	struct request *first_rq =
 		list_first_entry(pending, struct request, flush.list);
+	struct blk_queue_ctx *ctx = first_rq->queue_ctx;
 
 	/* C1 described at the top of this file */
 	if (q->flush_pending_idx != q->flush_running_idx || list_empty(pending))
 		return false;
 
 	/* C2 and C3 */
 	if (!list_empty(&q->flush_data_in_flight) &&
 	    time_before(jiffies,
 			q->flush_pending_since + FLUSH_PENDING_TIMEOUT))
 		return false;
 
 	/*
 	 * Issue flush and toggle pending_idx.  This makes pending_idx
 	 * different from running_idx, which means flush is in flight.
 	 */
-	blk_rq_init(q, &q->flush_rq);
+	blk_rq_init(ctx, &q->flush_rq);
 	q->flush_rq.cmd_type = REQ_TYPE_FS;
 	q->flush_rq.cmd_flags = WRITE_FLUSH | REQ_FLUSH_SEQ;
 	q->flush_rq.rq_disk = first_rq->rq_disk;
 	q->flush_rq.end_io = flush_end_io;
 
 	q->flush_pending_idx ^= 1;
 	list_add_tail(&q->flush_rq.queuelist, &q->queue_head);
 	return true;
 }
 
 static void flush_data_end_io(struct request *rq, int error)
 {
-	struct request_queue *q = rq->q;
+	struct request_queue *q = rq->queue_ctx->queue;
 
 	/*
 	 * After populating an empty queue, kick it to avoid stall.  Read
 	 * the comment in flush_end_io().
 	 */
 	if (blk_flush_complete_seq(rq, REQ_FSEQ_DATA, error))
 		blk_run_queue_async(q);
 }
 
@@ -291,19 +292,19 @@ static void flush_data_end_io(struct request *rq, int error)
  * To be called from __elv_add_request() for %ELEVATOR_INSERT_FLUSH insertions.
  * @rq is being submitted.  Analyze what needs to be done and put it on the
  * right queue.
  *
  * CONTEXT:
  * spin_lock_irq(q->queue_lock)
  */
 void blk_insert_flush(struct request *rq)
 {
-	struct request_queue *q = rq->q;
+	struct request_queue *q = rq->queue_ctx->queue;
 	unsigned int fflags = q->flush_flags;	/* may change, cache */
 	unsigned int policy = blk_flush_policy(fflags, rq);
 
 	/*
 	 * @policy now records what operations need to be done.  Adjust
 	 * REQ_FLUSH and FUA for the driver.
 	 */
 	rq->cmd_flags &= ~REQ_FLUSH;
 	if (!(fflags & REQ_FUA))
diff --git a/block/blk-map.c b/block/blk-map.c
index 623e1cd..a7dd895 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -8,19 +8,19 @@
 #include <scsi/sg.h>		/* for struct sg_iovec */
 
 #include "blk.h"
 
 int blk_rq_append_bio(struct request_queue *q, struct request *rq,
 		      struct bio *bio)
 {
 	if (!rq->bio)
 		blk_rq_bio_prep(q, rq, bio);
-	else if (!ll_back_merge_fn(q, rq, bio))
+	else if (!ll_back_merge_fn(rq->queue_ctx, rq, bio))
 		return -EINVAL;
 	else {
 		rq->biotail->bi_next = bio;
 		rq->biotail = bio;
 
 		rq->__data_len += bio->bi_size;
 	}
 	return 0;
 }
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 160035f..61538b3 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -64,19 +64,21 @@ new_segment:
 		fbio->bi_seg_front_size = seg_size;
 	if (seg_size > bbio->bi_seg_back_size)
 		bbio->bi_seg_back_size = seg_size;
 
 	return nr_phys_segs;
 }
 
 void blk_recalc_rq_segments(struct request *rq)
 {
-	rq->nr_phys_segments = __blk_recalc_rq_segments(rq->q, rq->bio);
+	struct request_queue *q = rq->queue_ctx->queue;
+
+	rq->nr_phys_segments = __blk_recalc_rq_segments(q, rq->bio);
 }
 
 void blk_recount_segments(struct request_queue *q, struct bio *bio)
 {
 	struct bio *nxt = bio->bi_next;
 
 	bio->bi_next = NULL;
 	bio->bi_phys_segments = __blk_recalc_rq_segments(q, bio);
 	bio->bi_next = nxt;
@@ -108,21 +110,21 @@ static int blk_phys_contig_segment(struct request_queue *q, struct bio *bio,
 		return 1;
 
 	return 0;
 }
 
 /*
  * map a request to scatterlist, return number of sg entries setup. Caller
  * must make sure sg can hold rq->nr_phys_segments entries
  */
-int blk_rq_map_sg(struct request_queue *q, struct request *rq,
-		  struct scatterlist *sglist)
+int blk_rq_map_sg(struct request *rq, struct scatterlist *sglist)
 {
+	struct request_queue *q = rq->queue_ctx->queue;
 	struct bio_vec *bvec, *bvprv;
 	struct req_iterator iter;
 	struct scatterlist *sg;
 	int nsegs, cluster;
 
 	nsegs = 0;
 	cluster = blk_queue_cluster(q);
 
 	/*
@@ -194,18 +196,19 @@ new_segment:
 
 	if (sg)
 		sg_mark_end(sg);
 
 	return nsegs;
 }
 EXPORT_SYMBOL(blk_rq_map_sg);
 
 static inline int ll_new_hw_segment(struct request_queue *q,
+				    struct blk_queue_ctx *ctx,
 				    struct request *req,
 				    struct bio *bio)
 {
 	int nr_phys_segs = bio_phys_segments(q, bio);
 
 	if (req->nr_phys_segments + nr_phys_segs > queue_max_segments(q))
 		goto no_merge;
 
 	if (bio_integrity(bio) && blk_integrity_merge_bio(q, req, bio))
@@ -214,75 +217,77 @@ static inline int ll_new_hw_segment(struct request_queue *q,
 	/*
 	 * This will form the start of a new hw segment.  Bump both
 	 * counters.
 	 */
 	req->nr_phys_segments += nr_phys_segs;
 	return 1;
 
 no_merge:
 	req->cmd_flags |= REQ_NOMERGE;
-	if (req == q->last_merge)
-		q->last_merge = NULL;
+	if (req == ctx->last_merge)
+		ctx->last_merge = NULL;
 	return 0;
 }
 
-int ll_back_merge_fn(struct request_queue *q, struct request *req,
+int ll_back_merge_fn(struct blk_queue_ctx *ctx, struct request *req,
 		     struct bio *bio)
 {
+	struct request_queue *q = ctx->queue;
 	unsigned short max_sectors;
 
 	if (unlikely(req->cmd_type == REQ_TYPE_BLOCK_PC))
 		max_sectors = queue_max_hw_sectors(q);
 	else
 		max_sectors = queue_max_sectors(q);
 
 	if (blk_rq_sectors(req) + bio_sectors(bio) > max_sectors) {
 		req->cmd_flags |= REQ_NOMERGE;
-		if (req == q->last_merge)
-			q->last_merge = NULL;
+		if (req == ctx->last_merge)
+			ctx->last_merge = NULL;
 		return 0;
 	}
 	if (!bio_flagged(req->biotail, BIO_SEG_VALID))
 		blk_recount_segments(q, req->biotail);
 	if (!bio_flagged(bio, BIO_SEG_VALID))
 		blk_recount_segments(q, bio);
 
-	return ll_new_hw_segment(q, req, bio);
+	return ll_new_hw_segment(q, ctx, req, bio);
 }
 
-int ll_front_merge_fn(struct request_queue *q, struct request *req,
+int ll_front_merge_fn(struct blk_queue_ctx *ctx, struct request *req,
 		      struct bio *bio)
 {
+	struct request_queue *q = ctx->queue;
 	unsigned short max_sectors;
 
 	if (unlikely(req->cmd_type == REQ_TYPE_BLOCK_PC))
 		max_sectors = queue_max_hw_sectors(q);
 	else
 		max_sectors = queue_max_sectors(q);
 
-
 	if (blk_rq_sectors(req) + bio_sectors(bio) > max_sectors) {
 		req->cmd_flags |= REQ_NOMERGE;
-		if (req == q->last_merge)
-			q->last_merge = NULL;
+		if (req == ctx->last_merge)
+			ctx->last_merge = NULL;
 		return 0;
 	}
 	if (!bio_flagged(bio, BIO_SEG_VALID))
 		blk_recount_segments(q, bio);
 	if (!bio_flagged(req->bio, BIO_SEG_VALID))
 		blk_recount_segments(q, req->bio);
 
-	return ll_new_hw_segment(q, req, bio);
+	return ll_new_hw_segment(q, ctx, req, bio);
 }
 
-static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
+static int ll_merge_requests_fn(struct blk_queue_ctx *ctx, struct request *req,
 				struct request *next)
 {
+	struct request_queue *q = ctx->queue;
 	int total_phys_segments;
 	unsigned int seg_size =
 		req->biotail->bi_seg_back_size + next->bio->bi_seg_front_size;
 
 	/*
 	 * First check if the either of the requests are re-queued
 	 * requests.  Can't merge them if they are.
 	 */
 	if (req->special || next->special)
@@ -358,20 +363,20 @@ static void blk_account_io_merge(struct request *req)
 
 		hd_struct_put(part);
 		part_stat_unlock();
 	}
 }
 
 /*
  * Has to be called with the request spinlock acquired
  */
-static int attempt_merge(struct request_queue *q, struct request *req,
-			  struct request *next)
+static int attempt_merge(struct blk_queue_ctx *ctx, struct request *req,
+			 struct request *next)
 {
 	if (!rq_mergeable(req) || !rq_mergeable(next))
 		return 0;
 
 	/*
 	 * Don't merge file system requests and discard requests
 	 */
 	if ((req->cmd_flags & REQ_DISCARD) != (next->cmd_flags & REQ_DISCARD))
 		return 0;
@@ -393,19 +398,19 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 	    || next->special)
 		return 0;
 
 	/*
 	 * If we are allowed to merge, then append bio list
 	 * from next to rq and release next. merge_requests_fn
 	 * will have updated segment counts, update sector
 	 * counts here.
 	 */
-	if (!ll_merge_requests_fn(q, req, next))
+	if (!ll_merge_requests_fn(ctx, req, next))
 		return 0;
 
 	/*
 	 * If failfast settings disagree or any of the two is already
 	 * a mixed merge, mark both as mixed before proceeding.  This
 	 * makes sure that all involved bios have mixable attributes
 	 * set properly.
 	 */
 	if ((req->cmd_flags | next->cmd_flags) & REQ_MIXED_MERGE ||
@@ -423,59 +428,59 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 	 */
 	if (time_after(req->start_time, next->start_time))
 		req->start_time = next->start_time;
 
 	req->biotail->bi_next = next->bio;
 	req->biotail = next->biotail;
 
 	req->__data_len += blk_rq_bytes(next);
 
-	elv_merge_requests(q, req, next);
+	elv_merge_requests(ctx, req, next);
 
 	/*
 	 * 'next' is going away, so update stats accordingly
 	 */
 	blk_account_io_merge(next);
 
 	req->ioprio = ioprio_best(req->ioprio, next->ioprio);
 	if (blk_rq_cpu_valid(next))
 		req->cpu = next->cpu;
 
 	/* owner-ship of bio passed from next to req */
 	next->bio = NULL;
-	__blk_put_request(q, next);
+	__blk_put_request(next);
 	return 1;
 }
 
-int attempt_back_merge(struct request_queue *q, struct request *rq)
+int attempt_back_merge(struct blk_queue_ctx *ctx, struct request *rq)
 {
-	struct request *next = elv_latter_request(q, rq);
+	struct request *next = elv_latter_request(ctx, rq);
 
 	if (next)
-		return attempt_merge(q, rq, next);
+		return attempt_merge(ctx, rq, next);
 
 	return 0;
 }
 
-int attempt_front_merge(struct request_queue *q, struct request *rq)
+int attempt_front_merge(struct blk_queue_ctx *ctx, struct request *rq)
 {
-	struct request *prev = elv_former_request(q, rq);
+	struct request *prev = elv_former_request(ctx, rq);
 
 	if (prev)
-		return attempt_merge(q, prev, rq);
+		return attempt_merge(ctx, prev, rq);
 
 	return 0;
 }
 
-int blk_attempt_req_merge(struct request_queue *q, struct request *rq,
+int blk_attempt_req_merge(struct blk_queue_ctx *ctx, struct request *rq,
 			  struct request *next)
 {
-	return attempt_merge(q, rq, next);
+	return attempt_merge(ctx, rq, next);
 }
 
 bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 {
 	if (!rq_mergeable(rq))
 		return false;
 
 	/* don't merge file system requests and discard requests */
 	if ((bio->bi_rw & REQ_DISCARD) != (rq->bio->bi_rw & REQ_DISCARD))
diff --git a/block/blk-settings.c b/block/blk-settings.c
index d3234fc..862b859 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -174,19 +174,18 @@ void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
 {
 	/*
 	 * set defaults
 	 */
 	q->nr_requests = BLKDEV_MAX_RQ;
 
 	q->make_request_fn = mfn;
 	blk_queue_dma_alignment(q, 511);
 	blk_queue_congestion_threshold(q);
-	q->nr_batching = BLK_BATCH_REQ;
 
 	blk_set_default_limits(&q->limits);
 
 	/*
 	 * by default assume old behaviour and bounce for any highmem page
 	 */
 	blk_queue_bounce_limit(q, BLK_BOUNCE_HIGH);
 }
 EXPORT_SYMBOL(blk_queue_make_request);
diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index 467c8de..295665a 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -15,30 +15,32 @@
 static DEFINE_PER_CPU(struct list_head, blk_cpu_done);
 
 /*
  * Softirq action handler - move entries to local list and loop over them
  * while passing them to the queue registered handler.
  */
 static void blk_done_softirq(struct softirq_action *h)
 {
 	struct list_head *cpu_list, local_list;
+	struct request_queue *q;
 
 	local_irq_disable();
 	cpu_list = &__get_cpu_var(blk_cpu_done);
 	list_replace_init(cpu_list, &local_list);
 	local_irq_enable();
 
 	while (!list_empty(&local_list)) {
 		struct request *rq;
 
 		rq = list_entry(local_list.next, struct request, csd.list);
 		list_del_init(&rq->csd.list);
-		rq->q->softirq_done_fn(rq);
+		q = rq->queue_ctx->queue;
+		q->softirq_done_fn(rq);
 	}
 }
 
 #if defined(CONFIG_SMP) && defined(CONFIG_USE_GENERIC_SMP_HELPERS)
 static void trigger_softirq(void *data)
 {
 	struct request *rq = data;
 	unsigned long flags;
 	struct list_head *list;
@@ -98,20 +100,20 @@ static int __cpuinit blk_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
 static struct notifier_block __cpuinitdata blk_cpu_notifier = {
 	.notifier_call	= blk_cpu_notify,
 };
 
 void __blk_complete_request(struct request *req)
 {
+	struct request_queue *q = req->queue_ctx->queue;
 	int ccpu, cpu;
-	struct request_queue *q = req->q;
 	unsigned long flags;
 	bool shared = false;
 
 	BUG_ON(!q->softirq_done_fn);
 
 	local_irq_save(flags);
 	cpu = smp_processor_id();
 
 	/*
@@ -159,19 +161,21 @@ do_local:
  * Description:
  *     Ends all I/O on a request. It does not handle partial completions,
  *     unless the driver actually implements this in its completion callback
  *     through requeueing. The actual completion happens out-of-order,
  *     through a softirq handler. The user must have registered a completion
  *     callback through blk_queue_softirq_done().
  **/
 void blk_complete_request(struct request *req)
 {
-	if (unlikely(blk_should_fake_timeout(req->q)))
+	struct request_queue *q = req->queue_ctx->queue;
+
+	if (unlikely(blk_should_fake_timeout(q)))
 		return;
 	if (!blk_mark_rq_complete(req))
 		__blk_complete_request(req);
 }
 EXPORT_SYMBOL(blk_complete_request);
 
 static __init int blk_softirq_init(void)
 {
 	int i;
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index cf15001..652cf84 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -33,29 +33,36 @@ queue_var_store(unsigned long *var, const char *page, size_t count)
 
 static ssize_t queue_requests_show(struct request_queue *q, char *page)
 {
 	return queue_var_show(q->nr_requests, (page));
 }
 
 static ssize_t
 queue_requests_store(struct request_queue *q, const char *page, size_t count)
 {
-	struct request_list *rl = &q->rq;
+	struct blk_queue_ctx *ctx;
+	struct request_list *rl;
 	unsigned long nr;
 	int ret;
 
 	if (!q->request_fn)
 		return -EINVAL;
+	/* just ignore it for now */
+	if (q->nr_queues > 1)
+		return count;
 
 	ret = queue_var_store(&nr, page, count);
 	if (nr < BLKDEV_MIN_RQ)
 		nr = BLKDEV_MIN_RQ;
 
+	ctx = blk_get_ctx(q, 0);
+	rl = &ctx->rl;
+
 	spin_lock_irq(q->queue_lock);
 	q->nr_requests = nr;
 	blk_queue_congestion_threshold(q);
 
 	if (rl->count[BLK_RW_SYNC] >= queue_congestion_on_threshold(q))
 		blk_set_queue_congested(q, BLK_RW_SYNC);
 	else if (rl->count[BLK_RW_SYNC] < queue_congestion_off_threshold(q))
 		blk_clear_queue_congested(q, BLK_RW_SYNC);
 
@@ -469,33 +476,34 @@ queue_attr_store(struct kobject *kobj, struct attribute *attr,
  *
  * Caveat:
  *     Hopefully the low level driver will have finished any
  *     outstanding requests first...
  **/
 static void blk_release_queue(struct kobject *kobj)
 {
 	struct request_queue *q =
 		container_of(kobj, struct request_queue, kobj);
-	struct request_list *rl = &q->rq;
 
 	blk_sync_queue(q);
 
 	if (q->elevator) {
 		spin_lock_irq(q->queue_lock);
 		ioc_clear_queue(q);
 		spin_unlock_irq(q->queue_lock);
-		elevator_exit(q->elevator);
+		elevator_exit(q, q->elevator);
 	}
 
 	blk_throtl_exit(q);
 
-	if (rl->rq_pool)
-		mempool_destroy(rl->rq_pool);
+	if (q->rq_pool)
+		mempool_destroy(q->rq_pool);
+	if (q->queue_ctx)
+		kfree(q->queue_ctx);
 
 	if (q->queue_tags)
 		__blk_queue_free_tags(q);
 
 	blk_throtl_release(q);
 	blk_trace_shutdown(q);
 
 	bdi_destroy(&q->backing_dev_info);
 
diff --git a/block/blk-tag.c b/block/blk-tag.c
index 4af6f5c..8701a2a 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -347,19 +347,19 @@ int blk_queue_start_tag(struct request_queue *q, struct request *rq)
 	 *
 	 * We reserve a few tags just for sync IO, since we don't want
 	 * to starve sync IO on behalf of flooding async IO.
 	 */
 	max_depth = bqt->max_depth;
 	if (!rq_is_sync(rq) && max_depth > 1) {
 		max_depth -= 2;
 		if (!max_depth)
 			max_depth = 1;
-		if (q->in_flight[BLK_RW_ASYNC] > max_depth)
+		if (__queue_in_flight(q, BLK_RW_ASYNC) > max_depth)
 			return 1;
 	}
 
 	do {
 		tag = find_first_zero_bit(bqt->tag_map, max_depth);
 		if (tag >= max_depth)
 			return 1;
 
 	} while (test_and_set_bit_lock(tag, bqt->tag_map));
diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index 7803548..a6b70fd 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -75,19 +75,19 @@ ssize_t part_timeout_store(struct device *dev, struct device_attribute *attr,
  *
  */
 void blk_delete_timer(struct request *req)
 {
 	list_del_init(&req->timeout_list);
 }
 
 static void blk_rq_timed_out(struct request *req)
 {
-	struct request_queue *q = req->q;
+	struct request_queue *q = req->queue_ctx->queue;
 	enum blk_eh_timer_return ret;
 
 	ret = q->rq_timed_out_fn(req);
 	switch (ret) {
 	case BLK_EH_HANDLED:
 		__blk_complete_request(req);
 		break;
 	case BLK_EH_RESET_TIMER:
 		blk_clear_rq_complete(req);
@@ -101,42 +101,53 @@ static void blk_rq_timed_out(struct request *req)
 		 * the blk layer.
 		 */
 		break;
 	default:
 		printk(KERN_ERR "block: bad eh return: %d\n", ret);
 		break;
 	}
 }
 
-void blk_rq_timed_out_timer(unsigned long data)
+static void __blk_rq_timed_out(struct request_queue *q,
+			       struct blk_queue_ctx *ctx,
+			       unsigned long *next, int *next_set)
+
 {
-	struct request_queue *q = (struct request_queue *) data;
-	unsigned long flags, next = 0;
 	struct request *rq, *tmp;
-	int next_set = 0;
 
-	spin_lock_irqsave(q->queue_lock, flags);
-
-	list_for_each_entry_safe(rq, tmp, &q->timeout_list, timeout_list) {
+	list_for_each_entry_safe(rq, tmp, &ctx->timeout_list, timeout_list) {
 		if (time_after_eq(jiffies, rq->deadline)) {
 			list_del_init(&rq->timeout_list);
 
 			/*
 			 * Check if we raced with end io completion
 			 */
 			if (blk_mark_rq_complete(rq))
 				continue;
 			blk_rq_timed_out(rq);
-		} else if (!next_set || time_after(next, rq->deadline)) {
-			next = rq->deadline;
-			next_set = 1;
+		} else if (!*next_set || time_after(*next, rq->deadline)) {
+			*next = rq->deadline;
+			*next_set = 1;
 		}
 	}
+}
+
+void blk_rq_timed_out_timer(unsigned long data)
+{
+	struct request_queue *q = (struct request_queue *) data;
+	struct blk_queue_ctx *ctx;
+	unsigned long flags, next = 0;
+	int next_set = 0, i;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+
+	queue_for_each_ctx(q, ctx, i)
+		__blk_rq_timed_out(q, ctx, &next, &next_set);
 
 	if (next_set)
 		mod_timer(&q->timeout, round_jiffies_up(next));
 
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
 /**
  * blk_abort_request -- Request request recovery for the specified command
@@ -160,36 +171,36 @@ EXPORT_SYMBOL_GPL(blk_abort_request);
  * blk_add_timer - Start timeout timer for a single request
  * @req:	request that is about to start running.
  *
  * Notes:
  *    Each request has its own timer, and as it is added to the queue, we
  *    set up the timer. When the request completes, we cancel the timer.
  */
 void blk_add_timer(struct request *req)
 {
-	struct request_queue *q = req->q;
+	struct request_queue *q = req->queue_ctx->queue;
 	unsigned long expiry;
 
 	if (!q->rq_timed_out_fn)
 		return;
 
 	BUG_ON(!list_empty(&req->timeout_list));
 	BUG_ON(test_bit(REQ_ATOM_COMPLETE, &req->atomic_flags));
 
 	/*
 	 * Some LLDs, like scsi, peek at the timeout to prevent a
 	 * command from being retried forever.
 	 */
 	if (!req->timeout)
 		req->timeout = q->rq_timeout;
 
 	req->deadline = jiffies + req->timeout;
-	list_add_tail(&req->timeout_list, &q->timeout_list);
+	list_add_tail(&req->timeout_list, &req->queue_ctx->timeout_list);
 
 	/*
 	 * If the timer isn't already pending or this timeout is earlier
 	 * than an existing one, modify the timer. Round up to next nearest
 	 * second.
 	 */
 	expiry = round_jiffies_up(req->deadline);
 
 	if (!timer_pending(&q->timeout) ||
@@ -198,43 +209,47 @@ void blk_add_timer(struct request *req)
 }
 
 /**
  * blk_abort_queue -- Abort all request on given queue
  * @queue:	pointer to queue
  *
  */
 void blk_abort_queue(struct request_queue *q)
 {
+	struct blk_queue_ctx *ctx;
 	unsigned long flags;
 	struct request *rq, *tmp;
 	LIST_HEAD(list);
+	unsigned int i;
 
 	/*
 	 * Not a request based block device, nothing to abort
 	 */
 	if (!q->request_fn)
 		return;
 
 	spin_lock_irqsave(q->queue_lock, flags);
 
 	elv_abort_queue(q);
 
 	/*
 	 * Splice entries to local list, to avoid deadlocking if entries
 	 * get readded to the timeout list by error handling
 	 */
-	list_splice_init(&q->timeout_list, &list);
+	queue_for_each_ctx(q, ctx, i)
+		list_splice_init(&ctx->timeout_list, &list);
 
 	list_for_each_entry_safe(rq, tmp, &list, timeout_list)
 		blk_abort_request(rq);
 
 	/*
 	 * Occasionally, blk_abort_request() will return without
 	 * deleting the element from the list. Make sure we add those back
 	 * instead of leaving them on the local stack list.
 	 */
-	list_splice(&list, &q->timeout_list);
+	list_for_each_entry_safe(rq, tmp, &list, timeout_list)
+		list_move_tail(&rq->timeout_list, &ctx->timeout_list);
 
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
 }
 EXPORT_SYMBOL_GPL(blk_abort_queue);
diff --git a/block/blk.h b/block/blk.h
index d45be87..0cdae8e 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -1,19 +1,15 @@
 #ifndef BLK_INTERNAL_H
 #define BLK_INTERNAL_H
 
 #include <linux/idr.h>
 
-/* Amount of time in which a process may batch requests */
-#define BLK_BATCH_TIME	(HZ/50UL)
-
-/* Number of requests a "batching" process may submit */
-#define BLK_BATCH_REQ	32
+#include <linux/blk-mq.h>
 
 extern struct kmem_cache *blk_requestq_cachep;
 extern struct kobj_type blk_queue_ktype;
 extern struct ida blk_queue_ida;
 
 static inline void __blk_get_queue(struct request_queue *q)
 {
 	kobject_get(&q->kobj);
 }
@@ -93,53 +89,55 @@ static inline struct request *__elv_next_request(struct request_queue *q)
 			q->flush_queue_delayed = 1;
 			return NULL;
 		}
 		if (unlikely(blk_queue_dead(q)) ||
 		    !q->elevator->type->ops.elevator_dispatch_fn(q, 0))
 			return NULL;
 	}
 }
 
-static inline void elv_activate_rq(struct request_queue *q, struct request *rq)
+static inline void elv_activate_rq(struct request *rq)
 {
+	struct request_queue *q = rq->queue_ctx->queue;
 	struct elevator_queue *e = q->elevator;
 
 	if (e->type->ops.elevator_activate_req_fn)
 		e->type->ops.elevator_activate_req_fn(q, rq);
 }
 
-static inline void elv_deactivate_rq(struct request_queue *q, struct request *rq)
+static inline void elv_deactivate_rq(struct request *rq)
 {
+	struct request_queue *q = rq->queue_ctx->queue;
 	struct elevator_queue *e = q->elevator;
 
 	if (e->type->ops.elevator_deactivate_req_fn)
 		e->type->ops.elevator_deactivate_req_fn(q, rq);
 }
 
 #ifdef CONFIG_FAIL_IO_TIMEOUT
 int blk_should_fake_timeout(struct request_queue *);
 ssize_t part_timeout_show(struct device *, struct device_attribute *, char *);
 ssize_t part_timeout_store(struct device *, struct device_attribute *,
 				const char *, size_t);
 #else
 static inline int blk_should_fake_timeout(struct request_queue *q)
 {
 	return 0;
 }
 #endif
 
-int ll_back_merge_fn(struct request_queue *q, struct request *req,
+int ll_back_merge_fn(struct blk_queue_ctx *ctx, struct request *req,
 		     struct bio *bio);
-int ll_front_merge_fn(struct request_queue *q, struct request *req, 
+int ll_front_merge_fn(struct blk_queue_ctx *ctx, struct request *req, 
 		      struct bio *bio);
-int attempt_back_merge(struct request_queue *q, struct request *rq);
-int attempt_front_merge(struct request_queue *q, struct request *rq);
-int blk_attempt_req_merge(struct request_queue *q, struct request *rq,
+int attempt_back_merge(struct blk_queue_ctx *ctx, struct request *rq);
+int attempt_front_merge(struct blk_queue_ctx *ctx, struct request *rq);
+int blk_attempt_req_merge(struct blk_queue_ctx *ctx, struct request *rq,
 				struct request *next);
 void blk_recalc_rq_segments(struct request *rq);
 void blk_rq_set_mixed_merge(struct request *rq);
 bool blk_rq_merge_ok(struct request *rq, struct bio *bio);
 int blk_try_merge(struct request *rq, struct bio *bio);
 
 void blk_queue_congestion_threshold(struct request_queue *q);
 
 int blk_dev_init(void);
diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index 7ad49c8..5d20741 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -16,18 +16,19 @@
  *  GNU General Public License for more details.
  *
  *  You should have received a copy of the GNU General Public License
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  *
  */
 #include <linux/slab.h>
 #include <linux/blkdev.h>
+#include <linux/blk-mq.h>
 #include <linux/delay.h>
 #include <linux/scatterlist.h>
 #include <linux/bsg-lib.h>
 #include <linux/export.h>
 #include <scsi/scsi_cmnd.h>
 
 /**
  * bsg_destroy_job - routine to teardown/delete a bsg job
  * @job: bsg_job that is to be torn down
@@ -91,32 +92,32 @@ static int bsg_map_buffer(struct bsg_buffer *buf, struct request *req)
 {
 	size_t sz = (sizeof(struct scatterlist) * req->nr_phys_segments);
 
 	BUG_ON(!req->nr_phys_segments);
 
 	buf->sg_list = kzalloc(sz, GFP_KERNEL);
 	if (!buf->sg_list)
 		return -ENOMEM;
 	sg_init_table(buf->sg_list, req->nr_phys_segments);
-	buf->sg_cnt = blk_rq_map_sg(req->q, req, buf->sg_list);
+	buf->sg_cnt = blk_rq_map_sg(req, buf->sg_list);
 	buf->payload_len = blk_rq_bytes(req);
 	return 0;
 }
 
 /**
  * bsg_create_job - create the bsg_job structure for the bsg request
  * @dev: device that is being sent the bsg request
  * @req: BSG request that needs a job structure
  */
 static int bsg_create_job(struct device *dev, struct request *req)
 {
 	struct request *rsp = req->next_rq;
-	struct request_queue *q = req->q;
+	struct request_queue *q = req->queue_ctx->queue;
 	struct bsg_job *job;
 	int ret;
 
 	BUG_ON(req->special);
 
 	job = kzalloc(sizeof(struct bsg_job) + q->bsg_job_size, GFP_KERNEL);
 	if (!job)
 		return -ENOMEM;
 
@@ -264,20 +265,19 @@ void bsg_remove_queue(struct request_queue *q)
 	blk_stop_queue(q);
 
 	/* drain all requests in the queue */
 	while (1) {
 		/* need the lock to fetch a request
 		 * this may fetch the same reqeust as the previous pass
 		 */
 		req = blk_fetch_request(q);
 		/* save requests in use and starved */
-		counts = q->rq.count[0] + q->rq.count[1] +
-			 q->rq.starved[0] + q->rq.starved[1];
+		counts = queue_rq_queued(q) + queue_rq_starved(q);
 		spin_unlock_irq(q->queue_lock);
 		/* any requests still outstanding? */
 		if (counts == 0)
 			break;
 
 		/* This may be the same req as the previous iteration,
 		 * always send the blk_end_request_all after a prefetch.
 		 * It is not okay to not end the request because the
 		 * prefetch started the request.
diff --git a/block/elevator.c b/block/elevator.c
index f016855..0b4e907 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -52,23 +52,23 @@ static const int elv_hash_shift = 6;
 #define ELV_HASH_ENTRIES	(1 << elv_hash_shift)
 #define rq_hash_key(rq)		(blk_rq_pos(rq) + blk_rq_sectors(rq))
 
 /*
  * Query io scheduler to see if the current process issuing bio may be
  * merged with rq.
  */
 static int elv_iosched_allow_merge(struct request *rq, struct bio *bio)
 {
-	struct request_queue *q = rq->q;
-	struct elevator_queue *e = q->elevator;
+	struct blk_queue_ctx *ctx = rq->queue_ctx;
+	struct elevator_queue *e = ctx->queue->elevator;
 
 	if (e->type->ops.elevator_allow_merge_fn)
-		return e->type->ops.elevator_allow_merge_fn(q, rq, bio);
+		return e->type->ops.elevator_allow_merge_fn(ctx, rq, bio);
 
 	return 1;
 }
 
 /*
  * can we safely merge with this request?
  */
 bool elv_rq_merge_ok(struct request *rq, struct bio *bio)
 {
@@ -116,23 +116,47 @@ static struct elevator_type *elevator_get(const char *name)
 	if (e && !try_module_get(e->elevator_owner))
 		e = NULL;
 
 	spin_unlock(&elv_list_lock);
 
 	return e;
 }
 
 static int elevator_init_queue(struct request_queue *q,
-			       struct elevator_queue *eq)
+			       struct elevator_queue *eq,
+			       unsigned int nr_queues)
 {
-	eq->elevator_data = eq->type->ops.elevator_init_fn(q);
-	if (eq->elevator_data)
-		return 0;
+	unsigned int i, j, hash_size;
+	struct blk_queue_ctx *ctx;
+	int ret;
+
+	ret = eq->type->ops.elevator_init_fn(q, nr_queues);
+	if (ret)
+		return ret;
+
+	hash_size = sizeof(struct hlist_head) * ELV_HASH_ENTRIES;
+	queue_for_each_ctx(q, ctx, i) {
+		ctx->hash = kmalloc_node(hash_size, GFP_KERNEL, q->node);
+		if (!ctx->hash)
+			goto err;
+
+		for (j = 0; j < ELV_HASH_ENTRIES; j++)
+			INIT_HLIST_HEAD(&ctx->hash[j]);
+	}
+
+	q->nr_queues = i;
+	return 0;
+err:
+	while (i--) {
+		ctx = blk_get_ctx(q, i);
+		kfree(ctx->hash);
+	}
+
 	return -ENOMEM;
 }
 
 static char chosen_elevator[ELV_NAME_MAX];
 
 static int __init elevator_setup(char *str)
 {
 	/*
 	 * Be backwards-compatible with previous kernels, so users
@@ -144,64 +168,51 @@ static int __init elevator_setup(char *str)
 
 __setup("elevator=", elevator_setup);
 
 static struct kobj_type elv_ktype;
 
 static struct elevator_queue *elevator_alloc(struct request_queue *q,
 				  struct elevator_type *e)
 {
 	struct elevator_queue *eq;
-	int i;
 
 	eq = kmalloc_node(sizeof(*eq), GFP_KERNEL | __GFP_ZERO, q->node);
-	if (unlikely(!eq))
-		goto err;
-
-	eq->type = e;
-	kobject_init(&eq->kobj, &elv_ktype);
-	mutex_init(&eq->sysfs_lock);
-
-	eq->hash = kmalloc_node(sizeof(struct hlist_head) * ELV_HASH_ENTRIES,
-					GFP_KERNEL, q->node);
-	if (!eq->hash)
-		goto err;
+	if (eq) {
+		eq->type = e;
+		kobject_init(&eq->kobj, &elv_ktype);
+		mutex_init(&eq->sysfs_lock);
 
-	for (i = 0; i < ELV_HASH_ENTRIES; i++)
-		INIT_HLIST_HEAD(&eq->hash[i]);
+		return eq;
+	}
 
-	return eq;
-err:
-	kfree(eq);
 	elevator_put(e);
 	return NULL;
 }
 
 static void elevator_release(struct kobject *kobj)
 {
 	struct elevator_queue *e;
 
 	e = container_of(kobj, struct elevator_queue, kobj);
 	elevator_put(e->type);
-	kfree(e->hash);
 	kfree(e);
 }
 
 int elevator_init(struct request_queue *q, char *name)
 {
 	struct elevator_type *e = NULL;
 	struct elevator_queue *eq;
 	int err;
 
 	if (unlikely(q->elevator))
 		return 0;
 
 	INIT_LIST_HEAD(&q->queue_head);
-	q->last_merge = NULL;
 	q->end_sector = 0;
 	q->boundary_rq = NULL;
 
 	if (name) {
 		e = elevator_get(name);
 		if (!e)
 			return -EINVAL;
 	}
 
@@ -220,72 +231,81 @@ int elevator_init(struct request_queue *q, char *name)
 				"Using noop.\n");
 			e = elevator_get("noop");
 		}
 	}
 
 	eq = elevator_alloc(q, e);
 	if (!eq)
 		return -ENOMEM;
 
-	err = elevator_init_queue(q, eq);
+	err = elevator_init_queue(q, eq, 1);
 	if (err) {
 		kobject_put(&eq->kobj);
 		return err;
 	}
 
 	q->elevator = eq;
 	return 0;
 }
 EXPORT_SYMBOL(elevator_init);
 
-void elevator_exit(struct elevator_queue *e)
+void elevator_exit(struct request_queue *q, struct elevator_queue *e)
 {
+	struct blk_queue_ctx *ctx;
+	unsigned int i;
+
 	mutex_lock(&e->sysfs_lock);
 	if (e->type->ops.elevator_exit_fn)
-		e->type->ops.elevator_exit_fn(e);
+		e->type->ops.elevator_exit_fn(q, e);
 	mutex_unlock(&e->sysfs_lock);
 
+	queue_for_each_ctx(q, ctx, i)
+		kfree(ctx->hash);
+
 	kobject_put(&e->kobj);
 }
 EXPORT_SYMBOL(elevator_exit);
 
 static inline void __elv_rqhash_del(struct request *rq)
 {
+	lockdep_assert_held(&rq->queue_ctx->lock);
 	hlist_del_init(&rq->hash);
 }
 
-static void elv_rqhash_del(struct request_queue *q, struct request *rq)
+static void elv_rqhash_del(struct request *rq)
 {
 	if (ELV_ON_HASH(rq))
 		__elv_rqhash_del(rq);
 }
 
-static void elv_rqhash_add(struct request_queue *q, struct request *rq)
+static void elv_rqhash_add(struct blk_queue_ctx *ctx, struct request *rq)
 {
-	struct elevator_queue *e = q->elevator;
-
+	lockdep_assert_held(&ctx->lock);
 	BUG_ON(ELV_ON_HASH(rq));
-	hlist_add_head(&rq->hash, &e->hash[ELV_HASH_FN(rq_hash_key(rq))]);
+	hlist_add_head(&rq->hash, &ctx->hash[ELV_HASH_FN(rq_hash_key(rq))]);
 }
 
-static void elv_rqhash_reposition(struct request_queue *q, struct request *rq)
+static void elv_rqhash_reposition(struct blk_queue_ctx *ctx, struct request *rq)
 {
+	lockdep_assert_held(&ctx->lock);
 	__elv_rqhash_del(rq);
-	elv_rqhash_add(q, rq);
+	elv_rqhash_add(ctx, rq);
 }
 
-static struct request *elv_rqhash_find(struct request_queue *q, sector_t offset)
+static struct request *elv_rqhash_find(struct blk_queue_ctx *ctx,
+				       sector_t offset)
 {
-	struct elevator_queue *e = q->elevator;
-	struct hlist_head *hash_list = &e->hash[ELV_HASH_FN(offset)];
+	struct hlist_head *hash_list = &ctx->hash[ELV_HASH_FN(offset)];
 	struct hlist_node *entry, *next;
 	struct request *rq;
 
+	lockdep_assert_held(&ctx->lock);
+
 	hlist_for_each_entry_safe(rq, entry, next, hash_list, hash) {
 		BUG_ON(!ELV_ON_HASH(rq));
 
 		if (unlikely(!rq_mergeable(rq))) {
 			__elv_rqhash_del(rq);
 			continue;
 		}
 
 		if (rq_hash_key(rq) == offset)
@@ -299,35 +319,39 @@ static struct request *elv_rqhash_find(struct request_queue *q, sector_t offset)
  * RB-tree support functions for inserting/lookup/removal of requests
  * in a sorted RB tree.
  */
 void elv_rb_add(struct rb_root *root, struct request *rq)
 {
 	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
 	struct request *__rq;
 
+	lockdep_assert_held(&rq->queue_ctx->lock);
+
 	while (*p) {
 		parent = *p;
 		__rq = rb_entry(parent, struct request, rb_node);
 
 		if (blk_rq_pos(rq) < blk_rq_pos(__rq))
 			p = &(*p)->rb_left;
 		else if (blk_rq_pos(rq) >= blk_rq_pos(__rq))
 			p = &(*p)->rb_right;
 	}
 
 	rb_link_node(&rq->rb_node, parent, p);
 	rb_insert_color(&rq->rb_node, root);
 }
 EXPORT_SYMBOL(elv_rb_add);
 
 void elv_rb_del(struct rb_root *root, struct request *rq)
 {
+	lockdep_assert_held(&rq->queue_ctx->lock);
+
 	BUG_ON(RB_EMPTY_NODE(&rq->rb_node));
 	rb_erase(&rq->rb_node, root);
 	RB_CLEAR_NODE(&rq->rb_node);
 }
 EXPORT_SYMBOL(elv_rb_del);
 
 struct request *elv_rb_find(struct rb_root *root, sector_t sector)
 {
 	struct rb_node *n = root->rb_node;
@@ -344,33 +368,37 @@ struct request *elv_rb_find(struct rb_root *root, sector_t sector)
 			return rq;
 	}
 
 	return NULL;
 }
 EXPORT_SYMBOL(elv_rb_find);
 
 /*
  * Insert rq into dispatch queue of q.  Queue lock must be held on
- * entry.  rq is sort instead into the dispatch queue. To be used by
+ * entry.  rq is sort inserted into the dispatch queue. To be used by
  * specific elevators.
  */
-void elv_dispatch_sort(struct request_queue *q, struct request *rq)
+void elv_dispatch_sort(struct request_queue *q, struct blk_queue_ctx *ctx,
+		       struct request *rq)
 {
 	sector_t boundary;
 	struct list_head *entry;
 	int stop_flags;
 
-	if (q->last_merge == rq)
-		q->last_merge = NULL;
+	assert_spin_locked(&ctx->lock);
+	assert_spin_locked(&ctx->lock);
 
-	elv_rqhash_del(q, rq);
+	if (ctx->last_merge == rq)
+		ctx->last_merge = NULL;
 
-	q->nr_sorted--;
+	elv_rqhash_del(rq);
+
+	ctx->nr_sorted--;
 
 	boundary = q->end_sector;
 	stop_flags = REQ_SOFTBARRIER | REQ_STARTED;
 	list_for_each_prev(entry, &q->queue_head) {
 		struct request *pos = list_entry_rq(entry);
 
 		if ((rq->cmd_flags & REQ_DISCARD) !=
 		    (pos->cmd_flags & REQ_DISCARD))
 			break;
@@ -392,181 +420,206 @@ void elv_dispatch_sort(struct request_queue *q, struct request *rq)
 	list_add(&rq->queuelist, entry);
 }
 EXPORT_SYMBOL(elv_dispatch_sort);
 
 /*
  * Insert rq into dispatch queue of q.  Queue lock must be held on
  * entry.  rq is added to the back of the dispatch queue. To be used by
  * specific elevators.
  */
-void elv_dispatch_add_tail(struct request_queue *q, struct request *rq)
+void elv_dispatch_add_tail(struct request_queue *q, struct blk_queue_ctx *ctx,
+			   struct request *rq)
 {
-	if (q->last_merge == rq)
-		q->last_merge = NULL;
+	assert_spin_locked(q->queue_lock);
+	assert_spin_locked(&ctx->lock);
+
+	if (ctx->last_merge == rq)
+		ctx->last_merge = NULL;
 
-	elv_rqhash_del(q, rq);
+	elv_rqhash_del(rq);
 
-	q->nr_sorted--;
+	ctx->nr_sorted--;
 
 	q->end_sector = rq_end_sector(rq);
 	q->boundary_rq = rq;
 	list_add_tail(&rq->queuelist, &q->queue_head);
 }
 EXPORT_SYMBOL(elv_dispatch_add_tail);
 
-int elv_merge(struct request_queue *q, struct request **req, struct bio *bio)
+int elv_merge(struct blk_queue_ctx *ctx, struct request **req, struct bio *bio)
 {
+	struct request_queue *q = ctx->queue;
 	struct elevator_queue *e = q->elevator;
 	struct request *__rq;
 	int ret;
 
+	assert_spin_locked(&ctx->lock);
+
 	/*
 	 * Levels of merges:
 	 * 	nomerges:  No merges at all attempted
 	 * 	noxmerges: Only simple one-hit cache try
 	 * 	merges:	   All merge tries attempted
 	 */
 	if (blk_queue_nomerges(q))
 		return ELEVATOR_NO_MERGE;
 
 	/*
 	 * First try one-hit cache.
 	 */
-	if (q->last_merge && elv_rq_merge_ok(q->last_merge, bio)) {
-		ret = blk_try_merge(q->last_merge, bio);
+	if (ctx->last_merge && elv_rq_merge_ok(ctx->last_merge, bio)) {
+		ret = blk_try_merge(ctx->last_merge, bio);
 		if (ret != ELEVATOR_NO_MERGE) {
-			*req = q->last_merge;
+			*req = ctx->last_merge;
 			return ret;
 		}
 	}
 
 	if (blk_queue_noxmerges(q))
 		return ELEVATOR_NO_MERGE;
 
 	/*
 	 * See if our hash lookup can find a potential backmerge.
 	 */
-	__rq = elv_rqhash_find(q, bio->bi_sector);
+	__rq = elv_rqhash_find(ctx, bio->bi_sector);
 	if (__rq && elv_rq_merge_ok(__rq, bio)) {
 		*req = __rq;
 		return ELEVATOR_BACK_MERGE;
 	}
 
 	if (e->type->ops.elevator_merge_fn)
-		return e->type->ops.elevator_merge_fn(q, req, bio);
+		return e->type->ops.elevator_merge_fn(ctx, req, bio);
 
 	return ELEVATOR_NO_MERGE;
 }
 
 /*
  * Attempt to do an insertion back merge. Only check for the case where
  * we can append 'rq' to an existing request, so we can throw 'rq' away
  * afterwards.
  *
  * Returns true if we merged, false otherwise
  */
-static bool elv_attempt_insert_merge(struct request_queue *q,
+static bool elv_attempt_insert_merge(struct blk_queue_ctx *ctx,
 				     struct request *rq)
 {
+	struct request_queue *q = ctx->queue;
 	struct request *__rq;
 
 	if (blk_queue_nomerges(q))
 		return false;
 
 	/*
 	 * First try one-hit cache.
 	 */
-	if (q->last_merge && blk_attempt_req_merge(q, q->last_merge, rq))
+	if (ctx->last_merge && blk_attempt_req_merge(ctx, ctx->last_merge, rq))
 		return true;
 
 	if (blk_queue_noxmerges(q))
 		return false;
 
 	/*
 	 * See if our hash lookup can find a potential backmerge.
 	 */
-	__rq = elv_rqhash_find(q, blk_rq_pos(rq));
-	if (__rq && blk_attempt_req_merge(q, __rq, rq))
+	__rq = elv_rqhash_find(ctx, blk_rq_pos(rq));
+	if (__rq && blk_attempt_req_merge(ctx, __rq, rq))
 		return true;
 
 	return false;
 }
 
-void elv_merged_request(struct request_queue *q, struct request *rq, int type)
+void elv_merged_request(struct blk_queue_ctx *ctx, struct request *rq, int type)
 {
-	struct elevator_queue *e = q->elevator;
+	struct elevator_queue *e = ctx->queue->elevator;
+
+	lockdep_assert_held(&ctx->lock);
 
 	if (e->type->ops.elevator_merged_fn)
-		e->type->ops.elevator_merged_fn(q, rq, type);
+		e->type->ops.elevator_merged_fn(ctx, rq, type);
 
 	if (type == ELEVATOR_BACK_MERGE)
-		elv_rqhash_reposition(q, rq);
+		elv_rqhash_reposition(ctx, rq);
 
-	q->last_merge = rq;
+	ctx->last_merge = rq;
 }
 
-void elv_merge_requests(struct request_queue *q, struct request *rq,
+void elv_merge_requests(struct blk_queue_ctx *ctx, struct request *rq,
 			     struct request *next)
 {
-	struct elevator_queue *e = q->elevator;
+	struct elevator_queue *e = ctx->queue->elevator;
 	const int next_sorted = next->cmd_flags & REQ_SORTED;
 
+	BUG_ON(rq->queue_ctx != next->queue_ctx);
+	lockdep_assert_held(&ctx->lock);
+
 	if (next_sorted && e->type->ops.elevator_merge_req_fn)
-		e->type->ops.elevator_merge_req_fn(q, rq, next);
+		e->type->ops.elevator_merge_req_fn(ctx, rq, next);
 
-	elv_rqhash_reposition(q, rq);
+	elv_rqhash_reposition(ctx, rq);
 
 	if (next_sorted) {
-		elv_rqhash_del(q, next);
-		q->nr_sorted--;
+		elv_rqhash_del(next);
+		ctx->nr_sorted--;
 	}
 
-	q->last_merge = rq;
+	ctx->last_merge = rq;
 }
 
-void elv_bio_merged(struct request_queue *q, struct request *rq,
+void elv_bio_merged(struct blk_queue_ctx *ctx, struct request *rq,
 			struct bio *bio)
 {
-	struct elevator_queue *e = q->elevator;
+	struct elevator_queue *e = ctx->queue->elevator;
+
+	lockdep_assert_held(&ctx->lock);
 
 	if (e->type->ops.elevator_bio_merged_fn)
-		e->type->ops.elevator_bio_merged_fn(q, rq, bio);
+		e->type->ops.elevator_bio_merged_fn(ctx, rq, bio);
 }
 
 void elv_requeue_request(struct request_queue *q, struct request *rq)
 {
 	/*
 	 * it already went through dequeue, we need to decrement the
 	 * in_flight count again
 	 */
 	if (blk_account_rq(rq)) {
-		q->in_flight[rq_is_sync(rq)]--;
+		struct blk_queue_ctx *ctx = rq->queue_ctx;
+
+		spin_lock(&ctx->lock);
+		ctx->in_flight[rq_is_sync(rq)]--;
+		spin_unlock(&ctx->lock);
+
 		if (rq->cmd_flags & REQ_SORTED)
-			elv_deactivate_rq(q, rq);
+			elv_deactivate_rq(rq);
 	}
 
 	rq->cmd_flags &= ~REQ_STARTED;
 
-	__elv_add_request(q, rq, ELEVATOR_INSERT_REQUEUE);
+	__elv_add_request(rq, ELEVATOR_INSERT_REQUEUE);
 }
 
 void elv_drain_elevator(struct request_queue *q)
 {
+	struct blk_queue_ctx *ctx;
 	static int printed;
+	int nr_sorted, i;
 
 	lockdep_assert_held(q->queue_lock);
 
 	while (q->elevator->type->ops.elevator_dispatch_fn(q, 1))
 		;
-	if (q->nr_sorted && printed++ < 10) {
+	nr_sorted = 0;
+	queue_for_each_ctx(q, ctx, i)
+		nr_sorted += ctx->nr_sorted;
+	if (nr_sorted && printed++ < 10) {
 		printk(KERN_ERR "%s: forced dispatching is broken "
 		       "(nr_sorted=%u), please report this\n",
-		       q->elevator->type->elevator_name, q->nr_sorted);
+		       q->elevator->type->elevator_name, nr_sorted);
 	}
 }
 
 void elv_quiesce_start(struct request_queue *q)
 {
 	if (!q->elevator)
 		return;
 
 	spin_lock_irq(q->queue_lock);
@@ -577,139 +630,149 @@ void elv_quiesce_start(struct request_queue *q)
 }
 
 void elv_quiesce_end(struct request_queue *q)
 {
 	spin_lock_irq(q->queue_lock);
 	queue_flag_clear(QUEUE_FLAG_ELVSWITCH, q);
 	spin_unlock_irq(q->queue_lock);
 }
 
-void __elv_add_request(struct request_queue *q, struct request *rq, int where)
+void __elv_add_request(struct request *rq, int where)
 {
+	struct blk_queue_ctx *ctx = rq->queue_ctx;
+	struct request_queue *q = ctx->queue;
+
+	lockdep_assert_held(&ctx->lock);
+
 	trace_block_rq_insert(q, rq);
 
-	rq->q = q;
+	BUG_ON(ctx != rq->queue_ctx);
 
 	if (rq->cmd_flags & REQ_SOFTBARRIER) {
 		/* barriers are scheduling boundary, update end_sector */
 		if (rq->cmd_type == REQ_TYPE_FS ||
 		    (rq->cmd_flags & REQ_DISCARD)) {
 			q->end_sector = rq_end_sector(rq);
 			q->boundary_rq = rq;
 		}
 	} else if (!(rq->cmd_flags & REQ_ELVPRIV) &&
 		    (where == ELEVATOR_INSERT_SORT ||
 		     where == ELEVATOR_INSERT_SORT_MERGE))
 		where = ELEVATOR_INSERT_BACK;
 
 	switch (where) {
 	case ELEVATOR_INSERT_REQUEUE:
 	case ELEVATOR_INSERT_FRONT:
 		rq->cmd_flags |= REQ_SOFTBARRIER;
+		queue_ctx_lock_queue(q, ctx);
 		list_add(&rq->queuelist, &q->queue_head);
+		queue_ctx_unlock_queue(q, ctx);
 		break;
 
 	case ELEVATOR_INSERT_BACK:
 		rq->cmd_flags |= REQ_SOFTBARRIER;
+		queue_ctx_lock_queue(q, ctx);
 		elv_drain_elevator(q);
 		list_add_tail(&rq->queuelist, &q->queue_head);
 		/*
 		 * We kick the queue here for the following reasons.
 		 * - The elevator might have returned NULL previously
 		 *   to delay requests and returned them now.  As the
 		 *   queue wasn't empty before this request, ll_rw_blk
 		 *   won't run the queue on return, resulting in hang.
 		 * - Usually, back inserted requests won't be merged
 		 *   with anything.  There's no point in delaying queue
 		 *   processing.
 		 */
 		__blk_run_queue(q);
+		queue_ctx_unlock_queue(q, ctx);
 		break;
 
 	case ELEVATOR_INSERT_SORT_MERGE:
 		/*
 		 * If we succeed in merging this request with one in the
 		 * queue already, we are done - rq has now been freed,
 		 * so no need to do anything further.
 		 */
-		if (elv_attempt_insert_merge(q, rq))
+		if (elv_attempt_insert_merge(ctx, rq))
 			break;
 	case ELEVATOR_INSERT_SORT:
 		BUG_ON(rq->cmd_type != REQ_TYPE_FS &&
 		       !(rq->cmd_flags & REQ_DISCARD));
 		rq->cmd_flags |= REQ_SORTED;
-		q->nr_sorted++;
+		ctx->nr_sorted++;
 		if (rq_mergeable(rq)) {
-			elv_rqhash_add(q, rq);
-			if (!q->last_merge)
-				q->last_merge = rq;
+			elv_rqhash_add(ctx, rq);
+			if (!ctx->last_merge)
+				ctx->last_merge = rq;
 		}
 
 		/*
 		 * Some ioscheds (cfq) run q->request_fn directly, so
 		 * rq cannot be accessed after calling
 		 * elevator_add_req_fn.
 		 */
-		q->elevator->type->ops.elevator_add_req_fn(q, rq);
+		ctx->queue->elevator->type->ops.elevator_add_req_fn(ctx, rq);
 		break;
 
 	case ELEVATOR_INSERT_FLUSH:
 		rq->cmd_flags |= REQ_SOFTBARRIER;
 		blk_insert_flush(rq);
 		break;
 	default:
 		printk(KERN_ERR "%s: bad insertion point %d\n",
 		       __func__, where);
 		BUG();
 	}
 }
 EXPORT_SYMBOL(__elv_add_request);
 
-void elv_add_request(struct request_queue *q, struct request *rq, int where)
+void elv_add_request(struct request *rq, int where)
 {
+	struct blk_queue_ctx *ctx = rq->queue_ctx;
 	unsigned long flags;
 
-	spin_lock_irqsave(q->queue_lock, flags);
-	__elv_add_request(q, rq, where);
-	spin_unlock_irqrestore(q->queue_lock, flags);
+	spin_lock_irqsave(&ctx->lock, flags);
+	__elv_add_request(rq, where);
+	spin_unlock_irqrestore(&ctx->lock, flags);
 }
 EXPORT_SYMBOL(elv_add_request);
 
-struct request *elv_latter_request(struct request_queue *q, struct request *rq)
+struct request *elv_latter_request(struct blk_queue_ctx *ctx, struct request *rq)
 {
-	struct elevator_queue *e = q->elevator;
+	struct elevator_queue *e = ctx->queue->elevator;
 
 	if (e->type->ops.elevator_latter_req_fn)
-		return e->type->ops.elevator_latter_req_fn(q, rq);
+		return e->type->ops.elevator_latter_req_fn(ctx, rq);
 	return NULL;
 }
 
-struct request *elv_former_request(struct request_queue *q, struct request *rq)
+struct request *elv_former_request(struct blk_queue_ctx *ctx, struct request *rq)
 {
-	struct elevator_queue *e = q->elevator;
+	struct elevator_queue *e = ctx->queue->elevator;
 
 	if (e->type->ops.elevator_former_req_fn)
-		return e->type->ops.elevator_former_req_fn(q, rq);
+		return e->type->ops.elevator_former_req_fn(ctx, rq);
 	return NULL;
 }
 
-int elv_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
+int elv_set_request(struct blk_queue_ctx *ctx, struct request *rq, gfp_t gfp_mask)
 {
-	struct elevator_queue *e = q->elevator;
+	struct elevator_queue *e = ctx->queue->elevator;
 
 	if (e->type->ops.elevator_set_req_fn)
-		return e->type->ops.elevator_set_req_fn(q, rq, gfp_mask);
+		return e->type->ops.elevator_set_req_fn(ctx, rq, gfp_mask);
 	return 0;
 }
 
-void elv_put_request(struct request_queue *q, struct request *rq)
+void elv_put_request(struct blk_queue_ctx *ctx, struct request *rq)
 {
-	struct elevator_queue *e = q->elevator;
+	struct elevator_queue *e = ctx->queue->elevator;
 
 	if (e->type->ops.elevator_put_req_fn)
 		e->type->ops.elevator_put_req_fn(rq);
 }
 
 int elv_may_queue(struct request_queue *q, int rw)
 {
 	struct elevator_queue *e = q->elevator;
 
@@ -733,30 +796,31 @@ void elv_abort_queue(struct request_queue *q)
 		 * Mark this request as started so we don't trigger
 		 * any debug logic in the end I/O path.
 		 */
 		blk_start_request(rq);
 		__blk_end_request_all(rq, -EIO);
 	}
 }
 EXPORT_SYMBOL(elv_abort_queue);
 
-void elv_completed_request(struct request_queue *q, struct request *rq)
+void elv_completed_request(struct request *rq)
 {
-	struct elevator_queue *e = q->elevator;
+	struct blk_queue_ctx *ctx = rq->queue_ctx;
+	struct elevator_queue *e = ctx->queue->elevator;
 
 	/*
 	 * request is released from the driver, io must be done
 	 */
 	if (blk_account_rq(rq)) {
-		q->in_flight[rq_is_sync(rq)]--;
+		ctx->in_flight[rq_is_sync(rq)]--;
 		if ((rq->cmd_flags & REQ_SORTED) &&
 		    e->type->ops.elevator_completed_req_fn)
-			e->type->ops.elevator_completed_req_fn(q, rq);
+			e->type->ops.elevator_completed_req_fn(ctx, rq);
 	}
 }
 
 #define to_elv(atr) container_of((atr), struct elv_fs_entry, attr)
 
 static ssize_t
 elv_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
 {
 	struct elv_fs_entry *entry = to_elv(attr);
@@ -909,19 +973,19 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
 {
 	struct elevator_queue *old_elevator, *e;
 	int err;
 
 	/* allocate new elevator */
 	e = elevator_alloc(q, new_e);
 	if (!e)
 		return -ENOMEM;
 
-	err = elevator_init_queue(q, e);
+	err = elevator_init_queue(q, e, 1);
 	if (err) {
 		kobject_put(&e->kobj);
 		return err;
 	}
 
 	/* turn on BYPASS and drain all requests w/ elevator private data */
 	elv_quiesce_start(q);
 
 	/* unregister old queue, register new one and kill old elevator */
@@ -933,31 +997,31 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
 	}
 
 	/* done, clear io_cq's, switch elevators and turn off BYPASS */
 	spin_lock_irq(q->queue_lock);
 	ioc_clear_queue(q);
 	old_elevator = q->elevator;
 	q->elevator = e;
 	spin_unlock_irq(q->queue_lock);
 
-	elevator_exit(old_elevator);
+	elevator_exit(q, old_elevator);
 	elv_quiesce_end(q);
 
 	blk_add_trace_msg(q, "elv switch: %s", e->type->elevator_name);
 
 	return 0;
 
 fail_register:
 	/*
 	 * switch failed, exit the new io scheduler and reattach the old
 	 * one again (along with re-adding the sysfs dir)
 	 */
-	elevator_exit(e);
+	elevator_exit(q, e);
 	elv_register_queue(q);
 	elv_quiesce_end(q);
 
 	return err;
 }
 
 /*
  * Switch this queue to the given IO scheduler.
  */
@@ -1020,32 +1084,30 @@ ssize_t elv_iosched_show(struct request_queue *q, char *name)
 		else
 			len += sprintf(name+len, "%s ", __e->elevator_name);
 	}
 	spin_unlock(&elv_list_lock);
 
 	len += sprintf(len+name, "\n");
 	return len;
 }
 
-struct request *elv_rb_former_request(struct request_queue *q,
-				      struct request *rq)
+struct request *elv_rb_former_request(struct request *rq)
 {
 	struct rb_node *rbprev = rb_prev(&rq->rb_node);
 
 	if (rbprev)
 		return rb_entry_rq(rbprev);
 
 	return NULL;
 }
 EXPORT_SYMBOL(elv_rb_former_request);
 
-struct request *elv_rb_latter_request(struct request_queue *q,
-				      struct request *rq)
+struct request *elv_rb_latter_request(struct request *rq)
 {
 	struct rb_node *rbnext = rb_next(&rq->rb_node);
 
 	if (rbnext)
 		return rb_entry_rq(rbnext);
 
 	return NULL;
 }
 EXPORT_SYMBOL(elv_rb_latter_request);
diff --git a/block/noop-iosched.c b/block/noop-iosched.c
index 413a0b1..d36d867 100644
--- a/block/noop-iosched.c
+++ b/block/noop-iosched.c
@@ -1,87 +1,121 @@
 /*
  * elevator noop
  */
 #include <linux/blkdev.h>
+#include <linux/blk-mq.h>
 #include <linux/elevator.h>
 #include <linux/bio.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 
 struct noop_data {
 	struct list_head queue;
 };
 
-static void noop_merged_requests(struct request_queue *q, struct request *rq,
+static void noop_merged_requests(struct blk_queue_ctx *ctx, struct request *rq,
 				 struct request *next)
 {
+	lockdep_assert_held(&ctx->lock);
 	list_del_init(&next->queuelist);
 }
 
 static int noop_dispatch(struct request_queue *q, int force)
 {
-	struct noop_data *nd = q->elevator->elevator_data;
+	struct blk_queue_ctx *ctx;
+	struct noop_data *nd;
+	unsigned int i, dispatched = 0;
 
-	if (!list_empty(&nd->queue)) {
+	/*
+	 * This obviously needs to me made more clever...
+	 */
+	queue_for_each_ctx(q, ctx, i) {
 		struct request *rq;
+
+		nd = ctx->elevator_data;
+		if (list_empty(&nd->queue))
+			continue;
+
+		spin_lock(&ctx->lock);
 		rq = list_entry(nd->queue.next, struct request, queuelist);
 		list_del_init(&rq->queuelist);
-		elv_dispatch_sort(q, rq);
-		return 1;
+		BUG_ON(rq->queue_ctx != ctx);
+		elv_dispatch_sort(q, ctx, rq);
+		spin_unlock(&ctx->lock);
+		dispatched++;
 	}
-	return 0;
+
+	return dispatched;
 }
 
-static void noop_add_request(struct request_queue *q, struct request *rq)
+static void noop_add_request(struct blk_queue_ctx *ctx, struct request *rq)
 {
-	struct noop_data *nd = q->elevator->elevator_data;
+	struct noop_data *nd = ctx->elevator_data;
 
+	lockdep_assert_held(&ctx->lock);
 	list_add_tail(&rq->queuelist, &nd->queue);
 }
 
 static struct request *
-noop_former_request(struct request_queue *q, struct request *rq)
+noop_former_request(struct blk_queue_ctx *ctx, struct request *rq)
 {
-	struct noop_data *nd = q->elevator->elevator_data;
+	struct noop_data *nd = ctx->elevator_data;
 
 	if (rq->queuelist.prev == &nd->queue)
 		return NULL;
 	return list_entry(rq->queuelist.prev, struct request, queuelist);
 }
 
 static struct request *
-noop_latter_request(struct request_queue *q, struct request *rq)
+noop_latter_request(struct blk_queue_ctx *ctx, struct request *rq)
 {
-	struct noop_data *nd = q->elevator->elevator_data;
+	struct noop_data *nd = ctx->elevator_data;
 
 	if (rq->queuelist.next == &nd->queue)
 		return NULL;
 	return list_entry(rq->queuelist.next, struct request, queuelist);
 }
 
-static void *noop_init_queue(struct request_queue *q)
+static int noop_init_queue(struct request_queue *q, unsigned int nr_queues)
 {
 	struct noop_data *nd;
+	unsigned int i;
 
-	nd = kmalloc_node(sizeof(*nd), GFP_KERNEL, q->node);
-	if (!nd)
-		return NULL;
-	INIT_LIST_HEAD(&nd->queue);
-	return nd;
+	for (i = 0; i < nr_queues; i++) {
+		nd = kmalloc_node(sizeof(*nd), GFP_KERNEL, q->node);
+		if (!nd)
+			goto cleanup;
+
+		INIT_LIST_HEAD(&nd->queue);
+		blk_get_ctx(q, i)->elevator_data = nd;
+	}
+
+	return 0;
+
+cleanup:
+	while (i--)
+		kfree(blk_get_ctx(q, i)->elevator_data);
+
+	return -ENOMEM;
 }
 
-static void noop_exit_queue(struct elevator_queue *e)
+static void noop_exit_queue(struct request_queue *q, struct elevator_queue *e)
 {
-	struct noop_data *nd = e->elevator_data;
+	struct blk_queue_ctx *ctx;
+	unsigned int i;
+
+	queue_for_each_ctx(q, ctx, i) {
+		struct noop_data *nd = ctx->elevator_data;
 
-	BUG_ON(!list_empty(&nd->queue));
-	kfree(nd);
+		BUG_ON(!list_empty(&nd->queue));
+		kfree(nd);
+	}
 }
 
 static struct elevator_type elevator_noop = {
 	.ops = {
 		.elevator_merge_req_fn		= noop_merged_requests,
 		.elevator_dispatch_fn		= noop_dispatch,
 		.elevator_add_req_fn		= noop_add_request,
 		.elevator_former_req_fn		= noop_former_request,
 		.elevator_latter_req_fn		= noop_latter_request,
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 061427a..7d07b44 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -9,18 +9,19 @@
  *
  * This file is released under GPLv2 or later.
  *
  * (part of code stolen from loop.c)
  */
 
 #include <linux/major.h>
 
 #include <linux/blkdev.h>
+#include <linux/blk-mq.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/bio.h>
 #include <linux/stat.h>
 #include <linux/errno.h>
 #include <linux/file.h>
 #include <linux/ioctl.h>
@@ -98,19 +99,19 @@ static const char *nbdcmd_to_ascii(int cmd)
 	case  NBD_CMD_DISC: return "disconnect";
 	}
 	return "invalid";
 }
 #endif /* NDEBUG */
 
 static void nbd_end_request(struct request *req)
 {
 	int error = req->errors ? -EIO : 0;
-	struct request_queue *q = req->q;
+	struct request_queue *q = req->queue_ctx->queue;
 	unsigned long flags;
 
 	dprintk(DBG_BLKDEV, "%s: request %p: %s\n", req->rq_disk->disk_name,
 			req, error ? "failed" : "done");
 
 	spin_lock_irqsave(q->queue_lock, flags);
 	__blk_end_request_all(req, error);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 0d39f2f..0894e14 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -152,19 +152,19 @@ static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
 	/*
 	 * If this is a packet command we need a couple of additional headers.
 	 * Behind the normal outhdr we put a segment with the scsi command
 	 * block, and before the normal inhdr we put the sense data and the
 	 * inhdr with additional status information before the normal inhdr.
 	 */
 	if (vbr->req->cmd_type == REQ_TYPE_BLOCK_PC)
 		sg_set_buf(&vblk->sg[out++], vbr->req->cmd, vbr->req->cmd_len);
 
-	num = blk_rq_map_sg(q, vbr->req, vblk->sg + out);
+	num = blk_rq_map_sg(vbr->req, vblk->sg + out);
 
 	if (vbr->req->cmd_type == REQ_TYPE_BLOCK_PC) {
 		sg_set_buf(&vblk->sg[num + out + in++], vbr->req->sense, SCSI_SENSE_BUFFERSIZE);
 		sg_set_buf(&vblk->sg[num + out + in++], &vbr->in_hdr,
 			   sizeof(vbr->in_hdr));
 	}
 
 	sg_set_buf(&vblk->sg[num + out + in++], &vbr->status,
 		   sizeof(vbr->status));
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e24143c..b41345b 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -13,18 +13,19 @@
 #include <linux/mutex.h>
 #include <linux/moduleparam.h>
 #include <linux/blkpg.h>
 #include <linux/bio.h>
 #include <linux/mempool.h>
 #include <linux/slab.h>
 #include <linux/idr.h>
 #include <linux/hdreg.h>
 #include <linux/delay.h>
+#include <linux/blk-mq.h>
 
 #include <trace/events/block.h>
 
 #define DM_MSG_PREFIX "core"
 
 #ifdef CONFIG_PRINTK
 /*
  * ratelimit state to be used in DMXXX_LIMIT().
  */
@@ -813,19 +814,19 @@ static void dm_unprep_request(struct request *rq)
 /*
  * Requeue the original request of a clone.
  */
 void dm_requeue_unmapped_request(struct request *clone)
 {
 	int rw = rq_data_dir(clone);
 	struct dm_rq_target_io *tio = clone->end_io_data;
 	struct mapped_device *md = tio->md;
 	struct request *rq = tio->orig;
-	struct request_queue *q = rq->q;
+	struct request_queue *q = rq->queue_ctx->queue;
 	unsigned long flags;
 
 	dm_unprep_request(rq);
 
 	spin_lock_irqsave(q->queue_lock, flags);
 	blk_requeue_request(q, rq);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
 	rq_completed(md, rw, 0);
@@ -935,19 +936,19 @@ EXPORT_SYMBOL_GPL(dm_kill_unmapped_request);
  */
 static void end_clone_request(struct request *clone, int error)
 {
 	/*
 	 * For just cleaning up the information of the queue in which
 	 * the clone was dispatched.
 	 * The clone is *NOT* freed actually here because it is alloced from
 	 * dm own mempool and REQ_ALLOCED isn't set in clone->cmd_flags.
 	 */
-	__blk_put_request(clone->q, clone);
+	__blk_put_request(clone);
 
 	/*
 	 * Actual request completion is done in a softirq context which doesn't
 	 * hold the queue lock.  Otherwise, deadlock could occur because:
 	 *     - another request may be submitted by the upper level driver
 	 *       of the stacking during the completion
 	 *     - the submission which requires queue lock may be done
 	 *       against this queue
 	 */
@@ -1442,23 +1443,23 @@ static void dm_request(struct request_queue *q, struct bio *bio)
 		blk_queue_bio(q, bio);
 	else
 		_dm_request(q, bio);
 }
 
 void dm_dispatch_request(struct request *rq)
 {
 	int r;
 
-	if (blk_queue_io_stat(rq->q))
+	if (blk_queue_io_stat(rq->queue_ctx->queue))
 		rq->cmd_flags |= REQ_IO_STAT;
 
 	rq->start_time = jiffies;
-	r = blk_insert_cloned_request(rq->q, rq);
+	r = blk_insert_cloned_request(rq->queue_ctx->queue, rq);
 	if (r)
 		dm_complete_request(rq, r);
 }
 EXPORT_SYMBOL_GPL(dm_dispatch_request);
 
 static void dm_rq_bio_destructor(struct bio *bio)
 {
 	struct dm_rq_clone_bio_info *info = bio->bi_private;
 	struct mapped_device *md = info->tio->md;
@@ -1577,19 +1578,19 @@ static int map_request(struct dm_target *ti, struct request *clone,
 
 	tio->ti = ti;
 	r = ti->type->map_rq(ti, clone, &tio->info);
 	switch (r) {
 	case DM_MAPIO_SUBMITTED:
 		/* The target has taken the I/O to submit by itself later */
 		break;
 	case DM_MAPIO_REMAPPED:
 		/* The target has remapped the I/O so dispatch it */
-		trace_block_rq_remap(clone->q, clone, disk_devt(dm_disk(md)),
+		trace_block_rq_remap(clone->queue_ctx->queue, clone, disk_devt(dm_disk(md)),
 				     blk_rq_pos(tio->orig));
 		dm_dispatch_request(clone);
 		break;
 	case DM_MAPIO_REQUEUE:
 		/* The target wants to requeue the I/O */
 		dm_requeue_unmapped_request(clone);
 		requeued = 1;
 		break;
 	default:
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 386f0c5..f4765eb 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1594,19 +1594,19 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		/*
 		 * no more retries - report this one back to upper level.
 		 */
 		return SUCCESS;
 	}
 }
 
 static void eh_lock_door_done(struct request *req, int uptodate)
 {
-	__blk_put_request(req->q, req);
+	__blk_put_request(req);
 }
 
 /**
  * scsi_eh_lock_door - Prevent medium removal for the specified device
  * @sdev:	SCSI device to prevent medium removal
  *
  * Locking:
  * 	We must be called from process context.
  *
@@ -1632,19 +1632,20 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
 	req->cmd[5] = 0;
 
 	req->cmd_len = COMMAND_SIZE(req->cmd[0]);
 
 	req->cmd_type = REQ_TYPE_BLOCK_PC;
 	req->cmd_flags |= REQ_QUIET;
 	req->timeout = 10 * HZ;
 	req->retries = 5;
 
-	blk_execute_rq_nowait(req->q, NULL, req, 1, eh_lock_door_done);
+	blk_execute_rq_nowait(sdev->request_queue, NULL, req, 1,
+				eh_lock_door_done);
 }
 
 /**
  * scsi_restart_operations - restart io operations to the specified host.
  * @shost:	Host we are restarting.
  *
  * Notes:
  *    When we entered the error handler, we blocked all further i/o to
  *    this device.  we need to 'reverse' this process.
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ead6405..b3fa509 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -228,19 +228,19 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	req->sense_len = 0;
 	req->retries = retries;
 	req->timeout = timeout;
 	req->cmd_type = REQ_TYPE_BLOCK_PC;
 	req->cmd_flags |= flags | REQ_QUIET | REQ_PREEMPT;
 
 	/*
 	 * head injection *required* here otherwise quiesce won't work
 	 */
-	blk_execute_rq(req->q, NULL, req, 1);
+	blk_execute_rq(sdev->request_queue, NULL, req, 1);
 
 	/*
 	 * Some devices (USB mass-storage in particular) may transfer
 	 * garbage data together with a residue indicating that the data
 	 * is invalid.  Prevent the garbage from being misinterpreted
 	 * and prevent security leaks by zeroing out the excess data.
 	 */
 	if (unlikely(req->resid_len > 0 && req->resid_len <= bufflen))
 		memset(buffer + (bufflen - req->resid_len), 0, req->resid_len);
@@ -980,19 +980,19 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
 		return BLKPREP_DEFER;
 	}
 
 	req->buffer = NULL;
 
 	/* 
 	 * Next, walk the list, and fill in the addresses and sizes of
 	 * each segment.
 	 */
-	count = blk_rq_map_sg(req->q, req, sdb->table.sgl);
+	count = blk_rq_map_sg(req, sdb->table.sgl);
 	BUG_ON(count > sdb->table.nents);
 	sdb->table.nents = count;
 	sdb->length = blk_rq_bytes(req);
 	return BLKPREP_OK;
 }
 
 /*
  * Function:    scsi_init_io()
  *
@@ -1022,32 +1022,33 @@ int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 
 		rq->next_rq->special = bidi_sdb;
 		error = scsi_init_sgtable(rq->next_rq, bidi_sdb, GFP_ATOMIC);
 		if (error)
 			goto err_exit;
 	}
 
 	if (blk_integrity_rq(rq)) {
 		struct scsi_data_buffer *prot_sdb = cmd->prot_sdb;
+		struct request_queue *q = rq->queue_ctx->queue;
 		int ivecs, count;
 
 		BUG_ON(prot_sdb == NULL);
-		ivecs = blk_rq_count_integrity_sg(rq->q, rq->bio);
+		ivecs = blk_rq_count_integrity_sg(q, rq->bio);
 
 		if (scsi_alloc_sgtable(prot_sdb, ivecs, gfp_mask)) {
 			error = BLKPREP_DEFER;
 			goto err_exit;
 		}
 
-		count = blk_rq_map_integrity_sg(rq->q, rq->bio,
+		count = blk_rq_map_integrity_sg(q, rq->bio,
 						prot_sdb->table.sgl);
 		BUG_ON(unlikely(count > ivecs));
-		BUG_ON(unlikely(count > queue_max_integrity_segments(rq->q)));
+		BUG_ON(unlikely(count > queue_max_integrity_segments(q)));
 
 		cmd->prot_sdb = prot_sdb;
 		cmd->prot_sdb->table.nents = count;
 	}
 
 	return BLKPREP_OK ;
 
 err_exit:
 	scsi_release_buffers(cmd);
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 80fbe2a..d32564a 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3657,26 +3657,27 @@ fc_bsg_job_timeout(struct request *req)
 		return BLK_EH_NOT_HANDLED;
 	else
 		return BLK_EH_HANDLED;
 }
 
 static int
 fc_bsg_map_buffer(struct fc_bsg_buffer *buf, struct request *req)
 {
 	size_t sz = (sizeof(struct scatterlist) * req->nr_phys_segments);
+	struct request_queue *q = req->queue_ctx->queue;
 
 	BUG_ON(!req->nr_phys_segments);
 
 	buf->sg_list = kzalloc(sz, GFP_KERNEL);
 	if (!buf->sg_list)
 		return -ENOMEM;
 	sg_init_table(buf->sg_list, req->nr_phys_segments);
-	buf->sg_cnt = blk_rq_map_sg(req->q, req, buf->sg_list);
+	buf->sg_cnt = blk_rq_map_sg(q, req, buf->sg_list);
 	buf->payload_len = blk_rq_bytes(req);
 	return 0;
 }
 
 
 /**
  * fc_req_to_bsgjob - Allocate/create the fc_bsg_job structure for the
  *                   bsg request
  * @shost:	SCSI Host corresponding to the bsg object
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
new file mode 100644
index 0000000..a6f6ae4
--- /dev/null
+++ b/include/linux/blk-mq.h
@@ -0,0 +1,97 @@
+#ifndef BLK_MQ_H
+#define BLK_MQ_H
+
+#include <linux/blkdev.h>
+
+struct request_list {
+	/*
+	 * count[], starved[], and wait[] are indexed by
+	 * BLK_RW_SYNC/BLK_RW_ASYNC
+	 */
+	int count[2];
+	int starved[2];
+	int elvpriv;
+	wait_queue_head_t wait[2];
+};
+
+struct blk_queue_ctx {
+	spinlock_t		lock;
+	void			*elevator_data;
+	struct request_queue	*queue;
+	struct hlist_head	*hash;
+
+	struct request		*last_merge;
+
+	/*
+	 * the queue request freelist, one for reads and one for writes
+	 */
+	struct request_list	rl;
+
+	unsigned int		nr_sorted;
+	unsigned int		in_flight[2];
+
+	struct list_head	timeout_list;
+};
+
+
+static inline struct blk_queue_ctx *blk_get_ctx(struct request_queue *q, int nr)
+{
+	BUG_ON(nr >= q->nr_queues);
+
+	return &q->queue_ctx[nr];
+}
+
+#define queue_for_each_ctx(q, ctx, i)					\
+	for (i = 0, ctx = &(q)->queue_ctx[0];				\
+		i < (q)->nr_queues; i++, ctx++)				\
+
+#define blk_ctx_sum(q, sum)						\
+({									\
+	struct blk_queue_ctx *__ctx;					\
+	unsigned int __ret = 0, __i;					\
+									\
+	queue_for_each_ctx((q), __ctx, __i)				\
+		__ret += sum;						\
+	__ret;								\
+})
+
+static inline int __queue_in_flight(struct request_queue *q, int index)
+{
+	return blk_ctx_sum(q, __ctx->in_flight[index]);
+}
+
+static inline int queue_in_flight(struct request_queue *q)
+{
+	return blk_ctx_sum(q, __ctx->in_flight[0] + __ctx->in_flight[1]);
+}
+
+static inline int queue_rq_queued(struct request_queue *q)
+{
+	return blk_ctx_sum(q, __ctx->rl.count[0] + __ctx->rl.count[1]);
+}
+
+static inline int queue_rq_starved(struct request_queue *q)
+{
+	return blk_ctx_sum(q, __ctx->rl.starved[0] + __ctx->rl.starved[1]);
+}
+
+static inline int queue_elvpriv(struct request_queue *q)
+{
+	return blk_ctx_sum(q, __ctx->rl.elvpriv);
+}
+
+static inline void queue_ctx_lock_queue(struct request_queue *q,
+					struct blk_queue_ctx *ctx)
+{
+	spin_unlock(&ctx->lock);
+	spin_lock(q->queue_lock);
+}
+
+static inline void queue_ctx_unlock_queue(struct request_queue *q,
+					  struct blk_queue_ctx *ctx)
+{
+	spin_unlock(q->queue_lock);
+	spin_lock(&ctx->lock);
+}
+
+#endif
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2aa2466..6a3ab7a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -32,30 +32,18 @@ struct request;
 struct sg_io_hdr;
 struct bsg_job;
 
 #define BLKDEV_MIN_RQ	4
 #define BLKDEV_MAX_RQ	128	/* Default maximum */
 
 struct request;
 typedef void (rq_end_io_fn)(struct request *, int);
 
-struct request_list {
-	/*
-	 * count[], starved[], and wait[] are indexed by
-	 * BLK_RW_SYNC/BLK_RW_ASYNC
-	 */
-	int count[2];
-	int starved[2];
-	int elvpriv;
-	mempool_t *rq_pool;
-	wait_queue_head_t wait[2];
-};
-
 /*
  * request command types
  */
 enum rq_cmd_type_bits {
 	REQ_TYPE_FS		= 1,	/* fs request */
 	REQ_TYPE_BLOCK_PC,		/* scsi command */
 	REQ_TYPE_SENSE,			/* sense request */
 	REQ_TYPE_PM_SUSPEND,		/* suspend request */
 	REQ_TYPE_PM_RESUME,		/* resume request */
@@ -75,19 +63,19 @@ enum rq_cmd_type_bits {
 /*
  * try to put the fields that are referenced together in the same cacheline.
  * if you modify this structure, be sure to check block/blk-core.c:blk_rq_init()
  * as well!
  */
 struct request {
 	struct list_head queuelist;
 	struct call_single_data csd;
 
-	struct request_queue *q;
+	struct blk_queue_ctx *queue_ctx;
 
 	unsigned int cmd_flags;
 	enum rq_cmd_type_bits cmd_type;
 	unsigned long atomic_flags;
 
 	int cpu;
 
 	/* the following two fields are internal, NEVER access directly */
 	unsigned int __data_len;	/* total data len */
@@ -266,25 +254,24 @@ struct queue_limits {
 	unsigned char		cluster;
 	unsigned char		discard_zeroes_data;
 };
 
 struct request_queue {
 	/*
 	 * Together with queue_head for cacheline sharing
 	 */
 	struct list_head	queue_head;
-	struct request		*last_merge;
 	struct elevator_queue	*elevator;
 
-	/*
-	 * the queue request freelist, one for reads and one for writes
-	 */
-	struct request_list	rq;
+	struct blk_queue_ctx	*queue_ctx;
+	unsigned int		nr_queues;
+
+	mempool_t		*rq_pool;
 
 	request_fn_proc		*request_fn;
 	make_request_fn		*make_request_fn;
 	prep_rq_fn		*prep_rq_fn;
 	unprep_rq_fn		*unprep_rq_fn;
 	merge_bvec_fn		*merge_bvec_fn;
 	softirq_done_fn		*softirq_done_fn;
 	rq_timed_out_fn		*rq_timed_out_fn;
 	dma_drain_needed_fn	*dma_drain_needed;
@@ -338,34 +325,29 @@ struct request_queue {
 	 */
 	struct kobject kobj;
 
 	/*
 	 * queue settings
 	 */
 	unsigned long		nr_requests;	/* Max # of requests */
 	unsigned int		nr_congestion_on;
 	unsigned int		nr_congestion_off;
-	unsigned int		nr_batching;
 
 	unsigned int		dma_drain_size;
 	void			*dma_drain_buffer;
 	unsigned int		dma_pad_mask;
 	unsigned int		dma_alignment;
 
 	struct blk_queue_tag	*queue_tags;
 	struct list_head	tag_busy_list;
 
-	unsigned int		nr_sorted;
-	unsigned int		in_flight[2];
-
 	unsigned int		rq_timeout;
 	struct timer_list	timeout;
-	struct list_head	timeout_list;
 
 	struct list_head	icq_list;
 
 	struct queue_limits	limits;
 
 	/*
 	 * sg stuff
 	 */
 	unsigned int		sg_timeout;
@@ -470,23 +452,18 @@ static inline void queue_flag_set(unsigned int flag, struct request_queue *q)
 	__set_bit(flag, &q->queue_flags);
 }
 
 static inline void queue_flag_clear_unlocked(unsigned int flag,
 					     struct request_queue *q)
 {
 	__clear_bit(flag, &q->queue_flags);
 }
 
-static inline int queue_in_flight(struct request_queue *q)
-{
-	return q->in_flight[0] + q->in_flight[1];
-}
-
 static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 {
 	queue_lockdep_assert_held(q);
 	__clear_bit(flag, &q->queue_flags);
 }
 
 #define blk_queue_tagged(q)	test_bit(QUEUE_FLAG_QUEUED, &(q)->queue_flags)
 #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
 #define blk_queue_dead(q)	test_bit(QUEUE_FLAG_DEAD, &(q)->queue_flags)
@@ -657,21 +634,21 @@ extern void rq_flush_dcache_pages(struct request *rq);
 #else
 static inline void rq_flush_dcache_pages(struct request *rq)
 {
 }
 #endif
 
 extern int blk_register_queue(struct gendisk *disk);
 extern void blk_unregister_queue(struct gendisk *disk);
 extern void generic_make_request(struct bio *bio);
-extern void blk_rq_init(struct request_queue *q, struct request *rq);
+extern void blk_rq_init(struct blk_queue_ctx *ctx, struct request *rq);
 extern void blk_put_request(struct request *);
-extern void __blk_put_request(struct request_queue *, struct request *);
+extern void __blk_put_request(struct request *);
 extern struct request *blk_get_request(struct request_queue *, int, gfp_t);
 extern struct request *blk_make_request(struct request_queue *, struct bio *,
 					gfp_t);
 extern void blk_requeue_request(struct request_queue *, struct request *);
 extern void blk_add_request_payload(struct request *rq, struct page *page,
 		unsigned int len);
 extern int blk_rq_check_limits(struct request_queue *q, struct request *rq);
 extern int blk_lld_busy(struct request_queue *q);
 extern int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
@@ -809,19 +786,20 @@ extern void blk_complete_request(struct request *);
 extern void __blk_complete_request(struct request *);
 extern void blk_abort_request(struct request *);
 extern void blk_abort_queue(struct request_queue *);
 extern void blk_unprep_request(struct request *);
 
 /*
  * Access functions for manipulating queue properties
  */
 extern struct request_queue *blk_init_queue_node(request_fn_proc *rfn,
-					spinlock_t *lock, int node_id);
+					spinlock_t *lock, int node_id,
+					unsigned int nr_queues);
 extern struct request_queue *blk_init_queue(request_fn_proc *, spinlock_t *);
 extern struct request_queue *blk_init_allocated_queue(struct request_queue *,
 						      request_fn_proc *, spinlock_t *);
 extern void blk_cleanup_queue(struct request_queue *);
 extern void blk_queue_make_request(struct request_queue *, make_request_fn *);
 extern void blk_queue_bounce_limit(struct request_queue *, u64);
 extern void blk_limits_max_hw_sectors(struct queue_limits *, unsigned int);
 extern void blk_queue_max_hw_sectors(struct request_queue *, unsigned int);
 extern void blk_queue_max_segments(struct request_queue *, unsigned short);
@@ -858,25 +836,25 @@ extern void blk_queue_merge_bvec(struct request_queue *, merge_bvec_fn *);
 extern void blk_queue_dma_alignment(struct request_queue *, int);
 extern void blk_queue_update_dma_alignment(struct request_queue *, int);
 extern void blk_queue_softirq_done(struct request_queue *, softirq_done_fn *);
 extern void blk_queue_rq_timed_out(struct request_queue *, rq_timed_out_fn *);
 extern void blk_queue_rq_timeout(struct request_queue *, unsigned int);
 extern void blk_queue_flush(struct request_queue *q, unsigned int flush);
 extern void blk_queue_flush_queueable(struct request_queue *q, bool queueable);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
 
-extern int blk_rq_map_sg(struct request_queue *, struct request *, struct scatterlist *);
+extern int blk_rq_map_sg(struct request *, struct scatterlist *);
 extern void blk_dump_rq_flags(struct request *, char *);
 extern long nr_blockdev_pages(void);
 
 bool __must_check blk_get_queue(struct request_queue *);
 struct request_queue *blk_alloc_queue(gfp_t);
-struct request_queue *blk_alloc_queue_node(gfp_t, int);
+struct request_queue *blk_alloc_queue_node(gfp_t, int, unsigned int);
 extern void blk_put_queue(struct request_queue *);
 
 /*
  * blk_plug permits building a queue of related requests by holding the I/O
  * fragments for a short period. This allows merging of sequential requests
  * into single larger request. As the requests are moved from a per-task list to
  * the device's request_queue in a batch, this results in improved scalability
  * as the lock contention for request_queue lock is reduced.
  *
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 7d4e035..6bb2096 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -1,46 +1,47 @@
 #ifndef _LINUX_ELEVATOR_H
 #define _LINUX_ELEVATOR_H
 
 #include <linux/percpu.h>
 
 #ifdef CONFIG_BLOCK
 
 struct io_cq;
+struct blk_queue_ctx;
 
-typedef int (elevator_merge_fn) (struct request_queue *, struct request **,
+typedef int (elevator_merge_fn) (struct blk_queue_ctx *, struct request **,
 				 struct bio *);
 
-typedef void (elevator_merge_req_fn) (struct request_queue *, struct request *, struct request *);
+typedef void (elevator_merge_req_fn) (struct blk_queue_ctx *, struct request *, struct request *);
 
-typedef void (elevator_merged_fn) (struct request_queue *, struct request *, int);
+typedef void (elevator_merged_fn) (struct blk_queue_ctx *, struct request *, int);
 
-typedef int (elevator_allow_merge_fn) (struct request_queue *, struct request *, struct bio *);
+typedef int (elevator_allow_merge_fn) (struct blk_queue_ctx *, struct request *, struct bio *);
 
-typedef void (elevator_bio_merged_fn) (struct request_queue *,
+typedef void (elevator_bio_merged_fn) (struct blk_queue_ctx *,
 						struct request *, struct bio *);
 
 typedef int (elevator_dispatch_fn) (struct request_queue *, int);
 
-typedef void (elevator_add_req_fn) (struct request_queue *, struct request *);
-typedef struct request *(elevator_request_list_fn) (struct request_queue *, struct request *);
-typedef void (elevator_completed_req_fn) (struct request_queue *, struct request *);
+typedef void (elevator_add_req_fn) (struct blk_queue_ctx *, struct request *);
+typedef struct request *(elevator_request_list_fn) (struct blk_queue_ctx *, struct request *);
+typedef void (elevator_completed_req_fn) (struct blk_queue_ctx *, struct request *);
 typedef int (elevator_may_queue_fn) (struct request_queue *, int);
 
 typedef void (elevator_init_icq_fn) (struct io_cq *);
 typedef void (elevator_exit_icq_fn) (struct io_cq *);
-typedef int (elevator_set_req_fn) (struct request_queue *, struct request *, gfp_t);
+typedef int (elevator_set_req_fn) (struct blk_queue_ctx *, struct request *, gfp_t);
 typedef void (elevator_put_req_fn) (struct request *);
 typedef void (elevator_activate_req_fn) (struct request_queue *, struct request *);
 typedef void (elevator_deactivate_req_fn) (struct request_queue *, struct request *);
 
-typedef void *(elevator_init_fn) (struct request_queue *);
-typedef void (elevator_exit_fn) (struct elevator_queue *);
+typedef int (elevator_init_fn) (struct request_queue *, unsigned int);
+typedef void (elevator_exit_fn) (struct request_queue *, struct elevator_queue *);
 
 struct elevator_ops
 {
 	elevator_merge_fn *elevator_merge_fn;
 	elevator_merged_fn *elevator_merged_fn;
 	elevator_merge_req_fn *elevator_merge_req_fn;
 	elevator_allow_merge_fn *elevator_allow_merge_fn;
 	elevator_bio_merged_fn *elevator_bio_merged_fn;
 
@@ -95,72 +96,71 @@ struct elevator_type
 	struct list_head list;
 };
 
 /*
  * each queue has an elevator_queue associated with it
  */
 struct elevator_queue
 {
 	struct elevator_type *type;
-	void *elevator_data;
 	struct kobject kobj;
 	struct mutex sysfs_lock;
-	struct hlist_head *hash;
 	unsigned int registered:1;
 };
 
 /*
  * block elevator interface
  */
-extern void elv_dispatch_sort(struct request_queue *, struct request *);
-extern void elv_dispatch_add_tail(struct request_queue *, struct request *);
-extern void elv_add_request(struct request_queue *, struct request *, int);
-extern void __elv_add_request(struct request_queue *, struct request *, int);
-extern int elv_merge(struct request_queue *, struct request **, struct bio *);
-extern void elv_merge_requests(struct request_queue *, struct request *,
+extern void elv_dispatch_sort(struct request_queue *, struct blk_queue_ctx *, struct request *);
+extern void elv_dispatch_add_tail(struct request_queue *, struct blk_queue_ctx *, struct request *);
+extern void elv_add_request(struct request *, int);
+extern void __elv_add_request(struct request *, int);
+extern void elv_insert(struct request *, int);
+extern int elv_merge(struct blk_queue_ctx *, struct request **, struct bio *);
+extern void elv_merge_requests(struct blk_queue_ctx *, struct request *,
 			       struct request *);
-extern void elv_merged_request(struct request_queue *, struct request *, int);
-extern void elv_bio_merged(struct request_queue *q, struct request *,
+extern void elv_merged_request(struct blk_queue_ctx *, struct request *, int);
+extern void elv_bio_merged(struct blk_queue_ctx *q, struct request *,
 				struct bio *);
 extern void elv_requeue_request(struct request_queue *, struct request *);
-extern struct request *elv_former_request(struct request_queue *, struct request *);
-extern struct request *elv_latter_request(struct request_queue *, struct request *);
+extern struct request *elv_former_request(struct blk_queue_ctx *, struct request *);
+extern struct request *elv_latter_request(struct blk_queue_ctx *, struct request *);
 extern int elv_register_queue(struct request_queue *q);
 extern void elv_unregister_queue(struct request_queue *q);
 extern int elv_may_queue(struct request_queue *, int);
 extern void elv_abort_queue(struct request_queue *);
-extern void elv_completed_request(struct request_queue *, struct request *);
-extern int elv_set_request(struct request_queue *, struct request *, gfp_t);
-extern void elv_put_request(struct request_queue *, struct request *);
+extern void elv_completed_request(struct request *);
+extern int elv_set_request(struct blk_queue_ctx *, struct request *, gfp_t);
+extern void elv_put_request(struct blk_queue_ctx *, struct request *);
 extern void elv_drain_elevator(struct request_queue *);
 
 /*
  * io scheduler registration
  */
 extern int elv_register(struct elevator_type *);
 extern void elv_unregister(struct elevator_type *);
 
 /*
  * io scheduler sysfs switching
  */
 extern ssize_t elv_iosched_show(struct request_queue *, char *);
 extern ssize_t elv_iosched_store(struct request_queue *, const char *, size_t);
 
 extern int elevator_init(struct request_queue *, char *);
-extern void elevator_exit(struct elevator_queue *);
+extern void elevator_exit(struct request_queue *, struct elevator_queue *);
 extern int elevator_change(struct request_queue *, const char *);
 extern bool elv_rq_merge_ok(struct request *, struct bio *);
 
 /*
  * Helper functions.
  */
-extern struct request *elv_rb_former_request(struct request_queue *, struct request *);
-extern struct request *elv_rb_latter_request(struct request_queue *, struct request *);
+extern struct request *elv_rb_former_request(struct request *);
+extern struct request *elv_rb_latter_request(struct request *);
 
 /*
  * rb support functions.
  */
 extern void elv_rb_add(struct rb_root *, struct request *);
 extern void elv_rb_del(struct rb_root *, struct request *);
 extern struct request *elv_rb_find(struct rb_root *, sector_t);
 
 /*
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 6efb2e1..279c887 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -1,16 +1,17 @@
 #ifndef _SCSI_SCSI_DEVICE_H
 #define _SCSI_SCSI_DEVICE_H
 
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/blkdev.h>
+#include <linux/blk-mq.h>
 #include <scsi/scsi.h>
 #include <linux/atomic.h>
 
 struct device;
 struct request_queue;
 struct scsi_cmnd;
 struct scsi_lun;
 struct scsi_sense_hdr;
 
-- 
1.7.10


--=_4fd91c57.QUPvmKpaiKC7NMbdRYJGnC0mkHZgL2sWbuuLZuxtc33/kohi
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=".config"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.4.0-rc3 Kernel Configuration
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
# CONFIG_KTIME_SCALAR is not set
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_FHANDLE=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
# CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_FANOUT=64
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_RCU_FAST_NO_HZ=y
CONFIG_TREE_RCU_TRACE=y
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_CGROUP_MEM_RES_CTLR=y
CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
# CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED is not set
# CONFIG_CGROUP_MEM_RES_CTLR_KMEM is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_PERF_COUNTERS is not set
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
CONFIG_OPTPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_MQ is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_THROTTLING is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
# CONFIG_ACORN_PARTITION_CUMANA is not set
# CONFIG_ACORN_PARTITION_EESOX is not set
CONFIG_ACORN_PARTITION_ICS=y
# CONFIG_ACORN_PARTITION_ADFS is not set
# CONFIG_ACORN_PARTITION_POWERTEC is not set
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
# CONFIG_MUTEX_SPIN_ON_OWNER is not set
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_SMP=y
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PRIVILEGED_GUEST=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=500
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=512
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_I8K=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=y
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
# CONFIG_CLEANCACHE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_TEST_SUSPEND=y
CONFIG_CAN_PM_TRACE=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
# CONFIG_ACPI_PROC_EVENT is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_BGRT is not set
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
# CONFIG_ACPI_APEI_EINJ is not set
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_PCC_CPUFREQ=y
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_POWERNOW_K8=y
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_P4_CLOCKMOD=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
CONFIG_INTEL_IDLE=y

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
CONFIG_PCIEAER_INJECT=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_XEN_PCIDEV_FRONTEND=y
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=y
CONFIG_I82092=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_FAKE=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=y
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=y
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=y
CONFIG_HOTPLUG_PCI_SHPC=y
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IPGRE=y
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_INET_UDP_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=y
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=y
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=y
CONFIG_TCP_CONG_SCALABLE=y
CONFIG_TCP_CONG_LP=y
CONFIG_TCP_CONG_VENO=y
CONFIG_TCP_CONG_YEAH=y
CONFIG_TCP_CONG_ILLINOIS=y
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_HYBLA is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_VENO is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
CONFIG_INET6_IPCOMP=y
CONFIG_IPV6_MIP6=y
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
CONFIG_IPV6_SIT=y
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
# CONFIG_NETFILTER_NETLINK_ACCT is not set
CONFIG_NETFILTER_NETLINK_QUEUE=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CONNTRACK_TIMEOUT is not set
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CT_PROTO_DCCP=y
CONFIG_NF_CT_PROTO_GRE=y
CONFIG_NF_CT_PROTO_SCTP=y
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=y
CONFIG_NF_CONNTRACK_FTP=y
CONFIG_NF_CONNTRACK_H323=y
CONFIG_NF_CONNTRACK_IRC=y
CONFIG_NF_CONNTRACK_BROADCAST=y
CONFIG_NF_CONNTRACK_NETBIOS_NS=y
CONFIG_NF_CONNTRACK_SNMP=y
CONFIG_NF_CONNTRACK_PPTP=y
CONFIG_NF_CONNTRACK_SANE=y
CONFIG_NF_CONNTRACK_SIP=y
CONFIG_NF_CONNTRACK_TFTP=y
CONFIG_NF_CT_NETLINK=y
# CONFIG_NF_CT_NETLINK_TIMEOUT is not set
CONFIG_NETFILTER_TPROXY=y
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=y
CONFIG_NETFILTER_XT_CONNMARK=y
CONFIG_NETFILTER_XT_SET=y

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=y
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=y
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=y
CONFIG_NETFILTER_XT_TARGET_CONNMARK=y
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=y
CONFIG_NETFILTER_XT_TARGET_CT=y
CONFIG_NETFILTER_XT_TARGET_DSCP=y
CONFIG_NETFILTER_XT_TARGET_HL=y
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=y
CONFIG_NETFILTER_XT_TARGET_LED=y
# CONFIG_NETFILTER_XT_TARGET_LOG is not set
CONFIG_NETFILTER_XT_TARGET_MARK=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=y
CONFIG_NETFILTER_XT_TARGET_NOTRACK=y
CONFIG_NETFILTER_XT_TARGET_RATEEST=y
CONFIG_NETFILTER_XT_TARGET_TEE=y
CONFIG_NETFILTER_XT_TARGET_TPROXY=y
CONFIG_NETFILTER_XT_TARGET_TRACE=y
CONFIG_NETFILTER_XT_TARGET_SECMARK=y
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=y

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=y
CONFIG_NETFILTER_XT_MATCH_CLUSTER=y
CONFIG_NETFILTER_XT_MATCH_COMMENT=y
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=y
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=y
CONFIG_NETFILTER_XT_MATCH_CONNMARK=y
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
CONFIG_NETFILTER_XT_MATCH_CPU=y
CONFIG_NETFILTER_XT_MATCH_DCCP=y
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=y
CONFIG_NETFILTER_XT_MATCH_DSCP=y
CONFIG_NETFILTER_XT_MATCH_ECN=y
CONFIG_NETFILTER_XT_MATCH_ESP=y
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=y
CONFIG_NETFILTER_XT_MATCH_HELPER=y
CONFIG_NETFILTER_XT_MATCH_HL=y
CONFIG_NETFILTER_XT_MATCH_IPRANGE=y
CONFIG_NETFILTER_XT_MATCH_IPVS=y
CONFIG_NETFILTER_XT_MATCH_LENGTH=y
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
CONFIG_NETFILTER_XT_MATCH_MAC=y
CONFIG_NETFILTER_XT_MATCH_MARK=y
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
# CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
CONFIG_NETFILTER_XT_MATCH_OSF=y
CONFIG_NETFILTER_XT_MATCH_OWNER=y
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=y
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=y
CONFIG_NETFILTER_XT_MATCH_QUOTA=y
CONFIG_NETFILTER_XT_MATCH_RATEEST=y
CONFIG_NETFILTER_XT_MATCH_REALM=y
CONFIG_NETFILTER_XT_MATCH_RECENT=y
CONFIG_NETFILTER_XT_MATCH_SCTP=y
CONFIG_NETFILTER_XT_MATCH_SOCKET=y
CONFIG_NETFILTER_XT_MATCH_STATE=y
CONFIG_NETFILTER_XT_MATCH_STATISTIC=y
CONFIG_NETFILTER_XT_MATCH_STRING=y
CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
CONFIG_NETFILTER_XT_MATCH_TIME=y
CONFIG_NETFILTER_XT_MATCH_U32=y
CONFIG_IP_SET=y
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=y
CONFIG_IP_SET_BITMAP_IPMAC=y
CONFIG_IP_SET_BITMAP_PORT=y
CONFIG_IP_SET_HASH_IP=y
CONFIG_IP_SET_HASH_IPPORT=y
CONFIG_IP_SET_HASH_IPPORTIP=y
CONFIG_IP_SET_HASH_IPPORTNET=y
CONFIG_IP_SET_HASH_NET=y
CONFIG_IP_SET_HASH_NETPORT=y
CONFIG_IP_SET_HASH_NETIFACE=y
CONFIG_IP_SET_LIST_SET=y
CONFIG_IP_VS=y
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=y
CONFIG_IP_VS_WRR=y
CONFIG_IP_VS_LC=y
CONFIG_IP_VS_WLC=y
CONFIG_IP_VS_LBLC=y
CONFIG_IP_VS_LBLCR=y
CONFIG_IP_VS_DH=y
CONFIG_IP_VS_SH=y
CONFIG_IP_VS_SED=y
CONFIG_IP_VS_NQ=y

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=y
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=y

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=y
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_AH=y
CONFIG_IP_NF_MATCH_ECN=y
# CONFIG_IP_NF_MATCH_RPFILTER is not set
CONFIG_IP_NF_MATCH_TTL=y
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_ULOG=y
CONFIG_NF_NAT=y
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=y
CONFIG_IP_NF_TARGET_NETMAP=y
CONFIG_IP_NF_TARGET_REDIRECT=y
CONFIG_NF_NAT_SNMP_BASIC=y
CONFIG_NF_NAT_PROTO_DCCP=y
CONFIG_NF_NAT_PROTO_GRE=y
CONFIG_NF_NAT_PROTO_UDPLITE=y
CONFIG_NF_NAT_PROTO_SCTP=y
CONFIG_NF_NAT_FTP=y
CONFIG_NF_NAT_IRC=y
CONFIG_NF_NAT_TFTP=y
CONFIG_NF_NAT_AMANDA=y
CONFIG_NF_NAT_PPTP=y
CONFIG_NF_NAT_H323=y
CONFIG_NF_NAT_SIP=y
CONFIG_IP_NF_MANGLE=y
CONFIG_IP_NF_TARGET_CLUSTERIP=y
CONFIG_IP_NF_TARGET_ECN=y
CONFIG_IP_NF_TARGET_TTL=y
CONFIG_IP_NF_RAW=y
CONFIG_IP_NF_SECURITY=y
CONFIG_IP_NF_ARPTABLES=y
CONFIG_IP_NF_ARPFILTER=y
CONFIG_IP_NF_ARP_MANGLE=y

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=y
CONFIG_NF_CONNTRACK_IPV6=y
# CONFIG_IP6_NF_QUEUE is not set
CONFIG_IP6_NF_IPTABLES=y
CONFIG_IP6_NF_MATCH_AH=y
CONFIG_IP6_NF_MATCH_EUI64=y
CONFIG_IP6_NF_MATCH_FRAG=y
CONFIG_IP6_NF_MATCH_OPTS=y
CONFIG_IP6_NF_MATCH_HL=y
CONFIG_IP6_NF_MATCH_IPV6HEADER=y
CONFIG_IP6_NF_MATCH_MH=y
# CONFIG_IP6_NF_MATCH_RPFILTER is not set
CONFIG_IP6_NF_MATCH_RT=y
CONFIG_IP6_NF_TARGET_HL=y
CONFIG_IP6_NF_FILTER=y
CONFIG_IP6_NF_TARGET_REJECT=y
CONFIG_IP6_NF_MANGLE=y
CONFIG_IP6_NF_RAW=y
CONFIG_IP6_NF_SECURITY=y

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=y
CONFIG_BRIDGE_NF_EBTABLES=y
CONFIG_BRIDGE_EBT_BROUTE=y
CONFIG_BRIDGE_EBT_T_FILTER=y
CONFIG_BRIDGE_EBT_T_NAT=y
CONFIG_BRIDGE_EBT_802_3=y
CONFIG_BRIDGE_EBT_AMONG=y
CONFIG_BRIDGE_EBT_ARP=y
CONFIG_BRIDGE_EBT_IP=y
CONFIG_BRIDGE_EBT_IP6=y
CONFIG_BRIDGE_EBT_LIMIT=y
CONFIG_BRIDGE_EBT_MARK=y
CONFIG_BRIDGE_EBT_PKTTYPE=y
CONFIG_BRIDGE_EBT_STP=y
CONFIG_BRIDGE_EBT_VLAN=y
CONFIG_BRIDGE_EBT_ARPREPLY=y
CONFIG_BRIDGE_EBT_DNAT=y
CONFIG_BRIDGE_EBT_MARK_T=y
CONFIG_BRIDGE_EBT_REDIRECT=y
CONFIG_BRIDGE_EBT_SNAT=y
CONFIG_BRIDGE_EBT_LOG=y
CONFIG_BRIDGE_EBT_ULOG=y
CONFIG_BRIDGE_EBT_NFLOG=y
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=y

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_TFRC_LIB=y

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_NET_DCCPPROBE=y
CONFIG_IP_SCTP=y
CONFIG_NET_SCTPPROBE=y
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
CONFIG_RDS=y
CONFIG_RDS_RDMA=y
CONFIG_RDS_TCP=y
# CONFIG_RDS_DEBUG is not set
CONFIG_TIPC=y
CONFIG_TIPC_ADVANCED=y
CONFIG_TIPC_PORTS=8191
CONFIG_TIPC_LOG=0
# CONFIG_TIPC_DEBUG is not set
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=y
CONFIG_ATM_MPOA=y
CONFIG_ATM_BR2684=y
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=y
CONFIG_L2TP_DEBUGFS=y
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=y
CONFIG_L2TP_ETH=y
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_IPDDP=y
CONFIG_IPDDP_ENCAP=y
CONFIG_IPDDP_DECAP=y
# CONFIG_X25 is not set
CONFIG_LAPB=y
# CONFIG_ECONET is not set
CONFIG_WAN_ROUTER=y
CONFIG_PHONET=y
CONFIG_IEEE802154=y
CONFIG_IEEE802154_6LOWPAN=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_ATM=y
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_MULTIQ=y
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFB=y
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_MQPRIO=y
CONFIG_NET_SCH_CHOKE=y
CONFIG_NET_SCH_QFQ=y
CONFIG_NET_SCH_INGRESS=y
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=y
CONFIG_NET_EMATCH_NBYTE=y
CONFIG_NET_EMATCH_U32=y
CONFIG_NET_EMATCH_META=y
CONFIG_NET_EMATCH_TEXT=y
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=y
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=y
CONFIG_NET_ACT_IPT=y
CONFIG_NET_ACT_NAT=y
CONFIG_NET_ACT_PEDIT=y
CONFIG_NET_ACT_SIMP=y
CONFIG_NET_ACT_SKBEDIT=y
CONFIG_NET_ACT_CSUM=y
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_DEBUG is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_BQL=y
CONFIG_HAVE_BPF_JIT=y
CONFIG_BPF_JIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
# CONFIG_NET_TCPPROBE is not set
CONFIG_NET_DROP_MONITOR=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
# CONFIG_AX25_DAMA_SLAVE is not set
CONFIG_NETROM=y
CONFIG_ROSE=y

#
# AX.25 network device drivers
#
CONFIG_MKISS=y
CONFIG_6PACK=y
CONFIG_BPQETHER=y
CONFIG_BAYCOM_SER_FDX=y
CONFIG_BAYCOM_SER_HDX=y
CONFIG_BAYCOM_PAR=y
CONFIG_YAM=y
CONFIG_CAN=y
CONFIG_CAN_RAW=y
CONFIG_CAN_BCM=y
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
CONFIG_CAN_SLCAN=y
CONFIG_CAN_DEV=y
CONFIG_CAN_CALC_BITTIMING=y
CONFIG_CAN_MCP251X=y
CONFIG_PCH_CAN=y
CONFIG_CAN_SJA1000=y
# CONFIG_CAN_SJA1000_ISA is not set
# CONFIG_CAN_SJA1000_PLATFORM is not set
CONFIG_CAN_EMS_PCMCIA=y
CONFIG_CAN_EMS_PCI=y
# CONFIG_CAN_PEAK_PCMCIA is not set
CONFIG_CAN_PEAK_PCI=y
CONFIG_CAN_PEAK_PCIEC=y
CONFIG_CAN_KVASER_PCI=y
CONFIG_CAN_PLX_PCI=y
# CONFIG_CAN_C_CAN is not set
# CONFIG_CAN_CC770 is not set

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=y
CONFIG_CAN_ESD_USB2=y
# CONFIG_CAN_PEAK_USB is not set
CONFIG_CAN_SOFTING=y
CONFIG_CAN_SOFTING_CS=y
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
CONFIG_IRNET=y
CONFIG_IRCOMM=y
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=y

#
# Dongle support
#
CONFIG_DONGLE=y
CONFIG_ESI_DONGLE=y
CONFIG_ACTISYS_DONGLE=y
CONFIG_TEKRAM_DONGLE=y
CONFIG_TOIM3232_DONGLE=y
CONFIG_LITELINK_DONGLE=y
CONFIG_MA600_DONGLE=y
CONFIG_GIRBIL_DONGLE=y
CONFIG_MCP2120_DONGLE=y
CONFIG_OLD_BELKIN_DONGLE=y
CONFIG_ACT200L_DONGLE=y
CONFIG_KINGSUN_DONGLE=y
CONFIG_KSDAZZLE_DONGLE=y
CONFIG_KS959_DONGLE=y

#
# FIR device drivers
#
CONFIG_USB_IRDA=y
CONFIG_SIGMATEL_FIR=y
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=y
CONFIG_SMC_IRCC_FIR=y
CONFIG_ALI_FIR=y
CONFIG_VLSI_FIR=y
CONFIG_VIA_FIR=y
CONFIG_MCS_FIR=y
CONFIG_BT=y
CONFIG_BT_RFCOMM=y
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=y
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_CMTP=y
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=y
CONFIG_BT_HCIBTSDIO=y
CONFIG_BT_HCIUART=y
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_ATH3K=y
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIBCM203X=y
CONFIG_BT_HCIBPA10X=y
CONFIG_BT_HCIBFUSB=y
CONFIG_BT_HCIDTL1=y
CONFIG_BT_HCIBT3C=y
CONFIG_BT_HCIBLUECARD=y
CONFIG_BT_HCIBTUART=y
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=y
CONFIG_BT_MRVL_SDIO=y
CONFIG_BT_ATH3K=y
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
# CONFIG_WIRELESS_EXT_SYSFS is not set
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_REGULATOR is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_NET_9P_RDMA=y
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
# CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
CONFIG_NFC=y
CONFIG_NFC_NCI=y
# CONFIG_NFC_LLCP is not set

#
# Near Field Communication (NFC) devices
#
# CONFIG_PN544_NFC is not set
CONFIG_NFC_PN533=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
CONFIG_SYS_HYPERVISOR=y
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=y
# CONFIG_MTD_TESTS is not set
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_CHAR=y
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
CONFIG_FTL=y
CONFIG_NFTL=y
CONFIG_NFTL_RW=y
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
CONFIG_SSFDC=y
# CONFIG_SM_FTL is not set
CONFIG_MTD_OOPS=y
CONFIG_MTD_SWAP=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
# CONFIG_MTD_PHYSMAP_COMPAT is not set
CONFIG_MTD_SC520CDP=y
CONFIG_MTD_NETSC520=y
CONFIG_MTD_TS5500=y
CONFIG_MTD_SBC_GXX=y
# CONFIG_MTD_AMD76XROM is not set
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
CONFIG_MTD_PCI=y
CONFIG_MTD_PCMCIA=y
# CONFIG_MTD_PCMCIA_ANONYMOUS is not set
# CONFIG_MTD_GPIO_ADDR is not set
CONFIG_MTD_INTEL_VR_NOR=y
CONFIG_MTD_PLATRAM=y
# CONFIG_MTD_LATCH_ADDR is not set

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
# CONFIG_MTD_PMC551_BUGFIX is not set
# CONFIG_MTD_PMC551_DEBUG is not set
CONFIG_MTD_DATAFLASH=y
# CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
# CONFIG_MTD_DATAFLASH_OTP is not set
CONFIG_MTD_M25P80=y
CONFIG_M25PXX_USE_FAST_READ=y
CONFIG_MTD_SST25L=y
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOC2000=y
CONFIG_MTD_DOC2001=y
CONFIG_MTD_DOC2001PLUS=y
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_DOCPROBE=y
CONFIG_MTD_DOCECC=y
# CONFIG_MTD_DOCPROBE_ADVANCED is not set
CONFIG_MTD_DOCPROBE_ADDRESS=0x0
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=y
# CONFIG_MTD_NAND_VERIFY_WRITE is not set
# CONFIG_MTD_NAND_ECC_BCH is not set
CONFIG_MTD_SM_COMMON=y
# CONFIG_MTD_NAND_MUSEUM_IDS is not set
# CONFIG_MTD_NAND_DENALI is not set
CONFIG_MTD_NAND_IDS=y
CONFIG_MTD_NAND_RICOH=y
CONFIG_MTD_NAND_DISKONCHIP=y
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
# CONFIG_MTD_NAND_DOCG4 is not set
CONFIG_MTD_NAND_CAFE=y
CONFIG_MTD_NAND_NANDSIM=y
CONFIG_MTD_NAND_PLATFORM=y
CONFIG_MTD_ALAUDA=y
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=y
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y
CONFIG_MTD_ONENAND_SIM=y

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_RESERVE=1
# CONFIG_MTD_UBI_GLUEBI is not set
# CONFIG_MTD_UBI_DEBUG is not set
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
CONFIG_PARPORT_SERIAL=y
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
CONFIG_PARPORT_PC_PCMCIA=y
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
CONFIG_PARIDE=m

#
# Parallel IDE high-level drivers
#
CONFIG_PARIDE_PD=m
CONFIG_PARIDE_PCD=m
CONFIG_PARIDE_PF=m
CONFIG_PARIDE_PT=m
CONFIG_PARIDE_PG=m

#
# Parallel IDE protocol modules
#
CONFIG_PARIDE_ATEN=m
CONFIG_PARIDE_BPCK=m
CONFIG_PARIDE_COMM=m
CONFIG_PARIDE_DSTR=m
CONFIG_PARIDE_FIT2=m
CONFIG_PARIDE_FIT3=m
CONFIG_PARIDE_EPAT=m
# CONFIG_PARIDE_EPATC8 is not set
CONFIG_PARIDE_EPIA=m
CONFIG_PARIDE_FRIQ=m
CONFIG_PARIDE_FRPW=m
CONFIG_PARIDE_KBIC=m
CONFIG_PARIDE_KTTI=m
CONFIG_PARIDE_ON20=m
CONFIG_PARIDE_ON26=m
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
CONFIG_BLK_CPQ_DA=y
CONFIG_BLK_CPQ_CISS_DA=y
CONFIG_CISS_SCSI_TAPE=y
CONFIG_BLK_DEV_DAC960=y
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
CONFIG_BLK_DEV_DRBD=y
# CONFIG_DRBD_FAULT_INJECTION is not set
CONFIG_BLK_DEV_NBD=y
# CONFIG_BLK_DEV_NVME is not set
CONFIG_BLK_DEV_OSD=y
CONFIG_BLK_DEV_SX8=y
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=65536
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=y
CONFIG_XEN_BLKDEV_FRONTEND=y
CONFIG_XEN_BLKDEV_BACKEND=y
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
CONFIG_BLK_DEV_RBD=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_AD525X_DPOT_SPI=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
# CONFIG_INTEL_MID_PTI is not set
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=y
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
CONFIG_DS1682=y
CONFIG_TI_DAC7512=y
CONFIG_VMWARE_BALLOON=y
# CONFIG_BMP085 is not set
CONFIG_PCH_PHUB=y
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_93XX46 is not set
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y
CONFIG_IWMC3200TOP=y
# CONFIG_IWMC3200TOP_DEBUG is not set
# CONFIG_IWMC3200TOP_DEBUGFS is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
CONFIG_IDE_GD_ATAPI=y
# CONFIG_BLK_DEV_IDECS is not set
CONFIG_BLK_DEV_DELKIN=y
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
CONFIG_BLK_DEV_IDEPNP=y
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
# CONFIG_BLK_DEV_GENERIC is not set
CONFIG_BLK_DEV_OPTI621=y
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
CONFIG_BLK_DEV_HPT366=y
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=y
CONFIG_BLK_DEV_IT8172=y
CONFIG_BLK_DEV_IT8213=y
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
CONFIG_BLK_DEV_TRM290=y
# CONFIG_BLK_DEV_VIA82CXXX is not set
CONFIG_BLK_DEV_TC86C001=y
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_ENCLOSURE=y
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
CONFIG_ISCSI_BOOT_SYSFS=y
CONFIG_SCSI_CXGB3_ISCSI=y
CONFIG_SCSI_CXGB4_ISCSI=y
CONFIG_SCSI_BNX2_ISCSI=y
CONFIG_SCSI_BNX2X_FCOE=y
CONFIG_BE2ISCSI=y
CONFIG_BLK_DEV_3W_XXXX_RAID=y
CONFIG_SCSI_HPSA=y
CONFIG_SCSI_3W_9XXX=y
CONFIG_SCSI_3W_SAS=y
CONFIG_SCSI_ACARD=y
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=8
CONFIG_AIC7XXX_RESET_DELAY_MS=15000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC7XXX_OLD=y
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=15000
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC94XX=y
# CONFIG_AIC94XX_DEBUG is not set
CONFIG_SCSI_MVSAS=y
# CONFIG_SCSI_MVSAS_DEBUG is not set
# CONFIG_SCSI_MVSAS_TASKLET is not set
CONFIG_SCSI_MVUMI=y
CONFIG_SCSI_DPT_I2O=y
CONFIG_SCSI_ADVANSYS=y
CONFIG_SCSI_ARCMSR=y
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_MPT2SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS_LOGGING is not set
# CONFIG_SCSI_UFSHCD is not set
CONFIG_SCSI_HPTIOP=y
CONFIG_SCSI_BUSLOGIC=y
CONFIG_VMWARE_PVSCSI=y
CONFIG_HYPERV_STORAGE=y
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
CONFIG_FCOE=y
CONFIG_FCOE_FNIC=y
CONFIG_SCSI_DMX3191D=y
CONFIG_SCSI_EATA=y
CONFIG_SCSI_EATA_TAGGED_QUEUE=y
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=y
CONFIG_SCSI_GDTH=y
CONFIG_SCSI_ISCI=y
CONFIG_SCSI_IPS=y
CONFIG_SCSI_INITIO=y
CONFIG_SCSI_INIA100=y
CONFIG_SCSI_PPA=y
CONFIG_SCSI_IMM=y
# CONFIG_SCSI_IZIP_EPP16 is not set
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
CONFIG_SCSI_STEX=y
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
CONFIG_SCSI_IPR=y
# CONFIG_SCSI_IPR_TRACE is not set
# CONFIG_SCSI_IPR_DUMP is not set
CONFIG_SCSI_QLOGIC_1280=y
CONFIG_SCSI_QLA_FC=y
CONFIG_SCSI_QLA_ISCSI=y
# CONFIG_SCSI_LPFC is not set
CONFIG_SCSI_DC395x=y
CONFIG_SCSI_DC390T=y
CONFIG_SCSI_DEBUG=y
CONFIG_SCSI_PMCRAID=y
CONFIG_SCSI_PM8001=y
CONFIG_SCSI_SRP=y
CONFIG_SCSI_BFA_FC=y
CONFIG_SCSI_VIRTIO=y
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_PCMCIA_AHA152X=m
CONFIG_PCMCIA_FDOMAIN=m
CONFIG_PCMCIA_QLOGIC=m
CONFIG_PCMCIA_SYM53C500=m
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
CONFIG_SCSI_OSD_INITIATOR=y
CONFIG_SCSI_OSD_ULD=y
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
# CONFIG_SATA_AHCI_PLATFORM is not set
CONFIG_SATA_INIC162X=y
CONFIG_SATA_ACARD_AHCI=y
CONFIG_SATA_SIL24=y
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=y
CONFIG_SATA_QSTOR=y
CONFIG_SATA_SX4=y
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
CONFIG_SATA_MV=y
CONFIG_SATA_NV=y
CONFIG_SATA_PROMISE=y
CONFIG_SATA_SIL=y
CONFIG_SATA_SIS=y
CONFIG_SATA_SVW=y
CONFIG_SATA_ULI=y
CONFIG_SATA_VIA=y
CONFIG_SATA_VITESSE=y

#
# PATA SFF controllers with BMDMA
#
CONFIG_PATA_ALI=y
CONFIG_PATA_AMD=y
CONFIG_PATA_ARASAN_CF=y
CONFIG_PATA_ARTOP=y
CONFIG_PATA_ATIIXP=y
CONFIG_PATA_ATP867X=y
CONFIG_PATA_CMD64X=y
CONFIG_PATA_CS5520=y
CONFIG_PATA_CS5530=y
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
CONFIG_PATA_EFAR=y
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
CONFIG_PATA_IT821X=y
CONFIG_PATA_JMICRON=y
CONFIG_PATA_MARVELL=y
CONFIG_PATA_NETCELL=y
# CONFIG_PATA_NINJA32 is not set
CONFIG_PATA_NS87415=y
CONFIG_PATA_OLDPIIX=y
# CONFIG_PATA_OPTIDMA is not set
CONFIG_PATA_PDC2027X=y
CONFIG_PATA_PDC_OLD=y
# CONFIG_PATA_RADISYS is not set
CONFIG_PATA_RDC=y
CONFIG_PATA_SC1200=y
CONFIG_PATA_SCH=y
CONFIG_PATA_SERVERWORKS=y
CONFIG_PATA_SIL680=y
CONFIG_PATA_SIS=y
CONFIG_PATA_TOSHIBA=y
CONFIG_PATA_TRIFLEX=y
CONFIG_PATA_VIA=y
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
CONFIG_PATA_MPIIX=y
CONFIG_PATA_NS87410=y
# CONFIG_PATA_OPTI is not set
CONFIG_PATA_PCMCIA=y
CONFIG_PATA_RZ1000=y

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
CONFIG_ATA_GENERIC=y
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
# CONFIG_MULTICORE_RAID456 is not set
CONFIG_MD_MULTIPATH=y
CONFIG_MD_FAULTY=y
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_BUFIO=y
CONFIG_DM_PERSISTENT_DATA=y
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_THIN_PROVISIONING=y
# CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
# CONFIG_DM_DEBUG_SPACE_MAPS is not set
CONFIG_DM_MIRROR=y
CONFIG_DM_RAID=y
CONFIG_DM_LOG_USERSPACE=y
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=y
CONFIG_DM_MULTIPATH_QL=y
CONFIG_DM_MULTIPATH_ST=y
CONFIG_DM_DELAY=y
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=y
# CONFIG_DM_VERITY is not set
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=y
CONFIG_TCM_FILEIO=y
CONFIG_TCM_PSCSI=y
CONFIG_LOOPBACK_TARGET=y
CONFIG_TCM_FC=y
CONFIG_ISCSI_TARGET=y
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
CONFIG_FUSION_LAN=y
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_SBP2=y
CONFIG_FIREWIRE_NET=y
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
CONFIG_I2O_CONFIG=y
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=y
CONFIG_I2O_BLOCK=y
CONFIG_I2O_SCSI=y
CONFIG_I2O_PROC=y
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
CONFIG_BONDING=y
CONFIG_DUMMY=y
CONFIG_EQUALIZER=y
CONFIG_NET_FC=y
CONFIG_MII=y
CONFIG_IEEE802154_DRIVERS=y
CONFIG_IEEE802154_FAKEHARD=y
CONFIG_IFB=y
# CONFIG_NET_TEAM is not set
CONFIG_MACVLAN=y
CONFIG_MACVTAP=y
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=y
CONFIG_VETH=y
CONFIG_VIRTIO_NET=y
CONFIG_SUNGEM_PHY=y
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
CONFIG_ARCNET_1051=y
CONFIG_ARCNET_RAW=y
CONFIG_ARCNET_CAP=y
CONFIG_ARCNET_COM90xx=y
CONFIG_ARCNET_COM90xxIO=y
CONFIG_ARCNET_RIM_I=y
CONFIG_ARCNET_COM20020=y
CONFIG_ARCNET_COM20020_PCI=y
CONFIG_ARCNET_COM20020_CS=y
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=y
CONFIG_ATM_TCP=y
CONFIG_ATM_LANAI=y
CONFIG_ATM_ENI=y
# CONFIG_ATM_ENI_DEBUG is not set
# CONFIG_ATM_ENI_TUNE_BURST is not set
CONFIG_ATM_FIRESTREAM=y
CONFIG_ATM_ZATM=y
# CONFIG_ATM_ZATM_DEBUG is not set
CONFIG_ATM_NICSTAR=y
CONFIG_ATM_NICSTAR_USE_SUNI=y
CONFIG_ATM_NICSTAR_USE_IDT77105=y
CONFIG_ATM_IDT77252=y
# CONFIG_ATM_IDT77252_DEBUG is not set
# CONFIG_ATM_IDT77252_RCV_ALL is not set
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_AMBASSADOR=y
# CONFIG_ATM_AMBASSADOR_DEBUG is not set
CONFIG_ATM_HORIZON=y
# CONFIG_ATM_HORIZON_DEBUG is not set
CONFIG_ATM_IA=y
# CONFIG_ATM_IA_DEBUG is not set
CONFIG_ATM_FORE200E=y
# CONFIG_ATM_FORE200E_USE_TASKLET is not set
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
CONFIG_ATM_HE=y
CONFIG_ATM_HE_USE_SUNI=y
CONFIG_ATM_SOLOS=y

#
# CAIF transport drivers
#
CONFIG_ETHERNET=y
CONFIG_MDIO=y
CONFIG_NET_VENDOR_3COM=y
CONFIG_PCMCIA_3C574=y
CONFIG_PCMCIA_3C589=y
CONFIG_VORTEX=y
CONFIG_TYPHOON=y
CONFIG_NET_VENDOR_ADAPTEC=y
CONFIG_ADAPTEC_STARFIRE=y
CONFIG_NET_VENDOR_ALTEON=y
CONFIG_ACENIC=y
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_NET_VENDOR_AMD=y
CONFIG_AMD8111_ETH=y
CONFIG_PCNET32=y
CONFIG_PCMCIA_NMCLAN=y
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=y
CONFIG_ATL1=y
CONFIG_ATL1E=y
CONFIG_ATL1C=y
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BNX2=y
CONFIG_CNIC=y
CONFIG_TIGON3=y
CONFIG_BNX2X=y
CONFIG_NET_VENDOR_BROCADE=y
CONFIG_BNA=y
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CHELSIO=y
CONFIG_CHELSIO_T1=y
CONFIG_CHELSIO_T1_1G=y
CONFIG_CHELSIO_T3=y
CONFIG_CHELSIO_T4=y
CONFIG_CHELSIO_T4VF=y
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=y
CONFIG_DNET=y
CONFIG_NET_VENDOR_DEC=y
CONFIG_NET_TULIP=y
CONFIG_DE2104X=y
CONFIG_DE2104X_DSL=0
CONFIG_TULIP=y
# CONFIG_TULIP_MWI is not set
# CONFIG_TULIP_MMIO is not set
CONFIG_TULIP_NAPI=y
CONFIG_TULIP_NAPI_HW_MITIGATION=y
CONFIG_DE4X5=y
CONFIG_WINBOND_840=y
CONFIG_DM9102=y
CONFIG_ULI526X=y
CONFIG_PCMCIA_XIRCOM=y
CONFIG_NET_VENDOR_DLINK=y
CONFIG_DE600=y
CONFIG_DE620=y
CONFIG_DL2K=y
CONFIG_SUNDANCE=y
# CONFIG_SUNDANCE_MMIO is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=y
CONFIG_NET_VENDOR_EXAR=y
CONFIG_S2IO=y
CONFIG_VXGE=y
# CONFIG_VXGE_DEBUG_TRACE_ALL is not set
CONFIG_NET_VENDOR_FUJITSU=y
CONFIG_PCMCIA_FMVJ18X=y
CONFIG_NET_VENDOR_HP=y
CONFIG_HP100=y
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=y
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_IGB=y
CONFIG_IGB_DCA=y
CONFIG_IGBVF=y
CONFIG_IXGB=y
CONFIG_IXGBE=y
CONFIG_IXGBE_DCA=y
CONFIG_IXGBE_DCB=y
CONFIG_IXGBEVF=y
CONFIG_NET_VENDOR_I825XX=y
# CONFIG_ZNET is not set
CONFIG_IP1000=y
CONFIG_JME=y
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_SKGE=y
CONFIG_SKGE_DEBUG=y
CONFIG_SKGE_GENESIS=y
CONFIG_SKY2=y
CONFIG_SKY2_DEBUG=y
CONFIG_NET_VENDOR_MELLANOX=y
CONFIG_MLX4_EN=y
CONFIG_MLX4_CORE=y
CONFIG_MLX4_DEBUG=y
CONFIG_NET_VENDOR_MICREL=y
CONFIG_KS8842=y
CONFIG_KS8851=y
CONFIG_KS8851_MLL=y
CONFIG_KSZ884X_PCI=y
CONFIG_NET_VENDOR_MICROCHIP=y
CONFIG_ENC28J60=y
# CONFIG_ENC28J60_WRITEVERIFY is not set
CONFIG_NET_VENDOR_MYRI=y
CONFIG_MYRI10GE=y
CONFIG_MYRI10GE_DCA=y
CONFIG_FEALNX=y
CONFIG_NET_VENDOR_NATSEMI=y
CONFIG_NATSEMI=y
CONFIG_NS83820=y
CONFIG_NET_VENDOR_8390=y
CONFIG_PCMCIA_AXNET=y
CONFIG_NE2K_PCI=y
CONFIG_PCMCIA_PCNET=y
CONFIG_NET_VENDOR_NVIDIA=y
CONFIG_FORCEDETH=y
CONFIG_NET_VENDOR_OKI=y
CONFIG_PCH_GBE=y
CONFIG_ETHOC=y
CONFIG_NET_PACKET_ENGINE=y
CONFIG_HAMACHI=y
CONFIG_YELLOWFIN=y
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=y
CONFIG_QLCNIC=y
CONFIG_QLGE=y
CONFIG_NETXEN_NIC=y
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_ATP=y
CONFIG_8139CP=y
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
CONFIG_8139TOO_TUNE_TWISTER=y
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=y
CONFIG_NET_VENDOR_RDC=y
CONFIG_R6040=y
CONFIG_NET_VENDOR_SEEQ=y
# CONFIG_SEEQ8005 is not set
CONFIG_NET_VENDOR_SILAN=y
CONFIG_SC92031=y
CONFIG_NET_VENDOR_SIS=y
CONFIG_SIS900=y
CONFIG_SIS190=y
CONFIG_SFC=y
CONFIG_SFC_MTD=y
CONFIG_SFC_MCDI_MON=y
CONFIG_SFC_SRIOV=y
CONFIG_NET_VENDOR_SMSC=y
CONFIG_PCMCIA_SMC91C92=y
CONFIG_EPIC100=y
CONFIG_SMSC9420=y
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
CONFIG_HAPPYMEAL=y
CONFIG_SUNGEM=y
CONFIG_CASSINI=y
CONFIG_NIU=y
CONFIG_NET_VENDOR_TEHUTI=y
CONFIG_TEHUTI=y
CONFIG_NET_VENDOR_TI=y
CONFIG_TLAN=y
CONFIG_NET_VENDOR_VIA=y
CONFIG_VIA_RHINE=y
# CONFIG_VIA_RHINE_MMIO is not set
CONFIG_VIA_VELOCITY=y
CONFIG_NET_VENDOR_XIRCOM=y
CONFIG_PCMCIA_XIRC2PS=y
CONFIG_FDDI=y
CONFIG_DEFXX=y
# CONFIG_DEFXX_MMIO is not set
CONFIG_SKFP=y
CONFIG_HIPPI=y
CONFIG_ROADRUNNER=y
# CONFIG_ROADRUNNER_LARGE_RINGS is not set
CONFIG_NET_SB1000=y
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AMD_PHY is not set
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
CONFIG_MICREL_PHY=y
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
# CONFIG_MDIO_GPIO is not set
# CONFIG_MICREL_KS8995MA is not set
CONFIG_PLIP=y
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=y
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=y
CONFIG_PPPOE=y
CONFIG_PPTP=y
CONFIG_PPPOL2TP=y
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
CONFIG_SLIP=y
CONFIG_SLHC=y
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLIP_SMART=y
CONFIG_SLIP_MODE_SLIP6=y
# CONFIG_TR is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=y
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=y
CONFIG_USB_NET_DM9601=y
CONFIG_USB_NET_SMSC75XX=y
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=y
CONFIG_USB_NET_CX82310_ETH=y
CONFIG_USB_NET_KALMIA=y
# CONFIG_USB_NET_QMI_WWAN is not set
CONFIG_USB_HSO=y
CONFIG_USB_NET_INT51X1=y
CONFIG_USB_CDC_PHONET=y
CONFIG_USB_IPHETH=y
CONFIG_USB_SIERRA_NET=y
CONFIG_USB_VL600=y
CONFIG_WLAN=y
CONFIG_PCMCIA_RAYCS=y
CONFIG_LIBERTAS_THINFIRM=y
# CONFIG_LIBERTAS_THINFIRM_DEBUG is not set
CONFIG_LIBERTAS_THINFIRM_USB=y
CONFIG_AIRO=y
CONFIG_ATMEL=y
CONFIG_PCI_ATMEL=y
CONFIG_PCMCIA_ATMEL=y
CONFIG_AT76C50X_USB=y
CONFIG_AIRO_CS=y
CONFIG_PCMCIA_WL3501=y
# CONFIG_PRISM54 is not set
CONFIG_USB_ZD1201=y
CONFIG_USB_NET_RNDIS_WLAN=y
CONFIG_RTL8180=y
CONFIG_RTL8187=y
CONFIG_RTL8187_LEDS=y
CONFIG_ADM8211=y
CONFIG_MAC80211_HWSIM=y
CONFIG_MWL8K=y
CONFIG_ATH_COMMON=y
# CONFIG_ATH_DEBUG is not set
CONFIG_ATH5K=y
# CONFIG_ATH5K_DEBUG is not set
# CONFIG_ATH5K_TRACER is not set
CONFIG_ATH5K_PCI=y
CONFIG_ATH9K_HW=y
CONFIG_ATH9K_COMMON=y
CONFIG_ATH9K_BTCOEX_SUPPORT=y
CONFIG_ATH9K=y
CONFIG_ATH9K_PCI=y
# CONFIG_ATH9K_AHB is not set
# CONFIG_ATH9K_DEBUGFS is not set
CONFIG_ATH9K_RATE_CONTROL=y
CONFIG_ATH9K_HTC=y
# CONFIG_ATH9K_HTC_DEBUGFS is not set
CONFIG_CARL9170=y
CONFIG_CARL9170_LEDS=y
CONFIG_CARL9170_WPC=y
# CONFIG_CARL9170_HWRNG is not set
# CONFIG_ATH6KL is not set
CONFIG_B43=y
CONFIG_B43_BCMA=y
# CONFIG_B43_BCMA_EXTRA is not set
CONFIG_B43_SSB=y
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
CONFIG_B43_PCMCIA=y
CONFIG_B43_SDIO=y
CONFIG_B43_BCMA_PIO=y
CONFIG_B43_PIO=y
CONFIG_B43_PHY_N=y
CONFIG_B43_PHY_LP=y
CONFIG_B43_PHY_HT=y
CONFIG_B43_LEDS=y
CONFIG_B43_HWRNG=y
# CONFIG_B43_DEBUG is not set
CONFIG_B43LEGACY=y
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
CONFIG_B43LEGACY_HWRNG=y
CONFIG_B43LEGACY_DEBUG=y
CONFIG_B43LEGACY_DMA=y
CONFIG_B43LEGACY_PIO=y
CONFIG_B43LEGACY_DMA_AND_PIO_MODE=y
# CONFIG_B43LEGACY_DMA_MODE is not set
# CONFIG_B43LEGACY_PIO_MODE is not set
CONFIG_BRCMUTIL=y
CONFIG_BRCMSMAC=y
# CONFIG_BRCMFMAC is not set
# CONFIG_BRCMDBG is not set
CONFIG_HOSTAP=y
CONFIG_HOSTAP_FIRMWARE=y
# CONFIG_HOSTAP_FIRMWARE_NVRAM is not set
CONFIG_HOSTAP_PLX=y
CONFIG_HOSTAP_PCI=y
CONFIG_HOSTAP_CS=y
# CONFIG_IPW2100 is not set
CONFIG_IPW2200=y
CONFIG_IPW2200_MONITOR=y
CONFIG_IPW2200_RADIOTAP=y
CONFIG_IPW2200_PROMISCUOUS=y
CONFIG_IPW2200_QOS=y
# CONFIG_IPW2200_DEBUG is not set
CONFIG_LIBIPW=y
# CONFIG_LIBIPW_DEBUG is not set
CONFIG_IWLWIFI=y

#
# Debugging Options
#
# CONFIG_IWLWIFI_DEBUG is not set
# CONFIG_IWLWIFI_DEVICE_TRACING is not set
CONFIG_IWLWIFI_P2P=y
# CONFIG_IWLWIFI_EXPERIMENTAL_MFP is not set
CONFIG_IWLEGACY=y
CONFIG_IWL4965=y
CONFIG_IWL3945=y

#
# iwl3945 / iwl4965 Debugging Options
#
# CONFIG_IWLEGACY_DEBUG is not set
CONFIG_IWM=y
# CONFIG_IWM_DEBUG is not set
# CONFIG_IWM_TRACING is not set
CONFIG_LIBERTAS=y
CONFIG_LIBERTAS_USB=y
CONFIG_LIBERTAS_CS=y
CONFIG_LIBERTAS_SDIO=y
CONFIG_LIBERTAS_SPI=y
# CONFIG_LIBERTAS_DEBUG is not set
CONFIG_LIBERTAS_MESH=y
CONFIG_HERMES=y
# CONFIG_HERMES_PRISM is not set
CONFIG_HERMES_CACHE_FW_ON_INIT=y
CONFIG_PLX_HERMES=y
CONFIG_TMD_HERMES=y
CONFIG_NORTEL_HERMES=y
CONFIG_PCMCIA_HERMES=y
CONFIG_PCMCIA_SPECTRUM=y
CONFIG_ORINOCO_USB=y
CONFIG_P54_COMMON=y
CONFIG_P54_USB=y
CONFIG_P54_PCI=y
CONFIG_P54_SPI=y
# CONFIG_P54_SPI_DEFAULT_EEPROM is not set
CONFIG_P54_LEDS=y
CONFIG_RT2X00=y
CONFIG_RT2400PCI=y
CONFIG_RT2500PCI=y
CONFIG_RT61PCI=y
CONFIG_RT2800PCI=y
CONFIG_RT2800PCI_RT33XX=y
CONFIG_RT2800PCI_RT35XX=y
CONFIG_RT2800PCI_RT53XX=y
CONFIG_RT2500USB=y
CONFIG_RT73USB=y
CONFIG_RT2800USB=y
CONFIG_RT2800USB_RT33XX=y
CONFIG_RT2800USB_RT35XX=y
CONFIG_RT2800USB_RT53XX=y
# CONFIG_RT2800USB_UNKNOWN is not set
CONFIG_RT2800_LIB=y
CONFIG_RT2X00_LIB_PCI=y
CONFIG_RT2X00_LIB_USB=y
CONFIG_RT2X00_LIB=y
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_RT2X00_LIB_LEDS=y
# CONFIG_RT2X00_DEBUG is not set
CONFIG_RTL8192CE=y
CONFIG_RTL8192SE=y
CONFIG_RTL8192DE=y
CONFIG_RTL8192CU=y
CONFIG_RTLWIFI=y
CONFIG_RTLWIFI_DEBUG=y
CONFIG_RTL8192C_COMMON=y
# CONFIG_WL1251 is not set
# CONFIG_WL12XX_MENU is not set
CONFIG_ZD1211RW=y
# CONFIG_ZD1211RW_DEBUG is not set
CONFIG_MWIFIEX=y
CONFIG_MWIFIEX_SDIO=y
CONFIG_MWIFIEX_PCIE=y

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=y
CONFIG_WIMAX_I2400M_USB=y
CONFIG_WIMAX_I2400M_SDIO=y
CONFIG_WIMAX_IWMC3200_SDIO=y
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
CONFIG_WAN=y
CONFIG_LANMEDIA=y
CONFIG_HDLC=y
CONFIG_HDLC_RAW=y
CONFIG_HDLC_RAW_ETH=y
CONFIG_HDLC_CISCO=y
CONFIG_HDLC_FR=y
CONFIG_HDLC_PPP=y
# CONFIG_HDLC_X25 is not set
CONFIG_PCI200SYN=y
CONFIG_WANXL=y
# CONFIG_PC300TOO is not set
CONFIG_FARSYNC=y
CONFIG_DSCC4=m
CONFIG_DSCC4_PCISYNC=y
CONFIG_DSCC4_PCI_RST=y
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
CONFIG_WAN_ROUTER_DRIVERS=y
CONFIG_CYCLADES_SYNC=y
# CONFIG_CYCLOMX_X25 is not set
CONFIG_SBNI=y
# CONFIG_SBNI_MULTILINE is not set
CONFIG_XEN_NETDEV_FRONTEND=y
CONFIG_XEN_NETDEV_BACKEND=y
CONFIG_VMXNET3=y
CONFIG_HYPERV_NET=y
CONFIG_ISDN=y
# CONFIG_ISDN_I4L is not set
CONFIG_ISDN_CAPI=y
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
CONFIG_CAPI_TRACE=y
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPI20=y

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
CONFIG_ISDN_DRV_AVMB1_B1PCI=y
CONFIG_ISDN_DRV_AVMB1_B1PCIV4=y
CONFIG_ISDN_DRV_AVMB1_B1PCMCIA=y
CONFIG_ISDN_DRV_AVMB1_AVM_CS=y
CONFIG_ISDN_DRV_AVMB1_T1PCI=y
CONFIG_ISDN_DRV_AVMB1_C4=y
# CONFIG_CAPI_EICON is not set
CONFIG_ISDN_DRV_GIGASET=y
CONFIG_GIGASET_CAPI=y
# CONFIG_GIGASET_DUMMYLL is not set
CONFIG_GIGASET_BASE=y
CONFIG_GIGASET_M105=y
CONFIG_GIGASET_M101=y
# CONFIG_GIGASET_DEBUG is not set
CONFIG_HYSDN=m
CONFIG_HYSDN_CAPI=y
CONFIG_MISDN=y
CONFIG_MISDN_DSP=y
CONFIG_MISDN_L1OIP=y

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=y
CONFIG_MISDN_HFCMULTI=y
CONFIG_MISDN_HFCUSB=y
CONFIG_MISDN_AVMFRITZ=y
CONFIG_MISDN_SPEEDFAX=y
CONFIG_MISDN_INFINEON=y
CONFIG_MISDN_W6692=y
# CONFIG_MISDN_NETJET is not set
CONFIG_MISDN_IPAC=y
CONFIG_MISDN_ISAR=y

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=y
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
CONFIG_KEYBOARD_QT2160=y
CONFIG_KEYBOARD_LKKBD=y
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
CONFIG_KEYBOARD_LM8323=y
CONFIG_KEYBOARD_MAX7359=y
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_OPENCORES=y
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_SUNKBD=y
# CONFIG_KEYBOARD_OMAP4 is not set
CONFIG_KEYBOARD_XTKBD=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=y
CONFIG_MOUSE_APPLETOUCH=y
CONFIG_MOUSE_BCM5974=y
CONFIG_MOUSE_VSXXXAA=y
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=y
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=y
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_DB9=y
CONFIG_JOYSTICK_GAMECON=y
CONFIG_JOYSTICK_TURBOGRAFX=y
# CONFIG_JOYSTICK_AS5011 is not set
CONFIG_JOYSTICK_JOYDUMP=y
CONFIG_JOYSTICK_XPAD=y
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
CONFIG_JOYSTICK_WALKERA0701=y
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
CONFIG_TABLET_USB_AIPTEK=y
CONFIG_TABLET_USB_GTCO=y
CONFIG_TABLET_USB_HANWANG=y
CONFIG_TABLET_USB_KBTAB=y
CONFIG_TABLET_USB_WACOM=y
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=y
CONFIG_TOUCHSCREEN_AD7877=y
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
# CONFIG_TOUCHSCREEN_AD7879_SPI is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
CONFIG_TOUCHSCREEN_EETI=y
# CONFIG_TOUCHSCREEN_EGALAX is not set
CONFIG_TOUCHSCREEN_FUJITSU=y
# CONFIG_TOUCHSCREEN_ILI210X is not set
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
# CONFIG_TOUCHSCREEN_MAX11801 is not set
CONFIG_TOUCHSCREEN_MCS5000=y
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
# CONFIG_TOUCHSCREEN_PIXCIR is not set
CONFIG_TOUCHSCREEN_WM97XX=y
CONFIG_TOUCHSCREEN_WM9705=y
CONFIG_TOUCHSCREEN_WM9712=y
CONFIG_TOUCHSCREEN_WM9713=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
CONFIG_TOUCHSCREEN_USB_ELO=y
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2005 is not set
CONFIG_TOUCHSCREEN_TSC2007=y
# CONFIG_TOUCHSCREEN_ST1232 is not set
CONFIG_TOUCHSCREEN_TPS6507X=y
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
CONFIG_INPUT_PCSPKR=y
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
CONFIG_INPUT_APANEL=y
# CONFIG_INPUT_GP2A is not set
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
CONFIG_INPUT_ATLAS_BTNS=y
CONFIG_INPUT_ATI_REMOTE2=y
CONFIG_INPUT_KEYSPAN_REMOTE=y
# CONFIG_INPUT_KXTJ9 is not set
CONFIG_INPUT_POWERMATE=y
CONFIG_INPUT_YEALINK=y
CONFIG_INPUT_CM109=y
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF50633_PMU=y
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set
CONFIG_INPUT_XEN_KBDDEV_FRONTEND=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=y
CONFIG_CYCLADES=y
# CONFIG_CYZ_INTR is not set
CONFIG_MOXA_INTELLIO=y
CONFIG_MOXA_SMARTIO=y
CONFIG_SYNCLINK=y
CONFIG_SYNCLINKMP=y
CONFIG_SYNCLINK_GT=y
CONFIG_NOZOMI=y
CONFIG_ISI=y
CONFIG_N_HDLC=y
CONFIG_N_GSM=y
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set
CONFIG_STALDRV=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CS=y
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=y
# CONFIG_SERIAL_MAX3107 is not set
CONFIG_SERIAL_MFD_HSU=y
# CONFIG_SERIAL_MFD_HSU_CONSOLE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
CONFIG_SERIAL_PCH_UART=y
# CONFIG_SERIAL_PCH_UART_CONSOLE is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=y
CONFIG_R3964=y
CONFIG_APPLICOM=y

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
CONFIG_IPWIRELESS=y
CONFIG_MWAVE=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
CONFIG_TCG_INFINEON=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
# CONFIG_RAMOOPS is not set
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
CONFIG_I2C_SCMI=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_EG20T=y
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_INTEL_MID is not set
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_TAOS_EVM=y
CONFIG_I2C_TINY_USB=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
# CONFIG_SPI_GPIO is not set
CONFIG_SPI_LM70_LLP=y
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_TOPCLIFF_PCH=y
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
CONFIG_SPI_TLE62X0=y
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=y
CONFIG_PPS_CLIENT_PARPORT=y
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_VX855 is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_LANGWELL is not set
CONFIG_GPIO_PCH=y
CONFIG_GPIO_ML_IOH=y
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MCP23S08 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_74X164 is not set

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_DS1WM is not set
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
# CONFIG_W1_SLAVE_DS2780 is not set
# CONFIG_W1_SLAVE_DS2781 is not set
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2760=y
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_WM97XX is not set
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_MAX17040=y
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_CHARGER_PCF50633=y
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_MANAGER is not set
# CONFIG_CHARGER_SMB347 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADCXX=y
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX1111=y
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NTC_THERMISTOR=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=y
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_VIA_CPUTEMP=y
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_APPLESMC=y

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=y
CONFIG_SENSORS_ATK0110=y
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=y
CONFIG_ALIM7101_WDT=y
CONFIG_F71808E_WDT=y
CONFIG_SP5100_TCO=y
CONFIG_SC520_WDT=y
CONFIG_SBC_FITPC2_WATCHDOG=y
CONFIG_EUROTECH_WDT=y
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=y
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
CONFIG_HP_WATCHDOG=y
CONFIG_HPWDT_NMI_DECODING=y
CONFIG_SC1200_WDT=y
CONFIG_PC87413_WDT=y
CONFIG_NV_TCO=y
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
CONFIG_W83697HF_WDT=y
CONFIG_W83697UG_WDT=y
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y
CONFIG_XEN_WDT=y

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
CONFIG_WDTPCI=y

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_BLOCKIO=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_BLOCKIO=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
# CONFIG_UCB1400_CORE is not set
# CONFIG_TPS6105X is not set
CONFIG_TPS65010=y
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_S5M_CORE is not set
CONFIG_MFD_WM8400=y
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
# CONFIG_MFD_MC13XXX is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_LPC_SCH=y
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_WL1273_CORE=y
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_RC5T583 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_GPIO is not set
# CONFIG_REGULATOR_AD5398 is not set
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_LP3971=y
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_PCF50633=y
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
# CONFIG_REGULATOR_TPS6524X is not set
CONFIG_REGULATOR_WM8400=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_COMMON=y
# CONFIG_VIDEO_V4L2_SUBDEV_API is not set
CONFIG_DVB_CORE=y
CONFIG_DVB_NET=y
CONFIG_VIDEO_MEDIA=y

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=y
CONFIG_VIDEO_SAA7146_VV=y
CONFIG_RC_CORE=y
CONFIG_LIRC=y
CONFIG_RC_MAP=y
CONFIG_IR_NEC_DECODER=y
CONFIG_IR_RC5_DECODER=y
CONFIG_IR_RC6_DECODER=y
CONFIG_IR_JVC_DECODER=y
CONFIG_IR_SONY_DECODER=y
CONFIG_IR_RC5_SZ_DECODER=y
CONFIG_IR_SANYO_DECODER=y
CONFIG_IR_MCE_KBD_DECODER=y
CONFIG_IR_LIRC_CODEC=y
# CONFIG_RC_ATI_REMOTE is not set
CONFIG_IR_ENE=y
CONFIG_IR_IMON=y
CONFIG_IR_MCEUSB=y
CONFIG_IR_ITE_CIR=y
CONFIG_IR_FINTEK=y
CONFIG_IR_NUVOTON=y
CONFIG_IR_REDRAT3=y
CONFIG_IR_STREAMZAP=y
CONFIG_IR_WINBOND_CIR=y
CONFIG_RC_LOOPBACK=y
# CONFIG_IR_GPIO_CIR is not set
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=y
# CONFIG_MEDIA_TUNER_CUSTOMISE is not set
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_MT2060=y
CONFIG_MEDIA_TUNER_MT2266=y
CONFIG_MEDIA_TUNER_MT2131=y
CONFIG_MEDIA_TUNER_QT1010=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MXL5005S=y
CONFIG_MEDIA_TUNER_MXL5007T=y
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_MEDIA_TUNER_MAX2165=y
CONFIG_MEDIA_TUNER_TDA18218=y
CONFIG_MEDIA_TUNER_TDA18212=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_SG=y
CONFIG_VIDEOBUF_VMALLOC=y
CONFIG_VIDEOBUF_DVB=y
CONFIG_VIDEO_BTCX=y
CONFIG_VIDEO_TVEEPROM=y
CONFIG_VIDEO_TUNER=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_VMALLOC=y
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=y

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=y
CONFIG_VIDEO_TDA7432=y
CONFIG_VIDEO_TDA9840=y
CONFIG_VIDEO_TEA6415C=y
CONFIG_VIDEO_TEA6420=y
CONFIG_VIDEO_MSP3400=y
CONFIG_VIDEO_CS5345=y
CONFIG_VIDEO_CS53L32A=y
CONFIG_VIDEO_WM8775=y
CONFIG_VIDEO_WM8739=y
CONFIG_VIDEO_VP27SMPX=y

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=y

#
# Video decoders
#
CONFIG_VIDEO_BT819=y
CONFIG_VIDEO_BT856=y
CONFIG_VIDEO_BT866=y
CONFIG_VIDEO_KS0127=y
CONFIG_VIDEO_SAA7110=y
CONFIG_VIDEO_SAA711X=y
CONFIG_VIDEO_TVP5150=y
CONFIG_VIDEO_VPX3220=y

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=y
CONFIG_VIDEO_CX25840=y

#
# MPEG video encoders
#
CONFIG_VIDEO_CX2341X=y

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=y
CONFIG_VIDEO_SAA7185=y
CONFIG_VIDEO_ADV7170=y
CONFIG_VIDEO_ADV7175=y

#
# Camera sensor devices
#
CONFIG_VIDEO_MT9V011=y

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=y
CONFIG_VIDEO_UPD64083=y

#
# Miscelaneous helper chips
#
CONFIG_VIDEO_M52790=y
CONFIG_VIDEO_VIVI=y
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_VIDEO_CLASS=y
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=y
CONFIG_USB_M5602=y
CONFIG_USB_STV06XX=y
CONFIG_USB_GL860=y
CONFIG_USB_GSPCA_BENQ=y
CONFIG_USB_GSPCA_CONEX=y
CONFIG_USB_GSPCA_CPIA1=y
CONFIG_USB_GSPCA_ETOMS=y
CONFIG_USB_GSPCA_FINEPIX=y
CONFIG_USB_GSPCA_JEILINJ=y
# CONFIG_USB_GSPCA_JL2005BCD is not set
CONFIG_USB_GSPCA_KINECT=y
CONFIG_USB_GSPCA_KONICA=y
CONFIG_USB_GSPCA_MARS=y
CONFIG_USB_GSPCA_MR97310A=y
CONFIG_USB_GSPCA_NW80X=y
CONFIG_USB_GSPCA_OV519=y
CONFIG_USB_GSPCA_OV534=y
CONFIG_USB_GSPCA_OV534_9=y
CONFIG_USB_GSPCA_PAC207=y
CONFIG_USB_GSPCA_PAC7302=y
CONFIG_USB_GSPCA_PAC7311=y
CONFIG_USB_GSPCA_SE401=y
CONFIG_USB_GSPCA_SN9C2028=y
CONFIG_USB_GSPCA_SN9C20X=y
CONFIG_USB_GSPCA_SONIXB=y
CONFIG_USB_GSPCA_SONIXJ=y
CONFIG_USB_GSPCA_SPCA500=y
CONFIG_USB_GSPCA_SPCA501=y
CONFIG_USB_GSPCA_SPCA505=y
CONFIG_USB_GSPCA_SPCA506=y
CONFIG_USB_GSPCA_SPCA508=y
CONFIG_USB_GSPCA_SPCA561=y
CONFIG_USB_GSPCA_SPCA1528=y
CONFIG_USB_GSPCA_SQ905=y
CONFIG_USB_GSPCA_SQ905C=y
CONFIG_USB_GSPCA_SQ930X=y
CONFIG_USB_GSPCA_STK014=y
CONFIG_USB_GSPCA_STV0680=y
CONFIG_USB_GSPCA_SUNPLUS=y
CONFIG_USB_GSPCA_T613=y
# CONFIG_USB_GSPCA_TOPRO is not set
CONFIG_USB_GSPCA_TV8532=y
CONFIG_USB_GSPCA_VC032X=y
CONFIG_USB_GSPCA_VICAM=y
CONFIG_USB_GSPCA_XIRLINK_CIT=y
CONFIG_USB_GSPCA_ZC3XX=y
CONFIG_VIDEO_PVRUSB2=y
CONFIG_VIDEO_PVRUSB2_SYSFS=y
CONFIG_VIDEO_PVRUSB2_DVB=y
# CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
CONFIG_VIDEO_HDPVR=y
CONFIG_VIDEO_EM28XX=y
CONFIG_VIDEO_EM28XX_ALSA=y
CONFIG_VIDEO_EM28XX_DVB=y
CONFIG_VIDEO_EM28XX_RC=y
CONFIG_VIDEO_TLG2300=y
CONFIG_VIDEO_CX231XX=y
CONFIG_VIDEO_CX231XX_RC=y
CONFIG_VIDEO_CX231XX_ALSA=y
CONFIG_VIDEO_CX231XX_DVB=y
CONFIG_VIDEO_TM6000=y
CONFIG_VIDEO_TM6000_ALSA=y
CONFIG_VIDEO_TM6000_DVB=y
CONFIG_VIDEO_USBVISION=y
# CONFIG_USB_ET61X251 is not set
CONFIG_USB_SN9C102=y
CONFIG_USB_PWC=y
# CONFIG_USB_PWC_DEBUG is not set
CONFIG_USB_PWC_INPUT_EVDEV=y
CONFIG_VIDEO_CPIA2=y
CONFIG_USB_ZR364XX=y
CONFIG_USB_STKWEBCAM=y
CONFIG_USB_S2255=y
CONFIG_V4L_PCI_DRIVERS=y
CONFIG_VIDEO_AU0828=y
CONFIG_VIDEO_BT848=y
CONFIG_VIDEO_BT848_DVB=y
CONFIG_VIDEO_CX18=y
CONFIG_VIDEO_CX18_ALSA=y
CONFIG_VIDEO_CX23885=y
# CONFIG_MEDIA_ALTERA_CI is not set
# CONFIG_VIDEO_CX25821 is not set
CONFIG_VIDEO_CX88=y
CONFIG_VIDEO_CX88_ALSA=y
CONFIG_VIDEO_CX88_BLACKBIRD=y
CONFIG_VIDEO_CX88_DVB=y
CONFIG_VIDEO_CX88_VP3054=y
CONFIG_VIDEO_CX88_MPEG=y
CONFIG_VIDEO_HEXIUM_GEMINI=y
CONFIG_VIDEO_HEXIUM_ORION=y
CONFIG_VIDEO_IVTV=y
CONFIG_VIDEO_FB_IVTV=y
CONFIG_VIDEO_MEYE=y
CONFIG_VIDEO_MXB=y
CONFIG_VIDEO_SAA7134=y
CONFIG_VIDEO_SAA7134_ALSA=y
CONFIG_VIDEO_SAA7134_RC=y
CONFIG_VIDEO_SAA7134_DVB=y
CONFIG_VIDEO_SAA7164=y
CONFIG_VIDEO_ZORAN=y
CONFIG_VIDEO_ZORAN_DC30=y
CONFIG_VIDEO_ZORAN_ZR36060=y
CONFIG_VIDEO_ZORAN_BUZ=y
CONFIG_VIDEO_ZORAN_DC10=y
CONFIG_VIDEO_ZORAN_LML33=y
CONFIG_VIDEO_ZORAN_LML33R10=y
CONFIG_VIDEO_ZORAN_AVS6EYES=y
# CONFIG_V4L_ISA_PARPORT_DRIVERS is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
CONFIG_V4L_MEM2MEM_DRIVERS=y
# CONFIG_VIDEO_MEM2MEM_TESTDEV is not set
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_SI470X=y
CONFIG_USB_SI470X=y
CONFIG_USB_MR800=y
CONFIG_USB_DSBR=y
CONFIG_RADIO_MAXIRADIO=y
CONFIG_I2C_SI4713=y
CONFIG_RADIO_SI4713=y
# CONFIG_USB_KEENE is not set
CONFIG_RADIO_TEA5764=y
CONFIG_RADIO_TEA5764_XTAL=y
CONFIG_RADIO_SAA7706H=y
CONFIG_RADIO_TEF6862=y
CONFIG_RADIO_WL1273=y

#
# Texas Instruments WL128x FM driver (ST based)
#
# CONFIG_RADIO_WL128X is not set
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
CONFIG_TTPCI_EEPROM=y
CONFIG_DVB_AV7110=y
CONFIG_DVB_AV7110_OSD=y
CONFIG_DVB_BUDGET_CORE=y
CONFIG_DVB_BUDGET=y
CONFIG_DVB_BUDGET_CI=y
CONFIG_DVB_BUDGET_AV=y
CONFIG_DVB_BUDGET_PATCH=y

#
# Supported USB Adapters
#
CONFIG_DVB_USB=y
# CONFIG_DVB_USB_DEBUG is not set
CONFIG_DVB_USB_A800=y
CONFIG_DVB_USB_DIBUSB_MB=y
CONFIG_DVB_USB_DIBUSB_MB_FAULTY=y
CONFIG_DVB_USB_DIBUSB_MC=y
CONFIG_DVB_USB_DIB0700=y
CONFIG_DVB_USB_UMT_010=y
CONFIG_DVB_USB_CXUSB=y
CONFIG_DVB_USB_M920X=y
CONFIG_DVB_USB_GL861=y
CONFIG_DVB_USB_AU6610=y
CONFIG_DVB_USB_DIGITV=y
CONFIG_DVB_USB_VP7045=y
CONFIG_DVB_USB_VP702X=y
CONFIG_DVB_USB_GP8PSK=y
CONFIG_DVB_USB_NOVA_T_USB2=y
CONFIG_DVB_USB_TTUSB2=y
CONFIG_DVB_USB_DTT200U=y
CONFIG_DVB_USB_OPERA1=y
CONFIG_DVB_USB_AF9005=y
CONFIG_DVB_USB_AF9005_REMOTE=y
# CONFIG_DVB_USB_PCTV452E is not set
CONFIG_DVB_USB_DW2102=y
CONFIG_DVB_USB_CINERGY_T2=y
CONFIG_DVB_USB_ANYSEE=y
CONFIG_DVB_USB_DTV5100=y
CONFIG_DVB_USB_AF9015=y
CONFIG_DVB_USB_CE6230=y
CONFIG_DVB_USB_FRIIO=y
CONFIG_DVB_USB_EC168=y
# CONFIG_DVB_USB_AZ6007 is not set
CONFIG_DVB_USB_AZ6027=y
CONFIG_DVB_USB_LME2510=y
CONFIG_DVB_USB_TECHNISAT_USB2=y
CONFIG_DVB_USB_IT913X=y
# CONFIG_DVB_USB_MXL111SF is not set
# CONFIG_DVB_USB_RTL28XXU is not set
CONFIG_DVB_TTUSB_BUDGET=y
CONFIG_DVB_TTUSB_DEC=y
CONFIG_SMS_SIANO_MDTV=y

#
# Siano module components
#
CONFIG_SMS_USB_DRV=y
CONFIG_SMS_SDIO_DRV=y

#
# Supported FlexCopII (B2C2) Adapters
#
CONFIG_DVB_B2C2_FLEXCOP=y
CONFIG_DVB_B2C2_FLEXCOP_PCI=y
CONFIG_DVB_B2C2_FLEXCOP_USB=y
# CONFIG_DVB_B2C2_FLEXCOP_DEBUG is not set

#
# Supported BT878 Adapters
#
CONFIG_DVB_BT8XX=y

#
# Supported Pluto2 Adapters
#
CONFIG_DVB_PLUTO2=y

#
# Supported SDMC DM1105 Adapters
#
CONFIG_DVB_DM1105=y

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=y
CONFIG_DVB_FIREDTV_INPUT=y

#
# Supported Earthsoft PT1 Adapters
#
CONFIG_DVB_PT1=y

#
# Supported Mantis Adapters
#
CONFIG_MANTIS_CORE=y
CONFIG_DVB_MANTIS=y
CONFIG_DVB_HOPPER=y

#
# Supported nGene Adapters
#
CONFIG_DVB_NGENE=y

#
# Supported ddbridge ('Octopus') Adapters
#
# CONFIG_DVB_DDBRIDGE is not set

#
# Supported DVB Frontends
#
# CONFIG_DVB_FE_CUSTOMISE is not set

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=y
CONFIG_DVB_STB6100=y
CONFIG_DVB_STV090x=y
CONFIG_DVB_STV6110x=y

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=y
CONFIG_DVB_TDA18271C2DD=y

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=y
CONFIG_DVB_CX24123=y
CONFIG_DVB_MT312=y
CONFIG_DVB_ZL10036=y
CONFIG_DVB_ZL10039=y
CONFIG_DVB_S5H1420=y
CONFIG_DVB_STV0288=y
CONFIG_DVB_STB6000=y
CONFIG_DVB_STV0299=y
CONFIG_DVB_STV6110=y
CONFIG_DVB_STV0900=y
CONFIG_DVB_TDA8083=y
CONFIG_DVB_TDA10086=y
CONFIG_DVB_TDA8261=y
CONFIG_DVB_VES1X93=y
CONFIG_DVB_TUNER_ITD1000=y
CONFIG_DVB_TUNER_CX24113=y
CONFIG_DVB_TDA826X=y
CONFIG_DVB_TUA6100=y
CONFIG_DVB_CX24116=y
CONFIG_DVB_SI21XX=y
CONFIG_DVB_DS3000=y
CONFIG_DVB_MB86A16=y
CONFIG_DVB_TDA10071=y

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=y
CONFIG_DVB_SP887X=y
CONFIG_DVB_CX22700=y
CONFIG_DVB_CX22702=y
CONFIG_DVB_DRXD=y
CONFIG_DVB_L64781=y
CONFIG_DVB_TDA1004X=y
CONFIG_DVB_NXT6000=y
CONFIG_DVB_MT352=y
CONFIG_DVB_ZL10353=y
CONFIG_DVB_DIB3000MB=y
CONFIG_DVB_DIB3000MC=y
CONFIG_DVB_DIB7000M=y
CONFIG_DVB_DIB7000P=y
CONFIG_DVB_TDA10048=y
CONFIG_DVB_AF9013=y
CONFIG_DVB_EC100=y
CONFIG_DVB_STV0367=y
CONFIG_DVB_CXD2820R=y

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=y
CONFIG_DVB_TDA10021=y
CONFIG_DVB_TDA10023=y
CONFIG_DVB_STV0297=y

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=y
CONFIG_DVB_OR51211=y
CONFIG_DVB_OR51132=y
CONFIG_DVB_BCM3510=y
CONFIG_DVB_LGDT330X=y
CONFIG_DVB_LGDT3305=y
CONFIG_DVB_S5H1409=y
CONFIG_DVB_AU8522=y
CONFIG_DVB_S5H1411=y

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=y
CONFIG_DVB_DIB8000=y
CONFIG_DVB_MB86A20S=y

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=y
CONFIG_DVB_TUNER_DIB0070=y
CONFIG_DVB_TUNER_DIB0090=y

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=y
CONFIG_DVB_ISL6405=y
CONFIG_DVB_ISL6421=y
CONFIG_DVB_ISL6423=y
CONFIG_DVB_A8293=y
CONFIG_DVB_LGS8GXX=y
CONFIG_DVB_ATBM8830=y
CONFIG_DVB_TDA665x=y
CONFIG_DVB_IX2505V=y
CONFIG_DVB_IT913X_FE=y
CONFIG_DVB_M88RS2000=y

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=y
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_KMS=y
CONFIG_DRM_NOUVEAU=y
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
# CONFIG_DRM_NOUVEAU_DEBUG is not set

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
CONFIG_DRM_I2C_SIL164=y
# CONFIG_DRM_I810 is not set
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
CONFIG_DRM_MGA=y
CONFIG_DRM_SIS=y
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
CONFIG_DRM_VMWGFX=y
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_STUB_POULSBO is not set
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
# CONFIG_FB_WMT_GE_ROPS is not set
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=y
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=y
CONFIG_FB_CYBER2000_DDC=y
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
CONFIG_FB_VGA16=y
CONFIG_FB_UVESA=y
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
CONFIG_FB_MATROX=y
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=y
CONFIG_FB_MATROX_MAVEN=y
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
# CONFIG_FB_ATY_GENERIC_LCD is not set
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=y
CONFIG_FB_S3_DDC=y
CONFIG_FB_SAVAGE=y
# CONFIG_FB_SAVAGE_I2C is not set
# CONFIG_FB_SAVAGE_ACCEL is not set
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
CONFIG_FB_VIA=y
# CONFIG_FB_VIA_DIRECT_PROCFS is not set
CONFIG_FB_VIA_X_COMPATIBILITY=y
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
CONFIG_FB_SM501=y
# CONFIG_FB_SMSCUFX is not set
CONFIG_FB_UDL=y
CONFIG_FB_VIRTUAL=y
CONFIG_XEN_FBDEV_FRONTEND=y
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
# CONFIG_FB_BROADSHEET is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_PROGEAR=y
CONFIG_BACKLIGHT_APPLE=y
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_PCF50633 is not set
# CONFIG_BACKLIGHT_LP855X is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=y
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_HRTIMER=y
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_KCTL_JACK=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=y
CONFIG_SND_OPL3_LIB_SEQ=y
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
CONFIG_SND_EMU10K1_SEQ=y
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_VX_LIB=y
CONFIG_SND_AC97_CODEC=y
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=y
CONFIG_SND_DUMMY=y
CONFIG_SND_ALOOP=y
CONFIG_SND_VIRMIDI=y
CONFIG_SND_MTPAV=y
CONFIG_SND_MTS64=y
CONFIG_SND_SERIAL_U16550=y
CONFIG_SND_MPU401=y
CONFIG_SND_PORTMAN2X4=y
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0
CONFIG_SND_SB_COMMON=y
CONFIG_SND_SB16_DSP=y
CONFIG_SND_TEA575X=y
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=y
CONFIG_SND_ALS300=y
CONFIG_SND_ALS4000=y
CONFIG_SND_ALI5451=y
CONFIG_SND_ASIHPI=y
CONFIG_SND_ATIIXP=y
CONFIG_SND_ATIIXP_MODEM=y
CONFIG_SND_AU8810=y
CONFIG_SND_AU8820=y
CONFIG_SND_AU8830=y
# CONFIG_SND_AW2 is not set
CONFIG_SND_AZT3328=y
CONFIG_SND_BT87X=y
# CONFIG_SND_BT87X_OVERCLOCK is not set
CONFIG_SND_CA0106=y
CONFIG_SND_CMIPCI=y
CONFIG_SND_OXYGEN_LIB=y
CONFIG_SND_OXYGEN=y
CONFIG_SND_CS4281=y
CONFIG_SND_CS46XX=y
CONFIG_SND_CS46XX_NEW_DSP=y
CONFIG_SND_CS5530=y
CONFIG_SND_CS5535AUDIO=y
CONFIG_SND_CTXFI=y
CONFIG_SND_DARLA20=y
CONFIG_SND_GINA20=y
CONFIG_SND_LAYLA20=y
CONFIG_SND_DARLA24=y
CONFIG_SND_GINA24=y
CONFIG_SND_LAYLA24=y
CONFIG_SND_MONA=y
CONFIG_SND_MIA=y
CONFIG_SND_ECHO3G=y
CONFIG_SND_INDIGO=y
CONFIG_SND_INDIGOIO=y
CONFIG_SND_INDIGODJ=y
CONFIG_SND_INDIGOIOX=y
CONFIG_SND_INDIGODJX=y
CONFIG_SND_EMU10K1=y
CONFIG_SND_EMU10K1X=y
CONFIG_SND_ENS1370=y
CONFIG_SND_ENS1371=y
CONFIG_SND_ES1938=y
CONFIG_SND_ES1968=y
CONFIG_SND_ES1968_INPUT=y
CONFIG_SND_ES1968_RADIO=y
CONFIG_SND_FM801=y
CONFIG_SND_FM801_TEA575X_BOOL=y
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_PREALLOC_SIZE=64
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=1
CONFIG_SND_HDA_INPUT_JACK=y
CONFIG_SND_HDA_PATCH_LOADER=y
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_ENABLE_REALTEK_QUIRKS=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_HDMI=y
CONFIG_SND_HDA_CODEC_CIRRUS=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CA0110=y
CONFIG_SND_HDA_CODEC_CA0132=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
CONFIG_SND_HDSP=y

#
# Don't forget to add built-in firmwares for HDSP driver
#
CONFIG_SND_HDSPM=y
CONFIG_SND_ICE1712=y
CONFIG_SND_ICE1724=y
CONFIG_SND_INTEL8X0=y
CONFIG_SND_INTEL8X0M=y
CONFIG_SND_KORG1212=y
CONFIG_SND_LOLA=y
CONFIG_SND_LX6464ES=y
CONFIG_SND_MAESTRO3=y
CONFIG_SND_MAESTRO3_INPUT=y
CONFIG_SND_MIXART=y
CONFIG_SND_NM256=y
CONFIG_SND_PCXHR=y
CONFIG_SND_RIPTIDE=y
CONFIG_SND_RME32=y
CONFIG_SND_RME96=y
CONFIG_SND_RME9652=y
CONFIG_SND_SONICVIBES=y
CONFIG_SND_TRIDENT=y
CONFIG_SND_VIA82XX=y
CONFIG_SND_VIA82XX_MODEM=y
CONFIG_SND_VIRTUOSO=y
CONFIG_SND_VX222=y
CONFIG_SND_YMFPCI=y
CONFIG_SND_SPI=y
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=y
CONFIG_SND_USB_UA101=y
CONFIG_SND_USB_USX2Y=y
CONFIG_SND_USB_CAIAQ=y
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_USB_US122L=y
CONFIG_SND_USB_6FIRE=y
CONFIG_SND_FIREWIRE=y
CONFIG_SND_FIREWIRE_LIB=y
CONFIG_SND_FIREWIRE_SPEAKERS=y
CONFIG_SND_ISIGHT=y
CONFIG_SND_PCMCIA=y
CONFIG_SND_VXPOCKET=y
CONFIG_SND_PDAUDIOCF=y
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=y
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_PRODIKEYS=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
# CONFIG_HID_HOLTEK is not set
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LEDS=y
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_ROCCAT=y
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
# CONFIG_HID_HYPERV_MOUSE is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=y
# CONFIG_HID_WACOM_POWER_SUPPLY is not set
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICEFS is not set
CONFIG_USB_DEVICE_CLASS=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_DWC3 is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB=y
CONFIG_USB_WUSB_CBAF=y
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=y
# CONFIG_USB_XHCI_HCD_DEBUGGING is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_OXU210HP_HCD is not set
CONFIG_USB_ISP116X_HCD=y
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_SSB is not set
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=y
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_HCD_ISO is not set
CONFIG_USB_SL811_CS=y
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_WHCI_HCD=y
CONFIG_USB_HWA_HCD=y
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_RENESAS_USBHS is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=y
CONFIG_REALTEK_AUTOPM=y
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=y
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
CONFIG_USB_STORAGE_ENE_UB6250=y
CONFIG_USB_UAS=y
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y

#
# USB port drivers
#
CONFIG_USB_USS720=y
CONFIG_USB_SERIAL=y
# CONFIG_USB_SERIAL_CONSOLE is not set
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=y
CONFIG_USB_SERIAL_ARK3116=y
CONFIG_USB_SERIAL_BELKIN=y
CONFIG_USB_SERIAL_CH341=y
CONFIG_USB_SERIAL_WHITEHEAT=y
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
CONFIG_USB_SERIAL_CP210X=y
CONFIG_USB_SERIAL_CYPRESS_M8=y
CONFIG_USB_SERIAL_EMPEG=y
CONFIG_USB_SERIAL_FTDI_SIO=y
CONFIG_USB_SERIAL_FUNSOFT=y
CONFIG_USB_SERIAL_VISOR=y
CONFIG_USB_SERIAL_IPAQ=y
CONFIG_USB_SERIAL_IR=y
CONFIG_USB_SERIAL_EDGEPORT=y
CONFIG_USB_SERIAL_EDGEPORT_TI=y
# CONFIG_USB_SERIAL_F81232 is not set
CONFIG_USB_SERIAL_GARMIN=y
CONFIG_USB_SERIAL_IPW=y
CONFIG_USB_SERIAL_IUU=y
CONFIG_USB_SERIAL_KEYSPAN_PDA=y
CONFIG_USB_SERIAL_KEYSPAN=y
CONFIG_USB_SERIAL_KLSI=y
CONFIG_USB_SERIAL_KOBIL_SCT=y
CONFIG_USB_SERIAL_MCT_U232=y
# CONFIG_USB_SERIAL_METRO is not set
CONFIG_USB_SERIAL_MOS7720=y
CONFIG_USB_SERIAL_MOS7715_PARPORT=y
CONFIG_USB_SERIAL_MOS7840=y
CONFIG_USB_SERIAL_MOTOROLA=y
CONFIG_USB_SERIAL_NAVMAN=y
CONFIG_USB_SERIAL_PL2303=y
CONFIG_USB_SERIAL_OTI6858=y
CONFIG_USB_SERIAL_QCAUX=y
CONFIG_USB_SERIAL_QUALCOMM=y
CONFIG_USB_SERIAL_SPCP8X5=y
CONFIG_USB_SERIAL_HP4X=y
CONFIG_USB_SERIAL_SAFE=y
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
CONFIG_USB_SERIAL_SIEMENS_MPI=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=y
CONFIG_USB_SERIAL_SYMBOL=y
CONFIG_USB_SERIAL_TI=y
CONFIG_USB_SERIAL_CYBERJACK=y
CONFIG_USB_SERIAL_XIRCOM=y
CONFIG_USB_SERIAL_WWAN=y
CONFIG_USB_SERIAL_OPTION=y
CONFIG_USB_SERIAL_OMNINET=y
CONFIG_USB_SERIAL_OPTICON=y
CONFIG_USB_SERIAL_VIVOPAY_SERIAL=y
CONFIG_USB_SERIAL_ZIO=y
CONFIG_USB_SERIAL_SSU100=y
CONFIG_USB_SERIAL_DEBUG=y

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=y
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y
CONFIG_USB_ATM=y
CONFIG_USB_SPEEDTOUCH=y
CONFIG_USB_CXACRU=y
CONFIG_USB_UEAGLEATM=y
CONFIG_USB_XUSBATM=y
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2
# CONFIG_USB_R8A66597 is not set
# CONFIG_USB_MV_UDC is not set
# CONFIG_USB_M66592 is not set
# CONFIG_USB_AMD5536UDC is not set
# CONFIG_USB_CI13XXX_PCI is not set
# CONFIG_USB_NET2272 is not set
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
CONFIG_USB_EG20T=y
# CONFIG_USB_DUMMY_HCD is not set
CONFIG_USB_GADGET_DUALSPEED=y
# CONFIG_USB_ZERO is not set
# CONFIG_USB_AUDIO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_FILE_STORAGE is not set
# CONFIG_USB_MASS_STORAGE is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_MIDI_GADGET is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_NOKIA is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_USB_G_WEBCAM is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
# CONFIG_USB_GPIO_VBUS is not set
CONFIG_NOP_USB_XCEIV=y
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
CONFIG_UWB_I1480U=y
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=y
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_WBSD=y
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_SPI=y
CONFIG_MMC_SDRICOH_CS=y
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
CONFIG_MMC_VUB300=y
CONFIG_MMC_USHC=y
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_MEMSTICK_R592=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=y
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_CLEVO_MAIL=y
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_PCA9633 is not set
CONFIG_LEDS_DAC124S085=y
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_INTEL_SS4200=y
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_DELL_NETBOOKS=y
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_IDE_DISK=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=y
CONFIG_INFINIBAND_MTHCA_DEBUG=y
CONFIG_INFINIBAND_IPATH=y
CONFIG_INFINIBAND_QIB=y
CONFIG_INFINIBAND_AMSO1100=y
# CONFIG_INFINIBAND_AMSO1100_DEBUG is not set
CONFIG_INFINIBAND_CXGB3=y
# CONFIG_INFINIBAND_CXGB3_DEBUG is not set
CONFIG_INFINIBAND_CXGB4=y
CONFIG_MLX4_INFINIBAND=y
CONFIG_INFINIBAND_NES=y
# CONFIG_INFINIBAND_NES_DEBUG is not set
CONFIG_INFINIBAND_IPOIB=y
CONFIG_INFINIBAND_IPOIB_CM=y
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=y
# CONFIG_INFINIBAND_SRPT is not set
CONFIG_INFINIBAND_ISER=y
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=y
# CONFIG_EDAC_MCE_INJ is not set
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_AMD64=y
# CONFIG_EDAC_AMD64_ERROR_INJECTION is not set
CONFIG_EDAC_E752X=y
CONFIG_EDAC_I82975X=y
CONFIG_EDAC_I3000=y
CONFIG_EDAC_I3200=y
CONFIG_EDAC_X38=y
CONFIG_EDAC_I5400=y
CONFIG_EDAC_I7CORE=y
CONFIG_EDAC_I5000=y
CONFIG_EDAC_I5100=y
CONFIG_EDAC_I7300=y
# CONFIG_EDAC_SBRIDGE is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1672=y
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
# CONFIG_RTC_DRV_ISL12022 is not set
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
# CONFIG_RTC_DRV_M41T80_WDT is not set
CONFIG_RTC_DRV_BQ32K=y
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=y
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
CONFIG_RTC_DRV_M41T94=y
CONFIG_RTC_DRV_DS1305=y
CONFIG_RTC_DRV_DS1390=y
CONFIG_RTC_DRV_MAX6902=y
CONFIG_RTC_DRV_R9701=y
CONFIG_RTC_DRV_RS5C348=y
CONFIG_RTC_DRV_DS3234=y
CONFIG_RTC_DRV_PCF2123=y

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_PCF50633=y

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
CONFIG_INTEL_IOATDMA=y
# CONFIG_TIMB_DMA is not set
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DCA=y
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=y
CONFIG_UIO_PDRV=y
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
CONFIG_UIO_NETX=y
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=y
CONFIG_HYPERV_UTILS=y

#
# Xen driver support
#
CONFIG_XEN_BALLOON=y
# CONFIG_XEN_BALLOON_MEMORY_HOTPLUG is not set
CONFIG_XEN_SCRUB_PAGES=y
CONFIG_XEN_DEV_EVTCHN=y
CONFIG_XEN_BACKEND=y
CONFIG_XENFS=y
CONFIG_XEN_COMPAT_XENFS=y
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
CONFIG_XEN_GNTDEV=y
CONFIG_XEN_GRANT_DEV_ALLOC=y
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_PCIDEV_BACKEND=y
CONFIG_XEN_PRIVCMD=y
CONFIG_XEN_ACPI_PROCESSOR=m
CONFIG_STAGING=y
CONFIG_ET131X=y
# CONFIG_SLICOSS is not set
CONFIG_USBIP_CORE=y
CONFIG_USBIP_VHCI_HCD=y
CONFIG_USBIP_HOST=y
# CONFIG_USBIP_DEBUG is not set
# CONFIG_W35UND is not set
CONFIG_PRISM2_USB=y
# CONFIG_ECHO is not set
CONFIG_COMEDI=m
# CONFIG_COMEDI_DEBUG is not set
CONFIG_COMEDI_MISC_DRIVERS=m
CONFIG_COMEDI_KCOMEDILIB=m
CONFIG_COMEDI_BOND=m
CONFIG_COMEDI_TEST=m
CONFIG_COMEDI_PARPORT=m
CONFIG_COMEDI_SERIAL2002=m
# CONFIG_COMEDI_SKEL is not set
CONFIG_COMEDI_PCI_DRIVERS=m
CONFIG_COMEDI_ADDI_APCI_035=m
CONFIG_COMEDI_ADDI_APCI_1032=m
CONFIG_COMEDI_ADDI_APCI_1500=m
CONFIG_COMEDI_ADDI_APCI_1516=m
CONFIG_COMEDI_ADDI_APCI_1564=m
CONFIG_COMEDI_ADDI_APCI_16XX=m
CONFIG_COMEDI_ADDI_APCI_2016=m
CONFIG_COMEDI_ADDI_APCI_2032=m
CONFIG_COMEDI_ADDI_APCI_2200=m
CONFIG_COMEDI_ADDI_APCI_3001=m
CONFIG_COMEDI_ADDI_APCI_3120=m
CONFIG_COMEDI_ADDI_APCI_3501=m
CONFIG_COMEDI_ADDI_APCI_3XXX=m
CONFIG_COMEDI_ADL_PCI6208=m
# CONFIG_COMEDI_ADL_PCI7230 is not set
CONFIG_COMEDI_ADL_PCI7296=m
CONFIG_COMEDI_ADL_PCI7432=m
CONFIG_COMEDI_ADL_PCI8164=m
CONFIG_COMEDI_ADL_PCI9111=m
CONFIG_COMEDI_ADL_PCI9118=m
CONFIG_COMEDI_ADV_PCI1710=m
CONFIG_COMEDI_ADV_PCI1723=m
CONFIG_COMEDI_ADV_PCI_DIO=m
# CONFIG_COMEDI_AMPLC_DIO200 is not set
# CONFIG_COMEDI_AMPLC_PC236 is not set
# CONFIG_COMEDI_AMPLC_PC263 is not set
CONFIG_COMEDI_AMPLC_PCI224=m
CONFIG_COMEDI_AMPLC_PCI230=m
CONFIG_COMEDI_CONTEC_PCI_DIO=m
CONFIG_COMEDI_DT3000=m
# CONFIG_COMEDI_DYNA_PCI10XX is not set
CONFIG_COMEDI_UNIOXX5=m
CONFIG_COMEDI_GSC_HPDI=m
CONFIG_COMEDI_ICP_MULTI=m
CONFIG_COMEDI_II_PCI20KC=m
CONFIG_COMEDI_DAQBOARD2000=m
CONFIG_COMEDI_JR3_PCI=m
CONFIG_COMEDI_KE_COUNTER=m
CONFIG_COMEDI_CB_PCIDAS64=m
CONFIG_COMEDI_CB_PCIDAS=m
CONFIG_COMEDI_CB_PCIDDA=m
CONFIG_COMEDI_CB_PCIDIO=m
CONFIG_COMEDI_CB_PCIMDAS=m
CONFIG_COMEDI_CB_PCIMDDA=m
CONFIG_COMEDI_ME4000=m
CONFIG_COMEDI_ME_DAQ=m
CONFIG_COMEDI_NI_6527=m
CONFIG_COMEDI_NI_65XX=m
CONFIG_COMEDI_NI_660X=m
CONFIG_COMEDI_NI_670X=m
CONFIG_COMEDI_NI_PCIDIO=m
CONFIG_COMEDI_NI_PCIMIO=m
CONFIG_COMEDI_RTD520=m
CONFIG_COMEDI_S526=m
CONFIG_COMEDI_S626=m
CONFIG_COMEDI_SSV_DNP=m
CONFIG_COMEDI_PCMCIA_DRIVERS=m
CONFIG_COMEDI_CB_DAS16_CS=m
CONFIG_COMEDI_DAS08_CS=m
CONFIG_COMEDI_NI_DAQ_700_CS=m
CONFIG_COMEDI_NI_DAQ_DIO24_CS=m
CONFIG_COMEDI_NI_LABPC_CS=m
CONFIG_COMEDI_NI_MIO_CS=m
CONFIG_COMEDI_QUATECH_DAQP_CS=m
CONFIG_COMEDI_USB_DRIVERS=m
CONFIG_COMEDI_DT9812=m
CONFIG_COMEDI_USBDUX=m
CONFIG_COMEDI_USBDUXFAST=m
# CONFIG_COMEDI_USBDUXSIGMA is not set
CONFIG_COMEDI_VMK80XX=m
CONFIG_COMEDI_NI_COMMON=m
CONFIG_COMEDI_MITE=m
CONFIG_COMEDI_NI_TIO=m
CONFIG_COMEDI_NI_LABPC=m
CONFIG_COMEDI_8255=m
CONFIG_COMEDI_DAS08=m
CONFIG_COMEDI_FC=m
# CONFIG_ASUS_OLED is not set
# CONFIG_PANEL is not set
CONFIG_R8187SE=m
CONFIG_RTL8192U=m
# CONFIG_RTLLIB is not set
CONFIG_R8712U=y
CONFIG_RTS_PSTOR=y
# CONFIG_RTS_PSTOR_DEBUG is not set
# CONFIG_RTS5139 is not set
# CONFIG_TRANZPORT is not set
# CONFIG_IDE_PHISON is not set
# CONFIG_LINE6_USB is not set
# CONFIG_USB_SERIAL_QUATECH2 is not set
# CONFIG_USB_SERIAL_QUATECH_USB2 is not set
# CONFIG_VT6655 is not set
CONFIG_VT6656=m
# CONFIG_VME_BUS is not set
# CONFIG_DX_SEP is not set
# CONFIG_IIO is not set
CONFIG_ZRAM=y
# CONFIG_ZRAM_DEBUG is not set
CONFIG_ZSMALLOC=y
# CONFIG_WLAGS49_H2 is not set
# CONFIG_WLAGS49_H25 is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_CXT1E1 is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_SBE_2T3E3 is not set
# CONFIG_USB_ENESTORAGE is not set
# CONFIG_BCM_WIMAX is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_SPEAKUP=y
CONFIG_SPEAKUP_SYNTH_ACNTSA=y
CONFIG_SPEAKUP_SYNTH_ACNTPC=y
CONFIG_SPEAKUP_SYNTH_APOLLO=y
CONFIG_SPEAKUP_SYNTH_AUDPTR=y
CONFIG_SPEAKUP_SYNTH_BNS=y
CONFIG_SPEAKUP_SYNTH_DECTLK=y
CONFIG_SPEAKUP_SYNTH_DECEXT=y
# CONFIG_SPEAKUP_SYNTH_DECPC is not set
CONFIG_SPEAKUP_SYNTH_DTLK=y
CONFIG_SPEAKUP_SYNTH_KEYPC=y
CONFIG_SPEAKUP_SYNTH_LTLK=y
CONFIG_SPEAKUP_SYNTH_SOFT=y
CONFIG_SPEAKUP_SYNTH_SPKOUT=y
CONFIG_SPEAKUP_SYNTH_TXPRT=y
CONFIG_SPEAKUP_SYNTH_DUMMY=y
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
# CONFIG_INTEL_MEI is not set
CONFIG_STAGING_MEDIA=y
# CONFIG_DVB_AS102 is not set
# CONFIG_DVB_CXD2099 is not set
# CONFIG_VIDEO_DT3155 is not set
CONFIG_EASYCAP=y
# CONFIG_EASYCAP_DEBUG is not set
# CONFIG_VIDEO_GO7007 is not set
# CONFIG_SOLO6X10 is not set
CONFIG_LIRC_STAGING=y
CONFIG_LIRC_BT829=y
CONFIG_LIRC_IGORPLUGUSB=y
CONFIG_LIRC_IMON=y
# CONFIG_LIRC_PARALLEL is not set
CONFIG_LIRC_SASEM=y
CONFIG_LIRC_SERIAL=y
CONFIG_LIRC_SERIAL_TRANSMITTER=y
CONFIG_LIRC_SIR=y
CONFIG_LIRC_TTUSBIR=y
CONFIG_LIRC_ZILOG=y

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_PHONE=y
CONFIG_PHONE_IXJ=y
CONFIG_PHONE_IXJ_PCMCIA=y
# CONFIG_USB_WPAN_HCD is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=y
CONFIG_ACERHDF=y
CONFIG_ASUS_LAPTOP=y
CONFIG_DELL_LAPTOP=y
CONFIG_DELL_WMI=y
CONFIG_DELL_WMI_AIO=y
CONFIG_FUJITSU_LAPTOP=y
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
# CONFIG_FUJITSU_TABLET is not set
CONFIG_AMILO_RFKILL=y
CONFIG_HP_ACCEL=y
CONFIG_HP_WMI=y
CONFIG_MSI_LAPTOP=y
CONFIG_PANASONIC_LAPTOP=y
CONFIG_COMPAL_LAPTOP=y
CONFIG_SONY_LAPTOP=y
CONFIG_SONYPI_COMPAT=y
CONFIG_IDEAPAD_LAPTOP=y
CONFIG_THINKPAD_ACPI=y
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_SENSORS_HDAPS=y
# CONFIG_INTEL_MENLOW is not set
CONFIG_EEEPC_LAPTOP=y
CONFIG_ASUS_WMI=y
CONFIG_ASUS_NB_WMI=y
CONFIG_EEEPC_WMI=y
CONFIG_ACPI_WMI=y
CONFIG_MSI_WMI=y
CONFIG_TOPSTAR_LAPTOP=y
CONFIG_ACPI_TOSHIBA=y
CONFIG_TOSHIBA_BT_RFKILL=y
CONFIG_ACPI_CMPC=y
CONFIG_INTEL_IPS=y
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_MXM_WMI=y
CONFIG_INTEL_OAKTRAIL=y
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_AMD_IOMMU=y
# CONFIG_AMD_IOMMU_STATS is not set
# CONFIG_AMD_IOMMU_V2 is not set
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
CONFIG_IRQ_REMAP=y

#
# Remoteproc drivers (EXPERIMENTAL)
#

#
# Rpmsg drivers (EXPERIMENTAL)
#
# CONFIG_VIRT_DRIVERS is not set
# CONFIG_PM_DEVFREQ is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=y
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=y
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=y
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="utf8"
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=y
CONFIG_ECRYPT_FS=y
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
CONFIG_JFFS2_SUMMARY=y
CONFIG_JFFS2_FS_XATTR=y
CONFIG_JFFS2_FS_POSIX_ACL=y
CONFIG_JFFS2_FS_SECURITY=y
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
CONFIG_JFFS2_LZO=y
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
# CONFIG_JFFS2_CMODE_NONE is not set
CONFIG_JFFS2_CMODE_PRIORITY=y
# CONFIG_JFFS2_CMODE_SIZE is not set
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
CONFIG_UBIFS_FS=y
# CONFIG_UBIFS_FS_XATTR is not set
CONFIG_UBIFS_FS_ADVANCED_COMPR=y
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_UBIFS_FS_DEBUG is not set
CONFIG_LOGFS=y
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=y
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=y
# CONFIG_QNX6FS_FS is not set
CONFIG_ROMFS_FS=y
# CONFIG_ROMFS_BACKED_BY_BLOCK is not set
# CONFIG_ROMFS_BACKED_BY_MTD is not set
CONFIG_ROMFS_BACKED_BY_BOTH=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_ROMFS_ON_MTD=y
CONFIG_PSTORE=y
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_EXOFS_FS=y
# CONFIG_EXOFS_DEBUG is not set
CONFIG_ORE=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_NFS_V4_1=y
CONFIG_PNFS_FILE_LAYOUT=y
CONFIG_PNFS_BLOCK=m
CONFIG_PNFS_OBJLAYOUT=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
CONFIG_ROOT_NFS=y
CONFIG_NFS_FSCACHE=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFSD=y
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
# CONFIG_NFSD_FAULT_INJECTION is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_SUNRPC_XPRT_RDMA=y
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_SUNRPC_DEBUG is not set
CONFIG_CEPH_FS=y
CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_DFS_UPCALL=y
CONFIG_CIFS_FSCACHE=y
CONFIG_CIFS_ACL=y
CONFIG_NCP_FS=y
CONFIG_NCPFS_PACKET_SIGNING=y
CONFIG_NCPFS_IOCTL_LOCKING=y
CONFIG_NCPFS_STRONG=y
CONFIG_NCPFS_NFS_NS=y
CONFIG_NCPFS_OS2_NS=y
# CONFIG_NCPFS_SMALLDOS is not set
CONFIG_NCPFS_NLS=y
CONFIG_NCPFS_EXTRAS=y
CONFIG_CODA_FS=y
CONFIG_AFS_FS=y
# CONFIG_AFS_DEBUG is not set
CONFIG_AFS_FSCACHE=y
CONFIG_9P_FS=y
CONFIG_9P_FSCACHE=y
CONFIG_9P_FS_POSIX_ACL=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
CONFIG_DLM_DEBUG=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=300
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_DEBUG_SLAB=y
# CONFIG_DEBUG_SLAB_LEAK is not set
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
# CONFIG_PROVE_RCU is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
CONFIG_TEST_LIST_SORT=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_BLOCK_EXT_DEVT=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_LKDTM=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAIL_MMC_REQUEST is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
CONFIG_LATENCYTOP=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FTRACE_NMI_ENTER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_FTRACE_NMI_ENTER=y
CONFIG_EVENT_TRACING=y
CONFIG_EVENT_POWER_TRACING_DEPRECATED=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
CONFIG_DYNAMIC_FTRACE=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
# CONFIG_EVENT_TRACE_TEST_SYSCALLS is not set
CONFIG_MMIOTRACE=y
# CONFIG_MMIOTRACE_TEST is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_TEST_KSTRTOX is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_TRUSTED_KEYS is not set
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
# CONFIG_INTEL_TXT is not set
CONFIG_LSM_MMAP_MIN_ADDR=65536
CONFIG_SECURITY_SELINUX=y
# CONFIG_SECURITY_SELINUX_BOOTPARAM is not set
# CONFIG_SECURITY_SELINUX_DISABLE is not set
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
CONFIG_SECURITY_TOMOYO=y
CONFIG_SECURITY_TOMOYO_MAX_ACCEPT_ENTRY=2048
CONFIG_SECURITY_TOMOYO_MAX_AUDIT_LOG=1024
# CONFIG_SECURITY_TOMOYO_OMIT_USERSPACE_LOADER is not set
CONFIG_SECURITY_TOMOYO_POLICY_LOADER="/sbin/tomoyo-init"
CONFIG_SECURITY_TOMOYO_ACTIVATION_TRIGGER="/sbin/init"
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
# CONFIG_SECURITY_YAMA is not set
# CONFIG_IMA is not set
# CONFIG_EVM is not set
# CONFIG_DEFAULT_SECURITY_SELINUX is not set
# CONFIG_DEFAULT_SECURITY_TOMOYO is not set
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=y
# CONFIG_CRYPTO_CAMELLIA_X86_64 is not set
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
CONFIG_KVM_AMD=y
# CONFIG_KVM_MMU_AUDIT is not set
CONFIG_VHOST_NET=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
# CONFIG_CPUMASK_OFFSTACK is not set
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_LRU_CACHE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y

--=_4fd91c57.QUPvmKpaiKC7NMbdRYJGnC0mkHZgL2sWbuuLZuxtc33/kohi--
