From: wfg@linux.intel.com
Subject: drivers/block/cpqarray.c:938:2: error: too many arguments to
	function =?utf-8?Q?=E2=80=98blk=5Frq=5Fmap=5Fsg=E2=80=99?=
Date: Thu, 14 Jun 2012 07:03:27 +0800
Message-ID: <4fd91c3f.KAwMcygw9fFGn9Cx%wfg@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="=_4fd91c3f.R4ms68f5hejM12e5zdJOlaXCA5NYIvmvSlWnmiraoFWGO1Xb"
Return-path: <virtualization-bounces@lists.linux-foundation.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

--=_4fd91c3f.R4ms68f5hejM12e5zdJOlaXCA5NYIvmvSlWnmiraoFWGO1Xb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

FYI, kernel build failed on

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.g=
it multiqueue
head:   e9a6aa8a0b7b93195774a9fcf551632bf3abcd97
commit: 67db7275fa4325d46853a4bfcb79acf32e48eca8 [1/3] multiqueue: a hodg=
e podge of things
config: i386-allmodconfig (attached as .config)

All related error/warning messages are:

block/blk-core.c: In function =E2=80=98attempt_plug_merge=E2=80=99:
block/blk-core.c:1253:9: error: =E2=80=98struct request=E2=80=99 has no m=
ember named =E2=80=98q=E2=80=99
drivers/block/cpqarray.c:938:2: warning: passing argument 1 of =E2=80=98b=
lk_rq_map_sg=E2=80=99 from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected =E2=80=98struct request *=E2=
=80=99 but argument is of type =E2=80=98struct request_queue *=E2=80=99
drivers/block/cpqarray.c:938:2: warning: passing argument 2 of =E2=80=98b=
lk_rq_map_sg=E2=80=99 from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected =E2=80=98struct scatterlist=
 *=E2=80=99 but argument is of type =E2=80=98struct request *=E2=80=99
drivers/block/cpqarray.c:938:2: error: too many arguments to function =E2=
=80=98blk_rq_map_sg=E2=80=99
include/linux/blkdev.h:845:12: note: declared here
drivers/block/cciss.c:3339:2: warning: passing argument 1 of =E2=80=98blk=
_rq_map_sg=E2=80=99 from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected =E2=80=98struct request *=E2=
=80=99 but argument is of type =E2=80=98struct request_queue *=E2=80=99
drivers/block/cciss.c:3339:2: warning: passing argument 2 of =E2=80=98blk=
_rq_map_sg=E2=80=99 from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected =E2=80=98struct scatterlist=
 *=E2=80=99 but argument is of type =E2=80=98struct request *=E2=80=99
drivers/block/cciss.c:3339:2: error: too many arguments to function =E2=80=
=98blk_rq_map_sg=E2=80=99
include/linux/blkdev.h:845:12: note: declared here
drivers/block/DAC960.c:3355:5: warning: passing argument 1 of =E2=80=98bl=
k_rq_map_sg=E2=80=99 from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected =E2=80=98struct request *=E2=
=80=99 but argument is of type =E2=80=98struct request_queue *=E2=80=99
drivers/block/DAC960.c:3355:5: warning: passing argument 2 of =E2=80=98bl=
k_rq_map_sg=E2=80=99 from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected =E2=80=98struct scatterlist=
 *=E2=80=99 but argument is of type =E2=80=98struct request *=E2=80=99
drivers/block/DAC960.c:3355:5: error: too many arguments to function =E2=80=
=98blk_rq_map_sg=E2=80=99
include/linux/blkdev.h:845:12: note: declared here
drivers/block/DAC960.c:3433:3: warning: passing argument 1 of =E2=80=98bl=
k_rq_map_sg=E2=80=99 from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected =E2=80=98struct request *=E2=
=80=99 but argument is of type =E2=80=98struct request_queue *=E2=80=99
drivers/block/DAC960.c:3433:3: warning: passing argument 2 of =E2=80=98bl=
k_rq_map_sg=E2=80=99 from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected =E2=80=98struct scatterlist=
 *=E2=80=99 but argument is of type =E2=80=98struct request *=E2=80=99
drivers/block/DAC960.c:3433:3: error: too many arguments to function =E2=80=
=98blk_rq_map_sg=E2=80=99
include/linux/blkdev.h:845:12: note: declared here
drivers/block/sx8.c:873:2: warning: passing argument 1 of =E2=80=98blk_rq=
_map_sg=E2=80=99 from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected =E2=80=98struct request *=E2=
=80=99 but argument is of type =E2=80=98struct request_queue *=E2=80=99
drivers/block/sx8.c:873:2: warning: passing argument 2 of =E2=80=98blk_rq=
_map_sg=E2=80=99 from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected =E2=80=98struct scatterlist=
 *=E2=80=99 but argument is of type =E2=80=98struct request *=E2=80=99
drivers/block/sx8.c:873:2: error: too many arguments to function =E2=80=98=
blk_rq_map_sg=E2=80=99
include/linux/blkdev.h:845:12: note: declared here
drivers/block/ub.c:638:2: warning: passing argument 1 of =E2=80=98blk_rq_=
map_sg=E2=80=99 from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected =E2=80=98struct request *=E2=
=80=99 but argument is of type =E2=80=98struct request_queue *=E2=80=99
drivers/block/ub.c:638:2: warning: passing argument 2 of =E2=80=98blk_rq_=
map_sg=E2=80=99 from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected =E2=80=98struct scatterlist=
 *=E2=80=99 but argument is of type =E2=80=98struct request *=E2=80=99
drivers/block/ub.c:638:2: error: too many arguments to function =E2=80=98=
blk_rq_map_sg=E2=80=99
include/linux/blkdev.h:845:12: note: declared here
drivers/ide/ide-io.c:229:2: warning: passing argument 1 of =E2=80=98blk_r=
q_map_sg=E2=80=99 from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected =E2=80=98struct request *=E2=
=80=99 but argument is of type =E2=80=98struct request_queue *=E2=80=99
drivers/ide/ide-io.c:229:2: warning: passing argument 2 of =E2=80=98blk_r=
q_map_sg=E2=80=99 from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected =E2=80=98struct scatterlist=
 *=E2=80=99 but argument is of type =E2=80=98struct request *=E2=80=99
drivers/ide/ide-io.c:229:2: error: too many arguments to function =E2=80=98=
blk_rq_map_sg=E2=80=99
include/linux/blkdev.h:845:12: note: declared here
drivers/ide/ide-probe.c:762:2: error: too few arguments to function =E2=80=
=98blk_init_queue_node=E2=80=99
include/linux/blkdev.h:794:30: note: declared here
drivers/ide/ide-park.c:55:2: warning: passing argument 1 of =E2=80=98elv_=
add_request=E2=80=99 from incompatible pointer type [enabled by default]
include/linux/elevator.h:115:13: note: expected =E2=80=98struct request *=
=E2=80=99 but argument is of type =E2=80=98struct request_queue *=E2=80=99
drivers/ide/ide-park.c:55:2: warning: passing argument 2 of =E2=80=98elv_=
add_request=E2=80=99 makes integer from pointer without a cast [enabled b=
y default]
include/linux/elevator.h:115:13: note: expected =E2=80=98int=E2=80=99 but=
 argument is of type =E2=80=98struct request *=E2=80=99
drivers/ide/ide-park.c:55:2: error: too many arguments to function =E2=80=
=98elv_add_request=E2=80=99
include/linux/elevator.h:115:13: note: declared here
drivers/ide/ide-atapi.c:237:2: warning: passing argument 1 of =E2=80=98el=
v_add_request=E2=80=99 from incompatible pointer type [enabled by default=
]
include/linux/elevator.h:115:13: note: expected =E2=80=98struct request *=
=E2=80=99 but argument is of type =E2=80=98struct request_queue *=E2=80=99
drivers/ide/ide-atapi.c:237:2: warning: passing argument 2 of =E2=80=98el=
v_add_request=E2=80=99 makes integer from pointer without a cast [enabled=
 by default]
include/linux/elevator.h:115:13: note: expected =E2=80=98int=E2=80=99 but=
 argument is of type =E2=80=98struct request *=E2=80=99
drivers/ide/ide-atapi.c:237:2: error: too many arguments to function =E2=80=
=98elv_add_request=E2=80=99
include/linux/elevator.h:115:13: note: declared here
drivers/memstick/core/mspro_block.c:711:13: warning: passing argument 2 o=
f =E2=80=98blk_rq_map_sg=E2=80=99 from incompatible pointer type [enabled=
 by default]
include/linux/blkdev.h:845:12: note: expected =E2=80=98struct scatterlist=
 *=E2=80=99 but argument is of type =E2=80=98struct request *=E2=80=99
drivers/memstick/core/mspro_block.c:711:13: error: too many arguments to =
function =E2=80=98blk_rq_map_sg=E2=80=99
include/linux/blkdev.h:845:12: note: declared here
drivers/mmc/card/queue.c:391:3: warning: passing argument 1 of =E2=80=98b=
lk_rq_map_sg=E2=80=99 from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected =E2=80=98struct request *=E2=
=80=99 but argument is of type =E2=80=98struct request_queue *=E2=80=99
drivers/mmc/card/queue.c:391:3: warning: passing argument 2 of =E2=80=98b=
lk_rq_map_sg=E2=80=99 from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected =E2=80=98struct scatterlist=
 *=E2=80=99 but argument is of type =E2=80=98struct request *=E2=80=99
drivers/mmc/card/queue.c:391:3: error: too many arguments to function =E2=
=80=98blk_rq_map_sg=E2=80=99
include/linux/blkdev.h:845:12: note: declared here
drivers/mmc/card/queue.c:395:2: warning: passing argument 1 of =E2=80=98b=
lk_rq_map_sg=E2=80=99 from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected =E2=80=98struct request *=E2=
=80=99 but argument is of type =E2=80=98struct request_queue *=E2=80=99
drivers/mmc/card/queue.c:395:2: warning: passing argument 2 of =E2=80=98b=
lk_rq_map_sg=E2=80=99 from incompatible pointer type [enabled by default]
include/linux/blkdev.h:845:12: note: expected =E2=80=98struct scatterlist=
 *=E2=80=99 but argument is of type =E2=80=98struct request *=E2=80=99
drivers/mmc/card/queue.c:395:2: error: too many arguments to function =E2=
=80=98blk_rq_map_sg=E2=80=99
include/linux/blkdev.h:845:12: note: declared here
drivers/message/i2o/i2o_block.c:324:2: warning: passing argument 2 of =E2=
=80=98blk_rq_map_sg=E2=80=99 from incompatible pointer type [enabled by d=
efault]
include/linux/blkdev.h:845:12: note: expected =E2=80=98struct scatterlist=
 *=E2=80=99 but argument is of type =E2=80=98struct request *=E2=80=99
drivers/message/i2o/i2o_block.c:324:2: error: too many arguments to funct=
ion =E2=80=98blk_rq_map_sg=E2=80=99
include/linux/blkdev.h:845:12: note: declared here
drivers/target/target_core_pscsi.c:1224:2: error: too many arguments to f=
unction =E2=80=98__blk_put_request=E2=80=99
include/linux/blkdev.h:645:13: note: declared here
drivers/scsi/device_handler/scsi_dh_hp_sw.c:230:2: error: too many argume=
nts to function =E2=80=98__blk_put_request=E2=80=99
include/linux/blkdev.h:645:13: note: declared here
drivers/scsi/device_handler/scsi_dh_alua.c:255:2: error: too many argumen=
ts to function =E2=80=98__blk_put_request=E2=80=99
include/linux/blkdev.h:645:13: note: declared here
drivers/scsi/osd/osd_initiator.c:501:3: error: too many arguments to func=
tion =E2=80=98__blk_put_request=E2=80=99
include/linux/blkdev.h:645:13: note: declared here
drivers/scsi/osd/osd_initiator.c:505:2: error: too many arguments to func=
tion =E2=80=98__blk_put_request=E2=80=99
include/linux/blkdev.h:645:13: note: declared here
drivers/scsi/scsi_tgt_lib.c:155:2: warning: passing argument 1 of =E2=80=98=
__blk_put_request=E2=80=99 from incompatible pointer type [enabled by def=
ault]
include/linux/blkdev.h:645:13: note: expected =E2=80=98struct request *=E2=
=80=99 but argument is of type =E2=80=98struct request_queue *=E2=80=99
drivers/scsi/scsi_tgt_lib.c:155:2: error: too many arguments to function =
=E2=80=98__blk_put_request=E2=80=99
include/linux/blkdev.h:645:13: note: declared here
drivers/scsi/scsi_transport_fc.c: In function =E2=80=98fc_bsg_map_buffer=E2=
=80=99:
drivers/scsi/scsi_transport_fc.c:3674:2: warning: passing argument 1 of =E2=
=80=98blk_rq_map_sg=E2=80=99 from incompatible pointer type [enabled by d=
efault]
include/linux/blkdev.h:845:12: note: expected =E2=80=98struct request *=E2=
=80=99 but argument is of type =E2=80=98struct request_queue *=E2=80=99
drivers/scsi/scsi_transport_fc.c:3674:2: warning: passing argument 2 of =E2=
=80=98blk_rq_map_sg=E2=80=99 from incompatible pointer type [enabled by d=
efault]
include/linux/blkdev.h:845:12: note: expected =E2=80=98struct scatterlist=
 *=E2=80=99 but argument is of type =E2=80=98struct request *=E2=80=99
drivers/scsi/scsi_transport_fc.c:3674:2: error: too many arguments to fun=
ction =E2=80=98blk_rq_map_sg=E2=80=99
include/linux/blkdev.h:845:12: note: declared here
drivers/scsi/scsi_transport_fc.c: In function =E2=80=98fc_bsg_remove=E2=80=
=99:

---
0-DAY kernel build testing backend         Open Source Technology Centre
Fengguang Wu <wfg@linux.intel.com>                     Intel Corporation

--=_4fd91c3f.R4ms68f5hejM12e5zdJOlaXCA5NYIvmvSlWnmiraoFWGO1Xb
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


--=_4fd91c3f.R4ms68f5hejM12e5zdJOlaXCA5NYIvmvSlWnmiraoFWGO1Xb
Content-Type: text/x-csrc;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="blk-core.c"

/*
 * Copyright (C) 1991, 1992 Linus Torvalds
 * Copyright (C) 1994,      Karl Keyte: Added support for disk statistics
 * Elevator latency, (C) 2000  Andrea Arcangeli <andrea@suse.de> SuSE
 * Queue request tables / lock, selectable elevator, Jens Axboe <axboe@suse.de>
 * kernel-doc documentation started by NeilBrown <neilb@cse.unsw.edu.au>
 *	-  July2000
 * bio rewrite, highmem i/o, etc, Jens Axboe <axboe@suse.de> - may 2001
 */

/*
 * This handles all read/write requests to block devices
 */
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/backing-dev.h>
#include <linux/bio.h>
#include <linux/blkdev.h>
#include <linux/highmem.h>
#include <linux/mm.h>
#include <linux/kernel_stat.h>
#include <linux/string.h>
#include <linux/init.h>
#include <linux/completion.h>
#include <linux/slab.h>
#include <linux/swap.h>
#include <linux/writeback.h>
#include <linux/task_io_accounting_ops.h>
#include <linux/fault-inject.h>
#include <linux/list_sort.h>
#include <linux/delay.h>

#define CREATE_TRACE_POINTS
#include <trace/events/block.h>

#include "blk.h"

EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_remap);
EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_remap);
EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_complete);

DEFINE_IDA(blk_queue_ida);

/*
 * For the allocated request tables
 */
static struct kmem_cache *request_cachep;

/*
 * For queue allocation
 */
struct kmem_cache *blk_requestq_cachep;

/*
 * Controlling structure to kblockd
 */
static struct workqueue_struct *kblockd_workqueue;

static void drive_stat_acct(struct request *rq, int new_io)
{
	struct hd_struct *part;
	int rw = rq_data_dir(rq);
	int cpu;

	if (!blk_do_io_stat(rq))
		return;

	cpu = part_stat_lock();

	if (!new_io) {
		part = rq->part;
		part_stat_inc(cpu, part, merges[rw]);
	} else {
		part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
		if (!hd_struct_try_get(part)) {
			/*
			 * The partition is already being removed,
			 * the request will be accounted on the disk only
			 *
			 * We take a reference on disk->part0 although that
			 * partition will never be deleted, so we can treat
			 * it as any other partition.
			 */
			part = &rq->rq_disk->part0;
			hd_struct_get(part);
		}
		part_round_stats(cpu, part);
		part_inc_in_flight(part, rw);
		rq->part = part;
	}

	part_stat_unlock();
}

void blk_queue_congestion_threshold(struct request_queue *q)
{
	int nr;

	nr = q->nr_requests - (q->nr_requests / 8) + 1;
	if (nr > q->nr_requests)
		nr = q->nr_requests;
	q->nr_congestion_on = nr;

	nr = q->nr_requests - (q->nr_requests / 8) - (q->nr_requests / 16) - 1;
	if (nr < 1)
		nr = 1;
	q->nr_congestion_off = nr;
}

/**
 * blk_get_backing_dev_info - get the address of a queue's backing_dev_info
 * @bdev:	device
 *
 * Locates the passed device's request queue and returns the address of its
 * backing_dev_info
 *
 * Will return NULL if the request queue cannot be located.
 */
struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev)
{
	struct backing_dev_info *ret = NULL;
	struct request_queue *q = bdev_get_queue(bdev);

	if (q)
		ret = &q->backing_dev_info;
	return ret;
}
EXPORT_SYMBOL(blk_get_backing_dev_info);

void blk_rq_init(struct blk_queue_ctx *ctx, struct request *rq)
{
	memset(rq, 0, sizeof(*rq));

	INIT_LIST_HEAD(&rq->queuelist);
	INIT_LIST_HEAD(&rq->timeout_list);
	rq->cpu = -1;
	rq->queue_ctx = ctx;
	rq->__sector = (sector_t) -1;
	INIT_HLIST_NODE(&rq->hash);
	RB_CLEAR_NODE(&rq->rb_node);
	rq->cmd = rq->__cmd;
	rq->cmd_len = BLK_MAX_CDB;
	rq->tag = -1;
	rq->ref_count = 1;
	rq->start_time = jiffies;
	set_start_time_ns(rq);
	rq->part = NULL;
}
EXPORT_SYMBOL(blk_rq_init);

static void req_bio_endio(struct request *rq, struct bio *bio,
			  unsigned int nbytes, int error)
{
	if (error)
		clear_bit(BIO_UPTODATE, &bio->bi_flags);
	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
		error = -EIO;

	if (unlikely(nbytes > bio->bi_size)) {
		printk(KERN_ERR "%s: want %u bytes done, %u left\n",
		       __func__, nbytes, bio->bi_size);
		nbytes = bio->bi_size;
	}

	if (unlikely(rq->cmd_flags & REQ_QUIET))
		set_bit(BIO_QUIET, &bio->bi_flags);

	bio->bi_size -= nbytes;
	bio->bi_sector += (nbytes >> 9);

	if (bio_integrity(bio))
		bio_integrity_advance(bio, nbytes);

	/* don't actually finish bio if it's part of flush sequence */
	if (bio->bi_size == 0 && !(rq->cmd_flags & REQ_FLUSH_SEQ))
		bio_endio(bio, error);
}

void blk_dump_rq_flags(struct request *rq, char *msg)
{
	int bit;

	printk(KERN_INFO "%s: dev %s: type=%x, flags=%x\n", msg,
		rq->rq_disk ? rq->rq_disk->disk_name : "?", rq->cmd_type,
		rq->cmd_flags);

	printk(KERN_INFO "  sector %llu, nr/cnr %u/%u\n",
	       (unsigned long long)blk_rq_pos(rq),
	       blk_rq_sectors(rq), blk_rq_cur_sectors(rq));
	printk(KERN_INFO "  bio %p, biotail %p, buffer %p, len %u\n",
	       rq->bio, rq->biotail, rq->buffer, blk_rq_bytes(rq));

	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
		printk(KERN_INFO "  cdb: ");
		for (bit = 0; bit < BLK_MAX_CDB; bit++)
			printk("%02x ", rq->cmd[bit]);
		printk("\n");
	}
}
EXPORT_SYMBOL(blk_dump_rq_flags);

static void blk_delay_work(struct work_struct *work)
{
	struct request_queue *q;

	q = container_of(work, struct request_queue, delay_work.work);
	spin_lock_irq(q->queue_lock);
	__blk_run_queue(q);
	spin_unlock_irq(q->queue_lock);
}

/**
 * blk_delay_queue - restart queueing after defined interval
 * @q:		The &struct request_queue in question
 * @msecs:	Delay in msecs
 *
 * Description:
 *   Sometimes queueing needs to be postponed for a little while, to allow
 *   resources to come back. This function will make sure that queueing is
 *   restarted around the specified time.
 */
void blk_delay_queue(struct request_queue *q, unsigned long msecs)
{
	queue_delayed_work(kblockd_workqueue, &q->delay_work,
				msecs_to_jiffies(msecs));
}
EXPORT_SYMBOL(blk_delay_queue);

/**
 * blk_start_queue - restart a previously stopped queue
 * @q:    The &struct request_queue in question
 *
 * Description:
 *   blk_start_queue() will clear the stop flag on the queue, and call
 *   the request_fn for the queue if it was in a stopped state when
 *   entered. Also see blk_stop_queue(). Queue lock must be held.
 **/
void blk_start_queue(struct request_queue *q)
{
	WARN_ON(!irqs_disabled());

	queue_flag_clear(QUEUE_FLAG_STOPPED, q);
	__blk_run_queue(q);
}
EXPORT_SYMBOL(blk_start_queue);

/**
 * blk_stop_queue - stop a queue
 * @q:    The &struct request_queue in question
 *
 * Description:
 *   The Linux block layer assumes that a block driver will consume all
 *   entries on the request queue when the request_fn strategy is called.
 *   Often this will not happen, because of hardware limitations (queue
 *   depth settings). If a device driver gets a 'queue full' response,
 *   or if it simply chooses not to queue more I/O at one point, it can
 *   call this function to prevent the request_fn from being called until
 *   the driver has signalled it's ready to go again. This happens by calling
 *   blk_start_queue() to restart queue operations. Queue lock must be held.
 **/
void blk_stop_queue(struct request_queue *q)
{
	__cancel_delayed_work(&q->delay_work);
	queue_flag_set(QUEUE_FLAG_STOPPED, q);
}
EXPORT_SYMBOL(blk_stop_queue);

/**
 * blk_sync_queue - cancel any pending callbacks on a queue
 * @q: the queue
 *
 * Description:
 *     The block layer may perform asynchronous callback activity
 *     on a queue, such as calling the unplug function after a timeout.
 *     A block device may call blk_sync_queue to ensure that any
 *     such activity is cancelled, thus allowing it to release resources
 *     that the callbacks might use. The caller must already have made sure
 *     that its ->make_request_fn will not re-add plugging prior to calling
 *     this function.
 *
 *     This function does not cancel any asynchronous activity arising
 *     out of elevator or throttling code. That would require elevaotor_exit()
 *     and blk_throtl_exit() to be called with queue lock initialized.
 *
 */
void blk_sync_queue(struct request_queue *q)
{
	del_timer_sync(&q->timeout);
	cancel_delayed_work_sync(&q->delay_work);
}
EXPORT_SYMBOL(blk_sync_queue);

/**
 * __blk_run_queue - run a single device queue
 * @q:	The queue to run
 *
 * Description:
 *    See @blk_run_queue. This variant must be called with the queue lock
 *    held and interrupts disabled.
 */
void __blk_run_queue(struct request_queue *q)
{
	lockdep_assert_held(q->queue_lock);

	if (unlikely(blk_queue_stopped(q)))
		return;

	q->request_fn(q);
}
EXPORT_SYMBOL(__blk_run_queue);

/**
 * blk_run_queue_async - run a single device queue in workqueue context
 * @q:	The queue to run
 *
 * Description:
 *    Tells kblockd to perform the equivalent of @blk_run_queue on behalf
 *    of us.
 */
void blk_run_queue_async(struct request_queue *q)
{
	if (likely(!blk_queue_stopped(q))) {
		__cancel_delayed_work(&q->delay_work);
		queue_delayed_work(kblockd_workqueue, &q->delay_work, 0);
	}
}
EXPORT_SYMBOL(blk_run_queue_async);

/**
 * blk_run_queue - run a single device queue
 * @q: The queue to run
 *
 * Description:
 *    Invoke request handling on this queue, if it has pending work to do.
 *    May be used to restart queueing when a request has completed.
 */
void blk_run_queue(struct request_queue *q)
{
	unsigned long flags;

	spin_lock_irqsave(q->queue_lock, flags);
	__blk_run_queue(q);
	spin_unlock_irqrestore(q->queue_lock, flags);
}
EXPORT_SYMBOL(blk_run_queue);

void blk_put_queue(struct request_queue *q)
{
	kobject_put(&q->kobj);
}
EXPORT_SYMBOL(blk_put_queue);

/**
 * blk_drain_queue - drain requests from request_queue
 * @q: queue to drain
 * @drain_all: whether to drain all requests or only the ones w/ ELVPRIV
 *
 * Drain requests from @q.  If @drain_all is set, all requests are drained.
 * If not, only ELVPRIV requests are drained.  The caller is responsible
 * for ensuring that no new requests which need to be drained are queued.
 */
void blk_drain_queue(struct request_queue *q, bool drain_all)
{
	while (true) {
		bool drain = false;
		int i;

		spin_lock_irq(q->queue_lock);

		elv_drain_elevator(q);
		if (drain_all)
			blk_throtl_drain(q);

		/*
		 * This function might be called on a queue which failed
		 * driver init after queue creation.  Some drivers
		 * (e.g. fd) get unhappy in such cases.  Kick queue iff
		 * dispatch queue has something on it.
		 */
		if (!list_empty(&q->queue_head))
			__blk_run_queue(q);

		drain |= queue_elvpriv(q);

		/*
		 * Unfortunately, requests are queued at and tracked from
		 * multiple places and there's no single counter which can
		 * be drained.  Check all the queues and counters.
		 */
		if (drain_all) {
			drain |= !list_empty(&q->queue_head);
			for (i = 0; i < 2; i++) {
				drain |= queue_rq_queued(q);
				drain |= queue_in_flight(q);
				drain |= !list_empty(&q->flush_queue[i]);
			}
		}

		spin_unlock_irq(q->queue_lock);

		if (!drain)
			break;
		msleep(10);
	}
}

/**
 * blk_cleanup_queue - shutdown a request queue
 * @q: request queue to shutdown
 *
 * Mark @q DEAD, drain all pending requests, destroy and put it.  All
 * future requests will be failed immediately with -ENODEV.
 */
void blk_cleanup_queue(struct request_queue *q)
{
	spinlock_t *lock = q->queue_lock;

	/* mark @q DEAD, no new request or merges will be allowed afterwards */
	mutex_lock(&q->sysfs_lock);
	queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);

	spin_lock_irq(lock);
	queue_flag_set(QUEUE_FLAG_NOMERGES, q);
	queue_flag_set(QUEUE_FLAG_NOXMERGES, q);
	queue_flag_set(QUEUE_FLAG_DEAD, q);

	if (q->queue_lock != &q->__queue_lock)
		q->queue_lock = &q->__queue_lock;

	spin_unlock_irq(lock);
	mutex_unlock(&q->sysfs_lock);

	/*
	 * Drain all requests queued before DEAD marking.  The caller might
	 * be trying to tear down @q before its elevator is initialized, in
	 * which case we don't want to call into draining.
	 */
	if (q->elevator)
		blk_drain_queue(q, true);

	/* @q won't process any more request, flush async actions */
	del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer);
	blk_sync_queue(q);

	/* @q is and will stay empty, shutdown and put */
	blk_put_queue(q);
}
EXPORT_SYMBOL(blk_cleanup_queue);

static int blk_init_queue_ctx(struct request_queue *q, unsigned int nr_queues)
{
	struct blk_queue_ctx *ctx;
	unsigned int i;

	q->nr_queues = nr_queues;
	queue_for_each_ctx(q, ctx, i) {
		struct request_list *rl = &ctx->rl;

		memset(ctx, 0, sizeof(*ctx));
		spin_lock_init(&ctx->lock);
		ctx->queue = q;
		init_waitqueue_head(&rl->wait[BLK_RW_SYNC]);
		init_waitqueue_head(&rl->wait[BLK_RW_ASYNC]);
		INIT_LIST_HEAD(&ctx->timeout_list);
	}

	return 0;
}

static int blk_init_free_list(struct request_queue *q)
{
	if (unlikely(q->rq_pool))
		return 0;

	q->rq_pool = mempool_create_node(BLKDEV_MIN_RQ, mempool_alloc_slab,
				mempool_free_slab, request_cachep, q->node);
	if (!q->rq_pool)
		return -ENOMEM;

	return 0;
}

struct request_queue *blk_alloc_queue(gfp_t gfp_mask)
{
	return blk_alloc_queue_node(gfp_mask, -1, 1);
}
EXPORT_SYMBOL(blk_alloc_queue);


struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id,
					   unsigned int nr_queues)
{
	struct request_queue *q;
	int err;

	q = kmem_cache_alloc_node(blk_requestq_cachep,
				gfp_mask | __GFP_ZERO, node_id);
	if (!q)
		return NULL;

	q->queue_ctx = kmalloc_node(nr_queues * sizeof(struct blk_queue_ctx),
					GFP_KERNEL, node_id);
	if (!q->queue_ctx) {
		kmem_cache_free(blk_requestq_cachep, q);
		return NULL;
	}

	blk_init_queue_ctx(q, nr_queues);

	q->id = ida_simple_get(&blk_queue_ida, 0, 0, gfp_mask);
	if (q->id < 0)
		goto fail_q;

	q->backing_dev_info.ra_pages =
			(VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
	q->backing_dev_info.state = 0;
	q->backing_dev_info.capabilities = BDI_CAP_MAP_COPY;
	q->backing_dev_info.name = "block";
	q->node = node_id;

	err = bdi_init(&q->backing_dev_info);
	if (err)
		goto fail_id;

	if (blk_throtl_init(q))
		goto fail_id;

	setup_timer(&q->backing_dev_info.laptop_mode_wb_timer,
		    laptop_mode_timer_fn, (unsigned long) q);
	setup_timer(&q->timeout, blk_rq_timed_out_timer, (unsigned long) q);
	INIT_LIST_HEAD(&q->icq_list);
	INIT_LIST_HEAD(&q->flush_queue[0]);
	INIT_LIST_HEAD(&q->flush_queue[1]);
	INIT_LIST_HEAD(&q->flush_data_in_flight);
	INIT_DELAYED_WORK(&q->delay_work, blk_delay_work);

	kobject_init(&q->kobj, &blk_queue_ktype);

	mutex_init(&q->sysfs_lock);
	spin_lock_init(&q->__queue_lock);

	/*
	 * By default initialize queue_lock to internal lock and driver can
	 * override it later if need be.
	 */
	q->queue_lock = &q->__queue_lock;

	return q;

fail_id:
	ida_simple_remove(&blk_queue_ida, q->id);
fail_q:
	kfree(q->queue_ctx);
	kmem_cache_free(blk_requestq_cachep, q);
	return NULL;
}
EXPORT_SYMBOL(blk_alloc_queue_node);

/**
 * blk_init_queue  - prepare a request queue for use with a block device
 * @rfn:  The function to be called to process requests that have been
 *        placed on the queue.
 * @lock: Request queue spin lock
 *
 * Description:
 *    If a block device wishes to use the standard request handling procedures,
 *    which sorts requests and coalesces adjacent requests, then it must
 *    call blk_init_queue().  The function @rfn will be called when there
 *    are requests on the queue that need to be processed.  If the device
 *    supports plugging, then @rfn may not be called immediately when requests
 *    are available on the queue, but may be called at some time later instead.
 *    Plugged queues are generally unplugged when a buffer belonging to one
 *    of the requests on the queue is needed, or due to memory pressure.
 *
 *    @rfn is not required, or even expected, to remove all requests off the
 *    queue, but only as many as it can handle at a time.  If it does leave
 *    requests on the queue, it is responsible for arranging that the requests
 *    get dealt with eventually.
 *
 *    The queue spin lock must be held while manipulating the requests on the
 *    request queue; this lock will be taken also from interrupt context, so irq
 *    disabling is needed for it.
 *
 *    Function returns a pointer to the initialized request queue, or %NULL if
 *    it didn't succeed.
 *
 * Note:
 *    blk_init_queue() must be paired with a blk_cleanup_queue() call
 *    when the block device is deactivated (such as at module unload).
 **/

struct request_queue *blk_init_queue(request_fn_proc *rfn, spinlock_t *lock)
{
	return blk_init_queue_node(rfn, lock, -1, 1);
}
EXPORT_SYMBOL(blk_init_queue);

struct request_queue *blk_init_queue_mq(request_fn_proc *rfn, spinlock_t *lock,
					unsigned int nr_queues)
{
	return blk_init_queue_node(rfn, lock, -1, nr_queues);
}
EXPORT_SYMBOL(blk_init_queue_mq);

struct request_queue *
blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id,
		    unsigned int nr_queues)
{
	struct request_queue *uninit_q, *q;

	uninit_q = blk_alloc_queue_node(GFP_KERNEL, node_id, nr_queues);
	if (!uninit_q)
		return NULL;

	q = blk_init_allocated_queue(uninit_q, rfn, lock);
	if (!q)
		blk_cleanup_queue(uninit_q);

	return q;
}
EXPORT_SYMBOL(blk_init_queue_node);

struct request_queue *
blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
			 spinlock_t *lock)
{
	if (!q)
		return NULL;

	if (blk_init_free_list(q))
		return NULL;

	q->request_fn		= rfn;
	q->prep_rq_fn		= NULL;
	q->unprep_rq_fn		= NULL;
	q->queue_flags		= QUEUE_FLAG_DEFAULT;

	/* Override internal queue lock with supplied lock pointer */
	if (lock)
		q->queue_lock		= lock;

	/*
	 * This also sets hw/phys segments, boundary and size
	 */
	blk_queue_make_request(q, blk_queue_bio);

	q->sg_reserved_size = INT_MAX;

	/*
	 * all done
	 */
	if (!elevator_init(q, NULL)) {
		blk_queue_congestion_threshold(q);
		return q;
	}

	return NULL;
}
EXPORT_SYMBOL(blk_init_allocated_queue);

bool blk_get_queue(struct request_queue *q)
{
	if (likely(!blk_queue_dead(q))) {
		__blk_get_queue(q);
		return true;
	}

	return false;
}
EXPORT_SYMBOL(blk_get_queue);

static inline void blk_free_request(struct blk_queue_ctx *ctx,
				    struct request *rq)
{
	struct request_queue *q = ctx->queue;

	if (rq->cmd_flags & REQ_ELVPRIV) {
		elv_put_request(ctx, rq);
		if (rq->elv.icq)
			put_io_context(rq->elv.icq->ioc);
	}

	mempool_free(rq, q->rq_pool);
}

static struct request *
blk_alloc_request(struct blk_queue_ctx *ctx, struct io_cq *icq,
		  unsigned int flags, gfp_t gfp_mask)
{
	struct request_queue *q = ctx->queue;
	struct request *rq;

	rq = mempool_alloc(q->rq_pool, gfp_mask);
	if (!rq)
		return NULL;

	blk_rq_init(ctx, rq);

	rq->cmd_flags = flags | REQ_ALLOCED;

	if (flags & REQ_ELVPRIV) {
		rq->elv.icq = icq;
		if (unlikely(elv_set_request(ctx, rq, gfp_mask))) {
			mempool_free(rq, q->rq_pool);
			return NULL;
		}
		/* @rq->elv.icq holds on to io_context until @rq is freed */
		if (icq)
			get_io_context(icq->ioc);
	}

	return rq;
}

static void __freed_request(struct blk_queue_ctx *ctx, int sync)
{
	struct request_queue *q = ctx->queue;
	struct request_list *rl = &ctx->rl;

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
 * congestion status, wake up any waiters.   Called under ctx->lock.
 */
static void freed_request(struct blk_queue_ctx *ctx, unsigned int flags)
{
	struct request_list *rl = &ctx->rl;
	int sync = rw_is_sync(flags);

	rl->count[sync]--;
	if (flags & REQ_ELVPRIV)
		rl->elvpriv--;

	__freed_request(ctx, sync);

	if (unlikely(rl->starved[sync ^ 1]))
		__freed_request(ctx, sync ^ 1);
}

/*
 * Determine if elevator data should be initialized when allocating the
 * request associated with @bio.
 */
static bool blk_rq_should_init_elevator(struct bio *bio)
{
	if (!bio)
		return true;

	/*
	 * Flush requests do not use the elevator so skip initialization.
	 * This allows a request to share the flush and elevator data.
	 */
	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA))
		return false;

	return true;
}

/**
 * get_request - get a free request
 * @q: request_queue to allocate request from
 * @rw_flags: RW and SYNC flags
 * @bio: bio to allocate request for (can be %NULL)
 * @gfp_mask: allocation mask
 *
 * Get a free request from @q.  This function may fail under memory
 * pressure or if @q is dead.
 *
 * Must be callled with @ctx->lock held.
 */
static struct request *get_request(struct blk_queue_ctx *ctx, int rw_flags,
				   struct bio *bio, gfp_t gfp_mask)
{
	struct request_queue *q = ctx->queue;
	struct request_list *rl = &ctx->rl;
	struct request *rq = NULL;
	struct elevator_type *et;
	struct io_cq *icq = NULL;
	const bool is_sync = rw_is_sync(rw_flags) != 0;
	const bool drop_lock = (gfp_mask & __GFP_WAIT) != 0;
	struct io_context *ioc;
	int may_queue;

	et = q->elevator->type;
	ioc = current->io_context;

	if (unlikely(blk_queue_dead(q)))
		return NULL;

	may_queue = elv_may_queue(q, rw_flags);
	if (may_queue == ELV_MQUEUE_NO)
		goto rq_starved;

	if (rl->count[is_sync]+1 >= queue_congestion_on_threshold(q)) {
		blk_set_queue_congested(q, is_sync);

		if (rl->count[is_sync]+1 >= q->nr_requests)
			if (may_queue != ELV_MQUEUE_MUST)
				goto out;
	}

	/*
	 * Only allow batching queuers to allocate up to 50% over the defined
	 * limit of requests, otherwise we could have thousands of requests
	 * allocated with any setting of ->nr_requests
	 */
	if (rl->count[is_sync] >= (3 * q->nr_requests / 2))
		goto out;

	rl->count[is_sync]++;
	rl->starved[is_sync] = 0;

	/*
	 * Decide whether the new request will be managed by elevator.  If
	 * so, mark @rw_flags and increment elvpriv.  Non-zero elvpriv will
	 * prevent the current elevator from being destroyed until the new
	 * request is freed.  This guarantees icq's won't be destroyed and
	 * makes creating new ones safe.
	 *
	 * Also, lookup icq while holding queue_lock.  If it doesn't exist,
	 * it will be created after releasing queue_lock.
	 */
	if (blk_rq_should_init_elevator(bio) &&
	    !test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags)) {
		rw_flags |= REQ_ELVPRIV;
		rl->elvpriv++;
		if (et->icq_cache && ioc)
			icq = ioc_lookup_icq(ioc, q);
	}

	if (blk_queue_io_stat(q))
		rw_flags |= REQ_IO_STAT;

	if (drop_lock)
		spin_unlock_irq(&ctx->lock);

	/* create icq if missing */
	if ((rw_flags & REQ_ELVPRIV) && unlikely(et->icq_cache && !icq)) {
		icq = ioc_create_icq(q, gfp_mask);
		if (!icq)
			goto fail_icq;
	}

	rq = blk_alloc_request(ctx, icq, rw_flags, gfp_mask);
fail_icq:
	if (unlikely(!rq)) {
		/*
		 * Allocation failed presumably due to memory. Undo anything
		 * we might have messed up.
		 *
		 * Allocating task should really be put onto the front of the
		 * wait queue, but this is pretty rare.
		 */
		if (drop_lock)
			spin_lock_irq(&ctx->lock);

		freed_request(ctx, rw_flags);

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

	trace_block_getrq(q, bio, rw_flags & 1);

	if (drop_lock)
		spin_lock_irq(&ctx->lock);
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
 * Must be callled with @ctx->lock held.
 */
static struct request *get_request_wait(struct blk_queue_ctx *ctx, int rw_flags,
					struct bio *bio)
{
	struct request_queue *q = ctx->queue;
	const bool is_sync = rw_is_sync(rw_flags) != 0;
	struct request *rq;

	rq = get_request(ctx, rw_flags, bio, GFP_NOIO);
	while (!rq) {
		DEFINE_WAIT(wait);
		struct request_list *rl = &ctx->rl;

		if (unlikely(blk_queue_dead(q)))
			return NULL;

		prepare_to_wait_exclusive(&rl->wait[is_sync], &wait,
				TASK_UNINTERRUPTIBLE);

		trace_block_sleeprq(q, bio, rw_flags & 1);

		spin_unlock_irq(&ctx->lock);
		io_schedule();

		/*
		 * After sleeping, we become a "batching" process and
		 * will be able to allocate at least one request, and
		 * up to a big batch of them for a small period time.
		 * See ioc_batching, ioc_set_batching
		 */
		create_io_context(current, GFP_NOIO, q->node);

		spin_lock_irq(&ctx->lock);
		finish_wait(&rl->wait[is_sync], &wait);

		rq = get_request(ctx, rw_flags, bio, GFP_NOIO);
	};

	return rq;
}

struct request *blk_get_request(struct request_queue *q, int rw, gfp_t gfp_mask)
{
	struct blk_queue_ctx *ctx = blk_get_ctx(q, 0);
	struct request *rq;

	BUG_ON(rw != READ && rw != WRITE);

	spin_lock_irq(&ctx->lock);

	if (gfp_mask & __GFP_WAIT)
		rq = get_request_wait(ctx, rw, NULL);
	else
		rq = get_request(ctx, rw, NULL, gfp_mask);

	spin_unlock_irq(&ctx->lock);
	return rq;
}
EXPORT_SYMBOL(blk_get_request);

/**
 * blk_make_request - given a bio, allocate a corresponding struct request.
 * @q: target request queue
 * @bio:  The bio describing the memory mappings that will be submitted for IO.
 *        It may be a chained-bio properly constructed by block/bio layer.
 * @gfp_mask: gfp flags to be used for memory allocation
 *
 * blk_make_request is the parallel of generic_make_request for BLOCK_PC
 * type commands. Where the struct request needs to be farther initialized by
 * the caller. It is passed a &struct bio, which describes the memory info of
 * the I/O transfer.
 *
 * The caller of blk_make_request must make sure that bi_io_vec
 * are set to describe the memory buffers. That bio_data_dir() will return
 * the needed direction of the request. (And all bio's in the passed bio-chain
 * are properly set accordingly)
 *
 * If called under none-sleepable conditions, mapped bio buffers must not
 * need bouncing, by calling the appropriate masked or flagged allocator,
 * suitable for the target device. Otherwise the call to blk_queue_bounce will
 * BUG.
 *
 * WARNING: When allocating/cloning a bio-chain, careful consideration should be
 * given to how you allocate bios. In particular, you cannot use __GFP_WAIT for
 * anything but the first bio in the chain. Otherwise you risk waiting for IO
 * completion of a bio that hasn't been submitted yet, thus resulting in a
 * deadlock. Alternatively bios should be allocated using bio_kmalloc() instead
 * of bio_alloc(), as that avoids the mempool deadlock.
 * If possible a big IO should be split into smaller parts when allocation
 * fails. Partial allocation should not be an error, or you risk a live-lock.
 */
struct request *blk_make_request(struct request_queue *q, struct bio *bio,
				 gfp_t gfp_mask)
{
	struct request *rq = blk_get_request(q, bio_data_dir(bio), gfp_mask);

	if (unlikely(!rq))
		return ERR_PTR(-ENOMEM);

	for_each_bio(bio) {
		struct bio *bounce_bio = bio;
		int ret;

		blk_queue_bounce(q, &bounce_bio);
		ret = blk_rq_append_bio(q, rq, bounce_bio);
		if (unlikely(ret)) {
			blk_put_request(rq);
			return ERR_PTR(ret);
		}
	}

	return rq;
}
EXPORT_SYMBOL(blk_make_request);

/**
 * blk_requeue_request - put a request back on queue
 * @q:		request queue where request should be inserted
 * @rq:		request to be inserted
 *
 * Description:
 *    Drivers often keep queueing requests until the hardware cannot accept
 *    more, when that condition happens we need to put the request back
 *    on the queue. Must be called with queue lock held.
 */
void blk_requeue_request(struct request_queue *q, struct request *rq)
{
	blk_delete_timer(rq);
	blk_clear_rq_complete(rq);
	trace_block_rq_requeue(q, rq);

	if (blk_rq_tagged(rq))
		blk_queue_end_tag(q, rq);

	BUG_ON(blk_queued_rq(rq));

	elv_requeue_request(q, rq);
}
EXPORT_SYMBOL(blk_requeue_request);

static void add_acct_request(struct request *rq, int where)
{
	struct blk_queue_ctx *ctx = rq->queue_ctx;

	BUG_ON(!irqs_disabled());

	drive_stat_acct(rq, 1);
	spin_lock(&ctx->lock);
	__elv_add_request(rq, where);
	spin_unlock(&ctx->lock);
}

static void part_round_stats_single(int cpu, struct hd_struct *part,
				    unsigned long now)
{
	if (now == part->stamp)
		return;

	if (part_in_flight(part)) {
		__part_stat_add(cpu, part, time_in_queue,
				part_in_flight(part) * (now - part->stamp));
		__part_stat_add(cpu, part, io_ticks, (now - part->stamp));
	}
	part->stamp = now;
}

/**
 * part_round_stats() - Round off the performance stats on a struct disk_stats.
 * @cpu: cpu number for stats access
 * @part: target partition
 *
 * The average IO queue length and utilisation statistics are maintained
 * by observing the current state of the queue length and the amount of
 * time it has been in this state for.
 *
 * Normally, that accounting is done on IO completion, but that can result
 * in more than a second's worth of IO being accounted for within any one
 * second, leading to >100% utilisation.  To deal with that, we call this
 * function to do a round-off before returning the results when reading
 * /proc/diskstats.  This accounts immediately for all queue usage up to
 * the current jiffies and restarts the counters again.
 */
void part_round_stats(int cpu, struct hd_struct *part)
{
	unsigned long now = jiffies;

	if (part->partno)
		part_round_stats_single(cpu, &part_to_disk(part)->part0, now);
	part_round_stats_single(cpu, part, now);
}
EXPORT_SYMBOL_GPL(part_round_stats);

/*
 * queue lock must be held
 */
void __blk_put_request(struct request *req)
{
	struct blk_queue_ctx *ctx = req->queue_ctx;

	if (unlikely(!ctx))
		return;
	if (unlikely(--req->ref_count))
		return;

	elv_completed_request(req);

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

		blk_free_request(ctx, req);
		freed_request(ctx, flags);
	}
}
EXPORT_SYMBOL_GPL(__blk_put_request);

void blk_put_request(struct request *req)
{
	struct blk_queue_ctx *ctx = req->queue_ctx;
	unsigned long flags;

	spin_lock_irqsave(&ctx->lock, flags);
	__blk_put_request(req);
	spin_unlock_irqrestore(&ctx->lock, flags);
}
EXPORT_SYMBOL(blk_put_request);

/**
 * blk_add_request_payload - add a payload to a request
 * @rq: request to update
 * @page: page backing the payload
 * @len: length of the payload.
 *
 * This allows to later add a payload to an already submitted request by
 * a block driver.  The driver needs to take care of freeing the payload
 * itself.
 *
 * Note that this is a quite horrible hack and nothing but handling of
 * discard requests should ever use it.
 */
void blk_add_request_payload(struct request *rq, struct page *page,
		unsigned int len)
{
	struct bio *bio = rq->bio;

	bio->bi_io_vec->bv_page = page;
	bio->bi_io_vec->bv_offset = 0;
	bio->bi_io_vec->bv_len = len;

	bio->bi_size = len;
	bio->bi_vcnt = 1;
	bio->bi_phys_segments = 1;

	rq->__data_len = rq->resid_len = len;
	rq->nr_phys_segments = 1;
	rq->buffer = bio_data(bio);
}
EXPORT_SYMBOL_GPL(blk_add_request_payload);

static bool bio_attempt_back_merge(struct blk_queue_ctx *ctx, struct request *req,
				   struct bio *bio)
{
	const int ff = bio->bi_rw & REQ_FAILFAST_MASK;

	if (!ll_back_merge_fn(ctx, req, bio))
		return false;

	trace_block_bio_backmerge(ctx->queue, bio);

	if ((req->cmd_flags & REQ_FAILFAST_MASK) != ff)
		blk_rq_set_mixed_merge(req);

	req->biotail->bi_next = bio;
	req->biotail = bio;
	req->__data_len += bio->bi_size;
	req->ioprio = ioprio_best(req->ioprio, bio_prio(bio));

	drive_stat_acct(req, 0);
	return true;
}

static bool bio_attempt_front_merge(struct blk_queue_ctx *ctx,
				    struct request *req, struct bio *bio)
{
	const int ff = bio->bi_rw & REQ_FAILFAST_MASK;

	if (!ll_front_merge_fn(ctx, req, bio))
		return false;

	trace_block_bio_frontmerge(ctx->queue, bio);

	if ((req->cmd_flags & REQ_FAILFAST_MASK) != ff)
		blk_rq_set_mixed_merge(req);

	bio->bi_next = req->bio;
	req->bio = bio;

	/*
	 * may not be valid. if the low level driver said
	 * it didn't need a bounce buffer then it better
	 * not touch req->buffer either...
	 */
	req->buffer = bio_data(bio);
	req->__sector = bio->bi_sector;
	req->__data_len += bio->bi_size;
	req->ioprio = ioprio_best(req->ioprio, bio_prio(bio));

	drive_stat_acct(req, 0);
	return true;
}

/**
 * attempt_plug_merge - try to merge with %current's plugged list
 * @q: request_queue new bio is being queued at
 * @bio: new bio being queued
 * @request_count: out parameter for number of traversed plugged requests
 *
 * Determine whether @bio being queued on @q can be merged with a request
 * on %current's plugged list.  Returns %true if merge was successful,
 * otherwise %false.
 *
 * Plugging coalesces IOs from the same issuer for the same purpose without
 * going through @q->queue_lock.  As such it's more of an issuing mechanism
 * than scheduling, and the request, while may have elvpriv data, is not
 * added on the elevator at this point.  In addition, we don't have
 * reliable access to the elevator outside queue lock.  Only check basic
 * merging parameters without querying the elevator.
 */
static bool attempt_plug_merge(struct request_queue *q, struct bio *bio,
			       unsigned int *request_count)
{
	struct blk_plug *plug;
	struct request *rq;
	bool ret = false;

	plug = current->plug;
	if (!plug)
		goto out;
	*request_count = 0;

	list_for_each_entry_reverse(rq, &plug->list, queuelist) {
		int el_ret;

		if (rq->q == q)
			(*request_count)++;

		if (rq->queue_ctx->queue != q || !blk_rq_merge_ok(rq, bio))
			continue;

		el_ret = blk_try_merge(rq, bio);
		if (el_ret == ELEVATOR_BACK_MERGE) {
			ret = bio_attempt_back_merge(rq->queue_ctx, rq, bio);
			if (ret)
				break;
		} else if (el_ret == ELEVATOR_FRONT_MERGE) {
			ret = bio_attempt_front_merge(rq->queue_ctx, rq, bio);
			if (ret)
				break;
		}
	}
out:
	return ret;
}

void init_request_from_bio(struct request *req, struct bio *bio)
{
	req->cmd_type = REQ_TYPE_FS;

	req->cmd_flags |= bio->bi_rw & REQ_COMMON_MASK;
	if (bio->bi_rw & REQ_RAHEAD)
		req->cmd_flags |= REQ_FAILFAST_MASK;

	req->errors = 0;
	req->__sector = bio->bi_sector;
	req->ioprio = bio_prio(bio);
	blk_rq_bio_prep(req->queue_ctx->queue, req, bio);
}

void blk_queue_bio(struct request_queue *q, struct bio *bio)
{
	const bool sync = !!(bio->bi_rw & REQ_SYNC);
	struct blk_queue_ctx *ctx = blk_get_ctx(q, 0);
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
		spin_lock_irq(&ctx->lock);
		where = ELEVATOR_INSERT_FLUSH;
		goto get_rq;
	}

	/*
	 * Check if we can merge with the plugged list before grabbing
	 * any locks.
	 */
	if (attempt_plug_merge(q, bio, &request_count))
		return;

	spin_lock_irq(&ctx->lock);

	el_ret = elv_merge(ctx, &req, bio);
	if (el_ret == ELEVATOR_BACK_MERGE) {
		if (bio_attempt_back_merge(ctx, req, bio)) {
			elv_bio_merged(ctx, req, bio);
			if (!attempt_back_merge(ctx, req))
				elv_merged_request(ctx, req, el_ret);
out_unlock:
			spin_unlock_irq(&ctx->lock);
			return;
		}
	} else if (el_ret == ELEVATOR_FRONT_MERGE) {
		if (bio_attempt_front_merge(ctx, req, bio)) {
			elv_bio_merged(ctx, req, bio);
			if (!attempt_front_merge(ctx, req))
				elv_merged_request(ctx, req, el_ret);
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
	 * Grab a free request. Fails if the queue is dead,
	 * otherwise succeeds. May drop lock, but reacquires it.
	 */
	req = get_request_wait(ctx, rw_flags, bio);
	if (unlikely(!req)) {
		bio_endio(bio, -ENODEV);	/* @q is dead */
		goto out_unlock;
	}

	spin_unlock_irq(&ctx->lock);

	/*
	 * After dropping the lock and possibly sleeping here, our request
	 * may now be mergeable after it had proven unmergeable (above).
	 * We don't worry about that case for efficiency. It won't happen
	 * often, and the elevators are able to handle it.
	 */
	init_request_from_bio(req, bio);

	if (test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags))
		req->cpu = raw_smp_processor_id();

	plug = current->plug;
	if (plug) {
		/*
		 * If this is the first request added after a plug, fire
		 * of a plug trace. If others have been added before, check
		 * if we have multiple devices in this plug. If so, make a
		 * note to sort the list before dispatch.
		 */
		if (list_empty(&plug->list))
			trace_block_plug(q);
		else {
			if (!plug->should_sort) {
				struct request *__rq;

				__rq = list_entry_rq(plug->list.prev);
				if (__rq->queue_ctx->queue != q)
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
		add_acct_request(req, where);
		__blk_run_queue(q);
		spin_unlock_irq(q->queue_lock);
	}
}
EXPORT_SYMBOL_GPL(blk_queue_bio);	/* for device mapper only */

/*
 * If bio->bi_dev is a partition, remap the location
 */
static inline void blk_partition_remap(struct bio *bio)
{
	struct block_device *bdev = bio->bi_bdev;

	if (bio_sectors(bio) && bdev != bdev->bd_contains) {
		struct hd_struct *p = bdev->bd_part;

		bio->bi_sector += p->start_sect;
		bio->bi_bdev = bdev->bd_contains;

		trace_block_bio_remap(bdev_get_queue(bio->bi_bdev), bio,
				      bdev->bd_dev,
				      bio->bi_sector - p->start_sect);
	}
}

static void handle_bad_sector(struct bio *bio)
{
	char b[BDEVNAME_SIZE];

	printk(KERN_INFO "attempt to access beyond end of device\n");
	printk(KERN_INFO "%s: rw=%ld, want=%Lu, limit=%Lu\n",
			bdevname(bio->bi_bdev, b),
			bio->bi_rw,
			(unsigned long long)bio->bi_sector + bio_sectors(bio),
			(long long)(i_size_read(bio->bi_bdev->bd_inode) >> 9));

	set_bit(BIO_EOF, &bio->bi_flags);
}

#ifdef CONFIG_FAIL_MAKE_REQUEST

static DECLARE_FAULT_ATTR(fail_make_request);

static int __init setup_fail_make_request(char *str)
{
	return setup_fault_attr(&fail_make_request, str);
}
__setup("fail_make_request=", setup_fail_make_request);

static bool should_fail_request(struct hd_struct *part, unsigned int bytes)
{
	return part->make_it_fail && should_fail(&fail_make_request, bytes);
}

static int __init fail_make_request_debugfs(void)
{
	struct dentry *dir = fault_create_debugfs_attr("fail_make_request",
						NULL, &fail_make_request);

	return IS_ERR(dir) ? PTR_ERR(dir) : 0;
}

late_initcall(fail_make_request_debugfs);

#else /* CONFIG_FAIL_MAKE_REQUEST */

static inline bool should_fail_request(struct hd_struct *part,
					unsigned int bytes)
{
	return false;
}

#endif /* CONFIG_FAIL_MAKE_REQUEST */

/*
 * Check whether this bio extends beyond the end of the device.
 */
static inline int bio_check_eod(struct bio *bio, unsigned int nr_sectors)
{
	sector_t maxsector;

	if (!nr_sectors)
		return 0;

	/* Test device or partition size, when known. */
	maxsector = i_size_read(bio->bi_bdev->bd_inode) >> 9;
	if (maxsector) {
		sector_t sector = bio->bi_sector;

		if (maxsector < nr_sectors || maxsector - nr_sectors < sector) {
			/*
			 * This may well happen - the kernel calls bread()
			 * without checking the size of the device, e.g., when
			 * mounting a device.
			 */
			handle_bad_sector(bio);
			return 1;
		}
	}

	return 0;
}

static noinline_for_stack bool
generic_make_request_checks(struct bio *bio)
{
	struct request_queue *q;
	int nr_sectors = bio_sectors(bio);
	int err = -EIO;
	char b[BDEVNAME_SIZE];
	struct hd_struct *part;

	might_sleep();

	if (bio_check_eod(bio, nr_sectors))
		goto end_io;

	q = bdev_get_queue(bio->bi_bdev);
	if (unlikely(!q)) {
		printk(KERN_ERR
		       "generic_make_request: Trying to access "
			"nonexistent block-device %s (%Lu)\n",
			bdevname(bio->bi_bdev, b),
			(long long) bio->bi_sector);
		goto end_io;
	}

	if (unlikely(!(bio->bi_rw & REQ_DISCARD) &&
		     nr_sectors > queue_max_hw_sectors(q))) {
		printk(KERN_ERR "bio too big device %s (%u > %u)\n",
		       bdevname(bio->bi_bdev, b),
		       bio_sectors(bio),
		       queue_max_hw_sectors(q));
		goto end_io;
	}

	part = bio->bi_bdev->bd_part;
	if (should_fail_request(part, bio->bi_size) ||
	    should_fail_request(&part_to_disk(part)->part0,
				bio->bi_size))
		goto end_io;

	/*
	 * If this device has partitions, remap block n
	 * of partition p to block n+start(p) of the disk.
	 */
	blk_partition_remap(bio);

	if (bio_integrity_enabled(bio) && bio_integrity_prep(bio))
		goto end_io;

	if (bio_check_eod(bio, nr_sectors))
		goto end_io;

	/*
	 * Filter flush bio's early so that make_request based
	 * drivers without flush support don't have to worry
	 * about them.
	 */
	if ((bio->bi_rw & (REQ_FLUSH | REQ_FUA)) && !q->flush_flags) {
		bio->bi_rw &= ~(REQ_FLUSH | REQ_FUA);
		if (!nr_sectors) {
			err = 0;
			goto end_io;
		}
	}

	if ((bio->bi_rw & REQ_DISCARD) &&
	    (!blk_queue_discard(q) ||
	     ((bio->bi_rw & REQ_SECURE) &&
	      !blk_queue_secdiscard(q)))) {
		err = -EOPNOTSUPP;
		goto end_io;
	}

	if (blk_throtl_bio(q, bio))
		return false;	/* throttled, will be resubmitted later */

	trace_block_bio_queue(q, bio);
	return true;

end_io:
	bio_endio(bio, err);
	return false;
}

/**
 * generic_make_request - hand a buffer to its device driver for I/O
 * @bio:  The bio describing the location in memory and on the device.
 *
 * generic_make_request() is used to make I/O requests of block
 * devices. It is passed a &struct bio, which describes the I/O that needs
 * to be done.
 *
 * generic_make_request() does not return any status.  The
 * success/failure status of the request, along with notification of
 * completion, is delivered asynchronously through the bio->bi_end_io
 * function described (one day) else where.
 *
 * The caller of generic_make_request must make sure that bi_io_vec
 * are set to describe the memory buffer, and that bi_dev and bi_sector are
 * set to describe the device address, and the
 * bi_end_io and optionally bi_private are set to describe how
 * completion notification should be signaled.
 *
 * generic_make_request and the drivers it calls may use bi_next if this
 * bio happens to be merged with someone else, and may resubmit the bio to
 * a lower device by calling into generic_make_request recursively, which
 * means the bio should NOT be touched after the call to ->make_request_fn.
 */
void generic_make_request(struct bio *bio)
{
	struct bio_list bio_list_on_stack;

	if (!generic_make_request_checks(bio))
		return;

	/*
	 * We only want one ->make_request_fn to be active at a time, else
	 * stack usage with stacked devices could be a problem.  So use
	 * current->bio_list to keep a list of requests submited by a
	 * make_request_fn function.  current->bio_list is also used as a
	 * flag to say if generic_make_request is currently active in this
	 * task or not.  If it is NULL, then no make_request is active.  If
	 * it is non-NULL, then a make_request is active, and new requests
	 * should be added at the tail
	 */
	if (current->bio_list) {
		bio_list_add(current->bio_list, bio);
		return;
	}

	/* following loop may be a bit non-obvious, and so deserves some
	 * explanation.
	 * Before entering the loop, bio->bi_next is NULL (as all callers
	 * ensure that) so we have a list with a single bio.
	 * We pretend that we have just taken it off a longer list, so
	 * we assign bio_list to a pointer to the bio_list_on_stack,
	 * thus initialising the bio_list of new bios to be
	 * added.  ->make_request() may indeed add some more bios
	 * through a recursive call to generic_make_request.  If it
	 * did, we find a non-NULL value in bio_list and re-enter the loop
	 * from the top.  In this case we really did just take the bio
	 * of the top of the list (no pretending) and so remove it from
	 * bio_list, and call into ->make_request() again.
	 */
	BUG_ON(bio->bi_next);
	bio_list_init(&bio_list_on_stack);
	current->bio_list = &bio_list_on_stack;
	do {
		struct request_queue *q = bdev_get_queue(bio->bi_bdev);

		q->make_request_fn(q, bio);

		bio = bio_list_pop(current->bio_list);
	} while (bio);
	current->bio_list = NULL; /* deactivate */
}
EXPORT_SYMBOL(generic_make_request);

/**
 * submit_bio - submit a bio to the block device layer for I/O
 * @rw: whether to %READ or %WRITE, or maybe to %READA (read ahead)
 * @bio: The &struct bio which describes the I/O
 *
 * submit_bio() is very similar in purpose to generic_make_request(), and
 * uses that function to do most of the work. Both are fairly rough
 * interfaces; @bio must be presetup and ready for I/O.
 *
 */
void submit_bio(int rw, struct bio *bio)
{
	int count = bio_sectors(bio);

	bio->bi_rw |= rw;

	/*
	 * If it's a regular read/write or a barrier with data attached,
	 * go through the normal accounting stuff before submission.
	 */
	if (bio_has_data(bio) && !(rw & REQ_DISCARD)) {
		if (rw & WRITE) {
			count_vm_events(PGPGOUT, count);
		} else {
			task_io_account_read(bio->bi_size);
			count_vm_events(PGPGIN, count);
		}

		if (unlikely(block_dump)) {
			char b[BDEVNAME_SIZE];
			printk(KERN_DEBUG "%s(%d): %s block %Lu on %s (%u sectors)\n",
			current->comm, task_pid_nr(current),
				(rw & WRITE) ? "WRITE" : "READ",
				(unsigned long long)bio->bi_sector,
				bdevname(bio->bi_bdev, b),
				count);
		}
	}

	generic_make_request(bio);
}
EXPORT_SYMBOL(submit_bio);

/**
 * blk_rq_check_limits - Helper function to check a request for the queue limit
 * @q:  the queue
 * @rq: the request being checked
 *
 * Description:
 *    @rq may have been made based on weaker limitations of upper-level queues
 *    in request stacking drivers, and it may violate the limitation of @q.
 *    Since the block layer and the underlying device driver trust @rq
 *    after it is inserted to @q, it should be checked against @q before
 *    the insertion using this generic function.
 *
 *    This function should also be useful for request stacking drivers
 *    in some cases below, so export this function.
 *    Request stacking drivers like request-based dm may change the queue
 *    limits while requests are in the queue (e.g. dm's table swapping).
 *    Such request stacking drivers should check those requests agaist
 *    the new queue limits again when they dispatch those requests,
 *    although such checkings are also done against the old queue limits
 *    when submitting requests.
 */
int blk_rq_check_limits(struct request_queue *q, struct request *rq)
{
	if (rq->cmd_flags & REQ_DISCARD)
		return 0;

	if (blk_rq_sectors(rq) > queue_max_sectors(q) ||
	    blk_rq_bytes(rq) > queue_max_hw_sectors(q) << 9) {
		printk(KERN_ERR "%s: over max size limit.\n", __func__);
		return -EIO;
	}

	/*
	 * queue's settings related to segment counting like q->bounce_pfn
	 * may differ from that of other stacking queues.
	 * Recalculate it to check the request correctly on this queue's
	 * limitation.
	 */
	blk_recalc_rq_segments(rq);
	if (rq->nr_phys_segments > queue_max_segments(q)) {
		printk(KERN_ERR "%s: over max segments limit.\n", __func__);
		return -EIO;
	}

	return 0;
}
EXPORT_SYMBOL_GPL(blk_rq_check_limits);

/**
 * blk_insert_cloned_request - Helper for stacking drivers to submit a request
 * @q:  the queue to submit the request
 * @rq: the request being queued
 */
int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
{
	unsigned long flags;
	int where = ELEVATOR_INSERT_BACK;

	if (blk_rq_check_limits(q, rq))
		return -EIO;

	if (rq->rq_disk &&
	    should_fail_request(&rq->rq_disk->part0, blk_rq_bytes(rq)))
		return -EIO;

	spin_lock_irqsave(q->queue_lock, flags);
	if (unlikely(blk_queue_dead(q))) {
		spin_unlock_irqrestore(q->queue_lock, flags);
		return -ENODEV;
	}

	/*
	 * Submitting request must be dequeued before calling this function
	 * because it will be linked to another request_queue
	 */
	BUG_ON(blk_queued_rq(rq));

	if (rq->cmd_flags & (REQ_FLUSH|REQ_FUA))
		where = ELEVATOR_INSERT_FLUSH;

	add_acct_request(rq, where);
	if (where == ELEVATOR_INSERT_FLUSH)
		__blk_run_queue(q);
	spin_unlock_irqrestore(q->queue_lock, flags);

	return 0;
}
EXPORT_SYMBOL_GPL(blk_insert_cloned_request);

/**
 * blk_rq_err_bytes - determine number of bytes till the next failure boundary
 * @rq: request to examine
 *
 * Description:
 *     A request could be merge of IOs which require different failure
 *     handling.  This function determines the number of bytes which
 *     can be failed from the beginning of the request without
 *     crossing into area which need to be retried further.
 *
 * Return:
 *     The number of bytes to fail.
 *
 * Context:
 *     queue_lock must be held.
 */
unsigned int blk_rq_err_bytes(const struct request *rq)
{
	unsigned int ff = rq->cmd_flags & REQ_FAILFAST_MASK;
	unsigned int bytes = 0;
	struct bio *bio;

	if (!(rq->cmd_flags & REQ_MIXED_MERGE))
		return blk_rq_bytes(rq);

	/*
	 * Currently the only 'mixing' which can happen is between
	 * different fastfail types.  We can safely fail portions
	 * which have all the failfast bits that the first one has -
	 * the ones which are at least as eager to fail as the first
	 * one.
	 */
	for (bio = rq->bio; bio; bio = bio->bi_next) {
		if ((bio->bi_rw & ff) != ff)
			break;
		bytes += bio->bi_size;
	}

	/* this could lead to infinite loop */
	BUG_ON(blk_rq_bytes(rq) && !bytes);
	return bytes;
}
EXPORT_SYMBOL_GPL(blk_rq_err_bytes);

static void blk_account_io_completion(struct request *req, unsigned int bytes)
{
	if (blk_do_io_stat(req)) {
		const int rw = rq_data_dir(req);
		struct hd_struct *part;
		int cpu;

		cpu = part_stat_lock();
		part = req->part;
		part_stat_add(cpu, part, sectors[rw], bytes >> 9);
		part_stat_unlock();
	}
}

static void blk_account_io_done(struct request *req)
{
	/*
	 * Account IO completion.  flush_rq isn't accounted as a
	 * normal IO on queueing nor completion.  Accounting the
	 * containing request is enough.
	 */
	if (blk_do_io_stat(req) && !(req->cmd_flags & REQ_FLUSH_SEQ)) {
		unsigned long duration = jiffies - req->start_time;
		const int rw = rq_data_dir(req);
		struct hd_struct *part;
		int cpu;

		cpu = part_stat_lock();
		part = req->part;

		part_stat_inc(cpu, part, ios[rw]);
		part_stat_add(cpu, part, ticks[rw], duration);
		part_round_stats(cpu, part);
		part_dec_in_flight(part, rw);

		hd_struct_put(part);
		part_stat_unlock();
	}
}

/**
 * blk_peek_request - peek at the top of a request queue
 * @q: request queue to peek at
 *
 * Description:
 *     Return the request at the top of @q.  The returned request
 *     should be started using blk_start_request() before LLD starts
 *     processing it.
 *
 * Return:
 *     Pointer to the request at the top of @q if available.  Null
 *     otherwise.
 *
 * Context:
 *     queue_lock must be held.
 */
struct request *blk_peek_request(struct request_queue *q)
{
	struct request *rq;
	int ret;

	while ((rq = __elv_next_request(q)) != NULL) {
		if (!(rq->cmd_flags & REQ_STARTED)) {
			/*
			 * This is the first time the device driver
			 * sees this request (possibly after
			 * requeueing).  Notify IO scheduler.
			 */
			if (rq->cmd_flags & REQ_SORTED)
				elv_activate_rq(rq);

			/*
			 * just mark as started even if we don't start
			 * it, a request that has been delayed should
			 * not be passed by new incoming requests
			 */
			rq->cmd_flags |= REQ_STARTED;
			trace_block_rq_issue(q, rq);
		}

		if (!q->boundary_rq || q->boundary_rq == rq) {
			q->end_sector = rq_end_sector(rq);
			q->boundary_rq = NULL;
		}

		if (rq->cmd_flags & REQ_DONTPREP)
			break;

		if (q->dma_drain_size && blk_rq_bytes(rq)) {
			/*
			 * make sure space for the drain appears we
			 * know we can do this because max_hw_segments
			 * has been adjusted to be one fewer than the
			 * device can handle
			 */
			rq->nr_phys_segments++;
		}

		if (!q->prep_rq_fn)
			break;

		ret = q->prep_rq_fn(q, rq);
		if (ret == BLKPREP_OK) {
			break;
		} else if (ret == BLKPREP_DEFER) {
			/*
			 * the request may have been (partially) prepped.
			 * we need to keep this request in the front to
			 * avoid resource deadlock.  REQ_STARTED will
			 * prevent other fs requests from passing this one.
			 */
			if (q->dma_drain_size && blk_rq_bytes(rq) &&
			    !(rq->cmd_flags & REQ_DONTPREP)) {
				/*
				 * remove the space for the drain we added
				 * so that we don't add it again
				 */
				--rq->nr_phys_segments;
			}

			rq = NULL;
			break;
		} else if (ret == BLKPREP_KILL) {
			rq->cmd_flags |= REQ_QUIET;
			/*
			 * Mark this request as started so we don't trigger
			 * any debug logic in the end I/O path.
			 */
			blk_start_request(rq);
			__blk_end_request_all(rq, -EIO);
		} else {
			printk(KERN_ERR "%s: bad return=%d\n", __func__, ret);
			break;
		}
	}

	return rq;
}
EXPORT_SYMBOL(blk_peek_request);

void blk_dequeue_request(struct request *rq)
{
	struct blk_queue_ctx *ctx = rq->queue_ctx;

	BUG_ON(list_empty(&rq->queuelist));
	BUG_ON(ELV_ON_HASH(rq));

	list_del_init(&rq->queuelist);

	/*
	 * the time frame between a request being removed from the lists
	 * and to it is freed is accounted as io that is in progress at
	 * the driver side.
	 */
	if (blk_account_rq(rq)) {
		ctx->in_flight[rq_is_sync(rq)]++;
		set_io_start_time_ns(rq);
	}
}

/**
 * blk_start_request - start request processing on the driver
 * @req: request to dequeue
 *
 * Description:
 *     Dequeue @req and start timeout timer on it.  This hands off the
 *     request to the driver.
 *
 *     Block internal functions which don't want to start timer should
 *     call blk_dequeue_request().
 *
 * Context:
 *     queue_lock must be held.
 */
void blk_start_request(struct request *req)
{
	blk_dequeue_request(req);

	/*
	 * We are now handing the request to the hardware, initialize
	 * resid_len to full count and add the timeout handler.
	 */
	req->resid_len = blk_rq_bytes(req);
	if (unlikely(blk_bidi_rq(req)))
		req->next_rq->resid_len = blk_rq_bytes(req->next_rq);

	blk_add_timer(req);
}
EXPORT_SYMBOL(blk_start_request);

/**
 * blk_fetch_request - fetch a request from a request queue
 * @q: request queue to fetch a request from
 *
 * Description:
 *     Return the request at the top of @q.  The request is started on
 *     return and LLD can start processing it immediately.
 *
 * Return:
 *     Pointer to the request at the top of @q if available.  Null
 *     otherwise.
 *
 * Context:
 *     queue_lock must be held.
 */
struct request *blk_fetch_request(struct request_queue *q)
{
	struct request *rq;

	rq = blk_peek_request(q);
	if (rq)
		blk_start_request(rq);
	return rq;
}
EXPORT_SYMBOL(blk_fetch_request);

/**
 * blk_update_request - Special helper function for request stacking drivers
 * @req:      the request being processed
 * @error:    %0 for success, < %0 for error
 * @nr_bytes: number of bytes to complete @req
 *
 * Description:
 *     Ends I/O on a number of bytes attached to @req, but doesn't complete
 *     the request structure even if @req doesn't have leftover.
 *     If @req has leftover, sets it up for the next range of segments.
 *
 *     This special helper function is only for request stacking drivers
 *     (e.g. request-based dm) so that they can handle partial completion.
 *     Actual device drivers should use blk_end_request instead.
 *
 *     Passing the result of blk_rq_bytes() as @nr_bytes guarantees
 *     %false return from this function.
 *
 * Return:
 *     %false - this request doesn't have any more data
 *     %true  - this request has more data
 **/
bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
{
	int total_bytes, bio_nbytes, next_idx = 0;
	struct bio *bio;

	if (!req->bio)
		return false;

	trace_block_rq_complete(req->queue_ctx->queue, req);

	/*
	 * For fs requests, rq is just carrier of independent bio's
	 * and each partial completion should be handled separately.
	 * Reset per-request error on each partial completion.
	 *
	 * TODO: tj: This is too subtle.  It would be better to let
	 * low level drivers do what they see fit.
	 */
	if (req->cmd_type == REQ_TYPE_FS)
		req->errors = 0;

	if (error && req->cmd_type == REQ_TYPE_FS &&
	    !(req->cmd_flags & REQ_QUIET)) {
		char *error_type;

		switch (error) {
		case -ENOLINK:
			error_type = "recoverable transport";
			break;
		case -EREMOTEIO:
			error_type = "critical target";
			break;
		case -EBADE:
			error_type = "critical nexus";
			break;
		case -EIO:
		default:
			error_type = "I/O";
			break;
		}
		printk(KERN_ERR "end_request: %s error, dev %s, sector %llu\n",
		       error_type, req->rq_disk ? req->rq_disk->disk_name : "?",
		       (unsigned long long)blk_rq_pos(req));
	}

	blk_account_io_completion(req, nr_bytes);

	total_bytes = bio_nbytes = 0;
	while ((bio = req->bio) != NULL) {
		int nbytes;

		if (nr_bytes >= bio->bi_size) {
			req->bio = bio->bi_next;
			nbytes = bio->bi_size;
			req_bio_endio(req, bio, nbytes, error);
			next_idx = 0;
			bio_nbytes = 0;
		} else {
			int idx = bio->bi_idx + next_idx;

			if (unlikely(idx >= bio->bi_vcnt)) {
				blk_dump_rq_flags(req, "__end_that");
				printk(KERN_ERR "%s: bio idx %d >= vcnt %d\n",
				       __func__, idx, bio->bi_vcnt);
				break;
			}

			nbytes = bio_iovec_idx(bio, idx)->bv_len;
			BIO_BUG_ON(nbytes > bio->bi_size);

			/*
			 * not a complete bvec done
			 */
			if (unlikely(nbytes > nr_bytes)) {
				bio_nbytes += nr_bytes;
				total_bytes += nr_bytes;
				break;
			}

			/*
			 * advance to the next vector
			 */
			next_idx++;
			bio_nbytes += nbytes;
		}

		total_bytes += nbytes;
		nr_bytes -= nbytes;

		bio = req->bio;
		if (bio) {
			/*
			 * end more in this run, or just return 'not-done'
			 */
			if (unlikely(nr_bytes <= 0))
				break;
		}
	}

	/*
	 * completely done
	 */
	if (!req->bio) {
		/*
		 * Reset counters so that the request stacking driver
		 * can find how many bytes remain in the request
		 * later.
		 */
		req->__data_len = 0;
		return false;
	}

	/*
	 * if the request wasn't completed, update state
	 */
	if (bio_nbytes) {
		req_bio_endio(req, bio, bio_nbytes, error);
		bio->bi_idx += next_idx;
		bio_iovec(bio)->bv_offset += nr_bytes;
		bio_iovec(bio)->bv_len -= nr_bytes;
	}

	req->__data_len -= total_bytes;
	req->buffer = bio_data(req->bio);

	/* update sector only for requests with clear definition of sector */
	if (req->cmd_type == REQ_TYPE_FS || (req->cmd_flags & REQ_DISCARD))
		req->__sector += total_bytes >> 9;

	/* mixed attributes always follow the first bio */
	if (req->cmd_flags & REQ_MIXED_MERGE) {
		req->cmd_flags &= ~REQ_FAILFAST_MASK;
		req->cmd_flags |= req->bio->bi_rw & REQ_FAILFAST_MASK;
	}

	/*
	 * If total number of sectors is less than the first segment
	 * size, something has gone terribly wrong.
	 */
	if (blk_rq_bytes(req) < blk_rq_cur_bytes(req)) {
		blk_dump_rq_flags(req, "request botched");
		req->__data_len = blk_rq_cur_bytes(req);
	}

	/* recalculate the number of segments */
	blk_recalc_rq_segments(req);

	return true;
}
EXPORT_SYMBOL_GPL(blk_update_request);

static bool blk_update_bidi_request(struct request *rq, int error,
				    unsigned int nr_bytes,
				    unsigned int bidi_bytes)
{
	if (blk_update_request(rq, error, nr_bytes))
		return true;

	/* Bidi request must be completed as a whole */
	if (unlikely(blk_bidi_rq(rq)) &&
	    blk_update_request(rq->next_rq, error, bidi_bytes))
		return true;

	if (blk_queue_add_random(rq->queue_ctx->queue))
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
	struct request_queue *q = req->queue_ctx->queue;

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
	struct blk_queue_ctx *ctx = req->queue_ctx;
	struct request_queue *q = ctx->queue;

	if (blk_rq_tagged(req))
		blk_queue_end_tag(q, req);

	BUG_ON(blk_queued_rq(req));

	if (unlikely(laptop_mode) && req->cmd_type == REQ_TYPE_FS)
		laptop_io_completion(&q->backing_dev_info);

	blk_delete_timer(req);

	if (req->cmd_flags & REQ_DONTPREP)
		blk_unprep_request(req);


	blk_account_io_done(req);

	if (req->end_io)
		req->end_io(req, error);
	else {
		if (blk_bidi_rq(req))
			__blk_put_request(req->next_rq);

		__blk_put_request(req);
	}
}

/**
 * blk_end_bidi_request - Complete a bidi request
 * @rq:         the request to complete
 * @error:      %0 for success, < %0 for error
 * @nr_bytes:   number of bytes to complete @rq
 * @bidi_bytes: number of bytes to complete @rq->next_rq
 *
 * Description:
 *     Ends I/O on a number of bytes attached to @rq and @rq->next_rq.
 *     Drivers that supports bidi can safely call this member for any
 *     type of request, bidi or uni.  In the later case @bidi_bytes is
 *     just ignored.
 *
 * Return:
 *     %false - we are done with this request
 *     %true  - still buffers pending for this request
 **/
static bool blk_end_bidi_request(struct request *rq, int error,
				 unsigned int nr_bytes, unsigned int bidi_bytes)
{
	struct blk_queue_ctx *ctx = rq->queue_ctx;
	unsigned long flags;

	if (blk_update_bidi_request(rq, error, nr_bytes, bidi_bytes))
		return true;

	spin_lock_irqsave(&ctx->lock, flags);
	blk_finish_request(rq, error);
	spin_unlock_irqrestore(&ctx->lock, flags);

	return false;
}

/**
 * __blk_end_bidi_request - Complete a bidi request with queue lock held
 * @rq:         the request to complete
 * @error:      %0 for success, < %0 for error
 * @nr_bytes:   number of bytes to complete @rq
 * @bidi_bytes: number of bytes to complete @rq->next_rq
 *
 * Description:
 *     Identical to blk_end_bidi_request() except that queue lock is
 *     assumed to be locked on entry and remains so on return.
 *
 * Return:
 *     %false - we are done with this request
 *     %true  - still buffers pending for this request
 **/
bool __blk_end_bidi_request(struct request *rq, int error,
				   unsigned int nr_bytes, unsigned int bidi_bytes)
{
	if (blk_update_bidi_request(rq, error, nr_bytes, bidi_bytes))
		return true;

	blk_finish_request(rq, error);

	return false;
}

/**
 * blk_end_request - Helper function for drivers to complete the request.
 * @rq:       the request being processed
 * @error:    %0 for success, < %0 for error
 * @nr_bytes: number of bytes to complete
 *
 * Description:
 *     Ends I/O on a number of bytes attached to @rq.
 *     If @rq has leftover, sets it up for the next range of segments.
 *
 * Return:
 *     %false - we are done with this request
 *     %true  - still buffers pending for this request
 **/
bool blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
{
	return blk_end_bidi_request(rq, error, nr_bytes, 0);
}
EXPORT_SYMBOL(blk_end_request);

/**
 * blk_end_request_all - Helper function for drives to finish the request.
 * @rq: the request to finish
 * @error: %0 for success, < %0 for error
 *
 * Description:
 *     Completely finish @rq.
 */
void blk_end_request_all(struct request *rq, int error)
{
	bool pending;
	unsigned int bidi_bytes = 0;

	if (unlikely(blk_bidi_rq(rq)))
		bidi_bytes = blk_rq_bytes(rq->next_rq);

	pending = blk_end_bidi_request(rq, error, blk_rq_bytes(rq), bidi_bytes);
	BUG_ON(pending);
}
EXPORT_SYMBOL(blk_end_request_all);

/**
 * blk_end_request_cur - Helper function to finish the current request chunk.
 * @rq: the request to finish the current chunk for
 * @error: %0 for success, < %0 for error
 *
 * Description:
 *     Complete the current consecutively mapped chunk from @rq.
 *
 * Return:
 *     %false - we are done with this request
 *     %true  - still buffers pending for this request
 */
bool blk_end_request_cur(struct request *rq, int error)
{
	return blk_end_request(rq, error, blk_rq_cur_bytes(rq));
}
EXPORT_SYMBOL(blk_end_request_cur);

/**
 * blk_end_request_err - Finish a request till the next failure boundary.
 * @rq: the request to finish till the next failure boundary for
 * @error: must be negative errno
 *
 * Description:
 *     Complete @rq till the next failure boundary.
 *
 * Return:
 *     %false - we are done with this request
 *     %true  - still buffers pending for this request
 */
bool blk_end_request_err(struct request *rq, int error)
{
	WARN_ON(error >= 0);
	return blk_end_request(rq, error, blk_rq_err_bytes(rq));
}
EXPORT_SYMBOL_GPL(blk_end_request_err);

/**
 * __blk_end_request - Helper function for drivers to complete the request.
 * @rq:       the request being processed
 * @error:    %0 for success, < %0 for error
 * @nr_bytes: number of bytes to complete
 *
 * Description:
 *     Must be called with queue lock held unlike blk_end_request().
 *
 * Return:
 *     %false - we are done with this request
 *     %true  - still buffers pending for this request
 **/
bool __blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
{
	return __blk_end_bidi_request(rq, error, nr_bytes, 0);
}
EXPORT_SYMBOL(__blk_end_request);

/**
 * __blk_end_request_all - Helper function for drives to finish the request.
 * @rq: the request to finish
 * @error: %0 for success, < %0 for error
 *
 * Description:
 *     Completely finish @rq.  Must be called with queue lock held.
 */
void __blk_end_request_all(struct request *rq, int error)
{
	bool pending;
	unsigned int bidi_bytes = 0;

	if (unlikely(blk_bidi_rq(rq)))
		bidi_bytes = blk_rq_bytes(rq->next_rq);

	pending = __blk_end_bidi_request(rq, error, blk_rq_bytes(rq), bidi_bytes);
	BUG_ON(pending);
}
EXPORT_SYMBOL(__blk_end_request_all);

/**
 * __blk_end_request_cur - Helper function to finish the current request chunk.
 * @rq: the request to finish the current chunk for
 * @error: %0 for success, < %0 for error
 *
 * Description:
 *     Complete the current consecutively mapped chunk from @rq.  Must
 *     be called with queue lock held.
 *
 * Return:
 *     %false - we are done with this request
 *     %true  - still buffers pending for this request
 */
bool __blk_end_request_cur(struct request *rq, int error)
{
	return __blk_end_request(rq, error, blk_rq_cur_bytes(rq));
}
EXPORT_SYMBOL(__blk_end_request_cur);

/**
 * __blk_end_request_err - Finish a request till the next failure boundary.
 * @rq: the request to finish till the next failure boundary for
 * @error: must be negative errno
 *
 * Description:
 *     Complete @rq till the next failure boundary.  Must be called
 *     with queue lock held.
 *
 * Return:
 *     %false - we are done with this request
 *     %true  - still buffers pending for this request
 */
bool __blk_end_request_err(struct request *rq, int error)
{
	WARN_ON(error >= 0);
	return __blk_end_request(rq, error, blk_rq_err_bytes(rq));
}
EXPORT_SYMBOL_GPL(__blk_end_request_err);

void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
		     struct bio *bio)
{
	/* Bit 0 (R/W) is identical in rq->cmd_flags and bio->bi_rw */
	rq->cmd_flags |= bio->bi_rw & REQ_WRITE;

	if (bio_has_data(bio)) {
		rq->nr_phys_segments = bio_phys_segments(q, bio);
		rq->buffer = bio_data(bio);
	}
	rq->__data_len = bio->bi_size;
	rq->bio = rq->biotail = bio;

	if (bio->bi_bdev)
		rq->rq_disk = bio->bi_bdev->bd_disk;
}

#if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
/**
 * rq_flush_dcache_pages - Helper function to flush all pages in a request
 * @rq: the request to be flushed
 *
 * Description:
 *     Flush all pages in @rq.
 */
void rq_flush_dcache_pages(struct request *rq)
{
	struct req_iterator iter;
	struct bio_vec *bvec;

	rq_for_each_segment(bvec, rq, iter)
		flush_dcache_page(bvec->bv_page);
}
EXPORT_SYMBOL_GPL(rq_flush_dcache_pages);
#endif

/**
 * blk_lld_busy - Check if underlying low-level drivers of a device are busy
 * @q : the queue of the device being checked
 *
 * Description:
 *    Check if underlying low-level drivers of a device are busy.
 *    If the drivers want to export their busy state, they must set own
 *    exporting function using blk_queue_lld_busy() first.
 *
 *    Basically, this function is used only by request stacking drivers
 *    to stop dispatching requests to underlying devices when underlying
 *    devices are busy.  This behavior helps more I/O merging on the queue
 *    of the request stacking driver and prevents I/O throughput regression
 *    on burst I/O load.
 *
 * Return:
 *    0 - Not busy (The request stacking driver should dispatch request)
 *    1 - Busy (The request stacking driver should stop dispatching request)
 */
int blk_lld_busy(struct request_queue *q)
{
	if (q->lld_busy_fn)
		return q->lld_busy_fn(q);

	return 0;
}
EXPORT_SYMBOL_GPL(blk_lld_busy);

/**
 * blk_rq_unprep_clone - Helper function to free all bios in a cloned request
 * @rq: the clone request to be cleaned up
 *
 * Description:
 *     Free all bios in @rq for a cloned request.
 */
void blk_rq_unprep_clone(struct request *rq)
{
	struct bio *bio;

	while ((bio = rq->bio) != NULL) {
		rq->bio = bio->bi_next;

		bio_put(bio);
	}
}
EXPORT_SYMBOL_GPL(blk_rq_unprep_clone);

/*
 * Copy attributes of the original request to the clone request.
 * The actual data parts (e.g. ->cmd, ->buffer, ->sense) are not copied.
 */
static void __blk_rq_prep_clone(struct request *dst, struct request *src)
{
	dst->cpu = src->cpu;
	dst->cmd_flags = (src->cmd_flags & REQ_CLONE_MASK) | REQ_NOMERGE;
	dst->cmd_type = src->cmd_type;
	dst->__sector = blk_rq_pos(src);
	dst->__data_len = blk_rq_bytes(src);
	dst->nr_phys_segments = src->nr_phys_segments;
	dst->ioprio = src->ioprio;
	dst->extra_len = src->extra_len;
}

/**
 * blk_rq_prep_clone - Helper function to setup clone request
 * @rq: the request to be setup
 * @rq_src: original request to be cloned
 * @bs: bio_set that bios for clone are allocated from
 * @gfp_mask: memory allocation mask for bio
 * @bio_ctr: setup function to be called for each clone bio.
 *           Returns %0 for success, non %0 for failure.
 * @data: private data to be passed to @bio_ctr
 *
 * Description:
 *     Clones bios in @rq_src to @rq, and copies attributes of @rq_src to @rq.
 *     The actual data parts of @rq_src (e.g. ->cmd, ->buffer, ->sense)
 *     are not copied, and copying such parts is the caller's responsibility.
 *     Also, pages which the original bios are pointing to are not copied
 *     and the cloned bios just point same pages.
 *     So cloned bios must be completed before original bios, which means
 *     the caller must complete @rq before @rq_src.
 */
int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
		      struct bio_set *bs, gfp_t gfp_mask,
		      int (*bio_ctr)(struct bio *, struct bio *, void *),
		      void *data)
{
	struct bio *bio, *bio_src;

	if (!bs)
		bs = fs_bio_set;

	blk_rq_init(NULL, rq);

	__rq_for_each_bio(bio_src, rq_src) {
		bio = bio_alloc_bioset(gfp_mask, bio_src->bi_max_vecs, bs);
		if (!bio)
			goto free_and_out;

		__bio_clone(bio, bio_src);

		if (bio_integrity(bio_src) &&
		    bio_integrity_clone(bio, bio_src, gfp_mask, bs))
			goto free_and_out;

		if (bio_ctr && bio_ctr(bio, bio_src, data))
			goto free_and_out;

		if (rq->bio) {
			rq->biotail->bi_next = bio;
			rq->biotail = bio;
		} else
			rq->bio = rq->biotail = bio;
	}

	__blk_rq_prep_clone(rq, rq_src);

	return 0;

free_and_out:
	if (bio)
		bio_free(bio, bs);
	blk_rq_unprep_clone(rq);

	return -ENOMEM;
}
EXPORT_SYMBOL_GPL(blk_rq_prep_clone);

int kblockd_schedule_work(struct request_queue *q, struct work_struct *work)
{
	return queue_work(kblockd_workqueue, work);
}
EXPORT_SYMBOL(kblockd_schedule_work);

int kblockd_schedule_delayed_work(struct request_queue *q,
			struct delayed_work *dwork, unsigned long delay)
{
	return queue_delayed_work(kblockd_workqueue, dwork, delay);
}
EXPORT_SYMBOL(kblockd_schedule_delayed_work);

#define PLUG_MAGIC	0x91827364

/**
 * blk_start_plug - initialize blk_plug and track it inside the task_struct
 * @plug:	The &struct blk_plug that needs to be initialized
 *
 * Description:
 *   Tracking blk_plug inside the task_struct will help with auto-flushing the
 *   pending I/O should the task end up blocking between blk_start_plug() and
 *   blk_finish_plug(). This is important from a performance perspective, but
 *   also ensures that we don't deadlock. For instance, if the task is blocking
 *   for a memory allocation, memory reclaim could end up wanting to free a
 *   page belonging to that request that is currently residing in our private
 *   plug. By flushing the pending I/O when the process goes to sleep, we avoid
 *   this kind of deadlock.
 */
void blk_start_plug(struct blk_plug *plug)
{
	struct task_struct *tsk = current;

	plug->magic = PLUG_MAGIC;
	INIT_LIST_HEAD(&plug->list);
	INIT_LIST_HEAD(&plug->cb_list);
	plug->should_sort = 0;

	/*
	 * If this is a nested plug, don't actually assign it. It will be
	 * flushed on its own.
	 */
	if (!tsk->plug) {
		/*
		 * Store ordering should not be needed here, since a potential
		 * preempt will imply a full memory barrier
		 */
		tsk->plug = plug;
	}
}
EXPORT_SYMBOL(blk_start_plug);

static int plug_rq_cmp(void *priv, struct list_head *a, struct list_head *b)
{
	struct request *rqa = container_of(a, struct request, queuelist);
	struct request *rqb = container_of(b, struct request, queuelist);

	return !(rqa->queue_ctx <= rqb->queue_ctx);
}

/*
 * If 'from_schedule' is true, then postpone the dispatch of requests
 * until a safe kblockd context. We due this to avoid accidental big
 * additional stack usage in driver dispatch, in places where the originally
 * plugger did not intend it.
 */
static void queue_unplugged(struct request_queue *q, unsigned int depth,
			    bool from_schedule)
{
	trace_block_unplug(q, depth, !from_schedule);

	/*
	 * Don't mess with dead queue.
	 */
	if (unlikely(blk_queue_dead(q)))
		return;

	/*
	 * If we are punting this to kblockd, then we can safely drop
	 * the queue_lock before waking kblockd (which needs to take
	 * this lock).
	 */
	if (from_schedule)
		blk_run_queue_async(q);
	else {
		spin_lock(q->queue_lock);
		__blk_run_queue(q);
		spin_unlock(q->queue_lock);
	}
}

static void flush_plug_callbacks(struct blk_plug *plug)
{
	LIST_HEAD(callbacks);

	if (list_empty(&plug->cb_list))
		return;

	list_splice_init(&plug->cb_list, &callbacks);

	while (!list_empty(&callbacks)) {
		struct blk_plug_cb *cb = list_first_entry(&callbacks,
							  struct blk_plug_cb,
							  list);
		list_del(&cb->list);
		cb->callback(cb);
	}
}

void blk_flush_plug_list(struct blk_plug *plug, bool from_schedule)
{
	struct blk_queue_ctx *ctx;
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

	ctx = NULL;
	depth = 0;

	/*
	 * Save and disable interrupts here, to avoid doing it for every
	 * queue lock we have to take.
	 */
	local_irq_save(flags);
	while (!list_empty(&list)) {
		rq = list_entry_rq(list.next);
		list_del_init(&rq->queuelist);
		BUG_ON(!rq->queue_ctx);
		if (rq->queue_ctx != ctx) {
			if (ctx) {
				spin_unlock(&ctx->lock);
				queue_unplugged(ctx->queue, depth, from_schedule);
			}
			ctx = rq->queue_ctx;
			depth = 0;
			spin_lock(&ctx->lock);
		}

		/*
		 * Short-circuit if @q is dead
		 */
		if (unlikely(blk_queue_dead(ctx->queue))) {
			__blk_end_request_all(rq, -ENODEV);
			continue;
		}

		/*
		 * rq is already accounted, so use raw insert
		 */
		if (rq->cmd_flags & (REQ_FLUSH | REQ_FUA))
			__elv_add_request(rq, ELEVATOR_INSERT_FLUSH);
		else
			__elv_add_request(rq, ELEVATOR_INSERT_SORT_MERGE);

		depth++;
	}

	/*
	 * This drops the queue lock
	 */
	if (ctx) {
		spin_unlock(&ctx->lock);
		queue_unplugged(ctx->queue, depth, from_schedule);
	}

	local_irq_restore(flags);
}

void blk_finish_plug(struct blk_plug *plug)
{
	blk_flush_plug_list(plug, false);

	if (plug == current->plug)
		current->plug = NULL;
}
EXPORT_SYMBOL(blk_finish_plug);

int __init blk_dev_init(void)
{
	BUILD_BUG_ON(__REQ_NR_BITS > 8 *
			sizeof(((struct request *)0)->cmd_flags));

	/* used for unplugging and affects IO latency/throughput - HIGHPRI */
	kblockd_workqueue = alloc_workqueue("kblockd",
					    WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);
	if (!kblockd_workqueue)
		panic("Failed to create kblockd\n");

	request_cachep = kmem_cache_create("blkdev_requests",
			sizeof(struct request), 0, SLAB_PANIC, NULL);

	blk_requestq_cachep = kmem_cache_create("blkdev_queue",
			sizeof(struct request_queue), 0, SLAB_PANIC, NULL);

	return 0;
}

--=_4fd91c3f.R4ms68f5hejM12e5zdJOlaXCA5NYIvmvSlWnmiraoFWGO1Xb
Content-Type: text/x-csrc;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="scsi_transport_fc.c"

/*
 *  FiberChannel transport specific attributes exported to sysfs.
 *
 *  Copyright (c) 2003 Silicon Graphics, Inc.  All rights reserved.
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 *  ========
 *
 *  Copyright (C) 2004-2007   James Smart, Emulex Corporation
 *    Rewrite for host, target, device, and remote port attributes,
 *    statistics, and service functions...
 *    Add vports, etc
 *
 */
#include <linux/module.h>
#include <linux/init.h>
#include <linux/slab.h>
#include <linux/delay.h>
#include <linux/kernel.h>
#include <scsi/scsi_device.h>
#include <scsi/scsi_host.h>
#include <scsi/scsi_transport.h>
#include <scsi/scsi_transport_fc.h>
#include <scsi/scsi_cmnd.h>
#include <linux/netlink.h>
#include <net/netlink.h>
#include <scsi/scsi_netlink_fc.h>
#include <scsi/scsi_bsg_fc.h>
#include "scsi_priv.h"
#include "scsi_transport_fc_internal.h"

static int fc_queue_work(struct Scsi_Host *, struct work_struct *);
static void fc_vport_sched_delete(struct work_struct *work);
static int fc_vport_setup(struct Scsi_Host *shost, int channel,
	struct device *pdev, struct fc_vport_identifiers  *ids,
	struct fc_vport **vport);
static int fc_bsg_hostadd(struct Scsi_Host *, struct fc_host_attrs *);
static int fc_bsg_rportadd(struct Scsi_Host *, struct fc_rport *);
static void fc_bsg_remove(struct request_queue *);
static void fc_bsg_goose_queue(struct fc_rport *);

/*
 * Module Parameters
 */

/*
 * dev_loss_tmo: the default number of seconds that the FC transport
 *   should insulate the loss of a remote port.
 *   The maximum will be capped by the value of SCSI_DEVICE_BLOCK_MAX_TIMEOUT.
 */
static unsigned int fc_dev_loss_tmo = 60;		/* seconds */

module_param_named(dev_loss_tmo, fc_dev_loss_tmo, uint, S_IRUGO|S_IWUSR);
MODULE_PARM_DESC(dev_loss_tmo,
		 "Maximum number of seconds that the FC transport should"
		 " insulate the loss of a remote port. Once this value is"
		 " exceeded, the scsi target is removed. Value should be"
		 " between 1 and SCSI_DEVICE_BLOCK_MAX_TIMEOUT if"
		 " fast_io_fail_tmo is not set.");

/*
 * Redefine so that we can have same named attributes in the
 * sdev/starget/host objects.
 */
#define FC_DEVICE_ATTR(_prefix,_name,_mode,_show,_store)		\
struct device_attribute device_attr_##_prefix##_##_name = 	\
	__ATTR(_name,_mode,_show,_store)

#define fc_enum_name_search(title, table_type, table)			\
static const char *get_fc_##title##_name(enum table_type table_key)	\
{									\
	int i;								\
	char *name = NULL;						\
									\
	for (i = 0; i < ARRAY_SIZE(table); i++) {			\
		if (table[i].value == table_key) {			\
			name = table[i].name;				\
			break;						\
		}							\
	}								\
	return name;							\
}

#define fc_enum_name_match(title, table_type, table)			\
static int get_fc_##title##_match(const char *table_key,		\
		enum table_type *value)					\
{									\
	int i;								\
									\
	for (i = 0; i < ARRAY_SIZE(table); i++) {			\
		if (strncmp(table_key, table[i].name,			\
				table[i].matchlen) == 0) {		\
			*value = table[i].value;			\
			return 0; /* success */				\
		}							\
	}								\
	return 1; /* failure */						\
}


/* Convert fc_port_type values to ascii string name */
static struct {
	enum fc_port_type	value;
	char			*name;
} fc_port_type_names[] = {
	{ FC_PORTTYPE_UNKNOWN,		"Unknown" },
	{ FC_PORTTYPE_OTHER,		"Other" },
	{ FC_PORTTYPE_NOTPRESENT,	"Not Present" },
	{ FC_PORTTYPE_NPORT,	"NPort (fabric via point-to-point)" },
	{ FC_PORTTYPE_NLPORT,	"NLPort (fabric via loop)" },
	{ FC_PORTTYPE_LPORT,	"LPort (private loop)" },
	{ FC_PORTTYPE_PTP,	"Point-To-Point (direct nport connection)" },
	{ FC_PORTTYPE_NPIV,		"NPIV VPORT" },
};
fc_enum_name_search(port_type, fc_port_type, fc_port_type_names)
#define FC_PORTTYPE_MAX_NAMELEN		50

/* Reuse fc_port_type enum function for vport_type */
#define get_fc_vport_type_name get_fc_port_type_name


/* Convert fc_host_event_code values to ascii string name */
static const struct {
	enum fc_host_event_code		value;
	char				*name;
} fc_host_event_code_names[] = {
	{ FCH_EVT_LIP,			"lip" },
	{ FCH_EVT_LINKUP,		"link_up" },
	{ FCH_EVT_LINKDOWN,		"link_down" },
	{ FCH_EVT_LIPRESET,		"lip_reset" },
	{ FCH_EVT_RSCN,			"rscn" },
	{ FCH_EVT_ADAPTER_CHANGE,	"adapter_chg" },
	{ FCH_EVT_PORT_UNKNOWN,		"port_unknown" },
	{ FCH_EVT_PORT_ONLINE,		"port_online" },
	{ FCH_EVT_PORT_OFFLINE,		"port_offline" },
	{ FCH_EVT_PORT_FABRIC,		"port_fabric" },
	{ FCH_EVT_LINK_UNKNOWN,		"link_unknown" },
	{ FCH_EVT_VENDOR_UNIQUE,	"vendor_unique" },
};
fc_enum_name_search(host_event_code, fc_host_event_code,
		fc_host_event_code_names)
#define FC_HOST_EVENT_CODE_MAX_NAMELEN	30


/* Convert fc_port_state values to ascii string name */
static struct {
	enum fc_port_state	value;
	char			*name;
} fc_port_state_names[] = {
	{ FC_PORTSTATE_UNKNOWN,		"Unknown" },
	{ FC_PORTSTATE_NOTPRESENT,	"Not Present" },
	{ FC_PORTSTATE_ONLINE,		"Online" },
	{ FC_PORTSTATE_OFFLINE,		"Offline" },
	{ FC_PORTSTATE_BLOCKED,		"Blocked" },
	{ FC_PORTSTATE_BYPASSED,	"Bypassed" },
	{ FC_PORTSTATE_DIAGNOSTICS,	"Diagnostics" },
	{ FC_PORTSTATE_LINKDOWN,	"Linkdown" },
	{ FC_PORTSTATE_ERROR,		"Error" },
	{ FC_PORTSTATE_LOOPBACK,	"Loopback" },
	{ FC_PORTSTATE_DELETED,		"Deleted" },
};
fc_enum_name_search(port_state, fc_port_state, fc_port_state_names)
#define FC_PORTSTATE_MAX_NAMELEN	20


/* Convert fc_vport_state values to ascii string name */
static struct {
	enum fc_vport_state	value;
	char			*name;
} fc_vport_state_names[] = {
	{ FC_VPORT_UNKNOWN,		"Unknown" },
	{ FC_VPORT_ACTIVE,		"Active" },
	{ FC_VPORT_DISABLED,		"Disabled" },
	{ FC_VPORT_LINKDOWN,		"Linkdown" },
	{ FC_VPORT_INITIALIZING,	"Initializing" },
	{ FC_VPORT_NO_FABRIC_SUPP,	"No Fabric Support" },
	{ FC_VPORT_NO_FABRIC_RSCS,	"No Fabric Resources" },
	{ FC_VPORT_FABRIC_LOGOUT,	"Fabric Logout" },
	{ FC_VPORT_FABRIC_REJ_WWN,	"Fabric Rejected WWN" },
	{ FC_VPORT_FAILED,		"VPort Failed" },
};
fc_enum_name_search(vport_state, fc_vport_state, fc_vport_state_names)
#define FC_VPORTSTATE_MAX_NAMELEN	24

/* Reuse fc_vport_state enum function for vport_last_state */
#define get_fc_vport_last_state_name get_fc_vport_state_name


/* Convert fc_tgtid_binding_type values to ascii string name */
static const struct {
	enum fc_tgtid_binding_type	value;
	char				*name;
	int				matchlen;
} fc_tgtid_binding_type_names[] = {
	{ FC_TGTID_BIND_NONE, "none", 4 },
	{ FC_TGTID_BIND_BY_WWPN, "wwpn (World Wide Port Name)", 4 },
	{ FC_TGTID_BIND_BY_WWNN, "wwnn (World Wide Node Name)", 4 },
	{ FC_TGTID_BIND_BY_ID, "port_id (FC Address)", 7 },
};
fc_enum_name_search(tgtid_bind_type, fc_tgtid_binding_type,
		fc_tgtid_binding_type_names)
fc_enum_name_match(tgtid_bind_type, fc_tgtid_binding_type,
		fc_tgtid_binding_type_names)
#define FC_BINDTYPE_MAX_NAMELEN	30


#define fc_bitfield_name_search(title, table)			\
static ssize_t							\
get_fc_##title##_names(u32 table_key, char *buf)		\
{								\
	char *prefix = "";					\
	ssize_t len = 0;					\
	int i;							\
								\
	for (i = 0; i < ARRAY_SIZE(table); i++) {		\
		if (table[i].value & table_key) {		\
			len += sprintf(buf + len, "%s%s",	\
				prefix, table[i].name);		\
			prefix = ", ";				\
		}						\
	}							\
	len += sprintf(buf + len, "\n");			\
	return len;						\
}


/* Convert FC_COS bit values to ascii string name */
static const struct {
	u32 			value;
	char			*name;
} fc_cos_names[] = {
	{ FC_COS_CLASS1,	"Class 1" },
	{ FC_COS_CLASS2,	"Class 2" },
	{ FC_COS_CLASS3,	"Class 3" },
	{ FC_COS_CLASS4,	"Class 4" },
	{ FC_COS_CLASS6,	"Class 6" },
};
fc_bitfield_name_search(cos, fc_cos_names)


/* Convert FC_PORTSPEED bit values to ascii string name */
static const struct {
	u32 			value;
	char			*name;
} fc_port_speed_names[] = {
	{ FC_PORTSPEED_1GBIT,		"1 Gbit" },
	{ FC_PORTSPEED_2GBIT,		"2 Gbit" },
	{ FC_PORTSPEED_4GBIT,		"4 Gbit" },
	{ FC_PORTSPEED_10GBIT,		"10 Gbit" },
	{ FC_PORTSPEED_8GBIT,		"8 Gbit" },
	{ FC_PORTSPEED_16GBIT,		"16 Gbit" },
	{ FC_PORTSPEED_NOT_NEGOTIATED,	"Not Negotiated" },
};
fc_bitfield_name_search(port_speed, fc_port_speed_names)


static int
show_fc_fc4s (char *buf, u8 *fc4_list)
{
	int i, len=0;

	for (i = 0; i < FC_FC4_LIST_SIZE; i++, fc4_list++)
		len += sprintf(buf + len , "0x%02x ", *fc4_list);
	len += sprintf(buf + len, "\n");
	return len;
}


/* Convert FC_PORT_ROLE bit values to ascii string name */
static const struct {
	u32 			value;
	char			*name;
} fc_port_role_names[] = {
	{ FC_PORT_ROLE_FCP_TARGET,	"FCP Target" },
	{ FC_PORT_ROLE_FCP_INITIATOR,	"FCP Initiator" },
	{ FC_PORT_ROLE_IP_PORT,		"IP Port" },
};
fc_bitfield_name_search(port_roles, fc_port_role_names)

/*
 * Define roles that are specific to port_id. Values are relative to ROLE_MASK.
 */
#define FC_WELLKNOWN_PORTID_MASK	0xfffff0
#define FC_WELLKNOWN_ROLE_MASK  	0x00000f
#define FC_FPORT_PORTID			0x00000e
#define FC_FABCTLR_PORTID		0x00000d
#define FC_DIRSRVR_PORTID		0x00000c
#define FC_TIMESRVR_PORTID		0x00000b
#define FC_MGMTSRVR_PORTID		0x00000a


static void fc_timeout_deleted_rport(struct work_struct *work);
static void fc_timeout_fail_rport_io(struct work_struct *work);
static void fc_scsi_scan_rport(struct work_struct *work);

/*
 * Attribute counts pre object type...
 * Increase these values if you add attributes
 */
#define FC_STARGET_NUM_ATTRS 	3
#define FC_RPORT_NUM_ATTRS	10
#define FC_VPORT_NUM_ATTRS	9
#define FC_HOST_NUM_ATTRS	29

struct fc_internal {
	struct scsi_transport_template t;
	struct fc_function_template *f;

	/*
	 * For attributes : each object has :
	 *   An array of the actual attributes structures
	 *   An array of null-terminated pointers to the attribute
	 *     structures - used for mid-layer interaction.
	 *
	 * The attribute containers for the starget and host are are
	 * part of the midlayer. As the remote port is specific to the
	 * fc transport, we must provide the attribute container.
	 */
	struct device_attribute private_starget_attrs[
							FC_STARGET_NUM_ATTRS];
	struct device_attribute *starget_attrs[FC_STARGET_NUM_ATTRS + 1];

	struct device_attribute private_host_attrs[FC_HOST_NUM_ATTRS];
	struct device_attribute *host_attrs[FC_HOST_NUM_ATTRS + 1];

	struct transport_container rport_attr_cont;
	struct device_attribute private_rport_attrs[FC_RPORT_NUM_ATTRS];
	struct device_attribute *rport_attrs[FC_RPORT_NUM_ATTRS + 1];

	struct transport_container vport_attr_cont;
	struct device_attribute private_vport_attrs[FC_VPORT_NUM_ATTRS];
	struct device_attribute *vport_attrs[FC_VPORT_NUM_ATTRS + 1];
};

#define to_fc_internal(tmpl)	container_of(tmpl, struct fc_internal, t)

static int fc_target_setup(struct transport_container *tc, struct device *dev,
			   struct device *cdev)
{
	struct scsi_target *starget = to_scsi_target(dev);
	struct fc_rport *rport = starget_to_rport(starget);

	/*
	 * if parent is remote port, use values from remote port.
	 * Otherwise, this host uses the fc_transport, but not the
	 * remote port interface. As such, initialize to known non-values.
	 */
	if (rport) {
		fc_starget_node_name(starget) = rport->node_name;
		fc_starget_port_name(starget) = rport->port_name;
		fc_starget_port_id(starget) = rport->port_id;
	} else {
		fc_starget_node_name(starget) = -1;
		fc_starget_port_name(starget) = -1;
		fc_starget_port_id(starget) = -1;
	}

	return 0;
}

static DECLARE_TRANSPORT_CLASS(fc_transport_class,
			       "fc_transport",
			       fc_target_setup,
			       NULL,
			       NULL);

static int fc_host_setup(struct transport_container *tc, struct device *dev,
			 struct device *cdev)
{
	struct Scsi_Host *shost = dev_to_shost(dev);
	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);

	/*
	 * Set default values easily detected by the midlayer as
	 * failure cases.  The scsi lldd is responsible for initializing
	 * all transport attributes to valid values per host.
	 */
	fc_host->node_name = -1;
	fc_host->port_name = -1;
	fc_host->permanent_port_name = -1;
	fc_host->supported_classes = FC_COS_UNSPECIFIED;
	memset(fc_host->supported_fc4s, 0,
		sizeof(fc_host->supported_fc4s));
	fc_host->supported_speeds = FC_PORTSPEED_UNKNOWN;
	fc_host->maxframe_size = -1;
	fc_host->max_npiv_vports = 0;
	memset(fc_host->serial_number, 0,
		sizeof(fc_host->serial_number));
	memset(fc_host->manufacturer, 0,
		sizeof(fc_host->manufacturer));
	memset(fc_host->model, 0,
		sizeof(fc_host->model));
	memset(fc_host->model_description, 0,
		sizeof(fc_host->model_description));
	memset(fc_host->hardware_version, 0,
		sizeof(fc_host->hardware_version));
	memset(fc_host->driver_version, 0,
		sizeof(fc_host->driver_version));
	memset(fc_host->firmware_version, 0,
		sizeof(fc_host->firmware_version));
	memset(fc_host->optionrom_version, 0,
		sizeof(fc_host->optionrom_version));

	fc_host->port_id = -1;
	fc_host->port_type = FC_PORTTYPE_UNKNOWN;
	fc_host->port_state = FC_PORTSTATE_UNKNOWN;
	memset(fc_host->active_fc4s, 0,
		sizeof(fc_host->active_fc4s));
	fc_host->speed = FC_PORTSPEED_UNKNOWN;
	fc_host->fabric_name = -1;
	memset(fc_host->symbolic_name, 0, sizeof(fc_host->symbolic_name));
	memset(fc_host->system_hostname, 0, sizeof(fc_host->system_hostname));

	fc_host->tgtid_bind_type = FC_TGTID_BIND_BY_WWPN;

	INIT_LIST_HEAD(&fc_host->rports);
	INIT_LIST_HEAD(&fc_host->rport_bindings);
	INIT_LIST_HEAD(&fc_host->vports);
	fc_host->next_rport_number = 0;
	fc_host->next_target_id = 0;
	fc_host->next_vport_number = 0;
	fc_host->npiv_vports_inuse = 0;

	snprintf(fc_host->work_q_name, sizeof(fc_host->work_q_name),
		 "fc_wq_%d", shost->host_no);
	fc_host->work_q = alloc_workqueue(fc_host->work_q_name, 0, 0);
	if (!fc_host->work_q)
		return -ENOMEM;

	fc_host->dev_loss_tmo = fc_dev_loss_tmo;
	snprintf(fc_host->devloss_work_q_name,
		 sizeof(fc_host->devloss_work_q_name),
		 "fc_dl_%d", shost->host_no);
	fc_host->devloss_work_q =
			alloc_workqueue(fc_host->devloss_work_q_name, 0, 0);
	if (!fc_host->devloss_work_q) {
		destroy_workqueue(fc_host->work_q);
		fc_host->work_q = NULL;
		return -ENOMEM;
	}

	fc_bsg_hostadd(shost, fc_host);
	/* ignore any bsg add error - we just can't do sgio */

	return 0;
}

static int fc_host_remove(struct transport_container *tc, struct device *dev,
			 struct device *cdev)
{
	struct Scsi_Host *shost = dev_to_shost(dev);
	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);

	fc_bsg_remove(fc_host->rqst_q);
	return 0;
}

static DECLARE_TRANSPORT_CLASS(fc_host_class,
			       "fc_host",
			       fc_host_setup,
			       fc_host_remove,
			       NULL);

/*
 * Setup and Remove actions for remote ports are handled
 * in the service functions below.
 */
static DECLARE_TRANSPORT_CLASS(fc_rport_class,
			       "fc_remote_ports",
			       NULL,
			       NULL,
			       NULL);

/*
 * Setup and Remove actions for virtual ports are handled
 * in the service functions below.
 */
static DECLARE_TRANSPORT_CLASS(fc_vport_class,
			       "fc_vports",
			       NULL,
			       NULL,
			       NULL);

/*
 * Netlink Infrastructure
 */

static atomic_t fc_event_seq;

/**
 * fc_get_event_number - Obtain the next sequential FC event number
 *
 * Notes:
 *   We could have inlined this, but it would have required fc_event_seq to
 *   be exposed. For now, live with the subroutine call.
 *   Atomic used to avoid lock/unlock...
 */
u32
fc_get_event_number(void)
{
	return atomic_add_return(1, &fc_event_seq);
}
EXPORT_SYMBOL(fc_get_event_number);


/**
 * fc_host_post_event - called to post an even on an fc_host.
 * @shost:		host the event occurred on
 * @event_number:	fc event number obtained from get_fc_event_number()
 * @event_code:		fc_host event being posted
 * @event_data:		32bits of data for the event being posted
 *
 * Notes:
 *	This routine assumes no locks are held on entry.
 */
void
fc_host_post_event(struct Scsi_Host *shost, u32 event_number,
		enum fc_host_event_code event_code, u32 event_data)
{
	struct sk_buff *skb;
	struct nlmsghdr	*nlh;
	struct fc_nl_event *event;
	const char *name;
	u32 len, skblen;
	int err;

	if (!scsi_nl_sock) {
		err = -ENOENT;
		goto send_fail;
	}

	len = FC_NL_MSGALIGN(sizeof(*event));
	skblen = NLMSG_SPACE(len);

	skb = alloc_skb(skblen, GFP_KERNEL);
	if (!skb) {
		err = -ENOBUFS;
		goto send_fail;
	}

	nlh = nlmsg_put(skb, 0, 0, SCSI_TRANSPORT_MSG,
				skblen - sizeof(*nlh), 0);
	if (!nlh) {
		err = -ENOBUFS;
		goto send_fail_skb;
	}
	event = NLMSG_DATA(nlh);

	INIT_SCSI_NL_HDR(&event->snlh, SCSI_NL_TRANSPORT_FC,
				FC_NL_ASYNC_EVENT, len);
	event->seconds = get_seconds();
	event->vendor_id = 0;
	event->host_no = shost->host_no;
	event->event_datalen = sizeof(u32);	/* bytes */
	event->event_num = event_number;
	event->event_code = event_code;
	event->event_data = event_data;

	nlmsg_multicast(scsi_nl_sock, skb, 0, SCSI_NL_GRP_FC_EVENTS,
			GFP_KERNEL);
	return;

send_fail_skb:
	kfree_skb(skb);
send_fail:
	name = get_fc_host_event_code_name(event_code);
	printk(KERN_WARNING
		"%s: Dropped Event : host %d %s data 0x%08x - err %d\n",
		__func__, shost->host_no,
		(name) ? name : "<unknown>", event_data, err);
	return;
}
EXPORT_SYMBOL(fc_host_post_event);


/**
 * fc_host_post_vendor_event - called to post a vendor unique event on an fc_host
 * @shost:		host the event occurred on
 * @event_number:	fc event number obtained from get_fc_event_number()
 * @data_len:		amount, in bytes, of vendor unique data
 * @data_buf:		pointer to vendor unique data
 * @vendor_id:          Vendor id
 *
 * Notes:
 *	This routine assumes no locks are held on entry.
 */
void
fc_host_post_vendor_event(struct Scsi_Host *shost, u32 event_number,
		u32 data_len, char * data_buf, u64 vendor_id)
{
	struct sk_buff *skb;
	struct nlmsghdr	*nlh;
	struct fc_nl_event *event;
	u32 len, skblen;
	int err;

	if (!scsi_nl_sock) {
		err = -ENOENT;
		goto send_vendor_fail;
	}

	len = FC_NL_MSGALIGN(sizeof(*event) + data_len);
	skblen = NLMSG_SPACE(len);

	skb = alloc_skb(skblen, GFP_KERNEL);
	if (!skb) {
		err = -ENOBUFS;
		goto send_vendor_fail;
	}

	nlh = nlmsg_put(skb, 0, 0, SCSI_TRANSPORT_MSG,
				skblen - sizeof(*nlh), 0);
	if (!nlh) {
		err = -ENOBUFS;
		goto send_vendor_fail_skb;
	}
	event = NLMSG_DATA(nlh);

	INIT_SCSI_NL_HDR(&event->snlh, SCSI_NL_TRANSPORT_FC,
				FC_NL_ASYNC_EVENT, len);
	event->seconds = get_seconds();
	event->vendor_id = vendor_id;
	event->host_no = shost->host_no;
	event->event_datalen = data_len;	/* bytes */
	event->event_num = event_number;
	event->event_code = FCH_EVT_VENDOR_UNIQUE;
	memcpy(&event->event_data, data_buf, data_len);

	nlmsg_multicast(scsi_nl_sock, skb, 0, SCSI_NL_GRP_FC_EVENTS,
			GFP_KERNEL);
	return;

send_vendor_fail_skb:
	kfree_skb(skb);
send_vendor_fail:
	printk(KERN_WARNING
		"%s: Dropped Event : host %d vendor_unique - err %d\n",
		__func__, shost->host_no, err);
	return;
}
EXPORT_SYMBOL(fc_host_post_vendor_event);



static __init int fc_transport_init(void)
{
	int error;

	atomic_set(&fc_event_seq, 0);

	error = transport_class_register(&fc_host_class);
	if (error)
		return error;
	error = transport_class_register(&fc_vport_class);
	if (error)
		goto unreg_host_class;
	error = transport_class_register(&fc_rport_class);
	if (error)
		goto unreg_vport_class;
	error = transport_class_register(&fc_transport_class);
	if (error)
		goto unreg_rport_class;
	return 0;

unreg_rport_class:
	transport_class_unregister(&fc_rport_class);
unreg_vport_class:
	transport_class_unregister(&fc_vport_class);
unreg_host_class:
	transport_class_unregister(&fc_host_class);
	return error;
}

static void __exit fc_transport_exit(void)
{
	transport_class_unregister(&fc_transport_class);
	transport_class_unregister(&fc_rport_class);
	transport_class_unregister(&fc_host_class);
	transport_class_unregister(&fc_vport_class);
}

/*
 * FC Remote Port Attribute Management
 */

#define fc_rport_show_function(field, format_string, sz, cast)		\
static ssize_t								\
show_fc_rport_##field (struct device *dev, 				\
		       struct device_attribute *attr, char *buf)	\
{									\
	struct fc_rport *rport = transport_class_to_rport(dev);		\
	struct Scsi_Host *shost = rport_to_shost(rport);		\
	struct fc_internal *i = to_fc_internal(shost->transportt);	\
	if ((i->f->get_rport_##field) &&				\
	    !((rport->port_state == FC_PORTSTATE_BLOCKED) ||		\
	      (rport->port_state == FC_PORTSTATE_DELETED) ||		\
	      (rport->port_state == FC_PORTSTATE_NOTPRESENT)))		\
		i->f->get_rport_##field(rport);				\
	return snprintf(buf, sz, format_string, cast rport->field); 	\
}

#define fc_rport_store_function(field)					\
static ssize_t								\
store_fc_rport_##field(struct device *dev,				\
		       struct device_attribute *attr,			\
		       const char *buf,	size_t count)			\
{									\
	int val;							\
	struct fc_rport *rport = transport_class_to_rport(dev);		\
	struct Scsi_Host *shost = rport_to_shost(rport);		\
	struct fc_internal *i = to_fc_internal(shost->transportt);	\
	char *cp;							\
	if ((rport->port_state == FC_PORTSTATE_BLOCKED) ||		\
	    (rport->port_state == FC_PORTSTATE_DELETED) ||		\
	    (rport->port_state == FC_PORTSTATE_NOTPRESENT))		\
		return -EBUSY;						\
	val = simple_strtoul(buf, &cp, 0);				\
	if (*cp && (*cp != '\n'))					\
		return -EINVAL;						\
	i->f->set_rport_##field(rport, val);				\
	return count;							\
}

#define fc_rport_rd_attr(field, format_string, sz)			\
	fc_rport_show_function(field, format_string, sz, )		\
static FC_DEVICE_ATTR(rport, field, S_IRUGO,			\
			 show_fc_rport_##field, NULL)

#define fc_rport_rd_attr_cast(field, format_string, sz, cast)		\
	fc_rport_show_function(field, format_string, sz, (cast))	\
static FC_DEVICE_ATTR(rport, field, S_IRUGO,			\
			  show_fc_rport_##field, NULL)

#define fc_rport_rw_attr(field, format_string, sz)			\
	fc_rport_show_function(field, format_string, sz, )		\
	fc_rport_store_function(field)					\
static FC_DEVICE_ATTR(rport, field, S_IRUGO | S_IWUSR,		\
			show_fc_rport_##field,				\
			store_fc_rport_##field)


#define fc_private_rport_show_function(field, format_string, sz, cast)	\
static ssize_t								\
show_fc_rport_##field (struct device *dev, 				\
		       struct device_attribute *attr, char *buf)	\
{									\
	struct fc_rport *rport = transport_class_to_rport(dev);		\
	return snprintf(buf, sz, format_string, cast rport->field); 	\
}

#define fc_private_rport_rd_attr(field, format_string, sz)		\
	fc_private_rport_show_function(field, format_string, sz, )	\
static FC_DEVICE_ATTR(rport, field, S_IRUGO,			\
			 show_fc_rport_##field, NULL)

#define fc_private_rport_rd_attr_cast(field, format_string, sz, cast)	\
	fc_private_rport_show_function(field, format_string, sz, (cast)) \
static FC_DEVICE_ATTR(rport, field, S_IRUGO,			\
			  show_fc_rport_##field, NULL)


#define fc_private_rport_rd_enum_attr(title, maxlen)			\
static ssize_t								\
show_fc_rport_##title (struct device *dev,				\
		       struct device_attribute *attr, char *buf)	\
{									\
	struct fc_rport *rport = transport_class_to_rport(dev);		\
	const char *name;						\
	name = get_fc_##title##_name(rport->title);			\
	if (!name)							\
		return -EINVAL;						\
	return snprintf(buf, maxlen, "%s\n", name);			\
}									\
static FC_DEVICE_ATTR(rport, title, S_IRUGO,			\
			show_fc_rport_##title, NULL)


#define SETUP_RPORT_ATTRIBUTE_RD(field)					\
	i->private_rport_attrs[count] = device_attr_rport_##field; \
	i->private_rport_attrs[count].attr.mode = S_IRUGO;		\
	i->private_rport_attrs[count].store = NULL;			\
	i->rport_attrs[count] = &i->private_rport_attrs[count];		\
	if (i->f->show_rport_##field)					\
		count++

#define SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(field)				\
	i->private_rport_attrs[count] = device_attr_rport_##field; \
	i->private_rport_attrs[count].attr.mode = S_IRUGO;		\
	i->private_rport_attrs[count].store = NULL;			\
	i->rport_attrs[count] = &i->private_rport_attrs[count];		\
	count++

#define SETUP_RPORT_ATTRIBUTE_RW(field)					\
	i->private_rport_attrs[count] = device_attr_rport_##field; \
	if (!i->f->set_rport_##field) {					\
		i->private_rport_attrs[count].attr.mode = S_IRUGO;	\
		i->private_rport_attrs[count].store = NULL;		\
	}								\
	i->rport_attrs[count] = &i->private_rport_attrs[count];		\
	if (i->f->show_rport_##field)					\
		count++

#define SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(field)				\
{									\
	i->private_rport_attrs[count] = device_attr_rport_##field; \
	i->rport_attrs[count] = &i->private_rport_attrs[count];		\
	count++;							\
}


/* The FC Transport Remote Port Attributes: */

/* Fixed Remote Port Attributes */

fc_private_rport_rd_attr(maxframe_size, "%u bytes\n", 20);

static ssize_t
show_fc_rport_supported_classes (struct device *dev,
				 struct device_attribute *attr, char *buf)
{
	struct fc_rport *rport = transport_class_to_rport(dev);
	if (rport->supported_classes == FC_COS_UNSPECIFIED)
		return snprintf(buf, 20, "unspecified\n");
	return get_fc_cos_names(rport->supported_classes, buf);
}
static FC_DEVICE_ATTR(rport, supported_classes, S_IRUGO,
		show_fc_rport_supported_classes, NULL);

/* Dynamic Remote Port Attributes */

/*
 * dev_loss_tmo attribute
 */
static int fc_str_to_dev_loss(const char *buf, unsigned long *val)
{
	char *cp;

	*val = simple_strtoul(buf, &cp, 0);
	if ((*cp && (*cp != '\n')) || (*val < 0))
		return -EINVAL;
	/*
	 * Check for overflow; dev_loss_tmo is u32
	 */
	if (*val > UINT_MAX)
		return -EINVAL;

	return 0;
}

static int fc_rport_set_dev_loss_tmo(struct fc_rport *rport,
				     unsigned long val)
{
	struct Scsi_Host *shost = rport_to_shost(rport);
	struct fc_internal *i = to_fc_internal(shost->transportt);

	if ((rport->port_state == FC_PORTSTATE_BLOCKED) ||
	    (rport->port_state == FC_PORTSTATE_DELETED) ||
	    (rport->port_state == FC_PORTSTATE_NOTPRESENT))
		return -EBUSY;
	/*
	 * Check for overflow; dev_loss_tmo is u32
	 */
	if (val > UINT_MAX)
		return -EINVAL;

	/*
	 * If fast_io_fail is off we have to cap
	 * dev_loss_tmo at SCSI_DEVICE_BLOCK_MAX_TIMEOUT
	 */
	if (rport->fast_io_fail_tmo == -1 &&
	    val > SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
		return -EINVAL;

	i->f->set_rport_dev_loss_tmo(rport, val);
	return 0;
}

fc_rport_show_function(dev_loss_tmo, "%d\n", 20, )
static ssize_t
store_fc_rport_dev_loss_tmo(struct device *dev, struct device_attribute *attr,
			    const char *buf, size_t count)
{
	struct fc_rport *rport = transport_class_to_rport(dev);
	unsigned long val;
	int rc;

	rc = fc_str_to_dev_loss(buf, &val);
	if (rc)
		return rc;

	rc = fc_rport_set_dev_loss_tmo(rport, val);
	if (rc)
		return rc;
	return count;
}
static FC_DEVICE_ATTR(rport, dev_loss_tmo, S_IRUGO | S_IWUSR,
		show_fc_rport_dev_loss_tmo, store_fc_rport_dev_loss_tmo);


/* Private Remote Port Attributes */

fc_private_rport_rd_attr_cast(node_name, "0x%llx\n", 20, unsigned long long);
fc_private_rport_rd_attr_cast(port_name, "0x%llx\n", 20, unsigned long long);
fc_private_rport_rd_attr(port_id, "0x%06x\n", 20);

static ssize_t
show_fc_rport_roles (struct device *dev, struct device_attribute *attr,
		     char *buf)
{
	struct fc_rport *rport = transport_class_to_rport(dev);

	/* identify any roles that are port_id specific */
	if ((rport->port_id != -1) &&
	    (rport->port_id & FC_WELLKNOWN_PORTID_MASK) ==
					FC_WELLKNOWN_PORTID_MASK) {
		switch (rport->port_id & FC_WELLKNOWN_ROLE_MASK) {
		case FC_FPORT_PORTID:
			return snprintf(buf, 30, "Fabric Port\n");
		case FC_FABCTLR_PORTID:
			return snprintf(buf, 30, "Fabric Controller\n");
		case FC_DIRSRVR_PORTID:
			return snprintf(buf, 30, "Directory Server\n");
		case FC_TIMESRVR_PORTID:
			return snprintf(buf, 30, "Time Server\n");
		case FC_MGMTSRVR_PORTID:
			return snprintf(buf, 30, "Management Server\n");
		default:
			return snprintf(buf, 30, "Unknown Fabric Entity\n");
		}
	} else {
		if (rport->roles == FC_PORT_ROLE_UNKNOWN)
			return snprintf(buf, 20, "unknown\n");
		return get_fc_port_roles_names(rport->roles, buf);
	}
}
static FC_DEVICE_ATTR(rport, roles, S_IRUGO,
		show_fc_rport_roles, NULL);

fc_private_rport_rd_enum_attr(port_state, FC_PORTSTATE_MAX_NAMELEN);
fc_private_rport_rd_attr(scsi_target_id, "%d\n", 20);

/*
 * fast_io_fail_tmo attribute
 */
static ssize_t
show_fc_rport_fast_io_fail_tmo (struct device *dev,
				struct device_attribute *attr, char *buf)
{
	struct fc_rport *rport = transport_class_to_rport(dev);

	if (rport->fast_io_fail_tmo == -1)
		return snprintf(buf, 5, "off\n");
	return snprintf(buf, 20, "%d\n", rport->fast_io_fail_tmo);
}

static ssize_t
store_fc_rport_fast_io_fail_tmo(struct device *dev,
				struct device_attribute *attr, const char *buf,
				size_t count)
{
	int val;
	char *cp;
	struct fc_rport *rport = transport_class_to_rport(dev);

	if ((rport->port_state == FC_PORTSTATE_BLOCKED) ||
	    (rport->port_state == FC_PORTSTATE_DELETED) ||
	    (rport->port_state == FC_PORTSTATE_NOTPRESENT))
		return -EBUSY;
	if (strncmp(buf, "off", 3) == 0)
		rport->fast_io_fail_tmo = -1;
	else {
		val = simple_strtoul(buf, &cp, 0);
		if ((*cp && (*cp != '\n')) || (val < 0))
			return -EINVAL;
		/*
		 * Cap fast_io_fail by dev_loss_tmo or
		 * SCSI_DEVICE_BLOCK_MAX_TIMEOUT.
		 */
		if ((val >= rport->dev_loss_tmo) ||
		    (val > SCSI_DEVICE_BLOCK_MAX_TIMEOUT))
			return -EINVAL;

		rport->fast_io_fail_tmo = val;
	}
	return count;
}
static FC_DEVICE_ATTR(rport, fast_io_fail_tmo, S_IRUGO | S_IWUSR,
	show_fc_rport_fast_io_fail_tmo, store_fc_rport_fast_io_fail_tmo);


/*
 * FC SCSI Target Attribute Management
 */

/*
 * Note: in the target show function we recognize when the remote
 *  port is in the hierarchy and do not allow the driver to get
 *  involved in sysfs functions. The driver only gets involved if
 *  it's the "old" style that doesn't use rports.
 */
#define fc_starget_show_function(field, format_string, sz, cast)	\
static ssize_t								\
show_fc_starget_##field (struct device *dev, 				\
			 struct device_attribute *attr, char *buf)	\
{									\
	struct scsi_target *starget = transport_class_to_starget(dev);	\
	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);	\
	struct fc_internal *i = to_fc_internal(shost->transportt);	\
	struct fc_rport *rport = starget_to_rport(starget);		\
	if (rport)							\
		fc_starget_##field(starget) = rport->field;		\
	else if (i->f->get_starget_##field)				\
		i->f->get_starget_##field(starget);			\
	return snprintf(buf, sz, format_string, 			\
		cast fc_starget_##field(starget)); 			\
}

#define fc_starget_rd_attr(field, format_string, sz)			\
	fc_starget_show_function(field, format_string, sz, )		\
static FC_DEVICE_ATTR(starget, field, S_IRUGO,			\
			 show_fc_starget_##field, NULL)

#define fc_starget_rd_attr_cast(field, format_string, sz, cast)		\
	fc_starget_show_function(field, format_string, sz, (cast))	\
static FC_DEVICE_ATTR(starget, field, S_IRUGO,			\
			  show_fc_starget_##field, NULL)

#define SETUP_STARGET_ATTRIBUTE_RD(field)				\
	i->private_starget_attrs[count] = device_attr_starget_##field; \
	i->private_starget_attrs[count].attr.mode = S_IRUGO;		\
	i->private_starget_attrs[count].store = NULL;			\
	i->starget_attrs[count] = &i->private_starget_attrs[count];	\
	if (i->f->show_starget_##field)					\
		count++

#define SETUP_STARGET_ATTRIBUTE_RW(field)				\
	i->private_starget_attrs[count] = device_attr_starget_##field; \
	if (!i->f->set_starget_##field) {				\
		i->private_starget_attrs[count].attr.mode = S_IRUGO;	\
		i->private_starget_attrs[count].store = NULL;		\
	}								\
	i->starget_attrs[count] = &i->private_starget_attrs[count];	\
	if (i->f->show_starget_##field)					\
		count++

/* The FC Transport SCSI Target Attributes: */
fc_starget_rd_attr_cast(node_name, "0x%llx\n", 20, unsigned long long);
fc_starget_rd_attr_cast(port_name, "0x%llx\n", 20, unsigned long long);
fc_starget_rd_attr(port_id, "0x%06x\n", 20);


/*
 * FC Virtual Port Attribute Management
 */

#define fc_vport_show_function(field, format_string, sz, cast)		\
static ssize_t								\
show_fc_vport_##field (struct device *dev, 				\
		       struct device_attribute *attr, char *buf)	\
{									\
	struct fc_vport *vport = transport_class_to_vport(dev);		\
	struct Scsi_Host *shost = vport_to_shost(vport);		\
	struct fc_internal *i = to_fc_internal(shost->transportt);	\
	if ((i->f->get_vport_##field) &&				\
	    !(vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING)))	\
		i->f->get_vport_##field(vport);				\
	return snprintf(buf, sz, format_string, cast vport->field); 	\
}

#define fc_vport_store_function(field)					\
static ssize_t								\
store_fc_vport_##field(struct device *dev,				\
		       struct device_attribute *attr,			\
		       const char *buf,	size_t count)			\
{									\
	int val;							\
	struct fc_vport *vport = transport_class_to_vport(dev);		\
	struct Scsi_Host *shost = vport_to_shost(vport);		\
	struct fc_internal *i = to_fc_internal(shost->transportt);	\
	char *cp;							\
	if (vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING))	\
		return -EBUSY;						\
	val = simple_strtoul(buf, &cp, 0);				\
	if (*cp && (*cp != '\n'))					\
		return -EINVAL;						\
	i->f->set_vport_##field(vport, val);				\
	return count;							\
}

#define fc_vport_store_str_function(field, slen)			\
static ssize_t								\
store_fc_vport_##field(struct device *dev,				\
		       struct device_attribute *attr, 			\
		       const char *buf,	size_t count)			\
{									\
	struct fc_vport *vport = transport_class_to_vport(dev);		\
	struct Scsi_Host *shost = vport_to_shost(vport);		\
	struct fc_internal *i = to_fc_internal(shost->transportt);	\
	unsigned int cnt=count;						\
									\
	/* count may include a LF at end of string */			\
	if (buf[cnt-1] == '\n')						\
		cnt--;							\
	if (cnt > ((slen) - 1))						\
		return -EINVAL;						\
	memcpy(vport->field, buf, cnt);					\
	i->f->set_vport_##field(vport);					\
	return count;							\
}

#define fc_vport_rd_attr(field, format_string, sz)			\
	fc_vport_show_function(field, format_string, sz, )		\
static FC_DEVICE_ATTR(vport, field, S_IRUGO,			\
			 show_fc_vport_##field, NULL)

#define fc_vport_rd_attr_cast(field, format_string, sz, cast)		\
	fc_vport_show_function(field, format_string, sz, (cast))	\
static FC_DEVICE_ATTR(vport, field, S_IRUGO,			\
			  show_fc_vport_##field, NULL)

#define fc_vport_rw_attr(field, format_string, sz)			\
	fc_vport_show_function(field, format_string, sz, )		\
	fc_vport_store_function(field)					\
static FC_DEVICE_ATTR(vport, field, S_IRUGO | S_IWUSR,		\
			show_fc_vport_##field,				\
			store_fc_vport_##field)

#define fc_private_vport_show_function(field, format_string, sz, cast)	\
static ssize_t								\
show_fc_vport_##field (struct device *dev,				\
		       struct device_attribute *attr, char *buf)	\
{									\
	struct fc_vport *vport = transport_class_to_vport(dev);		\
	return snprintf(buf, sz, format_string, cast vport->field); 	\
}

#define fc_private_vport_store_u32_function(field)			\
static ssize_t								\
store_fc_vport_##field(struct device *dev,				\
		       struct device_attribute *attr,			\
		       const char *buf,	size_t count)			\
{									\
	u32 val;							\
	struct fc_vport *vport = transport_class_to_vport(dev);		\
	char *cp;							\
	if (vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING))		\
		return -EBUSY;						\
	val = simple_strtoul(buf, &cp, 0);				\
	if (*cp && (*cp != '\n'))					\
		return -EINVAL;						\
	vport->field = val;						\
	return count;							\
}


#define fc_private_vport_rd_attr(field, format_string, sz)		\
	fc_private_vport_show_function(field, format_string, sz, )	\
static FC_DEVICE_ATTR(vport, field, S_IRUGO,			\
			 show_fc_vport_##field, NULL)

#define fc_private_vport_rd_attr_cast(field, format_string, sz, cast)	\
	fc_private_vport_show_function(field, format_string, sz, (cast)) \
static FC_DEVICE_ATTR(vport, field, S_IRUGO,			\
			  show_fc_vport_##field, NULL)

#define fc_private_vport_rw_u32_attr(field, format_string, sz)		\
	fc_private_vport_show_function(field, format_string, sz, )	\
	fc_private_vport_store_u32_function(field)			\
static FC_DEVICE_ATTR(vport, field, S_IRUGO | S_IWUSR,		\
			show_fc_vport_##field,				\
			store_fc_vport_##field)


#define fc_private_vport_rd_enum_attr(title, maxlen)			\
static ssize_t								\
show_fc_vport_##title (struct device *dev,				\
		       struct device_attribute *attr,			\
		       char *buf)					\
{									\
	struct fc_vport *vport = transport_class_to_vport(dev);		\
	const char *name;						\
	name = get_fc_##title##_name(vport->title);			\
	if (!name)							\
		return -EINVAL;						\
	return snprintf(buf, maxlen, "%s\n", name);			\
}									\
static FC_DEVICE_ATTR(vport, title, S_IRUGO,			\
			show_fc_vport_##title, NULL)


#define SETUP_VPORT_ATTRIBUTE_RD(field)					\
	i->private_vport_attrs[count] = device_attr_vport_##field; \
	i->private_vport_attrs[count].attr.mode = S_IRUGO;		\
	i->private_vport_attrs[count].store = NULL;			\
	i->vport_attrs[count] = &i->private_vport_attrs[count];		\
	if (i->f->get_##field)						\
		count++
	/* NOTE: Above MACRO differs: checks function not show bit */

#define SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(field)				\
	i->private_vport_attrs[count] = device_attr_vport_##field; \
	i->private_vport_attrs[count].attr.mode = S_IRUGO;		\
	i->private_vport_attrs[count].store = NULL;			\
	i->vport_attrs[count] = &i->private_vport_attrs[count];		\
	count++

#define SETUP_VPORT_ATTRIBUTE_WR(field)					\
	i->private_vport_attrs[count] = device_attr_vport_##field; \
	i->vport_attrs[count] = &i->private_vport_attrs[count];		\
	if (i->f->field)						\
		count++
	/* NOTE: Above MACRO differs: checks function */

#define SETUP_VPORT_ATTRIBUTE_RW(field)					\
	i->private_vport_attrs[count] = device_attr_vport_##field; \
	if (!i->f->set_vport_##field) {					\
		i->private_vport_attrs[count].attr.mode = S_IRUGO;	\
		i->private_vport_attrs[count].store = NULL;		\
	}								\
	i->vport_attrs[count] = &i->private_vport_attrs[count];		\
	count++
	/* NOTE: Above MACRO differs: does not check show bit */

#define SETUP_PRIVATE_VPORT_ATTRIBUTE_RW(field)				\
{									\
	i->private_vport_attrs[count] = device_attr_vport_##field; \
	i->vport_attrs[count] = &i->private_vport_attrs[count];		\
	count++;							\
}


/* The FC Transport Virtual Port Attributes: */

/* Fixed Virtual Port Attributes */

/* Dynamic Virtual Port Attributes */

/* Private Virtual Port Attributes */

fc_private_vport_rd_enum_attr(vport_state, FC_VPORTSTATE_MAX_NAMELEN);
fc_private_vport_rd_enum_attr(vport_last_state, FC_VPORTSTATE_MAX_NAMELEN);
fc_private_vport_rd_attr_cast(node_name, "0x%llx\n", 20, unsigned long long);
fc_private_vport_rd_attr_cast(port_name, "0x%llx\n", 20, unsigned long long);

static ssize_t
show_fc_vport_roles (struct device *dev, struct device_attribute *attr,
		     char *buf)
{
	struct fc_vport *vport = transport_class_to_vport(dev);

	if (vport->roles == FC_PORT_ROLE_UNKNOWN)
		return snprintf(buf, 20, "unknown\n");
	return get_fc_port_roles_names(vport->roles, buf);
}
static FC_DEVICE_ATTR(vport, roles, S_IRUGO, show_fc_vport_roles, NULL);

fc_private_vport_rd_enum_attr(vport_type, FC_PORTTYPE_MAX_NAMELEN);

fc_private_vport_show_function(symbolic_name, "%s\n",
		FC_VPORT_SYMBOLIC_NAMELEN + 1, )
fc_vport_store_str_function(symbolic_name, FC_VPORT_SYMBOLIC_NAMELEN)
static FC_DEVICE_ATTR(vport, symbolic_name, S_IRUGO | S_IWUSR,
		show_fc_vport_symbolic_name, store_fc_vport_symbolic_name);

static ssize_t
store_fc_vport_delete(struct device *dev, struct device_attribute *attr,
		      const char *buf, size_t count)
{
	struct fc_vport *vport = transport_class_to_vport(dev);
	struct Scsi_Host *shost = vport_to_shost(vport);
	unsigned long flags;

	spin_lock_irqsave(shost->host_lock, flags);
	if (vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING)) {
		spin_unlock_irqrestore(shost->host_lock, flags);
		return -EBUSY;
	}
	vport->flags |= FC_VPORT_DELETING;
	spin_unlock_irqrestore(shost->host_lock, flags);

	fc_queue_work(shost, &vport->vport_delete_work);
	return count;
}
static FC_DEVICE_ATTR(vport, vport_delete, S_IWUSR,
			NULL, store_fc_vport_delete);


/*
 * Enable/Disable vport
 *  Write "1" to disable, write "0" to enable
 */
static ssize_t
store_fc_vport_disable(struct device *dev, struct device_attribute *attr,
		       const char *buf,
			   size_t count)
{
	struct fc_vport *vport = transport_class_to_vport(dev);
	struct Scsi_Host *shost = vport_to_shost(vport);
	struct fc_internal *i = to_fc_internal(shost->transportt);
	int stat;

	if (vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING))
		return -EBUSY;

	if (*buf == '0') {
		if (vport->vport_state != FC_VPORT_DISABLED)
			return -EALREADY;
	} else if (*buf == '1') {
		if (vport->vport_state == FC_VPORT_DISABLED)
			return -EALREADY;
	} else
		return -EINVAL;

	stat = i->f->vport_disable(vport, ((*buf == '0') ? false : true));
	return stat ? stat : count;
}
static FC_DEVICE_ATTR(vport, vport_disable, S_IWUSR,
			NULL, store_fc_vport_disable);


/*
 * Host Attribute Management
 */

#define fc_host_show_function(field, format_string, sz, cast)		\
static ssize_t								\
show_fc_host_##field (struct device *dev,				\
		      struct device_attribute *attr, char *buf)		\
{									\
	struct Scsi_Host *shost = transport_class_to_shost(dev);	\
	struct fc_internal *i = to_fc_internal(shost->transportt);	\
	if (i->f->get_host_##field)					\
		i->f->get_host_##field(shost);				\
	return snprintf(buf, sz, format_string, cast fc_host_##field(shost)); \
}

#define fc_host_store_function(field)					\
static ssize_t								\
store_fc_host_##field(struct device *dev, 				\
		      struct device_attribute *attr,			\
		      const char *buf,	size_t count)			\
{									\
	int val;							\
	struct Scsi_Host *shost = transport_class_to_shost(dev);	\
	struct fc_internal *i = to_fc_internal(shost->transportt);	\
	char *cp;							\
									\
	val = simple_strtoul(buf, &cp, 0);				\
	if (*cp && (*cp != '\n'))					\
		return -EINVAL;						\
	i->f->set_host_##field(shost, val);				\
	return count;							\
}

#define fc_host_store_str_function(field, slen)				\
static ssize_t								\
store_fc_host_##field(struct device *dev,				\
		      struct device_attribute *attr,			\
		      const char *buf, size_t count)			\
{									\
	struct Scsi_Host *shost = transport_class_to_shost(dev);	\
	struct fc_internal *i = to_fc_internal(shost->transportt);	\
	unsigned int cnt=count;						\
									\
	/* count may include a LF at end of string */			\
	if (buf[cnt-1] == '\n')						\
		cnt--;							\
	if (cnt > ((slen) - 1))						\
		return -EINVAL;						\
	memcpy(fc_host_##field(shost), buf, cnt);			\
	i->f->set_host_##field(shost);					\
	return count;							\
}

#define fc_host_rd_attr(field, format_string, sz)			\
	fc_host_show_function(field, format_string, sz, )		\
static FC_DEVICE_ATTR(host, field, S_IRUGO,			\
			 show_fc_host_##field, NULL)

#define fc_host_rd_attr_cast(field, format_string, sz, cast)		\
	fc_host_show_function(field, format_string, sz, (cast))		\
static FC_DEVICE_ATTR(host, field, S_IRUGO,			\
			  show_fc_host_##field, NULL)

#define fc_host_rw_attr(field, format_string, sz)			\
	fc_host_show_function(field, format_string, sz, )		\
	fc_host_store_function(field)					\
static FC_DEVICE_ATTR(host, field, S_IRUGO | S_IWUSR,		\
			show_fc_host_##field,				\
			store_fc_host_##field)

#define fc_host_rd_enum_attr(title, maxlen)				\
static ssize_t								\
show_fc_host_##title (struct device *dev,				\
		      struct device_attribute *attr, char *buf)		\
{									\
	struct Scsi_Host *shost = transport_class_to_shost(dev);	\
	struct fc_internal *i = to_fc_internal(shost->transportt);	\
	const char *name;						\
	if (i->f->get_host_##title)					\
		i->f->get_host_##title(shost);				\
	name = get_fc_##title##_name(fc_host_##title(shost));		\
	if (!name)							\
		return -EINVAL;						\
	return snprintf(buf, maxlen, "%s\n", name);			\
}									\
static FC_DEVICE_ATTR(host, title, S_IRUGO, show_fc_host_##title, NULL)

#define SETUP_HOST_ATTRIBUTE_RD(field)					\
	i->private_host_attrs[count] = device_attr_host_##field;	\
	i->private_host_attrs[count].attr.mode = S_IRUGO;		\
	i->private_host_attrs[count].store = NULL;			\
	i->host_attrs[count] = &i->private_host_attrs[count];		\
	if (i->f->show_host_##field)					\
		count++

#define SETUP_HOST_ATTRIBUTE_RD_NS(field)				\
	i->private_host_attrs[count] = device_attr_host_##field;	\
	i->private_host_attrs[count].attr.mode = S_IRUGO;		\
	i->private_host_attrs[count].store = NULL;			\
	i->host_attrs[count] = &i->private_host_attrs[count];		\
	count++

#define SETUP_HOST_ATTRIBUTE_RW(field)					\
	i->private_host_attrs[count] = device_attr_host_##field;	\
	if (!i->f->set_host_##field) {					\
		i->private_host_attrs[count].attr.mode = S_IRUGO;	\
		i->private_host_attrs[count].store = NULL;		\
	}								\
	i->host_attrs[count] = &i->private_host_attrs[count];		\
	if (i->f->show_host_##field)					\
		count++


#define fc_private_host_show_function(field, format_string, sz, cast)	\
static ssize_t								\
show_fc_host_##field (struct device *dev,				\
		      struct device_attribute *attr, char *buf)		\
{									\
	struct Scsi_Host *shost = transport_class_to_shost(dev);	\
	return snprintf(buf, sz, format_string, cast fc_host_##field(shost)); \
}

#define fc_private_host_rd_attr(field, format_string, sz)		\
	fc_private_host_show_function(field, format_string, sz, )	\
static FC_DEVICE_ATTR(host, field, S_IRUGO,			\
			 show_fc_host_##field, NULL)

#define fc_private_host_rd_attr_cast(field, format_string, sz, cast)	\
	fc_private_host_show_function(field, format_string, sz, (cast)) \
static FC_DEVICE_ATTR(host, field, S_IRUGO,			\
			  show_fc_host_##field, NULL)

#define SETUP_PRIVATE_HOST_ATTRIBUTE_RD(field)			\
	i->private_host_attrs[count] = device_attr_host_##field;	\
	i->private_host_attrs[count].attr.mode = S_IRUGO;		\
	i->private_host_attrs[count].store = NULL;			\
	i->host_attrs[count] = &i->private_host_attrs[count];		\
	count++

#define SETUP_PRIVATE_HOST_ATTRIBUTE_RW(field)			\
{									\
	i->private_host_attrs[count] = device_attr_host_##field;	\
	i->host_attrs[count] = &i->private_host_attrs[count];		\
	count++;							\
}


/* Fixed Host Attributes */

static ssize_t
show_fc_host_supported_classes (struct device *dev,
			        struct device_attribute *attr, char *buf)
{
	struct Scsi_Host *shost = transport_class_to_shost(dev);

	if (fc_host_supported_classes(shost) == FC_COS_UNSPECIFIED)
		return snprintf(buf, 20, "unspecified\n");

	return get_fc_cos_names(fc_host_supported_classes(shost), buf);
}
static FC_DEVICE_ATTR(host, supported_classes, S_IRUGO,
		show_fc_host_supported_classes, NULL);

static ssize_t
show_fc_host_supported_fc4s (struct device *dev,
			     struct device_attribute *attr, char *buf)
{
	struct Scsi_Host *shost = transport_class_to_shost(dev);
	return (ssize_t)show_fc_fc4s(buf, fc_host_supported_fc4s(shost));
}
static FC_DEVICE_ATTR(host, supported_fc4s, S_IRUGO,
		show_fc_host_supported_fc4s, NULL);

static ssize_t
show_fc_host_supported_speeds (struct device *dev,
			       struct device_attribute *attr, char *buf)
{
	struct Scsi_Host *shost = transport_class_to_shost(dev);

	if (fc_host_supported_speeds(shost) == FC_PORTSPEED_UNKNOWN)
		return snprintf(buf, 20, "unknown\n");

	return get_fc_port_speed_names(fc_host_supported_speeds(shost), buf);
}
static FC_DEVICE_ATTR(host, supported_speeds, S_IRUGO,
		show_fc_host_supported_speeds, NULL);


fc_private_host_rd_attr_cast(node_name, "0x%llx\n", 20, unsigned long long);
fc_private_host_rd_attr_cast(port_name, "0x%llx\n", 20, unsigned long long);
fc_private_host_rd_attr_cast(permanent_port_name, "0x%llx\n", 20,
			     unsigned long long);
fc_private_host_rd_attr(maxframe_size, "%u bytes\n", 20);
fc_private_host_rd_attr(max_npiv_vports, "%u\n", 20);
fc_private_host_rd_attr(serial_number, "%s\n", (FC_SERIAL_NUMBER_SIZE +1));
fc_private_host_rd_attr(manufacturer, "%s\n", FC_SERIAL_NUMBER_SIZE + 1);
fc_private_host_rd_attr(model, "%s\n", FC_SYMBOLIC_NAME_SIZE + 1);
fc_private_host_rd_attr(model_description, "%s\n", FC_SYMBOLIC_NAME_SIZE + 1);
fc_private_host_rd_attr(hardware_version, "%s\n", FC_VERSION_STRING_SIZE + 1);
fc_private_host_rd_attr(driver_version, "%s\n", FC_VERSION_STRING_SIZE + 1);
fc_private_host_rd_attr(firmware_version, "%s\n", FC_VERSION_STRING_SIZE + 1);
fc_private_host_rd_attr(optionrom_version, "%s\n", FC_VERSION_STRING_SIZE + 1);


/* Dynamic Host Attributes */

static ssize_t
show_fc_host_active_fc4s (struct device *dev,
			  struct device_attribute *attr, char *buf)
{
	struct Scsi_Host *shost = transport_class_to_shost(dev);
	struct fc_internal *i = to_fc_internal(shost->transportt);

	if (i->f->get_host_active_fc4s)
		i->f->get_host_active_fc4s(shost);

	return (ssize_t)show_fc_fc4s(buf, fc_host_active_fc4s(shost));
}
static FC_DEVICE_ATTR(host, active_fc4s, S_IRUGO,
		show_fc_host_active_fc4s, NULL);

static ssize_t
show_fc_host_speed (struct device *dev,
		    struct device_attribute *attr, char *buf)
{
	struct Scsi_Host *shost = transport_class_to_shost(dev);
	struct fc_internal *i = to_fc_internal(shost->transportt);

	if (i->f->get_host_speed)
		i->f->get_host_speed(shost);

	if (fc_host_speed(shost) == FC_PORTSPEED_UNKNOWN)
		return snprintf(buf, 20, "unknown\n");

	return get_fc_port_speed_names(fc_host_speed(shost), buf);
}
static FC_DEVICE_ATTR(host, speed, S_IRUGO,
		show_fc_host_speed, NULL);


fc_host_rd_attr(port_id, "0x%06x\n", 20);
fc_host_rd_enum_attr(port_type, FC_PORTTYPE_MAX_NAMELEN);
fc_host_rd_enum_attr(port_state, FC_PORTSTATE_MAX_NAMELEN);
fc_host_rd_attr_cast(fabric_name, "0x%llx\n", 20, unsigned long long);
fc_host_rd_attr(symbolic_name, "%s\n", FC_SYMBOLIC_NAME_SIZE + 1);

fc_private_host_show_function(system_hostname, "%s\n",
		FC_SYMBOLIC_NAME_SIZE + 1, )
fc_host_store_str_function(system_hostname, FC_SYMBOLIC_NAME_SIZE)
static FC_DEVICE_ATTR(host, system_hostname, S_IRUGO | S_IWUSR,
		show_fc_host_system_hostname, store_fc_host_system_hostname);


/* Private Host Attributes */

static ssize_t
show_fc_private_host_tgtid_bind_type(struct device *dev,
				     struct device_attribute *attr, char *buf)
{
	struct Scsi_Host *shost = transport_class_to_shost(dev);
	const char *name;

	name = get_fc_tgtid_bind_type_name(fc_host_tgtid_bind_type(shost));
	if (!name)
		return -EINVAL;
	return snprintf(buf, FC_BINDTYPE_MAX_NAMELEN, "%s\n", name);
}

#define get_list_head_entry(pos, head, member) 		\
	pos = list_entry((head)->next, typeof(*pos), member)

static ssize_t
store_fc_private_host_tgtid_bind_type(struct device *dev,
	struct device_attribute *attr, const char *buf, size_t count)
{
	struct Scsi_Host *shost = transport_class_to_shost(dev);
	struct fc_rport *rport;
 	enum fc_tgtid_binding_type val;
	unsigned long flags;

	if (get_fc_tgtid_bind_type_match(buf, &val))
		return -EINVAL;

	/* if changing bind type, purge all unused consistent bindings */
	if (val != fc_host_tgtid_bind_type(shost)) {
		spin_lock_irqsave(shost->host_lock, flags);
		while (!list_empty(&fc_host_rport_bindings(shost))) {
			get_list_head_entry(rport,
				&fc_host_rport_bindings(shost), peers);
			list_del(&rport->peers);
			rport->port_state = FC_PORTSTATE_DELETED;
			fc_queue_work(shost, &rport->rport_delete_work);
		}
		spin_unlock_irqrestore(shost->host_lock, flags);
	}

	fc_host_tgtid_bind_type(shost) = val;
	return count;
}

static FC_DEVICE_ATTR(host, tgtid_bind_type, S_IRUGO | S_IWUSR,
			show_fc_private_host_tgtid_bind_type,
			store_fc_private_host_tgtid_bind_type);

static ssize_t
store_fc_private_host_issue_lip(struct device *dev,
	struct device_attribute *attr, const char *buf, size_t count)
{
	struct Scsi_Host *shost = transport_class_to_shost(dev);
	struct fc_internal *i = to_fc_internal(shost->transportt);
	int ret;

	/* ignore any data value written to the attribute */
	if (i->f->issue_fc_host_lip) {
		ret = i->f->issue_fc_host_lip(shost);
		return ret ? ret: count;
	}

	return -ENOENT;
}

static FC_DEVICE_ATTR(host, issue_lip, S_IWUSR, NULL,
			store_fc_private_host_issue_lip);

static ssize_t
store_fc_private_host_dev_loss_tmo(struct device *dev,
				   struct device_attribute *attr,
				   const char *buf, size_t count)
{
	struct Scsi_Host *shost = transport_class_to_shost(dev);
	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
	struct fc_rport *rport;
	unsigned long val, flags;
	int rc;

	rc = fc_str_to_dev_loss(buf, &val);
	if (rc)
		return rc;

	fc_host_dev_loss_tmo(shost) = val;
	spin_lock_irqsave(shost->host_lock, flags);
	list_for_each_entry(rport, &fc_host->rports, peers)
		fc_rport_set_dev_loss_tmo(rport, val);
	spin_unlock_irqrestore(shost->host_lock, flags);
	return count;
}

fc_private_host_show_function(dev_loss_tmo, "%d\n", 20, );
static FC_DEVICE_ATTR(host, dev_loss_tmo, S_IRUGO | S_IWUSR,
		      show_fc_host_dev_loss_tmo,
		      store_fc_private_host_dev_loss_tmo);

fc_private_host_rd_attr(npiv_vports_inuse, "%u\n", 20);

/*
 * Host Statistics Management
 */

/* Show a given an attribute in the statistics group */
static ssize_t
fc_stat_show(const struct device *dev, char *buf, unsigned long offset)
{
	struct Scsi_Host *shost = transport_class_to_shost(dev);
	struct fc_internal *i = to_fc_internal(shost->transportt);
	struct fc_host_statistics *stats;
	ssize_t ret = -ENOENT;

	if (offset > sizeof(struct fc_host_statistics) ||
	    offset % sizeof(u64) != 0)
		WARN_ON(1);

	if (i->f->get_fc_host_stats) {
		stats = (i->f->get_fc_host_stats)(shost);
		if (stats)
			ret = snprintf(buf, 20, "0x%llx\n",
			      (unsigned long long)*(u64 *)(((u8 *) stats) + offset));
	}
	return ret;
}


/* generate a read-only statistics attribute */
#define fc_host_statistic(name)						\
static ssize_t show_fcstat_##name(struct device *cd,			\
				  struct device_attribute *attr,	\
				  char *buf)				\
{									\
	return fc_stat_show(cd, buf, 					\
			    offsetof(struct fc_host_statistics, name));	\
}									\
static FC_DEVICE_ATTR(host, name, S_IRUGO, show_fcstat_##name, NULL)

fc_host_statistic(seconds_since_last_reset);
fc_host_statistic(tx_frames);
fc_host_statistic(tx_words);
fc_host_statistic(rx_frames);
fc_host_statistic(rx_words);
fc_host_statistic(lip_count);
fc_host_statistic(nos_count);
fc_host_statistic(error_frames);
fc_host_statistic(dumped_frames);
fc_host_statistic(link_failure_count);
fc_host_statistic(loss_of_sync_count);
fc_host_statistic(loss_of_signal_count);
fc_host_statistic(prim_seq_protocol_err_count);
fc_host_statistic(invalid_tx_word_count);
fc_host_statistic(invalid_crc_count);
fc_host_statistic(fcp_input_requests);
fc_host_statistic(fcp_output_requests);
fc_host_statistic(fcp_control_requests);
fc_host_statistic(fcp_input_megabytes);
fc_host_statistic(fcp_output_megabytes);

static ssize_t
fc_reset_statistics(struct device *dev, struct device_attribute *attr,
		    const char *buf, size_t count)
{
	struct Scsi_Host *shost = transport_class_to_shost(dev);
	struct fc_internal *i = to_fc_internal(shost->transportt);

	/* ignore any data value written to the attribute */
	if (i->f->reset_fc_host_stats) {
		i->f->reset_fc_host_stats(shost);
		return count;
	}

	return -ENOENT;
}
static FC_DEVICE_ATTR(host, reset_statistics, S_IWUSR, NULL,
				fc_reset_statistics);

static struct attribute *fc_statistics_attrs[] = {
	&device_attr_host_seconds_since_last_reset.attr,
	&device_attr_host_tx_frames.attr,
	&device_attr_host_tx_words.attr,
	&device_attr_host_rx_frames.attr,
	&device_attr_host_rx_words.attr,
	&device_attr_host_lip_count.attr,
	&device_attr_host_nos_count.attr,
	&device_attr_host_error_frames.attr,
	&device_attr_host_dumped_frames.attr,
	&device_attr_host_link_failure_count.attr,
	&device_attr_host_loss_of_sync_count.attr,
	&device_attr_host_loss_of_signal_count.attr,
	&device_attr_host_prim_seq_protocol_err_count.attr,
	&device_attr_host_invalid_tx_word_count.attr,
	&device_attr_host_invalid_crc_count.attr,
	&device_attr_host_fcp_input_requests.attr,
	&device_attr_host_fcp_output_requests.attr,
	&device_attr_host_fcp_control_requests.attr,
	&device_attr_host_fcp_input_megabytes.attr,
	&device_attr_host_fcp_output_megabytes.attr,
	&device_attr_host_reset_statistics.attr,
	NULL
};

static struct attribute_group fc_statistics_group = {
	.name = "statistics",
	.attrs = fc_statistics_attrs,
};


/* Host Vport Attributes */

static int
fc_parse_wwn(const char *ns, u64 *nm)
{
	unsigned int i, j;
	u8 wwn[8];

	memset(wwn, 0, sizeof(wwn));

	/* Validate and store the new name */
	for (i=0, j=0; i < 16; i++) {
		int value;

		value = hex_to_bin(*ns++);
		if (value >= 0)
			j = (j << 4) | value;
		else
			return -EINVAL;
		if (i % 2) {
			wwn[i/2] = j & 0xff;
			j = 0;
		}
	}

	*nm = wwn_to_u64(wwn);

	return 0;
}


/*
 * "Short-cut" sysfs variable to create a new vport on a FC Host.
 * Input is a string of the form "<WWPN>:<WWNN>". Other attributes
 * will default to a NPIV-based FCP_Initiator; The WWNs are specified
 * as hex characters, and may *not* contain any prefixes (e.g. 0x, x, etc)
 */
static ssize_t
store_fc_host_vport_create(struct device *dev, struct device_attribute *attr,
			   const char *buf, size_t count)
{
	struct Scsi_Host *shost = transport_class_to_shost(dev);
	struct fc_vport_identifiers vid;
	struct fc_vport *vport;
	unsigned int cnt=count;
	int stat;

	memset(&vid, 0, sizeof(vid));

	/* count may include a LF at end of string */
	if (buf[cnt-1] == '\n')
		cnt--;

	/* validate we have enough characters for WWPN */
	if ((cnt != (16+1+16)) || (buf[16] != ':'))
		return -EINVAL;

	stat = fc_parse_wwn(&buf[0], &vid.port_name);
	if (stat)
		return stat;

	stat = fc_parse_wwn(&buf[17], &vid.node_name);
	if (stat)
		return stat;

	vid.roles = FC_PORT_ROLE_FCP_INITIATOR;
	vid.vport_type = FC_PORTTYPE_NPIV;
	/* vid.symbolic_name is already zero/NULL's */
	vid.disable = false;		/* always enabled */

	/* we only allow support on Channel 0 !!! */
	stat = fc_vport_setup(shost, 0, &shost->shost_gendev, &vid, &vport);
	return stat ? stat : count;
}
static FC_DEVICE_ATTR(host, vport_create, S_IWUSR, NULL,
			store_fc_host_vport_create);


/*
 * "Short-cut" sysfs variable to delete a vport on a FC Host.
 * Vport is identified by a string containing "<WWPN>:<WWNN>".
 * The WWNs are specified as hex characters, and may *not* contain
 * any prefixes (e.g. 0x, x, etc)
 */
static ssize_t
store_fc_host_vport_delete(struct device *dev, struct device_attribute *attr,
			   const char *buf, size_t count)
{
	struct Scsi_Host *shost = transport_class_to_shost(dev);
	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
	struct fc_vport *vport;
	u64 wwpn, wwnn;
	unsigned long flags;
	unsigned int cnt=count;
	int stat, match;

	/* count may include a LF at end of string */
	if (buf[cnt-1] == '\n')
		cnt--;

	/* validate we have enough characters for WWPN */
	if ((cnt != (16+1+16)) || (buf[16] != ':'))
		return -EINVAL;

	stat = fc_parse_wwn(&buf[0], &wwpn);
	if (stat)
		return stat;

	stat = fc_parse_wwn(&buf[17], &wwnn);
	if (stat)
		return stat;

	spin_lock_irqsave(shost->host_lock, flags);
	match = 0;
	/* we only allow support on Channel 0 !!! */
	list_for_each_entry(vport, &fc_host->vports, peers) {
		if ((vport->channel == 0) &&
		    (vport->port_name == wwpn) && (vport->node_name == wwnn)) {
			if (vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING))
				break;
			vport->flags |= FC_VPORT_DELETING;
			match = 1;
			break;
		}
	}
	spin_unlock_irqrestore(shost->host_lock, flags);

	if (!match)
		return -ENODEV;

	stat = fc_vport_terminate(vport);
	return stat ? stat : count;
}
static FC_DEVICE_ATTR(host, vport_delete, S_IWUSR, NULL,
			store_fc_host_vport_delete);


static int fc_host_match(struct attribute_container *cont,
			  struct device *dev)
{
	struct Scsi_Host *shost;
	struct fc_internal *i;

	if (!scsi_is_host_device(dev))
		return 0;

	shost = dev_to_shost(dev);
	if (!shost->transportt  || shost->transportt->host_attrs.ac.class
	    != &fc_host_class.class)
		return 0;

	i = to_fc_internal(shost->transportt);

	return &i->t.host_attrs.ac == cont;
}

static int fc_target_match(struct attribute_container *cont,
			    struct device *dev)
{
	struct Scsi_Host *shost;
	struct fc_internal *i;

	if (!scsi_is_target_device(dev))
		return 0;

	shost = dev_to_shost(dev->parent);
	if (!shost->transportt  || shost->transportt->host_attrs.ac.class
	    != &fc_host_class.class)
		return 0;

	i = to_fc_internal(shost->transportt);

	return &i->t.target_attrs.ac == cont;
}

static void fc_rport_dev_release(struct device *dev)
{
	struct fc_rport *rport = dev_to_rport(dev);
	put_device(dev->parent);
	kfree(rport);
}

int scsi_is_fc_rport(const struct device *dev)
{
	return dev->release == fc_rport_dev_release;
}
EXPORT_SYMBOL(scsi_is_fc_rport);

static int fc_rport_match(struct attribute_container *cont,
			    struct device *dev)
{
	struct Scsi_Host *shost;
	struct fc_internal *i;

	if (!scsi_is_fc_rport(dev))
		return 0;

	shost = dev_to_shost(dev->parent);
	if (!shost->transportt  || shost->transportt->host_attrs.ac.class
	    != &fc_host_class.class)
		return 0;

	i = to_fc_internal(shost->transportt);

	return &i->rport_attr_cont.ac == cont;
}


static void fc_vport_dev_release(struct device *dev)
{
	struct fc_vport *vport = dev_to_vport(dev);
	put_device(dev->parent);		/* release kobj parent */
	kfree(vport);
}

int scsi_is_fc_vport(const struct device *dev)
{
	return dev->release == fc_vport_dev_release;
}
EXPORT_SYMBOL(scsi_is_fc_vport);

static int fc_vport_match(struct attribute_container *cont,
			    struct device *dev)
{
	struct fc_vport *vport;
	struct Scsi_Host *shost;
	struct fc_internal *i;

	if (!scsi_is_fc_vport(dev))
		return 0;
	vport = dev_to_vport(dev);

	shost = vport_to_shost(vport);
	if (!shost->transportt  || shost->transportt->host_attrs.ac.class
	    != &fc_host_class.class)
		return 0;

	i = to_fc_internal(shost->transportt);
	return &i->vport_attr_cont.ac == cont;
}


/**
 * fc_timed_out - FC Transport I/O timeout intercept handler
 * @scmd:	The SCSI command which timed out
 *
 * This routine protects against error handlers getting invoked while a
 * rport is in a blocked state, typically due to a temporarily loss of
 * connectivity. If the error handlers are allowed to proceed, requests
 * to abort i/o, reset the target, etc will likely fail as there is no way
 * to communicate with the device to perform the requested function. These
 * failures may result in the midlayer taking the device offline, requiring
 * manual intervention to restore operation.
 *
 * This routine, called whenever an i/o times out, validates the state of
 * the underlying rport. If the rport is blocked, it returns
 * EH_RESET_TIMER, which will continue to reschedule the timeout.
 * Eventually, either the device will return, or devloss_tmo will fire,
 * and when the timeout then fires, it will be handled normally.
 * If the rport is not blocked, normal error handling continues.
 *
 * Notes:
 *	This routine assumes no locks are held on entry.
 */
static enum blk_eh_timer_return
fc_timed_out(struct scsi_cmnd *scmd)
{
	struct fc_rport *rport = starget_to_rport(scsi_target(scmd->device));

	if (rport->port_state == FC_PORTSTATE_BLOCKED)
		return BLK_EH_RESET_TIMER;

	return BLK_EH_NOT_HANDLED;
}

/*
 * Called by fc_user_scan to locate an rport on the shost that
 * matches the channel and target id, and invoke scsi_scan_target()
 * on the rport.
 */
static void
fc_user_scan_tgt(struct Scsi_Host *shost, uint channel, uint id, uint lun)
{
	struct fc_rport *rport;
	unsigned long flags;

	spin_lock_irqsave(shost->host_lock, flags);

	list_for_each_entry(rport, &fc_host_rports(shost), peers) {
		if (rport->scsi_target_id == -1)
			continue;

		if (rport->port_state != FC_PORTSTATE_ONLINE)
			continue;

		if ((channel == rport->channel) &&
		    (id == rport->scsi_target_id)) {
			spin_unlock_irqrestore(shost->host_lock, flags);
			scsi_scan_target(&rport->dev, channel, id, lun, 1);
			return;
		}
	}

	spin_unlock_irqrestore(shost->host_lock, flags);
}

/*
 * Called via sysfs scan routines. Necessary, as the FC transport
 * wants to place all target objects below the rport object. So this
 * routine must invoke the scsi_scan_target() routine with the rport
 * object as the parent.
 */
static int
fc_user_scan(struct Scsi_Host *shost, uint channel, uint id, uint lun)
{
	uint chlo, chhi;
	uint tgtlo, tgthi;

	if (((channel != SCAN_WILD_CARD) && (channel > shost->max_channel)) ||
	    ((id != SCAN_WILD_CARD) && (id >= shost->max_id)) ||
	    ((lun != SCAN_WILD_CARD) && (lun > shost->max_lun)))
		return -EINVAL;

	if (channel == SCAN_WILD_CARD) {
		chlo = 0;
		chhi = shost->max_channel + 1;
	} else {
		chlo = channel;
		chhi = channel + 1;
	}

	if (id == SCAN_WILD_CARD) {
		tgtlo = 0;
		tgthi = shost->max_id;
	} else {
		tgtlo = id;
		tgthi = id + 1;
	}

	for ( ; chlo < chhi; chlo++)
		for ( ; tgtlo < tgthi; tgtlo++)
			fc_user_scan_tgt(shost, chlo, tgtlo, lun);

	return 0;
}

static int fc_tsk_mgmt_response(struct Scsi_Host *shost, u64 nexus, u64 tm_id,
				int result)
{
	struct fc_internal *i = to_fc_internal(shost->transportt);
	return i->f->tsk_mgmt_response(shost, nexus, tm_id, result);
}

static int fc_it_nexus_response(struct Scsi_Host *shost, u64 nexus, int result)
{
	struct fc_internal *i = to_fc_internal(shost->transportt);
	return i->f->it_nexus_response(shost, nexus, result);
}

struct scsi_transport_template *
fc_attach_transport(struct fc_function_template *ft)
{
	int count;
	struct fc_internal *i = kzalloc(sizeof(struct fc_internal),
					GFP_KERNEL);

	if (unlikely(!i))
		return NULL;

	i->t.target_attrs.ac.attrs = &i->starget_attrs[0];
	i->t.target_attrs.ac.class = &fc_transport_class.class;
	i->t.target_attrs.ac.match = fc_target_match;
	i->t.target_size = sizeof(struct fc_starget_attrs);
	transport_container_register(&i->t.target_attrs);

	i->t.host_attrs.ac.attrs = &i->host_attrs[0];
	i->t.host_attrs.ac.class = &fc_host_class.class;
	i->t.host_attrs.ac.match = fc_host_match;
	i->t.host_size = sizeof(struct fc_host_attrs);
	if (ft->get_fc_host_stats)
		i->t.host_attrs.statistics = &fc_statistics_group;
	transport_container_register(&i->t.host_attrs);

	i->rport_attr_cont.ac.attrs = &i->rport_attrs[0];
	i->rport_attr_cont.ac.class = &fc_rport_class.class;
	i->rport_attr_cont.ac.match = fc_rport_match;
	transport_container_register(&i->rport_attr_cont);

	i->vport_attr_cont.ac.attrs = &i->vport_attrs[0];
	i->vport_attr_cont.ac.class = &fc_vport_class.class;
	i->vport_attr_cont.ac.match = fc_vport_match;
	transport_container_register(&i->vport_attr_cont);

	i->f = ft;

	/* Transport uses the shost workq for scsi scanning */
	i->t.create_work_queue = 1;

	i->t.eh_timed_out = fc_timed_out;

	i->t.user_scan = fc_user_scan;

	/* target-mode drivers' functions */
	i->t.tsk_mgmt_response = fc_tsk_mgmt_response;
	i->t.it_nexus_response = fc_it_nexus_response;

	/*
	 * Setup SCSI Target Attributes.
	 */
	count = 0;
	SETUP_STARGET_ATTRIBUTE_RD(node_name);
	SETUP_STARGET_ATTRIBUTE_RD(port_name);
	SETUP_STARGET_ATTRIBUTE_RD(port_id);

	BUG_ON(count > FC_STARGET_NUM_ATTRS);

	i->starget_attrs[count] = NULL;


	/*
	 * Setup SCSI Host Attributes.
	 */
	count=0;
	SETUP_HOST_ATTRIBUTE_RD(node_name);
	SETUP_HOST_ATTRIBUTE_RD(port_name);
	SETUP_HOST_ATTRIBUTE_RD(permanent_port_name);
	SETUP_HOST_ATTRIBUTE_RD(supported_classes);
	SETUP_HOST_ATTRIBUTE_RD(supported_fc4s);
	SETUP_HOST_ATTRIBUTE_RD(supported_speeds);
	SETUP_HOST_ATTRIBUTE_RD(maxframe_size);
	if (ft->vport_create) {
		SETUP_HOST_ATTRIBUTE_RD_NS(max_npiv_vports);
		SETUP_HOST_ATTRIBUTE_RD_NS(npiv_vports_inuse);
	}
	SETUP_HOST_ATTRIBUTE_RD(serial_number);
	SETUP_HOST_ATTRIBUTE_RD(manufacturer);
	SETUP_HOST_ATTRIBUTE_RD(model);
	SETUP_HOST_ATTRIBUTE_RD(model_description);
	SETUP_HOST_ATTRIBUTE_RD(hardware_version);
	SETUP_HOST_ATTRIBUTE_RD(driver_version);
	SETUP_HOST_ATTRIBUTE_RD(firmware_version);
	SETUP_HOST_ATTRIBUTE_RD(optionrom_version);

	SETUP_HOST_ATTRIBUTE_RD(port_id);
	SETUP_HOST_ATTRIBUTE_RD(port_type);
	SETUP_HOST_ATTRIBUTE_RD(port_state);
	SETUP_HOST_ATTRIBUTE_RD(active_fc4s);
	SETUP_HOST_ATTRIBUTE_RD(speed);
	SETUP_HOST_ATTRIBUTE_RD(fabric_name);
	SETUP_HOST_ATTRIBUTE_RD(symbolic_name);
	SETUP_HOST_ATTRIBUTE_RW(system_hostname);

	/* Transport-managed attributes */
	SETUP_PRIVATE_HOST_ATTRIBUTE_RW(dev_loss_tmo);
	SETUP_PRIVATE_HOST_ATTRIBUTE_RW(tgtid_bind_type);
	if (ft->issue_fc_host_lip)
		SETUP_PRIVATE_HOST_ATTRIBUTE_RW(issue_lip);
	if (ft->vport_create)
		SETUP_PRIVATE_HOST_ATTRIBUTE_RW(vport_create);
	if (ft->vport_delete)
		SETUP_PRIVATE_HOST_ATTRIBUTE_RW(vport_delete);

	BUG_ON(count > FC_HOST_NUM_ATTRS);

	i->host_attrs[count] = NULL;

	/*
	 * Setup Remote Port Attributes.
	 */
	count=0;
	SETUP_RPORT_ATTRIBUTE_RD(maxframe_size);
	SETUP_RPORT_ATTRIBUTE_RD(supported_classes);
	SETUP_RPORT_ATTRIBUTE_RW(dev_loss_tmo);
	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(node_name);
	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_name);
	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_id);
	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(roles);
	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_state);
	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(scsi_target_id);
	SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(fast_io_fail_tmo);

	BUG_ON(count > FC_RPORT_NUM_ATTRS);

	i->rport_attrs[count] = NULL;

	/*
	 * Setup Virtual Port Attributes.
	 */
	count=0;
	SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(vport_state);
	SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(vport_last_state);
	SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(node_name);
	SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(port_name);
	SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(roles);
	SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(vport_type);
	SETUP_VPORT_ATTRIBUTE_RW(symbolic_name);
	SETUP_VPORT_ATTRIBUTE_WR(vport_delete);
	SETUP_VPORT_ATTRIBUTE_WR(vport_disable);

	BUG_ON(count > FC_VPORT_NUM_ATTRS);

	i->vport_attrs[count] = NULL;

	return &i->t;
}
EXPORT_SYMBOL(fc_attach_transport);

void fc_release_transport(struct scsi_transport_template *t)
{
	struct fc_internal *i = to_fc_internal(t);

	transport_container_unregister(&i->t.target_attrs);
	transport_container_unregister(&i->t.host_attrs);
	transport_container_unregister(&i->rport_attr_cont);
	transport_container_unregister(&i->vport_attr_cont);

	kfree(i);
}
EXPORT_SYMBOL(fc_release_transport);

/**
 * fc_queue_work - Queue work to the fc_host workqueue.
 * @shost:	Pointer to Scsi_Host bound to fc_host.
 * @work:	Work to queue for execution.
 *
 * Return value:
 * 	1 - work queued for execution
 *	0 - work is already queued
 *	-EINVAL - work queue doesn't exist
 */
static int
fc_queue_work(struct Scsi_Host *shost, struct work_struct *work)
{
	if (unlikely(!fc_host_work_q(shost))) {
		printk(KERN_ERR
			"ERROR: FC host '%s' attempted to queue work, "
			"when no workqueue created.\n", shost->hostt->name);
		dump_stack();

		return -EINVAL;
	}

	return queue_work(fc_host_work_q(shost), work);
}

/**
 * fc_flush_work - Flush a fc_host's workqueue.
 * @shost:	Pointer to Scsi_Host bound to fc_host.
 */
static void
fc_flush_work(struct Scsi_Host *shost)
{
	if (!fc_host_work_q(shost)) {
		printk(KERN_ERR
			"ERROR: FC host '%s' attempted to flush work, "
			"when no workqueue created.\n", shost->hostt->name);
		dump_stack();
		return;
	}

	flush_workqueue(fc_host_work_q(shost));
}

/**
 * fc_queue_devloss_work - Schedule work for the fc_host devloss workqueue.
 * @shost:	Pointer to Scsi_Host bound to fc_host.
 * @work:	Work to queue for execution.
 * @delay:	jiffies to delay the work queuing
 *
 * Return value:
 * 	1 on success / 0 already queued / < 0 for error
 */
static int
fc_queue_devloss_work(struct Scsi_Host *shost, struct delayed_work *work,
				unsigned long delay)
{
	if (unlikely(!fc_host_devloss_work_q(shost))) {
		printk(KERN_ERR
			"ERROR: FC host '%s' attempted to queue work, "
			"when no workqueue created.\n", shost->hostt->name);
		dump_stack();

		return -EINVAL;
	}

	return queue_delayed_work(fc_host_devloss_work_q(shost), work, delay);
}

/**
 * fc_flush_devloss - Flush a fc_host's devloss workqueue.
 * @shost:	Pointer to Scsi_Host bound to fc_host.
 */
static void
fc_flush_devloss(struct Scsi_Host *shost)
{
	if (!fc_host_devloss_work_q(shost)) {
		printk(KERN_ERR
			"ERROR: FC host '%s' attempted to flush work, "
			"when no workqueue created.\n", shost->hostt->name);
		dump_stack();
		return;
	}

	flush_workqueue(fc_host_devloss_work_q(shost));
}


/**
 * fc_remove_host - called to terminate any fc_transport-related elements for a scsi host.
 * @shost:	Which &Scsi_Host
 *
 * This routine is expected to be called immediately preceding the
 * a driver's call to scsi_remove_host().
 *
 * WARNING: A driver utilizing the fc_transport, which fails to call
 *   this routine prior to scsi_remove_host(), will leave dangling
 *   objects in /sys/class/fc_remote_ports. Access to any of these
 *   objects can result in a system crash !!!
 *
 * Notes:
 *	This routine assumes no locks are held on entry.
 */
void
fc_remove_host(struct Scsi_Host *shost)
{
	struct fc_vport *vport = NULL, *next_vport = NULL;
	struct fc_rport *rport = NULL, *next_rport = NULL;
	struct workqueue_struct *work_q;
	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
	unsigned long flags;

	spin_lock_irqsave(shost->host_lock, flags);

	/* Remove any vports */
	list_for_each_entry_safe(vport, next_vport, &fc_host->vports, peers)
		fc_queue_work(shost, &vport->vport_delete_work);

	/* Remove any remote ports */
	list_for_each_entry_safe(rport, next_rport,
			&fc_host->rports, peers) {
		list_del(&rport->peers);
		rport->port_state = FC_PORTSTATE_DELETED;
		fc_queue_work(shost, &rport->rport_delete_work);
	}

	list_for_each_entry_safe(rport, next_rport,
			&fc_host->rport_bindings, peers) {
		list_del(&rport->peers);
		rport->port_state = FC_PORTSTATE_DELETED;
		fc_queue_work(shost, &rport->rport_delete_work);
	}

	spin_unlock_irqrestore(shost->host_lock, flags);

	/* flush all scan work items */
	scsi_flush_work(shost);

	/* flush all stgt delete, and rport delete work items, then kill it  */
	if (fc_host->work_q) {
		work_q = fc_host->work_q;
		fc_host->work_q = NULL;
		destroy_workqueue(work_q);
	}

	/* flush all devloss work items, then kill it  */
	if (fc_host->devloss_work_q) {
		work_q = fc_host->devloss_work_q;
		fc_host->devloss_work_q = NULL;
		destroy_workqueue(work_q);
	}
}
EXPORT_SYMBOL(fc_remove_host);

static void fc_terminate_rport_io(struct fc_rport *rport)
{
	struct Scsi_Host *shost = rport_to_shost(rport);
	struct fc_internal *i = to_fc_internal(shost->transportt);

	/* Involve the LLDD if possible to terminate all io on the rport. */
	if (i->f->terminate_rport_io)
		i->f->terminate_rport_io(rport);

	/*
	 * must unblock to flush queued IO. The caller will have set
	 * the port_state or flags, so that fc_remote_port_chkready will
	 * fail IO.
	 */
	scsi_target_unblock(&rport->dev);
}

/**
 * fc_starget_delete - called to delete the scsi descendants of an rport
 * @work:	remote port to be operated on.
 *
 * Deletes target and all sdevs.
 */
static void
fc_starget_delete(struct work_struct *work)
{
	struct fc_rport *rport =
		container_of(work, struct fc_rport, stgt_delete_work);

	fc_terminate_rport_io(rport);
	scsi_remove_target(&rport->dev);
}


/**
 * fc_rport_final_delete - finish rport termination and delete it.
 * @work:	remote port to be deleted.
 */
static void
fc_rport_final_delete(struct work_struct *work)
{
	struct fc_rport *rport =
		container_of(work, struct fc_rport, rport_delete_work);
	struct device *dev = &rport->dev;
	struct Scsi_Host *shost = rport_to_shost(rport);
	struct fc_internal *i = to_fc_internal(shost->transportt);
	unsigned long flags;
	int do_callback = 0;

	fc_terminate_rport_io(rport);

	/*
	 * if a scan is pending, flush the SCSI Host work_q so that
	 * that we can reclaim the rport scan work element.
	 */
	if (rport->flags & FC_RPORT_SCAN_PENDING)
		scsi_flush_work(shost);

	/*
	 * Cancel any outstanding timers. These should really exist
	 * only when rmmod'ing the LLDD and we're asking for
	 * immediate termination of the rports
	 */
	spin_lock_irqsave(shost->host_lock, flags);
	if (rport->flags & FC_RPORT_DEVLOSS_PENDING) {
		spin_unlock_irqrestore(shost->host_lock, flags);
		if (!cancel_delayed_work(&rport->fail_io_work))
			fc_flush_devloss(shost);
		if (!cancel_delayed_work(&rport->dev_loss_work))
			fc_flush_devloss(shost);
		spin_lock_irqsave(shost->host_lock, flags);
		rport->flags &= ~FC_RPORT_DEVLOSS_PENDING;
	}
	spin_unlock_irqrestore(shost->host_lock, flags);

	/* Delete SCSI target and sdevs */
	if (rport->scsi_target_id != -1)
		fc_starget_delete(&rport->stgt_delete_work);

	/*
	 * Notify the driver that the rport is now dead. The LLDD will
	 * also guarantee that any communication to the rport is terminated
	 *
	 * Avoid this call if we already called it when we preserved the
	 * rport for the binding.
	 */
	spin_lock_irqsave(shost->host_lock, flags);
	if (!(rport->flags & FC_RPORT_DEVLOSS_CALLBK_DONE) &&
	    (i->f->dev_loss_tmo_callbk)) {
		rport->flags |= FC_RPORT_DEVLOSS_CALLBK_DONE;
		do_callback = 1;
	}
	spin_unlock_irqrestore(shost->host_lock, flags);

	if (do_callback)
		i->f->dev_loss_tmo_callbk(rport);

	fc_bsg_remove(rport->rqst_q);

	transport_remove_device(dev);
	device_del(dev);
	transport_destroy_device(dev);
	put_device(&shost->shost_gendev);	/* for fc_host->rport list */
	put_device(dev);			/* for self-reference */
}


/**
 * fc_rport_create - allocates and creates a remote FC port.
 * @shost:	scsi host the remote port is connected to.
 * @channel:	Channel on shost port connected to.
 * @ids:	The world wide names, fc address, and FC4 port
 *		roles for the remote port.
 *
 * Allocates and creates the remoter port structure, including the
 * class and sysfs creation.
 *
 * Notes:
 *	This routine assumes no locks are held on entry.
 */
static struct fc_rport *
fc_rport_create(struct Scsi_Host *shost, int channel,
	struct fc_rport_identifiers  *ids)
{
	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
	struct fc_internal *fci = to_fc_internal(shost->transportt);
	struct fc_rport *rport;
	struct device *dev;
	unsigned long flags;
	int error;
	size_t size;

	size = (sizeof(struct fc_rport) + fci->f->dd_fcrport_size);
	rport = kzalloc(size, GFP_KERNEL);
	if (unlikely(!rport)) {
		printk(KERN_ERR "%s: allocation failure\n", __func__);
		return NULL;
	}

	rport->maxframe_size = -1;
	rport->supported_classes = FC_COS_UNSPECIFIED;
	rport->dev_loss_tmo = fc_host->dev_loss_tmo;
	memcpy(&rport->node_name, &ids->node_name, sizeof(rport->node_name));
	memcpy(&rport->port_name, &ids->port_name, sizeof(rport->port_name));
	rport->port_id = ids->port_id;
	rport->roles = ids->roles;
	rport->port_state = FC_PORTSTATE_ONLINE;
	if (fci->f->dd_fcrport_size)
		rport->dd_data = &rport[1];
	rport->channel = channel;
	rport->fast_io_fail_tmo = -1;

	INIT_DELAYED_WORK(&rport->dev_loss_work, fc_timeout_deleted_rport);
	INIT_DELAYED_WORK(&rport->fail_io_work, fc_timeout_fail_rport_io);
	INIT_WORK(&rport->scan_work, fc_scsi_scan_rport);
	INIT_WORK(&rport->stgt_delete_work, fc_starget_delete);
	INIT_WORK(&rport->rport_delete_work, fc_rport_final_delete);

	spin_lock_irqsave(shost->host_lock, flags);

	rport->number = fc_host->next_rport_number++;
	if (rport->roles & FC_PORT_ROLE_FCP_TARGET)
		rport->scsi_target_id = fc_host->next_target_id++;
	else
		rport->scsi_target_id = -1;
	list_add_tail(&rport->peers, &fc_host->rports);
	get_device(&shost->shost_gendev);	/* for fc_host->rport list */

	spin_unlock_irqrestore(shost->host_lock, flags);

	dev = &rport->dev;
	device_initialize(dev);			/* takes self reference */
	dev->parent = get_device(&shost->shost_gendev); /* parent reference */
	dev->release = fc_rport_dev_release;
	dev_set_name(dev, "rport-%d:%d-%d",
		     shost->host_no, channel, rport->number);
	transport_setup_device(dev);

	error = device_add(dev);
	if (error) {
		printk(KERN_ERR "FC Remote Port device_add failed\n");
		goto delete_rport;
	}
	transport_add_device(dev);
	transport_configure_device(dev);

	fc_bsg_rportadd(shost, rport);
	/* ignore any bsg add error - we just can't do sgio */

	if (rport->roles & FC_PORT_ROLE_FCP_TARGET) {
		/* initiate a scan of the target */
		rport->flags |= FC_RPORT_SCAN_PENDING;
		scsi_queue_work(shost, &rport->scan_work);
	}

	return rport;

delete_rport:
	transport_destroy_device(dev);
	spin_lock_irqsave(shost->host_lock, flags);
	list_del(&rport->peers);
	put_device(&shost->shost_gendev);	/* for fc_host->rport list */
	spin_unlock_irqrestore(shost->host_lock, flags);
	put_device(dev->parent);
	kfree(rport);
	return NULL;
}

/**
 * fc_remote_port_add - notify fc transport of the existence of a remote FC port.
 * @shost:	scsi host the remote port is connected to.
 * @channel:	Channel on shost port connected to.
 * @ids:	The world wide names, fc address, and FC4 port
 *		roles for the remote port.
 *
 * The LLDD calls this routine to notify the transport of the existence
 * of a remote port. The LLDD provides the unique identifiers (wwpn,wwn)
 * of the port, it's FC address (port_id), and the FC4 roles that are
 * active for the port.
 *
 * For ports that are FCP targets (aka scsi targets), the FC transport
 * maintains consistent target id bindings on behalf of the LLDD.
 * A consistent target id binding is an assignment of a target id to
 * a remote port identifier, which persists while the scsi host is
 * attached. The remote port can disappear, then later reappear, and
 * it's target id assignment remains the same. This allows for shifts
 * in FC addressing (if binding by wwpn or wwnn) with no apparent
 * changes to the scsi subsystem which is based on scsi host number and
 * target id values.  Bindings are only valid during the attachment of
 * the scsi host. If the host detaches, then later re-attaches, target
 * id bindings may change.
 *
 * This routine is responsible for returning a remote port structure.
 * The routine will search the list of remote ports it maintains
 * internally on behalf of consistent target id mappings. If found, the
 * remote port structure will be reused. Otherwise, a new remote port
 * structure will be allocated.
 *
 * Whenever a remote port is allocated, a new fc_remote_port class
 * device is created.
 *
 * Should not be called from interrupt context.
 *
 * Notes:
 *	This routine assumes no locks are held on entry.
 */
struct fc_rport *
fc_remote_port_add(struct Scsi_Host *shost, int channel,
	struct fc_rport_identifiers  *ids)
{
	struct fc_internal *fci = to_fc_internal(shost->transportt);
	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
	struct fc_rport *rport;
	unsigned long flags;
	int match = 0;

	/* ensure any stgt delete functions are done */
	fc_flush_work(shost);

	/*
	 * Search the list of "active" rports, for an rport that has been
	 * deleted, but we've held off the real delete while the target
	 * is in a "blocked" state.
	 */
	spin_lock_irqsave(shost->host_lock, flags);

	list_for_each_entry(rport, &fc_host->rports, peers) {

		if ((rport->port_state == FC_PORTSTATE_BLOCKED) &&
			(rport->channel == channel)) {

			switch (fc_host->tgtid_bind_type) {
			case FC_TGTID_BIND_BY_WWPN:
			case FC_TGTID_BIND_NONE:
				if (rport->port_name == ids->port_name)
					match = 1;
				break;
			case FC_TGTID_BIND_BY_WWNN:
				if (rport->node_name == ids->node_name)
					match = 1;
				break;
			case FC_TGTID_BIND_BY_ID:
				if (rport->port_id == ids->port_id)
					match = 1;
				break;
			}

			if (match) {

				memcpy(&rport->node_name, &ids->node_name,
					sizeof(rport->node_name));
				memcpy(&rport->port_name, &ids->port_name,
					sizeof(rport->port_name));
				rport->port_id = ids->port_id;

				rport->port_state = FC_PORTSTATE_ONLINE;
				rport->roles = ids->roles;

				spin_unlock_irqrestore(shost->host_lock, flags);

				if (fci->f->dd_fcrport_size)
					memset(rport->dd_data, 0,
						fci->f->dd_fcrport_size);

				/*
				 * If we were not a target, cancel the
				 * io terminate and rport timers, and
				 * we're done.
				 *
				 * If we were a target, but our new role
				 * doesn't indicate a target, leave the
				 * timers running expecting the role to
				 * change as the target fully logs in. If
				 * it doesn't, the target will be torn down.
				 *
				 * If we were a target, and our role shows
				 * we're still a target, cancel the timers
				 * and kick off a scan.
				 */

				/* was a target, not in roles */
				if ((rport->scsi_target_id != -1) &&
				    (!(ids->roles & FC_PORT_ROLE_FCP_TARGET)))
					return rport;

				/*
				 * Stop the fail io and dev_loss timers.
				 * If they flush, the port_state will
				 * be checked and will NOOP the function.
				 */
				if (!cancel_delayed_work(&rport->fail_io_work))
					fc_flush_devloss(shost);
				if (!cancel_delayed_work(&rport->dev_loss_work))
					fc_flush_devloss(shost);

				spin_lock_irqsave(shost->host_lock, flags);

				rport->flags &= ~(FC_RPORT_FAST_FAIL_TIMEDOUT |
						  FC_RPORT_DEVLOSS_PENDING |
						  FC_RPORT_DEVLOSS_CALLBK_DONE);

				/* if target, initiate a scan */
				if (rport->scsi_target_id != -1) {
					rport->flags |= FC_RPORT_SCAN_PENDING;
					scsi_queue_work(shost,
							&rport->scan_work);
					spin_unlock_irqrestore(shost->host_lock,
							flags);
					scsi_target_unblock(&rport->dev);
				} else
					spin_unlock_irqrestore(shost->host_lock,
							flags);

				fc_bsg_goose_queue(rport);

				return rport;
			}
		}
	}

	/*
	 * Search the bindings array
	 * Note: if never a FCP target, you won't be on this list
	 */
	if (fc_host->tgtid_bind_type != FC_TGTID_BIND_NONE) {

		/* search for a matching consistent binding */

		list_for_each_entry(rport, &fc_host->rport_bindings,
					peers) {
			if (rport->channel != channel)
				continue;

			switch (fc_host->tgtid_bind_type) {
			case FC_TGTID_BIND_BY_WWPN:
				if (rport->port_name == ids->port_name)
					match = 1;
				break;
			case FC_TGTID_BIND_BY_WWNN:
				if (rport->node_name == ids->node_name)
					match = 1;
				break;
			case FC_TGTID_BIND_BY_ID:
				if (rport->port_id == ids->port_id)
					match = 1;
				break;
			case FC_TGTID_BIND_NONE: /* to keep compiler happy */
				break;
			}

			if (match) {
				list_move_tail(&rport->peers, &fc_host->rports);
				break;
			}
		}

		if (match) {
			memcpy(&rport->node_name, &ids->node_name,
				sizeof(rport->node_name));
			memcpy(&rport->port_name, &ids->port_name,
				sizeof(rport->port_name));
			rport->port_id = ids->port_id;
			rport->roles = ids->roles;
			rport->port_state = FC_PORTSTATE_ONLINE;
			rport->flags &= ~FC_RPORT_FAST_FAIL_TIMEDOUT;

			if (fci->f->dd_fcrport_size)
				memset(rport->dd_data, 0,
						fci->f->dd_fcrport_size);

			if (rport->roles & FC_PORT_ROLE_FCP_TARGET) {
				/* initiate a scan of the target */
				rport->flags |= FC_RPORT_SCAN_PENDING;
				scsi_queue_work(shost, &rport->scan_work);
				spin_unlock_irqrestore(shost->host_lock, flags);
				scsi_target_unblock(&rport->dev);
			} else
				spin_unlock_irqrestore(shost->host_lock, flags);

			return rport;
		}
	}

	spin_unlock_irqrestore(shost->host_lock, flags);

	/* No consistent binding found - create new remote port entry */
	rport = fc_rport_create(shost, channel, ids);

	return rport;
}
EXPORT_SYMBOL(fc_remote_port_add);


/**
 * fc_remote_port_delete - notifies the fc transport that a remote port is no longer in existence.
 * @rport:	The remote port that no longer exists
 *
 * The LLDD calls this routine to notify the transport that a remote
 * port is no longer part of the topology. Note: Although a port
 * may no longer be part of the topology, it may persist in the remote
 * ports displayed by the fc_host. We do this under 2 conditions:
 * 1) If the port was a scsi target, we delay its deletion by "blocking" it.
 *   This allows the port to temporarily disappear, then reappear without
 *   disrupting the SCSI device tree attached to it. During the "blocked"
 *   period the port will still exist.
 * 2) If the port was a scsi target and disappears for longer than we
 *   expect, we'll delete the port and the tear down the SCSI device tree
 *   attached to it. However, we want to semi-persist the target id assigned
 *   to that port if it eventually does exist. The port structure will
 *   remain (although with minimal information) so that the target id
 *   bindings remails.
 *
 * If the remote port is not an FCP Target, it will be fully torn down
 * and deallocated, including the fc_remote_port class device.
 *
 * If the remote port is an FCP Target, the port will be placed in a
 * temporary blocked state. From the LLDD's perspective, the rport no
 * longer exists. From the SCSI midlayer's perspective, the SCSI target
 * exists, but all sdevs on it are blocked from further I/O. The following
 * is then expected.
 *
 *   If the remote port does not return (signaled by a LLDD call to
 *   fc_remote_port_add()) within the dev_loss_tmo timeout, then the
 *   scsi target is removed - killing all outstanding i/o and removing the
 *   scsi devices attached ot it. The port structure will be marked Not
 *   Present and be partially cleared, leaving only enough information to
 *   recognize the remote port relative to the scsi target id binding if
 *   it later appears.  The port will remain as long as there is a valid
 *   binding (e.g. until the user changes the binding type or unloads the
 *   scsi host with the binding).
 *
 *   If the remote port returns within the dev_loss_tmo value (and matches
 *   according to the target id binding type), the port structure will be
 *   reused. If it is no longer a SCSI target, the target will be torn
 *   down. If it continues to be a SCSI target, then the target will be
 *   unblocked (allowing i/o to be resumed), and a scan will be activated
 *   to ensure that all luns are detected.
 *
 * Called from normal process context only - cannot be called from interrupt.
 *
 * Notes:
 *	This routine assumes no locks are held on entry.
 */
void
fc_remote_port_delete(struct fc_rport  *rport)
{
	struct Scsi_Host *shost = rport_to_shost(rport);
	unsigned long timeout = rport->dev_loss_tmo;
	unsigned long flags;

	/*
	 * No need to flush the fc_host work_q's, as all adds are synchronous.
	 *
	 * We do need to reclaim the rport scan work element, so eventually
	 * (in fc_rport_final_delete()) we'll flush the scsi host work_q if
	 * there's still a scan pending.
	 */

	spin_lock_irqsave(shost->host_lock, flags);

	if (rport->port_state != FC_PORTSTATE_ONLINE) {
		spin_unlock_irqrestore(shost->host_lock, flags);
		return;
	}

	/*
	 * In the past, we if this was not an FCP-Target, we would
	 * unconditionally just jump to deleting the rport.
	 * However, rports can be used as node containers by the LLDD,
	 * and its not appropriate to just terminate the rport at the
	 * first sign of a loss in connectivity. The LLDD may want to
	 * send ELS traffic to re-validate the login. If the rport is
	 * immediately deleted, it makes it inappropriate for a node
	 * container.
	 * So... we now unconditionally wait dev_loss_tmo before
	 * destroying an rport.
	 */

	rport->port_state = FC_PORTSTATE_BLOCKED;

	rport->flags |= FC_RPORT_DEVLOSS_PENDING;

	spin_unlock_irqrestore(shost->host_lock, flags);

	if (rport->roles & FC_PORT_ROLE_FCP_INITIATOR &&
	    shost->active_mode & MODE_TARGET)
		fc_tgt_it_nexus_destroy(shost, (unsigned long)rport);

	scsi_target_block(&rport->dev);

	/* see if we need to kill io faster than waiting for device loss */
	if ((rport->fast_io_fail_tmo != -1) &&
	    (rport->fast_io_fail_tmo < timeout))
		fc_queue_devloss_work(shost, &rport->fail_io_work,
					rport->fast_io_fail_tmo * HZ);

	/* cap the length the devices can be blocked until they are deleted */
	fc_queue_devloss_work(shost, &rport->dev_loss_work, timeout * HZ);
}
EXPORT_SYMBOL(fc_remote_port_delete);

/**
 * fc_remote_port_rolechg - notifies the fc transport that the roles on a remote may have changed.
 * @rport:	The remote port that changed.
 * @roles:      New roles for this port.
 *
 * Description: The LLDD calls this routine to notify the transport that the
 * roles on a remote port may have changed. The largest effect of this is
 * if a port now becomes a FCP Target, it must be allocated a
 * scsi target id.  If the port is no longer a FCP target, any
 * scsi target id value assigned to it will persist in case the
 * role changes back to include FCP Target. No changes in the scsi
 * midlayer will be invoked if the role changes (in the expectation
 * that the role will be resumed. If it doesn't normal error processing
 * will take place).
 *
 * Should not be called from interrupt context.
 *
 * Notes:
 *	This routine assumes no locks are held on entry.
 */
void
fc_remote_port_rolechg(struct fc_rport  *rport, u32 roles)
{
	struct Scsi_Host *shost = rport_to_shost(rport);
	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
	unsigned long flags;
	int create = 0;
	int ret;

	spin_lock_irqsave(shost->host_lock, flags);
	if (roles & FC_PORT_ROLE_FCP_TARGET) {
		if (rport->scsi_target_id == -1) {
			rport->scsi_target_id = fc_host->next_target_id++;
			create = 1;
		} else if (!(rport->roles & FC_PORT_ROLE_FCP_TARGET))
			create = 1;
	} else if (shost->active_mode & MODE_TARGET) {
		ret = fc_tgt_it_nexus_create(shost, (unsigned long)rport,
					     (char *)&rport->node_name);
		if (ret)
			printk(KERN_ERR "FC Remore Port tgt nexus failed %d\n",
			       ret);
	}

	rport->roles = roles;

	spin_unlock_irqrestore(shost->host_lock, flags);

	if (create) {
		/*
		 * There may have been a delete timer running on the
		 * port. Ensure that it is cancelled as we now know
		 * the port is an FCP Target.
		 * Note: we know the rport is exists and in an online
		 *  state as the LLDD would not have had an rport
		 *  reference to pass us.
		 *
		 * Take no action on the del_timer failure as the state
		 * machine state change will validate the
		 * transaction.
		 */
		if (!cancel_delayed_work(&rport->fail_io_work))
			fc_flush_devloss(shost);
		if (!cancel_delayed_work(&rport->dev_loss_work))
			fc_flush_devloss(shost);

		spin_lock_irqsave(shost->host_lock, flags);
		rport->flags &= ~(FC_RPORT_FAST_FAIL_TIMEDOUT |
				  FC_RPORT_DEVLOSS_PENDING |
				  FC_RPORT_DEVLOSS_CALLBK_DONE);
		spin_unlock_irqrestore(shost->host_lock, flags);

		/* ensure any stgt delete functions are done */
		fc_flush_work(shost);

		/* initiate a scan of the target */
		spin_lock_irqsave(shost->host_lock, flags);
		rport->flags |= FC_RPORT_SCAN_PENDING;
		scsi_queue_work(shost, &rport->scan_work);
		spin_unlock_irqrestore(shost->host_lock, flags);
		scsi_target_unblock(&rport->dev);
	}
}
EXPORT_SYMBOL(fc_remote_port_rolechg);

/**
 * fc_timeout_deleted_rport - Timeout handler for a deleted remote port.
 * @work:	rport target that failed to reappear in the allotted time.
 *
 * Description: An attempt to delete a remote port blocks, and if it fails
 *              to return in the allotted time this gets called.
 */
static void
fc_timeout_deleted_rport(struct work_struct *work)
{
	struct fc_rport *rport =
		container_of(work, struct fc_rport, dev_loss_work.work);
	struct Scsi_Host *shost = rport_to_shost(rport);
	struct fc_internal *i = to_fc_internal(shost->transportt);
	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
	unsigned long flags;
	int do_callback = 0;

	spin_lock_irqsave(shost->host_lock, flags);

	rport->flags &= ~FC_RPORT_DEVLOSS_PENDING;

	/*
	 * If the port is ONLINE, then it came back. If it was a SCSI
	 * target, validate it still is. If not, tear down the
	 * scsi_target on it.
	 */
	if ((rport->port_state == FC_PORTSTATE_ONLINE) &&
	    (rport->scsi_target_id != -1) &&
	    !(rport->roles & FC_PORT_ROLE_FCP_TARGET)) {
		dev_printk(KERN_ERR, &rport->dev,
			"blocked FC remote port time out: no longer"
			" a FCP target, removing starget\n");
		spin_unlock_irqrestore(shost->host_lock, flags);
		scsi_target_unblock(&rport->dev);
		fc_queue_work(shost, &rport->stgt_delete_work);
		return;
	}

	/* NOOP state - we're flushing workq's */
	if (rport->port_state != FC_PORTSTATE_BLOCKED) {
		spin_unlock_irqrestore(shost->host_lock, flags);
		dev_printk(KERN_ERR, &rport->dev,
			"blocked FC remote port time out: leaving"
			" rport%s alone\n",
			(rport->scsi_target_id != -1) ?  " and starget" : "");
		return;
	}

	if ((fc_host->tgtid_bind_type == FC_TGTID_BIND_NONE) ||
	    (rport->scsi_target_id == -1)) {
		list_del(&rport->peers);
		rport->port_state = FC_PORTSTATE_DELETED;
		dev_printk(KERN_ERR, &rport->dev,
			"blocked FC remote port time out: removing"
			" rport%s\n",
			(rport->scsi_target_id != -1) ?  " and starget" : "");
		fc_queue_work(shost, &rport->rport_delete_work);
		spin_unlock_irqrestore(shost->host_lock, flags);
		return;
	}

	dev_printk(KERN_ERR, &rport->dev,
		"blocked FC remote port time out: removing target and "
		"saving binding\n");

	list_move_tail(&rport->peers, &fc_host->rport_bindings);

	/*
	 * Note: We do not remove or clear the hostdata area. This allows
	 *   host-specific target data to persist along with the
	 *   scsi_target_id. It's up to the host to manage it's hostdata area.
	 */

	/*
	 * Reinitialize port attributes that may change if the port comes back.
	 */
	rport->maxframe_size = -1;
	rport->supported_classes = FC_COS_UNSPECIFIED;
	rport->roles = FC_PORT_ROLE_UNKNOWN;
	rport->port_state = FC_PORTSTATE_NOTPRESENT;
	rport->flags &= ~FC_RPORT_FAST_FAIL_TIMEDOUT;

	/*
	 * Pre-emptively kill I/O rather than waiting for the work queue
	 * item to teardown the starget. (FCOE libFC folks prefer this
	 * and to have the rport_port_id still set when it's done).
	 */
	spin_unlock_irqrestore(shost->host_lock, flags);
	fc_terminate_rport_io(rport);

	spin_lock_irqsave(shost->host_lock, flags);

	if (rport->port_state == FC_PORTSTATE_NOTPRESENT) {	/* still missing */

		/* remove the identifiers that aren't used in the consisting binding */
		switch (fc_host->tgtid_bind_type) {
		case FC_TGTID_BIND_BY_WWPN:
			rport->node_name = -1;
			rport->port_id = -1;
			break;
		case FC_TGTID_BIND_BY_WWNN:
			rport->port_name = -1;
			rport->port_id = -1;
			break;
		case FC_TGTID_BIND_BY_ID:
			rport->node_name = -1;
			rport->port_name = -1;
			break;
		case FC_TGTID_BIND_NONE:	/* to keep compiler happy */
			break;
		}

		/*
		 * As this only occurs if the remote port (scsi target)
		 * went away and didn't come back - we'll remove
		 * all attached scsi devices.
		 */
		rport->flags |= FC_RPORT_DEVLOSS_CALLBK_DONE;
		fc_queue_work(shost, &rport->stgt_delete_work);

		do_callback = 1;
	}

	spin_unlock_irqrestore(shost->host_lock, flags);

	/*
	 * Notify the driver that the rport is now dead. The LLDD will
	 * also guarantee that any communication to the rport is terminated
	 *
	 * Note: we set the CALLBK_DONE flag above to correspond
	 */
	if (do_callback && i->f->dev_loss_tmo_callbk)
		i->f->dev_loss_tmo_callbk(rport);
}


/**
 * fc_timeout_fail_rport_io - Timeout handler for a fast io failing on a disconnected SCSI target.
 * @work:	rport to terminate io on.
 *
 * Notes: Only requests the failure of the io, not that all are flushed
 *    prior to returning.
 */
static void
fc_timeout_fail_rport_io(struct work_struct *work)
{
	struct fc_rport *rport =
		container_of(work, struct fc_rport, fail_io_work.work);

	if (rport->port_state != FC_PORTSTATE_BLOCKED)
		return;

	rport->flags |= FC_RPORT_FAST_FAIL_TIMEDOUT;
	fc_terminate_rport_io(rport);
}

/**
 * fc_scsi_scan_rport - called to perform a scsi scan on a remote port.
 * @work:	remote port to be scanned.
 */
static void
fc_scsi_scan_rport(struct work_struct *work)
{
	struct fc_rport *rport =
		container_of(work, struct fc_rport, scan_work);
	struct Scsi_Host *shost = rport_to_shost(rport);
	struct fc_internal *i = to_fc_internal(shost->transportt);
	unsigned long flags;

	if ((rport->port_state == FC_PORTSTATE_ONLINE) &&
	    (rport->roles & FC_PORT_ROLE_FCP_TARGET) &&
	    !(i->f->disable_target_scan)) {
		scsi_scan_target(&rport->dev, rport->channel,
			rport->scsi_target_id, SCAN_WILD_CARD, 1);
	}

	spin_lock_irqsave(shost->host_lock, flags);
	rport->flags &= ~FC_RPORT_SCAN_PENDING;
	spin_unlock_irqrestore(shost->host_lock, flags);
}

/**
 * fc_block_scsi_eh - Block SCSI eh thread for blocked fc_rport
 * @cmnd: SCSI command that scsi_eh is trying to recover
 *
 * This routine can be called from a FC LLD scsi_eh callback. It
 * blocks the scsi_eh thread until the fc_rport leaves the
 * FC_PORTSTATE_BLOCKED, or the fast_io_fail_tmo fires. This is
 * necessary to avoid the scsi_eh failing recovery actions for blocked
 * rports which would lead to offlined SCSI devices.
 *
 * Returns: 0 if the fc_rport left the state FC_PORTSTATE_BLOCKED.
 *	    FAST_IO_FAIL if the fast_io_fail_tmo fired, this should be
 *	    passed back to scsi_eh.
 */
int fc_block_scsi_eh(struct scsi_cmnd *cmnd)
{
	struct Scsi_Host *shost = cmnd->device->host;
	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
	unsigned long flags;

	spin_lock_irqsave(shost->host_lock, flags);
	while (rport->port_state == FC_PORTSTATE_BLOCKED &&
	       !(rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)) {
		spin_unlock_irqrestore(shost->host_lock, flags);
		msleep(1000);
		spin_lock_irqsave(shost->host_lock, flags);
	}
	spin_unlock_irqrestore(shost->host_lock, flags);

	if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
		return FAST_IO_FAIL;

	return 0;
}
EXPORT_SYMBOL(fc_block_scsi_eh);

/**
 * fc_vport_setup - allocates and creates a FC virtual port.
 * @shost:	scsi host the virtual port is connected to.
 * @channel:	Channel on shost port connected to.
 * @pdev:	parent device for vport
 * @ids:	The world wide names, FC4 port roles, etc for
 *              the virtual port.
 * @ret_vport:	The pointer to the created vport.
 *
 * Allocates and creates the vport structure, calls the parent host
 * to instantiate the vport, the completes w/ class and sysfs creation.
 *
 * Notes:
 *	This routine assumes no locks are held on entry.
 */
static int
fc_vport_setup(struct Scsi_Host *shost, int channel, struct device *pdev,
	struct fc_vport_identifiers  *ids, struct fc_vport **ret_vport)
{
	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
	struct fc_internal *fci = to_fc_internal(shost->transportt);
	struct fc_vport *vport;
	struct device *dev;
	unsigned long flags;
	size_t size;
	int error;

	*ret_vport = NULL;

	if ( ! fci->f->vport_create)
		return -ENOENT;

	size = (sizeof(struct fc_vport) + fci->f->dd_fcvport_size);
	vport = kzalloc(size, GFP_KERNEL);
	if (unlikely(!vport)) {
		printk(KERN_ERR "%s: allocation failure\n", __func__);
		return -ENOMEM;
	}

	vport->vport_state = FC_VPORT_UNKNOWN;
	vport->vport_last_state = FC_VPORT_UNKNOWN;
	vport->node_name = ids->node_name;
	vport->port_name = ids->port_name;
	vport->roles = ids->roles;
	vport->vport_type = ids->vport_type;
	if (fci->f->dd_fcvport_size)
		vport->dd_data = &vport[1];
	vport->shost = shost;
	vport->channel = channel;
	vport->flags = FC_VPORT_CREATING;
	INIT_WORK(&vport->vport_delete_work, fc_vport_sched_delete);

	spin_lock_irqsave(shost->host_lock, flags);

	if (fc_host->npiv_vports_inuse >= fc_host->max_npiv_vports) {
		spin_unlock_irqrestore(shost->host_lock, flags);
		kfree(vport);
		return -ENOSPC;
	}
	fc_host->npiv_vports_inuse++;
	vport->number = fc_host->next_vport_number++;
	list_add_tail(&vport->peers, &fc_host->vports);
	get_device(&shost->shost_gendev);	/* for fc_host->vport list */

	spin_unlock_irqrestore(shost->host_lock, flags);

	dev = &vport->dev;
	device_initialize(dev);			/* takes self reference */
	dev->parent = get_device(pdev);		/* takes parent reference */
	dev->release = fc_vport_dev_release;
	dev_set_name(dev, "vport-%d:%d-%d",
		     shost->host_no, channel, vport->number);
	transport_setup_device(dev);

	error = device_add(dev);
	if (error) {
		printk(KERN_ERR "FC Virtual Port device_add failed\n");
		goto delete_vport;
	}
	transport_add_device(dev);
	transport_configure_device(dev);

	error = fci->f->vport_create(vport, ids->disable);
	if (error) {
		printk(KERN_ERR "FC Virtual Port LLDD Create failed\n");
		goto delete_vport_all;
	}

	/*
	 * if the parent isn't the physical adapter's Scsi_Host, ensure
	 * the Scsi_Host at least contains ia symlink to the vport.
	 */
	if (pdev != &shost->shost_gendev) {
		error = sysfs_create_link(&shost->shost_gendev.kobj,
				 &dev->kobj, dev_name(dev));
		if (error)
			printk(KERN_ERR
				"%s: Cannot create vport symlinks for "
				"%s, err=%d\n",
				__func__, dev_name(dev), error);
	}
	spin_lock_irqsave(shost->host_lock, flags);
	vport->flags &= ~FC_VPORT_CREATING;
	spin_unlock_irqrestore(shost->host_lock, flags);

	dev_printk(KERN_NOTICE, pdev,
			"%s created via shost%d channel %d\n", dev_name(dev),
			shost->host_no, channel);

	*ret_vport = vport;

	return 0;

delete_vport_all:
	transport_remove_device(dev);
	device_del(dev);
delete_vport:
	transport_destroy_device(dev);
	spin_lock_irqsave(shost->host_lock, flags);
	list_del(&vport->peers);
	put_device(&shost->shost_gendev);	/* for fc_host->vport list */
	fc_host->npiv_vports_inuse--;
	spin_unlock_irqrestore(shost->host_lock, flags);
	put_device(dev->parent);
	kfree(vport);

	return error;
}

/**
 * fc_vport_create - Admin App or LLDD requests creation of a vport
 * @shost:	scsi host the virtual port is connected to.
 * @channel:	channel on shost port connected to.
 * @ids:	The world wide names, FC4 port roles, etc for
 *              the virtual port.
 *
 * Notes:
 *	This routine assumes no locks are held on entry.
 */
struct fc_vport *
fc_vport_create(struct Scsi_Host *shost, int channel,
	struct fc_vport_identifiers *ids)
{
	int stat;
	struct fc_vport *vport;

	stat = fc_vport_setup(shost, channel, &shost->shost_gendev,
		 ids, &vport);
	return stat ? NULL : vport;
}
EXPORT_SYMBOL(fc_vport_create);

/**
 * fc_vport_terminate - Admin App or LLDD requests termination of a vport
 * @vport:	fc_vport to be terminated
 *
 * Calls the LLDD vport_delete() function, then deallocates and removes
 * the vport from the shost and object tree.
 *
 * Notes:
 *	This routine assumes no locks are held on entry.
 */
int
fc_vport_terminate(struct fc_vport *vport)
{
	struct Scsi_Host *shost = vport_to_shost(vport);
	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
	struct fc_internal *i = to_fc_internal(shost->transportt);
	struct device *dev = &vport->dev;
	unsigned long flags;
	int stat;

	if (i->f->vport_delete)
		stat = i->f->vport_delete(vport);
	else
		stat = -ENOENT;

	spin_lock_irqsave(shost->host_lock, flags);
	vport->flags &= ~FC_VPORT_DELETING;
	if (!stat) {
		vport->flags |= FC_VPORT_DELETED;
		list_del(&vport->peers);
		fc_host->npiv_vports_inuse--;
		put_device(&shost->shost_gendev);  /* for fc_host->vport list */
	}
	spin_unlock_irqrestore(shost->host_lock, flags);

	if (stat)
		return stat;

	if (dev->parent != &shost->shost_gendev)
		sysfs_remove_link(&shost->shost_gendev.kobj, dev_name(dev));
	transport_remove_device(dev);
	device_del(dev);
	transport_destroy_device(dev);

	/*
	 * Removing our self-reference should mean our
	 * release function gets called, which will drop the remaining
	 * parent reference and free the data structure.
	 */
	put_device(dev);			/* for self-reference */

	return 0; /* SUCCESS */
}
EXPORT_SYMBOL(fc_vport_terminate);

/**
 * fc_vport_sched_delete - workq-based delete request for a vport
 * @work:	vport to be deleted.
 */
static void
fc_vport_sched_delete(struct work_struct *work)
{
	struct fc_vport *vport =
		container_of(work, struct fc_vport, vport_delete_work);
	int stat;

	stat = fc_vport_terminate(vport);
	if (stat)
		dev_printk(KERN_ERR, vport->dev.parent,
			"%s: %s could not be deleted created via "
			"shost%d channel %d - error %d\n", __func__,
			dev_name(&vport->dev), vport->shost->host_no,
			vport->channel, stat);
}


/*
 * BSG support
 */


/**
 * fc_destroy_bsgjob - routine to teardown/delete a fc bsg job
 * @job:	fc_bsg_job that is to be torn down
 */
static void
fc_destroy_bsgjob(struct fc_bsg_job *job)
{
	unsigned long flags;

	spin_lock_irqsave(&job->job_lock, flags);
	if (job->ref_cnt) {
		spin_unlock_irqrestore(&job->job_lock, flags);
		return;
	}
	spin_unlock_irqrestore(&job->job_lock, flags);

	put_device(job->dev);	/* release reference for the request */

	kfree(job->request_payload.sg_list);
	kfree(job->reply_payload.sg_list);
	kfree(job);
}

/**
 * fc_bsg_jobdone - completion routine for bsg requests that the LLD has
 *                  completed
 * @job:	fc_bsg_job that is complete
 */
static void
fc_bsg_jobdone(struct fc_bsg_job *job)
{
	struct request *req = job->req;
	struct request *rsp = req->next_rq;
	int err;

	err = job->req->errors = job->reply->result;

	if (err < 0)
		/* we're only returning the result field in the reply */
		job->req->sense_len = sizeof(uint32_t);
	else
		job->req->sense_len = job->reply_len;

	/* we assume all request payload was transferred, residual == 0 */
	req->resid_len = 0;

	if (rsp) {
		WARN_ON(job->reply->reply_payload_rcv_len > rsp->resid_len);

		/* set reply (bidi) residual */
		rsp->resid_len -= min(job->reply->reply_payload_rcv_len,
				      rsp->resid_len);
	}
	blk_complete_request(req);
}

/**
 * fc_bsg_softirq_done - softirq done routine for destroying the bsg requests
 * @rq:        BSG request that holds the job to be destroyed
 */
static void fc_bsg_softirq_done(struct request *rq)
{
	struct fc_bsg_job *job = rq->special;
	unsigned long flags;

	spin_lock_irqsave(&job->job_lock, flags);
	job->state_flags |= FC_RQST_STATE_DONE;
	job->ref_cnt--;
	spin_unlock_irqrestore(&job->job_lock, flags);

	blk_end_request_all(rq, rq->errors);
	fc_destroy_bsgjob(job);
}

/**
 * fc_bsg_job_timeout - handler for when a bsg request timesout
 * @req:	request that timed out
 */
static enum blk_eh_timer_return
fc_bsg_job_timeout(struct request *req)
{
	struct fc_bsg_job *job = (void *) req->special;
	struct Scsi_Host *shost = job->shost;
	struct fc_internal *i = to_fc_internal(shost->transportt);
	unsigned long flags;
	int err = 0, done = 0;

	if (job->rport && job->rport->port_state == FC_PORTSTATE_BLOCKED)
		return BLK_EH_RESET_TIMER;

	spin_lock_irqsave(&job->job_lock, flags);
	if (job->state_flags & FC_RQST_STATE_DONE)
		done = 1;
	else
		job->ref_cnt++;
	spin_unlock_irqrestore(&job->job_lock, flags);

	if (!done && i->f->bsg_timeout) {
		/* call LLDD to abort the i/o as it has timed out */
		err = i->f->bsg_timeout(job);
		if (err == -EAGAIN) {
			job->ref_cnt--;
			return BLK_EH_RESET_TIMER;
		} else if (err)
			printk(KERN_ERR "ERROR: FC BSG request timeout - LLD "
				"abort failed with status %d\n", err);
	}

	/* the blk_end_sync_io() doesn't check the error */
	if (done)
		return BLK_EH_NOT_HANDLED;
	else
		return BLK_EH_HANDLED;
}

static int
fc_bsg_map_buffer(struct fc_bsg_buffer *buf, struct request *req)
{
	size_t sz = (sizeof(struct scatterlist) * req->nr_phys_segments);
	struct request_queue *q = req->queue_ctx->queue;

	BUG_ON(!req->nr_phys_segments);

	buf->sg_list = kzalloc(sz, GFP_KERNEL);
	if (!buf->sg_list)
		return -ENOMEM;
	sg_init_table(buf->sg_list, req->nr_phys_segments);
	buf->sg_cnt = blk_rq_map_sg(q, req, buf->sg_list);
	buf->payload_len = blk_rq_bytes(req);
	return 0;
}


/**
 * fc_req_to_bsgjob - Allocate/create the fc_bsg_job structure for the
 *                   bsg request
 * @shost:	SCSI Host corresponding to the bsg object
 * @rport:	(optional) FC Remote Port corresponding to the bsg object
 * @req:	BSG request that needs a job structure
 */
static int
fc_req_to_bsgjob(struct Scsi_Host *shost, struct fc_rport *rport,
	struct request *req)
{
	struct fc_internal *i = to_fc_internal(shost->transportt);
	struct request *rsp = req->next_rq;
	struct fc_bsg_job *job;
	int ret;

	BUG_ON(req->special);

	job = kzalloc(sizeof(struct fc_bsg_job) + i->f->dd_bsg_size,
			GFP_KERNEL);
	if (!job)
		return -ENOMEM;

	/*
	 * Note: this is a bit silly.
	 * The request gets formatted as a SGIO v4 ioctl request, which
	 * then gets reformatted as a blk request, which then gets
	 * reformatted as a fc bsg request. And on completion, we have
	 * to wrap return results such that SGIO v4 thinks it was a scsi
	 * status.  I hope this was all worth it.
	 */

	req->special = job;
	job->shost = shost;
	job->rport = rport;
	job->req = req;
	if (i->f->dd_bsg_size)
		job->dd_data = (void *)&job[1];
	spin_lock_init(&job->job_lock);
	job->request = (struct fc_bsg_request *)req->cmd;
	job->request_len = req->cmd_len;
	job->reply = req->sense;
	job->reply_len = SCSI_SENSE_BUFFERSIZE;	/* Size of sense buffer
						 * allocated */
	if (req->bio) {
		ret = fc_bsg_map_buffer(&job->request_payload, req);
		if (ret)
			goto failjob_rls_job;
	}
	if (rsp && rsp->bio) {
		ret = fc_bsg_map_buffer(&job->reply_payload, rsp);
		if (ret)
			goto failjob_rls_rqst_payload;
	}
	job->job_done = fc_bsg_jobdone;
	if (rport)
		job->dev = &rport->dev;
	else
		job->dev = &shost->shost_gendev;
	get_device(job->dev);		/* take a reference for the request */

	job->ref_cnt = 1;

	return 0;


failjob_rls_rqst_payload:
	kfree(job->request_payload.sg_list);
failjob_rls_job:
	kfree(job);
	return -ENOMEM;
}


enum fc_dispatch_result {
	FC_DISPATCH_BREAK,	/* on return, q is locked, break from q loop */
	FC_DISPATCH_LOCKED,	/* on return, q is locked, continue on */
	FC_DISPATCH_UNLOCKED,	/* on return, q is unlocked, continue on */
};


/**
 * fc_bsg_host_dispatch - process fc host bsg requests and dispatch to LLDD
 * @q:		fc host request queue
 * @shost:	scsi host rport attached to
 * @job:	bsg job to be processed
 */
static enum fc_dispatch_result
fc_bsg_host_dispatch(struct request_queue *q, struct Scsi_Host *shost,
			 struct fc_bsg_job *job)
{
	struct fc_internal *i = to_fc_internal(shost->transportt);
	int cmdlen = sizeof(uint32_t);	/* start with length of msgcode */
	int ret;

	/* Validate the host command */
	switch (job->request->msgcode) {
	case FC_BSG_HST_ADD_RPORT:
		cmdlen += sizeof(struct fc_bsg_host_add_rport);
		break;

	case FC_BSG_HST_DEL_RPORT:
		cmdlen += sizeof(struct fc_bsg_host_del_rport);
		break;

	case FC_BSG_HST_ELS_NOLOGIN:
		cmdlen += sizeof(struct fc_bsg_host_els);
		/* there better be a xmt and rcv payloads */
		if ((!job->request_payload.payload_len) ||
		    (!job->reply_payload.payload_len)) {
			ret = -EINVAL;
			goto fail_host_msg;
		}
		break;

	case FC_BSG_HST_CT:
		cmdlen += sizeof(struct fc_bsg_host_ct);
		/* there better be xmt and rcv payloads */
		if ((!job->request_payload.payload_len) ||
		    (!job->reply_payload.payload_len)) {
			ret = -EINVAL;
			goto fail_host_msg;
		}
		break;

	case FC_BSG_HST_VENDOR:
		cmdlen += sizeof(struct fc_bsg_host_vendor);
		if ((shost->hostt->vendor_id == 0L) ||
		    (job->request->rqst_data.h_vendor.vendor_id !=
			shost->hostt->vendor_id)) {
			ret = -ESRCH;
			goto fail_host_msg;
		}
		break;

	default:
		ret = -EBADR;
		goto fail_host_msg;
	}

	/* check if we really have all the request data needed */
	if (job->request_len < cmdlen) {
		ret = -ENOMSG;
		goto fail_host_msg;
	}

	ret = i->f->bsg_request(job);
	if (!ret)
		return FC_DISPATCH_UNLOCKED;

fail_host_msg:
	/* return the errno failure code as the only status */
	BUG_ON(job->reply_len < sizeof(uint32_t));
	job->reply->reply_payload_rcv_len = 0;
	job->reply->result = ret;
	job->reply_len = sizeof(uint32_t);
	fc_bsg_jobdone(job);
	return FC_DISPATCH_UNLOCKED;
}


/*
 * fc_bsg_goose_queue - restart rport queue in case it was stopped
 * @rport:	rport to be restarted
 */
static void
fc_bsg_goose_queue(struct fc_rport *rport)
{
	if (!rport->rqst_q)
		return;

	/*
	 * This get/put dance makes no sense
	 */
	get_device(&rport->dev);
	blk_run_queue_async(rport->rqst_q);
	put_device(&rport->dev);
}

/**
 * fc_bsg_rport_dispatch - process rport bsg requests and dispatch to LLDD
 * @q:		rport request queue
 * @shost:	scsi host rport attached to
 * @rport:	rport request destined to
 * @job:	bsg job to be processed
 */
static enum fc_dispatch_result
fc_bsg_rport_dispatch(struct request_queue *q, struct Scsi_Host *shost,
			 struct fc_rport *rport, struct fc_bsg_job *job)
{
	struct fc_internal *i = to_fc_internal(shost->transportt);
	int cmdlen = sizeof(uint32_t);	/* start with length of msgcode */
	int ret;

	/* Validate the rport command */
	switch (job->request->msgcode) {
	case FC_BSG_RPT_ELS:
		cmdlen += sizeof(struct fc_bsg_rport_els);
		goto check_bidi;

	case FC_BSG_RPT_CT:
		cmdlen += sizeof(struct fc_bsg_rport_ct);
check_bidi:
		/* there better be xmt and rcv payloads */
		if ((!job->request_payload.payload_len) ||
		    (!job->reply_payload.payload_len)) {
			ret = -EINVAL;
			goto fail_rport_msg;
		}
		break;
	default:
		ret = -EBADR;
		goto fail_rport_msg;
	}

	/* check if we really have all the request data needed */
	if (job->request_len < cmdlen) {
		ret = -ENOMSG;
		goto fail_rport_msg;
	}

	ret = i->f->bsg_request(job);
	if (!ret)
		return FC_DISPATCH_UNLOCKED;

fail_rport_msg:
	/* return the errno failure code as the only status */
	BUG_ON(job->reply_len < sizeof(uint32_t));
	job->reply->reply_payload_rcv_len = 0;
	job->reply->result = ret;
	job->reply_len = sizeof(uint32_t);
	fc_bsg_jobdone(job);
	return FC_DISPATCH_UNLOCKED;
}


/**
 * fc_bsg_request_handler - generic handler for bsg requests
 * @q:		request queue to manage
 * @shost:	Scsi_Host related to the bsg object
 * @rport:	FC remote port related to the bsg object (optional)
 * @dev:	device structure for bsg object
 */
static void
fc_bsg_request_handler(struct request_queue *q, struct Scsi_Host *shost,
		       struct fc_rport *rport, struct device *dev)
{
	struct request *req;
	struct fc_bsg_job *job;
	enum fc_dispatch_result ret;

	if (!get_device(dev))
		return;

	while (1) {
		if (rport && (rport->port_state == FC_PORTSTATE_BLOCKED) &&
		    !(rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT))
			break;

		req = blk_fetch_request(q);
		if (!req)
			break;

		if (rport && (rport->port_state != FC_PORTSTATE_ONLINE)) {
			req->errors = -ENXIO;
			spin_unlock_irq(q->queue_lock);
			blk_end_request_all(req, -ENXIO);
			spin_lock_irq(q->queue_lock);
			continue;
		}

		spin_unlock_irq(q->queue_lock);

		ret = fc_req_to_bsgjob(shost, rport, req);
		if (ret) {
			req->errors = ret;
			blk_end_request_all(req, ret);
			spin_lock_irq(q->queue_lock);
			continue;
		}

		job = req->special;

		/* check if we have the msgcode value at least */
		if (job->request_len < sizeof(uint32_t)) {
			BUG_ON(job->reply_len < sizeof(uint32_t));
			job->reply->reply_payload_rcv_len = 0;
			job->reply->result = -ENOMSG;
			job->reply_len = sizeof(uint32_t);
			fc_bsg_jobdone(job);
			spin_lock_irq(q->queue_lock);
			continue;
		}

		/* the dispatch routines will unlock the queue_lock */
		if (rport)
			ret = fc_bsg_rport_dispatch(q, shost, rport, job);
		else
			ret = fc_bsg_host_dispatch(q, shost, job);

		/* did dispatcher hit state that can't process any more */
		if (ret == FC_DISPATCH_BREAK)
			break;

		/* did dispatcher had released the lock */
		if (ret == FC_DISPATCH_UNLOCKED)
			spin_lock_irq(q->queue_lock);
	}

	spin_unlock_irq(q->queue_lock);
	put_device(dev);
	spin_lock_irq(q->queue_lock);
}


/**
 * fc_bsg_host_handler - handler for bsg requests for a fc host
 * @q:		fc host request queue
 */
static void
fc_bsg_host_handler(struct request_queue *q)
{
	struct Scsi_Host *shost = q->queuedata;

	fc_bsg_request_handler(q, shost, NULL, &shost->shost_gendev);
}


/**
 * fc_bsg_rport_handler - handler for bsg requests for a fc rport
 * @q:		rport request queue
 */
static void
fc_bsg_rport_handler(struct request_queue *q)
{
	struct fc_rport *rport = q->queuedata;
	struct Scsi_Host *shost = rport_to_shost(rport);

	fc_bsg_request_handler(q, shost, rport, &rport->dev);
}


/**
 * fc_bsg_hostadd - Create and add the bsg hooks so we can receive requests
 * @shost:	shost for fc_host
 * @fc_host:	fc_host adding the structures to
 */
static int
fc_bsg_hostadd(struct Scsi_Host *shost, struct fc_host_attrs *fc_host)
{
	struct device *dev = &shost->shost_gendev;
	struct fc_internal *i = to_fc_internal(shost->transportt);
	struct request_queue *q;
	int err;
	char bsg_name[20];

	fc_host->rqst_q = NULL;

	if (!i->f->bsg_request)
		return -ENOTSUPP;

	snprintf(bsg_name, sizeof(bsg_name),
		 "fc_host%d", shost->host_no);

	q = __scsi_alloc_queue(shost, fc_bsg_host_handler);
	if (!q) {
		printk(KERN_ERR "fc_host%d: bsg interface failed to "
				"initialize - no request queue\n",
				 shost->host_no);
		return -ENOMEM;
	}

	q->queuedata = shost;
	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, q);
	blk_queue_softirq_done(q, fc_bsg_softirq_done);
	blk_queue_rq_timed_out(q, fc_bsg_job_timeout);
	blk_queue_rq_timeout(q, FC_DEFAULT_BSG_TIMEOUT);

	err = bsg_register_queue(q, dev, bsg_name, NULL);
	if (err) {
		printk(KERN_ERR "fc_host%d: bsg interface failed to "
				"initialize - register queue\n",
				shost->host_no);
		blk_cleanup_queue(q);
		return err;
	}

	fc_host->rqst_q = q;
	return 0;
}


/**
 * fc_bsg_rportadd - Create and add the bsg hooks so we can receive requests
 * @shost:	shost that rport is attached to
 * @rport:	rport that the bsg hooks are being attached to
 */
static int
fc_bsg_rportadd(struct Scsi_Host *shost, struct fc_rport *rport)
{
	struct device *dev = &rport->dev;
	struct fc_internal *i = to_fc_internal(shost->transportt);
	struct request_queue *q;
	int err;

	rport->rqst_q = NULL;

	if (!i->f->bsg_request)
		return -ENOTSUPP;

	q = __scsi_alloc_queue(shost, fc_bsg_rport_handler);
	if (!q) {
		printk(KERN_ERR "%s: bsg interface failed to "
				"initialize - no request queue\n",
				 dev->kobj.name);
		return -ENOMEM;
	}

	q->queuedata = rport;
	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, q);
	blk_queue_softirq_done(q, fc_bsg_softirq_done);
	blk_queue_rq_timed_out(q, fc_bsg_job_timeout);
	blk_queue_rq_timeout(q, BLK_DEFAULT_SG_TIMEOUT);

	err = bsg_register_queue(q, dev, NULL, NULL);
	if (err) {
		printk(KERN_ERR "%s: bsg interface failed to "
				"initialize - register queue\n",
				 dev->kobj.name);
		blk_cleanup_queue(q);
		return err;
	}

	rport->rqst_q = q;
	return 0;
}


/**
 * fc_bsg_remove - Deletes the bsg hooks on fchosts/rports
 * @q:	the request_queue that is to be torn down.
 *
 * Notes:
 *   Before unregistering the queue empty any requests that are blocked
 *
 *
 */
static void
fc_bsg_remove(struct request_queue *q)
{
	struct request *req; /* block request */
	int counts; /* totals for request_list count and starved */

	if (q) {
		/* Stop taking in new requests */
		spin_lock_irq(q->queue_lock);
		blk_stop_queue(q);

		/* drain all requests in the queue */
		while (1) {
			/* need the lock to fetch a request
			 * this may fetch the same reqeust as the previous pass
			 */
			req = blk_fetch_request(q);
			/* save requests in use and starved */
			counts = q->rq.count[0] + q->rq.count[1] +
				q->rq.starved[0] + q->rq.starved[1];
			spin_unlock_irq(q->queue_lock);
			/* any requests still outstanding? */
			if (counts == 0)
				break;

			/* This may be the same req as the previous iteration,
			 * always send the blk_end_request_all after a prefetch.
			 * It is not okay to not end the request because the
			 * prefetch started the request.
			 */
			if (req) {
				/* return -ENXIO to indicate that this queue is
				 * going away
				 */
				req->errors = -ENXIO;
				blk_end_request_all(req, -ENXIO);
			}

			msleep(200); /* allow bsg to possibly finish */
			spin_lock_irq(q->queue_lock);
		}

		bsg_unregister_queue(q);
		blk_cleanup_queue(q);
	}
}


/* Original Author:  Martin Hicks */
MODULE_AUTHOR("James Smart");
MODULE_DESCRIPTION("FC Transport Attributes");
MODULE_LICENSE("GPL");

module_init(fc_transport_init);
module_exit(fc_transport_exit);

--=_4fd91c3f.R4ms68f5hejM12e5zdJOlaXCA5NYIvmvSlWnmiraoFWGO1Xb
Content-Type: text/x-chdr;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="blkdev.h"

#ifndef _LINUX_BLKDEV_H
#define _LINUX_BLKDEV_H

#ifdef CONFIG_BLOCK

#include <linux/sched.h>
#include <linux/major.h>
#include <linux/genhd.h>
#include <linux/list.h>
#include <linux/timer.h>
#include <linux/workqueue.h>
#include <linux/pagemap.h>
#include <linux/backing-dev.h>
#include <linux/wait.h>
#include <linux/mempool.h>
#include <linux/bio.h>
#include <linux/stringify.h>
#include <linux/gfp.h>
#include <linux/bsg.h>
#include <linux/smp.h>

#include <asm/scatterlist.h>

struct module;
struct scsi_ioctl_command;

struct request_queue;
struct elevator_queue;
struct request_pm_state;
struct blk_trace;
struct request;
struct sg_io_hdr;
struct bsg_job;

#define BLKDEV_MIN_RQ	4
#define BLKDEV_MAX_RQ	128	/* Default maximum */

struct request;
typedef void (rq_end_io_fn)(struct request *, int);

/*
 * request command types
 */
enum rq_cmd_type_bits {
	REQ_TYPE_FS		= 1,	/* fs request */
	REQ_TYPE_BLOCK_PC,		/* scsi command */
	REQ_TYPE_SENSE,			/* sense request */
	REQ_TYPE_PM_SUSPEND,		/* suspend request */
	REQ_TYPE_PM_RESUME,		/* resume request */
	REQ_TYPE_PM_SHUTDOWN,		/* shutdown request */
	REQ_TYPE_SPECIAL,		/* driver defined type */
	/*
	 * for ATA/ATAPI devices. this really doesn't belong here, ide should
	 * use REQ_TYPE_SPECIAL and use rq->cmd[0] with the range of driver
	 * private REQ_LB opcodes to differentiate what type of request this is
	 */
	REQ_TYPE_ATA_TASKFILE,
	REQ_TYPE_ATA_PC,
};

#define BLK_MAX_CDB	16

/*
 * try to put the fields that are referenced together in the same cacheline.
 * if you modify this structure, be sure to check block/blk-core.c:blk_rq_init()
 * as well!
 */
struct request {
	struct list_head queuelist;
	struct call_single_data csd;

	struct blk_queue_ctx *queue_ctx;

	unsigned int cmd_flags;
	enum rq_cmd_type_bits cmd_type;
	unsigned long atomic_flags;

	int cpu;

	/* the following two fields are internal, NEVER access directly */
	unsigned int __data_len;	/* total data len */
	sector_t __sector;		/* sector cursor */

	struct bio *bio;
	struct bio *biotail;

	struct hlist_node hash;	/* merge hash */
	/*
	 * The rb_node is only used inside the io scheduler, requests
	 * are pruned when moved to the dispatch queue. So let the
	 * completion_data share space with the rb_node.
	 */
	union {
		struct rb_node rb_node;	/* sort/lookup */
		void *completion_data;
	};

	/*
	 * Three pointers are available for the IO schedulers, if they need
	 * more they have to dynamically allocate it.  Flush requests are
	 * never put on the IO scheduler. So let the flush fields share
	 * space with the elevator data.
	 */
	union {
		struct {
			struct io_cq		*icq;
			void			*priv[2];
		} elv;

		struct {
			unsigned int		seq;
			struct list_head	list;
			rq_end_io_fn		*saved_end_io;
		} flush;
	};

	struct gendisk *rq_disk;
	struct hd_struct *part;
	unsigned long start_time;
#ifdef CONFIG_BLK_CGROUP
	unsigned long long start_time_ns;
	unsigned long long io_start_time_ns;    /* when passed to hardware */
#endif
	/* Number of scatter-gather DMA addr+len pairs after
	 * physical address coalescing is performed.
	 */
	unsigned short nr_phys_segments;
#if defined(CONFIG_BLK_DEV_INTEGRITY)
	unsigned short nr_integrity_segments;
#endif

	unsigned short ioprio;

	int ref_count;

	void *special;		/* opaque pointer available for LLD use */
	char *buffer;		/* kaddr of the current segment if available */

	int tag;
	int errors;

	/*
	 * when request is used as a packet command carrier
	 */
	unsigned char __cmd[BLK_MAX_CDB];
	unsigned char *cmd;
	unsigned short cmd_len;

	unsigned int extra_len;	/* length of alignment and padding */
	unsigned int sense_len;
	unsigned int resid_len;	/* residual count */
	void *sense;

	unsigned long deadline;
	struct list_head timeout_list;
	unsigned int timeout;
	int retries;

	/*
	 * completion callback.
	 */
	rq_end_io_fn *end_io;
	void *end_io_data;

	/* for bidi */
	struct request *next_rq;
};

static inline unsigned short req_get_ioprio(struct request *req)
{
	return req->ioprio;
}

/*
 * State information carried for REQ_TYPE_PM_SUSPEND and REQ_TYPE_PM_RESUME
 * requests. Some step values could eventually be made generic.
 */
struct request_pm_state
{
	/* PM state machine step value, currently driver specific */
	int	pm_step;
	/* requested PM state value (S1, S2, S3, S4, ...) */
	u32	pm_state;
	void*	data;		/* for driver use */
};

#include <linux/elevator.h>

typedef void (request_fn_proc) (struct request_queue *q);
typedef void (make_request_fn) (struct request_queue *q, struct bio *bio);
typedef int (prep_rq_fn) (struct request_queue *, struct request *);
typedef void (unprep_rq_fn) (struct request_queue *, struct request *);

struct bio_vec;
struct bvec_merge_data {
	struct block_device *bi_bdev;
	sector_t bi_sector;
	unsigned bi_size;
	unsigned long bi_rw;
};
typedef int (merge_bvec_fn) (struct request_queue *, struct bvec_merge_data *,
			     struct bio_vec *);
typedef void (softirq_done_fn)(struct request *);
typedef int (dma_drain_needed_fn)(struct request *);
typedef int (lld_busy_fn) (struct request_queue *q);
typedef int (bsg_job_fn) (struct bsg_job *);

enum blk_eh_timer_return {
	BLK_EH_NOT_HANDLED,
	BLK_EH_HANDLED,
	BLK_EH_RESET_TIMER,
};

typedef enum blk_eh_timer_return (rq_timed_out_fn)(struct request *);

enum blk_queue_state {
	Queue_down,
	Queue_up,
};

struct blk_queue_tag {
	struct request **tag_index;	/* map of busy tags */
	unsigned long *tag_map;		/* bit map of free/busy tags */
	int busy;			/* current depth */
	int max_depth;			/* what we will send to device */
	int real_max_depth;		/* what the array can hold */
	atomic_t refcnt;		/* map can be shared */
};

#define BLK_SCSI_MAX_CMDS	(256)
#define BLK_SCSI_CMD_PER_LONG	(BLK_SCSI_MAX_CMDS / (sizeof(long) * 8))

struct queue_limits {
	unsigned long		bounce_pfn;
	unsigned long		seg_boundary_mask;

	unsigned int		max_hw_sectors;
	unsigned int		max_sectors;
	unsigned int		max_segment_size;
	unsigned int		physical_block_size;
	unsigned int		alignment_offset;
	unsigned int		io_min;
	unsigned int		io_opt;
	unsigned int		max_discard_sectors;
	unsigned int		discard_granularity;
	unsigned int		discard_alignment;

	unsigned short		logical_block_size;
	unsigned short		max_segments;
	unsigned short		max_integrity_segments;

	unsigned char		misaligned;
	unsigned char		discard_misaligned;
	unsigned char		cluster;
	unsigned char		discard_zeroes_data;
};

struct request_queue {
	/*
	 * Together with queue_head for cacheline sharing
	 */
	struct list_head	queue_head;
	struct elevator_queue	*elevator;

	struct blk_queue_ctx	*queue_ctx;
	unsigned int		nr_queues;

	mempool_t		*rq_pool;

	request_fn_proc		*request_fn;
	make_request_fn		*make_request_fn;
	prep_rq_fn		*prep_rq_fn;
	unprep_rq_fn		*unprep_rq_fn;
	merge_bvec_fn		*merge_bvec_fn;
	softirq_done_fn		*softirq_done_fn;
	rq_timed_out_fn		*rq_timed_out_fn;
	dma_drain_needed_fn	*dma_drain_needed;
	lld_busy_fn		*lld_busy_fn;

	/*
	 * Dispatch queue sorting
	 */
	sector_t		end_sector;
	struct request		*boundary_rq;

	/*
	 * Delayed queue handling
	 */
	struct delayed_work	delay_work;

	struct backing_dev_info	backing_dev_info;

	/*
	 * The queue owner gets to use this for whatever they like.
	 * ll_rw_blk doesn't touch it.
	 */
	void			*queuedata;

	/*
	 * various queue flags, see QUEUE_* below
	 */
	unsigned long		queue_flags;

	/*
	 * ida allocated id for this queue.  Used to index queues from
	 * ioctx.
	 */
	int			id;

	/*
	 * queue needs bounce pages for pages above this limit
	 */
	gfp_t			bounce_gfp;

	/*
	 * protects queue structures from reentrancy. ->__queue_lock should
	 * _never_ be used directly, it is queue private. always use
	 * ->queue_lock.
	 */
	spinlock_t		__queue_lock;
	spinlock_t		*queue_lock;

	/*
	 * queue kobject
	 */
	struct kobject kobj;

	/*
	 * queue settings
	 */
	unsigned long		nr_requests;	/* Max # of requests */
	unsigned int		nr_congestion_on;
	unsigned int		nr_congestion_off;

	unsigned int		dma_drain_size;
	void			*dma_drain_buffer;
	unsigned int		dma_pad_mask;
	unsigned int		dma_alignment;

	struct blk_queue_tag	*queue_tags;
	struct list_head	tag_busy_list;

	unsigned int		rq_timeout;
	struct timer_list	timeout;

	struct list_head	icq_list;

	struct queue_limits	limits;

	/*
	 * sg stuff
	 */
	unsigned int		sg_timeout;
	unsigned int		sg_reserved_size;
	int			node;
#ifdef CONFIG_BLK_DEV_IO_TRACE
	struct blk_trace	*blk_trace;
#endif
	/*
	 * for flush operations
	 */
	unsigned int		flush_flags;
	unsigned int		flush_not_queueable:1;
	unsigned int		flush_queue_delayed:1;
	unsigned int		flush_pending_idx:1;
	unsigned int		flush_running_idx:1;
	unsigned long		flush_pending_since;
	struct list_head	flush_queue[2];
	struct list_head	flush_data_in_flight;
	struct request		flush_rq;

	struct mutex		sysfs_lock;

#if defined(CONFIG_BLK_DEV_BSG)
	bsg_job_fn		*bsg_job_fn;
	int			bsg_job_size;
	struct bsg_class_device bsg_dev;
#endif

#ifdef CONFIG_BLK_DEV_THROTTLING
	/* Throttle data */
	struct throtl_data *td;
#endif
};

#define QUEUE_FLAG_QUEUED	1	/* uses generic tag queueing */
#define QUEUE_FLAG_STOPPED	2	/* queue is stopped */
#define	QUEUE_FLAG_SYNCFULL	3	/* read queue has been filled */
#define QUEUE_FLAG_ASYNCFULL	4	/* write queue has been filled */
#define QUEUE_FLAG_DEAD		5	/* queue being torn down */
#define QUEUE_FLAG_ELVSWITCH	6	/* don't use elevator, just do FIFO */
#define QUEUE_FLAG_BIDI		7	/* queue supports bidi requests */
#define QUEUE_FLAG_NOMERGES     8	/* disable merge attempts */
#define QUEUE_FLAG_SAME_COMP	9	/* complete on same CPU-group */
#define QUEUE_FLAG_FAIL_IO     10	/* fake timeout */
#define QUEUE_FLAG_STACKABLE   11	/* supports request stacking */
#define QUEUE_FLAG_NONROT      12	/* non-rotational device (SSD) */
#define QUEUE_FLAG_VIRT        QUEUE_FLAG_NONROT /* paravirt device */
#define QUEUE_FLAG_IO_STAT     13	/* do IO stats */
#define QUEUE_FLAG_DISCARD     14	/* supports DISCARD */
#define QUEUE_FLAG_NOXMERGES   15	/* No extended merges */
#define QUEUE_FLAG_ADD_RANDOM  16	/* Contributes to random pool */
#define QUEUE_FLAG_SECDISCARD  17	/* supports SECDISCARD */
#define QUEUE_FLAG_SAME_FORCE  18	/* force complete on same CPU */

#define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
				 (1 << QUEUE_FLAG_STACKABLE)	|	\
				 (1 << QUEUE_FLAG_SAME_COMP)	|	\
				 (1 << QUEUE_FLAG_ADD_RANDOM))

static inline void queue_lockdep_assert_held(struct request_queue *q)
{
	if (q->queue_lock)
		lockdep_assert_held(q->queue_lock);
}

static inline void queue_flag_set_unlocked(unsigned int flag,
					   struct request_queue *q)
{
	__set_bit(flag, &q->queue_flags);
}

static inline int queue_flag_test_and_clear(unsigned int flag,
					    struct request_queue *q)
{
	queue_lockdep_assert_held(q);

	if (test_bit(flag, &q->queue_flags)) {
		__clear_bit(flag, &q->queue_flags);
		return 1;
	}

	return 0;
}

static inline int queue_flag_test_and_set(unsigned int flag,
					  struct request_queue *q)
{
	queue_lockdep_assert_held(q);

	if (!test_bit(flag, &q->queue_flags)) {
		__set_bit(flag, &q->queue_flags);
		return 0;
	}

	return 1;
}

static inline void queue_flag_set(unsigned int flag, struct request_queue *q)
{
	queue_lockdep_assert_held(q);
	__set_bit(flag, &q->queue_flags);
}

static inline void queue_flag_clear_unlocked(unsigned int flag,
					     struct request_queue *q)
{
	__clear_bit(flag, &q->queue_flags);
}

static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
{
	queue_lockdep_assert_held(q);
	__clear_bit(flag, &q->queue_flags);
}

#define blk_queue_tagged(q)	test_bit(QUEUE_FLAG_QUEUED, &(q)->queue_flags)
#define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
#define blk_queue_dead(q)	test_bit(QUEUE_FLAG_DEAD, &(q)->queue_flags)
#define blk_queue_nomerges(q)	test_bit(QUEUE_FLAG_NOMERGES, &(q)->queue_flags)
#define blk_queue_noxmerges(q)	\
	test_bit(QUEUE_FLAG_NOXMERGES, &(q)->queue_flags)
#define blk_queue_nonrot(q)	test_bit(QUEUE_FLAG_NONROT, &(q)->queue_flags)
#define blk_queue_io_stat(q)	test_bit(QUEUE_FLAG_IO_STAT, &(q)->queue_flags)
#define blk_queue_add_random(q)	test_bit(QUEUE_FLAG_ADD_RANDOM, &(q)->queue_flags)
#define blk_queue_stackable(q)	\
	test_bit(QUEUE_FLAG_STACKABLE, &(q)->queue_flags)
#define blk_queue_discard(q)	test_bit(QUEUE_FLAG_DISCARD, &(q)->queue_flags)
#define blk_queue_secdiscard(q)	(blk_queue_discard(q) && \
	test_bit(QUEUE_FLAG_SECDISCARD, &(q)->queue_flags))

#define blk_noretry_request(rq) \
	((rq)->cmd_flags & (REQ_FAILFAST_DEV|REQ_FAILFAST_TRANSPORT| \
			     REQ_FAILFAST_DRIVER))

#define blk_account_rq(rq) \
	(((rq)->cmd_flags & REQ_STARTED) && \
	 ((rq)->cmd_type == REQ_TYPE_FS || \
	  ((rq)->cmd_flags & REQ_DISCARD)))

#define blk_pm_request(rq)	\
	((rq)->cmd_type == REQ_TYPE_PM_SUSPEND || \
	 (rq)->cmd_type == REQ_TYPE_PM_RESUME)

#define blk_rq_cpu_valid(rq)	((rq)->cpu != -1)
#define blk_bidi_rq(rq)		((rq)->next_rq != NULL)
/* rq->queuelist of dequeued request must be list_empty() */
#define blk_queued_rq(rq)	(!list_empty(&(rq)->queuelist))

#define list_entry_rq(ptr)	list_entry((ptr), struct request, queuelist)

#define rq_data_dir(rq)		((rq)->cmd_flags & 1)

static inline unsigned int blk_queue_cluster(struct request_queue *q)
{
	return q->limits.cluster;
}

/*
 * We regard a request as sync, if either a read or a sync write
 */
static inline bool rw_is_sync(unsigned int rw_flags)
{
	return !(rw_flags & REQ_WRITE) || (rw_flags & REQ_SYNC);
}

static inline bool rq_is_sync(struct request *rq)
{
	return rw_is_sync(rq->cmd_flags);
}

static inline int blk_queue_full(struct request_queue *q, int sync)
{
	if (sync)
		return test_bit(QUEUE_FLAG_SYNCFULL, &q->queue_flags);
	return test_bit(QUEUE_FLAG_ASYNCFULL, &q->queue_flags);
}

static inline void blk_set_queue_full(struct request_queue *q, int sync)
{
	if (sync)
		queue_flag_set(QUEUE_FLAG_SYNCFULL, q);
	else
		queue_flag_set(QUEUE_FLAG_ASYNCFULL, q);
}

static inline void blk_clear_queue_full(struct request_queue *q, int sync)
{
	if (sync)
		queue_flag_clear(QUEUE_FLAG_SYNCFULL, q);
	else
		queue_flag_clear(QUEUE_FLAG_ASYNCFULL, q);
}


/*
 * mergeable request must not have _NOMERGE or _BARRIER bit set, nor may
 * it already be started by driver.
 */
#define RQ_NOMERGE_FLAGS	\
	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA)
#define rq_mergeable(rq)	\
	(!((rq)->cmd_flags & RQ_NOMERGE_FLAGS) && \
	 (((rq)->cmd_flags & REQ_DISCARD) || \
	  (rq)->cmd_type == REQ_TYPE_FS))

/*
 * q->prep_rq_fn return values
 */
#define BLKPREP_OK		0	/* serve it */
#define BLKPREP_KILL		1	/* fatal error, kill */
#define BLKPREP_DEFER		2	/* leave on queue */

extern unsigned long blk_max_low_pfn, blk_max_pfn;

/*
 * standard bounce addresses:
 *
 * BLK_BOUNCE_HIGH	: bounce all highmem pages
 * BLK_BOUNCE_ANY	: don't bounce anything
 * BLK_BOUNCE_ISA	: bounce pages above ISA DMA boundary
 */

#if BITS_PER_LONG == 32
#define BLK_BOUNCE_HIGH		((u64)blk_max_low_pfn << PAGE_SHIFT)
#else
#define BLK_BOUNCE_HIGH		-1ULL
#endif
#define BLK_BOUNCE_ANY		(-1ULL)
#define BLK_BOUNCE_ISA		(DMA_BIT_MASK(24))

/*
 * default timeout for SG_IO if none specified
 */
#define BLK_DEFAULT_SG_TIMEOUT	(60 * HZ)
#define BLK_MIN_SG_TIMEOUT	(7 * HZ)

#ifdef CONFIG_BOUNCE
extern int init_emergency_isa_pool(void);
extern void blk_queue_bounce(struct request_queue *q, struct bio **bio);
#else
static inline int init_emergency_isa_pool(void)
{
	return 0;
}
static inline void blk_queue_bounce(struct request_queue *q, struct bio **bio)
{
}
#endif /* CONFIG_MMU */

struct rq_map_data {
	struct page **pages;
	int page_order;
	int nr_entries;
	unsigned long offset;
	int null_mapped;
	int from_user;
};

struct req_iterator {
	int i;
	struct bio *bio;
};

/* This should not be used directly - use rq_for_each_segment */
#define for_each_bio(_bio)		\
	for (; _bio; _bio = _bio->bi_next)
#define __rq_for_each_bio(_bio, rq)	\
	if ((rq->bio))			\
		for (_bio = (rq)->bio; _bio; _bio = _bio->bi_next)

#define rq_for_each_segment(bvl, _rq, _iter)			\
	__rq_for_each_bio(_iter.bio, _rq)			\
		bio_for_each_segment(bvl, _iter.bio, _iter.i)

#define rq_iter_last(rq, _iter)					\
		(_iter.bio->bi_next == NULL && _iter.i == _iter.bio->bi_vcnt-1)

#ifndef ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
# error	"You should define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE for your platform"
#endif
#if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
extern void rq_flush_dcache_pages(struct request *rq);
#else
static inline void rq_flush_dcache_pages(struct request *rq)
{
}
#endif

extern int blk_register_queue(struct gendisk *disk);
extern void blk_unregister_queue(struct gendisk *disk);
extern void generic_make_request(struct bio *bio);
extern void blk_rq_init(struct blk_queue_ctx *ctx, struct request *rq);
extern void blk_put_request(struct request *);
extern void __blk_put_request(struct request *);
extern struct request *blk_get_request(struct request_queue *, int, gfp_t);
extern struct request *blk_make_request(struct request_queue *, struct bio *,
					gfp_t);
extern void blk_requeue_request(struct request_queue *, struct request *);
extern void blk_add_request_payload(struct request *rq, struct page *page,
		unsigned int len);
extern int blk_rq_check_limits(struct request_queue *q, struct request *rq);
extern int blk_lld_busy(struct request_queue *q);
extern int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
			     struct bio_set *bs, gfp_t gfp_mask,
			     int (*bio_ctr)(struct bio *, struct bio *, void *),
			     void *data);
extern void blk_rq_unprep_clone(struct request *rq);
extern int blk_insert_cloned_request(struct request_queue *q,
				     struct request *rq);
extern void blk_delay_queue(struct request_queue *, unsigned long);
extern void blk_recount_segments(struct request_queue *, struct bio *);
extern int scsi_verify_blk_ioctl(struct block_device *, unsigned int);
extern int scsi_cmd_blk_ioctl(struct block_device *, fmode_t,
			      unsigned int, void __user *);
extern int scsi_cmd_ioctl(struct request_queue *, struct gendisk *, fmode_t,
			  unsigned int, void __user *);
extern int sg_scsi_ioctl(struct request_queue *, struct gendisk *, fmode_t,
			 struct scsi_ioctl_command __user *);

extern void blk_queue_bio(struct request_queue *q, struct bio *bio);

/*
 * A queue has just exitted congestion.  Note this in the global counter of
 * congested queues, and wake up anyone who was waiting for requests to be
 * put back.
 */
static inline void blk_clear_queue_congested(struct request_queue *q, int sync)
{
	clear_bdi_congested(&q->backing_dev_info, sync);
}

/*
 * A queue has just entered congestion.  Flag that in the queue's VM-visible
 * state flags and increment the global gounter of congested queues.
 */
static inline void blk_set_queue_congested(struct request_queue *q, int sync)
{
	set_bdi_congested(&q->backing_dev_info, sync);
}

extern void blk_start_queue(struct request_queue *q);
extern void blk_stop_queue(struct request_queue *q);
extern void blk_sync_queue(struct request_queue *q);
extern void __blk_stop_queue(struct request_queue *q);
extern void __blk_run_queue(struct request_queue *q);
extern void blk_run_queue(struct request_queue *);
extern void blk_run_queue_async(struct request_queue *q);
extern int blk_rq_map_user(struct request_queue *, struct request *,
			   struct rq_map_data *, void __user *, unsigned long,
			   gfp_t);
extern int blk_rq_unmap_user(struct bio *);
extern int blk_rq_map_kern(struct request_queue *, struct request *, void *, unsigned int, gfp_t);
extern int blk_rq_map_user_iov(struct request_queue *, struct request *,
			       struct rq_map_data *, struct sg_iovec *, int,
			       unsigned int, gfp_t);
extern int blk_execute_rq(struct request_queue *, struct gendisk *,
			  struct request *, int);
extern void blk_execute_rq_nowait(struct request_queue *, struct gendisk *,
				  struct request *, int, rq_end_io_fn *);

static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
{
	return bdev->bd_disk->queue;
}

/*
 * blk_rq_pos()			: the current sector
 * blk_rq_bytes()		: bytes left in the entire request
 * blk_rq_cur_bytes()		: bytes left in the current segment
 * blk_rq_err_bytes()		: bytes left till the next error boundary
 * blk_rq_sectors()		: sectors left in the entire request
 * blk_rq_cur_sectors()		: sectors left in the current segment
 */
static inline sector_t blk_rq_pos(const struct request *rq)
{
	return rq->__sector;
}

static inline unsigned int blk_rq_bytes(const struct request *rq)
{
	return rq->__data_len;
}

static inline int blk_rq_cur_bytes(const struct request *rq)
{
	return rq->bio ? bio_cur_bytes(rq->bio) : 0;
}

extern unsigned int blk_rq_err_bytes(const struct request *rq);

static inline unsigned int blk_rq_sectors(const struct request *rq)
{
	return blk_rq_bytes(rq) >> 9;
}

static inline unsigned int blk_rq_cur_sectors(const struct request *rq)
{
	return blk_rq_cur_bytes(rq) >> 9;
}

/*
 * Request issue related functions.
 */
extern struct request *blk_peek_request(struct request_queue *q);
extern void blk_start_request(struct request *rq);
extern struct request *blk_fetch_request(struct request_queue *q);

/*
 * Request completion related functions.
 *
 * blk_update_request() completes given number of bytes and updates
 * the request without completing it.
 *
 * blk_end_request() and friends.  __blk_end_request() must be called
 * with the request queue spinlock acquired.
 *
 * Several drivers define their own end_request and call
 * blk_end_request() for parts of the original function.
 * This prevents code duplication in drivers.
 */
extern bool blk_update_request(struct request *rq, int error,
			       unsigned int nr_bytes);
extern bool blk_end_request(struct request *rq, int error,
			    unsigned int nr_bytes);
extern void blk_end_request_all(struct request *rq, int error);
extern bool blk_end_request_cur(struct request *rq, int error);
extern bool blk_end_request_err(struct request *rq, int error);
extern bool __blk_end_request(struct request *rq, int error,
			      unsigned int nr_bytes);
extern void __blk_end_request_all(struct request *rq, int error);
extern bool __blk_end_request_cur(struct request *rq, int error);
extern bool __blk_end_request_err(struct request *rq, int error);

extern void blk_complete_request(struct request *);
extern void __blk_complete_request(struct request *);
extern void blk_abort_request(struct request *);
extern void blk_abort_queue(struct request_queue *);
extern void blk_unprep_request(struct request *);

/*
 * Access functions for manipulating queue properties
 */
extern struct request_queue *blk_init_queue_node(request_fn_proc *rfn,
					spinlock_t *lock, int node_id,
					unsigned int nr_queues);
extern struct request_queue *blk_init_queue(request_fn_proc *, spinlock_t *);
extern struct request_queue *blk_init_allocated_queue(struct request_queue *,
						      request_fn_proc *, spinlock_t *);
extern void blk_cleanup_queue(struct request_queue *);
extern void blk_queue_make_request(struct request_queue *, make_request_fn *);
extern void blk_queue_bounce_limit(struct request_queue *, u64);
extern void blk_limits_max_hw_sectors(struct queue_limits *, unsigned int);
extern void blk_queue_max_hw_sectors(struct request_queue *, unsigned int);
extern void blk_queue_max_segments(struct request_queue *, unsigned short);
extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
extern void blk_queue_max_discard_sectors(struct request_queue *q,
		unsigned int max_discard_sectors);
extern void blk_queue_logical_block_size(struct request_queue *, unsigned short);
extern void blk_queue_physical_block_size(struct request_queue *, unsigned int);
extern void blk_queue_alignment_offset(struct request_queue *q,
				       unsigned int alignment);
extern void blk_limits_io_min(struct queue_limits *limits, unsigned int min);
extern void blk_queue_io_min(struct request_queue *q, unsigned int min);
extern void blk_limits_io_opt(struct queue_limits *limits, unsigned int opt);
extern void blk_queue_io_opt(struct request_queue *q, unsigned int opt);
extern void blk_set_default_limits(struct queue_limits *lim);
extern void blk_set_stacking_limits(struct queue_limits *lim);
extern int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
			    sector_t offset);
extern int bdev_stack_limits(struct queue_limits *t, struct block_device *bdev,
			    sector_t offset);
extern void disk_stack_limits(struct gendisk *disk, struct block_device *bdev,
			      sector_t offset);
extern void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b);
extern void blk_queue_dma_pad(struct request_queue *, unsigned int);
extern void blk_queue_update_dma_pad(struct request_queue *, unsigned int);
extern int blk_queue_dma_drain(struct request_queue *q,
			       dma_drain_needed_fn *dma_drain_needed,
			       void *buf, unsigned int size);
extern void blk_queue_lld_busy(struct request_queue *q, lld_busy_fn *fn);
extern void blk_queue_segment_boundary(struct request_queue *, unsigned long);
extern void blk_queue_prep_rq(struct request_queue *, prep_rq_fn *pfn);
extern void blk_queue_unprep_rq(struct request_queue *, unprep_rq_fn *ufn);
extern void blk_queue_merge_bvec(struct request_queue *, merge_bvec_fn *);
extern void blk_queue_dma_alignment(struct request_queue *, int);
extern void blk_queue_update_dma_alignment(struct request_queue *, int);
extern void blk_queue_softirq_done(struct request_queue *, softirq_done_fn *);
extern void blk_queue_rq_timed_out(struct request_queue *, rq_timed_out_fn *);
extern void blk_queue_rq_timeout(struct request_queue *, unsigned int);
extern void blk_queue_flush(struct request_queue *q, unsigned int flush);
extern void blk_queue_flush_queueable(struct request_queue *q, bool queueable);
extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);

extern int blk_rq_map_sg(struct request *, struct scatterlist *);
extern void blk_dump_rq_flags(struct request *, char *);
extern long nr_blockdev_pages(void);

bool __must_check blk_get_queue(struct request_queue *);
struct request_queue *blk_alloc_queue(gfp_t);
struct request_queue *blk_alloc_queue_node(gfp_t, int, unsigned int);
extern void blk_put_queue(struct request_queue *);

/*
 * blk_plug permits building a queue of related requests by holding the I/O
 * fragments for a short period. This allows merging of sequential requests
 * into single larger request. As the requests are moved from a per-task list to
 * the device's request_queue in a batch, this results in improved scalability
 * as the lock contention for request_queue lock is reduced.
 *
 * It is ok not to disable preemption when adding the request to the plug list
 * or when attempting a merge, because blk_schedule_flush_list() will only flush
 * the plug list when the task sleeps by itself. For details, please see
 * schedule() where blk_schedule_flush_plug() is called.
 */
struct blk_plug {
	unsigned long magic; /* detect uninitialized use-cases */
	struct list_head list; /* requests */
	struct list_head cb_list; /* md requires an unplug callback */
	unsigned int should_sort; /* list to be sorted before flushing? */
};
#define BLK_MAX_REQUEST_COUNT 16

struct blk_plug_cb {
	struct list_head list;
	void (*callback)(struct blk_plug_cb *);
};

extern void blk_start_plug(struct blk_plug *);
extern void blk_finish_plug(struct blk_plug *);
extern void blk_flush_plug_list(struct blk_plug *, bool);

static inline void blk_flush_plug(struct task_struct *tsk)
{
	struct blk_plug *plug = tsk->plug;

	if (plug)
		blk_flush_plug_list(plug, false);
}

static inline void blk_schedule_flush_plug(struct task_struct *tsk)
{
	struct blk_plug *plug = tsk->plug;

	if (plug)
		blk_flush_plug_list(plug, true);
}

static inline bool blk_needs_flush_plug(struct task_struct *tsk)
{
	struct blk_plug *plug = tsk->plug;

	return plug && (!list_empty(&plug->list) || !list_empty(&plug->cb_list));
}

/*
 * tag stuff
 */
#define blk_rq_tagged(rq)		((rq)->cmd_flags & REQ_QUEUED)
extern int blk_queue_start_tag(struct request_queue *, struct request *);
extern struct request *blk_queue_find_tag(struct request_queue *, int);
extern void blk_queue_end_tag(struct request_queue *, struct request *);
extern int blk_queue_init_tags(struct request_queue *, int, struct blk_queue_tag *);
extern void blk_queue_free_tags(struct request_queue *);
extern int blk_queue_resize_tags(struct request_queue *, int);
extern void blk_queue_invalidate_tags(struct request_queue *);
extern struct blk_queue_tag *blk_init_tags(int);
extern void blk_free_tags(struct blk_queue_tag *);

static inline struct request *blk_map_queue_find_tag(struct blk_queue_tag *bqt,
						int tag)
{
	if (unlikely(bqt == NULL || tag >= bqt->real_max_depth))
		return NULL;
	return bqt->tag_index[tag];
}

#define BLKDEV_DISCARD_SECURE  0x01    /* secure discard */

extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *);
extern int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags);
extern int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
			sector_t nr_sects, gfp_t gfp_mask);
static inline int sb_issue_discard(struct super_block *sb, sector_t block,
		sector_t nr_blocks, gfp_t gfp_mask, unsigned long flags)
{
	return blkdev_issue_discard(sb->s_bdev, block << (sb->s_blocksize_bits - 9),
				    nr_blocks << (sb->s_blocksize_bits - 9),
				    gfp_mask, flags);
}
static inline int sb_issue_zeroout(struct super_block *sb, sector_t block,
		sector_t nr_blocks, gfp_t gfp_mask)
{
	return blkdev_issue_zeroout(sb->s_bdev,
				    block << (sb->s_blocksize_bits - 9),
				    nr_blocks << (sb->s_blocksize_bits - 9),
				    gfp_mask);
}

extern int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm);

enum blk_default_limits {
	BLK_MAX_SEGMENTS	= 128,
	BLK_SAFE_MAX_SECTORS	= 255,
	BLK_DEF_MAX_SECTORS	= 1024,
	BLK_MAX_SEGMENT_SIZE	= 65536,
	BLK_SEG_BOUNDARY_MASK	= 0xFFFFFFFFUL,
};

#define blkdev_entry_to_request(entry) list_entry((entry), struct request, queuelist)

static inline unsigned long queue_bounce_pfn(struct request_queue *q)
{
	return q->limits.bounce_pfn;
}

static inline unsigned long queue_segment_boundary(struct request_queue *q)
{
	return q->limits.seg_boundary_mask;
}

static inline unsigned int queue_max_sectors(struct request_queue *q)
{
	return q->limits.max_sectors;
}

static inline unsigned int queue_max_hw_sectors(struct request_queue *q)
{
	return q->limits.max_hw_sectors;
}

static inline unsigned short queue_max_segments(struct request_queue *q)
{
	return q->limits.max_segments;
}

static inline unsigned int queue_max_segment_size(struct request_queue *q)
{
	return q->limits.max_segment_size;
}

static inline unsigned short queue_logical_block_size(struct request_queue *q)
{
	int retval = 512;

	if (q && q->limits.logical_block_size)
		retval = q->limits.logical_block_size;

	return retval;
}

static inline unsigned short bdev_logical_block_size(struct block_device *bdev)
{
	return queue_logical_block_size(bdev_get_queue(bdev));
}

static inline unsigned int queue_physical_block_size(struct request_queue *q)
{
	return q->limits.physical_block_size;
}

static inline unsigned int bdev_physical_block_size(struct block_device *bdev)
{
	return queue_physical_block_size(bdev_get_queue(bdev));
}

static inline unsigned int queue_io_min(struct request_queue *q)
{
	return q->limits.io_min;
}

static inline int bdev_io_min(struct block_device *bdev)
{
	return queue_io_min(bdev_get_queue(bdev));
}

static inline unsigned int queue_io_opt(struct request_queue *q)
{
	return q->limits.io_opt;
}

static inline int bdev_io_opt(struct block_device *bdev)
{
	return queue_io_opt(bdev_get_queue(bdev));
}

static inline int queue_alignment_offset(struct request_queue *q)
{
	if (q->limits.misaligned)
		return -1;

	return q->limits.alignment_offset;
}

static inline int queue_limit_alignment_offset(struct queue_limits *lim, sector_t sector)
{
	unsigned int granularity = max(lim->physical_block_size, lim->io_min);
	unsigned int alignment = (sector << 9) & (granularity - 1);

	return (granularity + lim->alignment_offset - alignment)
		& (granularity - 1);
}

static inline int bdev_alignment_offset(struct block_device *bdev)
{
	struct request_queue *q = bdev_get_queue(bdev);

	if (q->limits.misaligned)
		return -1;

	if (bdev != bdev->bd_contains)
		return bdev->bd_part->alignment_offset;

	return q->limits.alignment_offset;
}

static inline int queue_discard_alignment(struct request_queue *q)
{
	if (q->limits.discard_misaligned)
		return -1;

	return q->limits.discard_alignment;
}

static inline int queue_limit_discard_alignment(struct queue_limits *lim, sector_t sector)
{
	unsigned int alignment = (sector << 9) & (lim->discard_granularity - 1);

	if (!lim->max_discard_sectors)
		return 0;

	return (lim->discard_granularity + lim->discard_alignment - alignment)
		& (lim->discard_granularity - 1);
}

static inline unsigned int queue_discard_zeroes_data(struct request_queue *q)
{
	if (q->limits.max_discard_sectors && q->limits.discard_zeroes_data == 1)
		return 1;

	return 0;
}

static inline unsigned int bdev_discard_zeroes_data(struct block_device *bdev)
{
	return queue_discard_zeroes_data(bdev_get_queue(bdev));
}

static inline int queue_dma_alignment(struct request_queue *q)
{
	return q ? q->dma_alignment : 511;
}

static inline int blk_rq_aligned(struct request_queue *q, unsigned long addr,
				 unsigned int len)
{
	unsigned int alignment = queue_dma_alignment(q) | q->dma_pad_mask;
	return !(addr & alignment) && !(len & alignment);
}

/* assumes size > 256 */
static inline unsigned int blksize_bits(unsigned int size)
{
	unsigned int bits = 8;
	do {
		bits++;
		size >>= 1;
	} while (size > 256);
	return bits;
}

static inline unsigned int block_size(struct block_device *bdev)
{
	return bdev->bd_block_size;
}

static inline bool queue_flush_queueable(struct request_queue *q)
{
	return !q->flush_not_queueable;
}

typedef struct {struct page *v;} Sector;

unsigned char *read_dev_sector(struct block_device *, sector_t, Sector *);

static inline void put_dev_sector(Sector p)
{
	page_cache_release(p.v);
}

struct work_struct;
int kblockd_schedule_work(struct request_queue *q, struct work_struct *work);

#ifdef CONFIG_BLK_CGROUP
/*
 * This should not be using sched_clock(). A real patch is in progress
 * to fix this up, until that is in place we need to disable preemption
 * around sched_clock() in this function and set_io_start_time_ns().
 */
static inline void set_start_time_ns(struct request *req)
{
	preempt_disable();
	req->start_time_ns = sched_clock();
	preempt_enable();
}

static inline void set_io_start_time_ns(struct request *req)
{
	preempt_disable();
	req->io_start_time_ns = sched_clock();
	preempt_enable();
}

static inline uint64_t rq_start_time_ns(struct request *req)
{
        return req->start_time_ns;
}

static inline uint64_t rq_io_start_time_ns(struct request *req)
{
        return req->io_start_time_ns;
}
#else
static inline void set_start_time_ns(struct request *req) {}
static inline void set_io_start_time_ns(struct request *req) {}
static inline uint64_t rq_start_time_ns(struct request *req)
{
	return 0;
}
static inline uint64_t rq_io_start_time_ns(struct request *req)
{
	return 0;
}
#endif

#define MODULE_ALIAS_BLOCKDEV(major,minor) \
	MODULE_ALIAS("block-major-" __stringify(major) "-" __stringify(minor))
#define MODULE_ALIAS_BLOCKDEV_MAJOR(major) \
	MODULE_ALIAS("block-major-" __stringify(major) "-*")

#if defined(CONFIG_BLK_DEV_INTEGRITY)

#define INTEGRITY_FLAG_READ	2	/* verify data integrity on read */
#define INTEGRITY_FLAG_WRITE	4	/* generate data integrity on write */

struct blk_integrity_exchg {
	void			*prot_buf;
	void			*data_buf;
	sector_t		sector;
	unsigned int		data_size;
	unsigned short		sector_size;
	const char		*disk_name;
};

typedef void (integrity_gen_fn) (struct blk_integrity_exchg *);
typedef int (integrity_vrfy_fn) (struct blk_integrity_exchg *);
typedef void (integrity_set_tag_fn) (void *, void *, unsigned int);
typedef void (integrity_get_tag_fn) (void *, void *, unsigned int);

struct blk_integrity {
	integrity_gen_fn	*generate_fn;
	integrity_vrfy_fn	*verify_fn;
	integrity_set_tag_fn	*set_tag_fn;
	integrity_get_tag_fn	*get_tag_fn;

	unsigned short		flags;
	unsigned short		tuple_size;
	unsigned short		sector_size;
	unsigned short		tag_size;

	const char		*name;

	struct kobject		kobj;
};

extern bool blk_integrity_is_initialized(struct gendisk *);
extern int blk_integrity_register(struct gendisk *, struct blk_integrity *);
extern void blk_integrity_unregister(struct gendisk *);
extern int blk_integrity_compare(struct gendisk *, struct gendisk *);
extern int blk_rq_map_integrity_sg(struct request_queue *, struct bio *,
				   struct scatterlist *);
extern int blk_rq_count_integrity_sg(struct request_queue *, struct bio *);
extern int blk_integrity_merge_rq(struct request_queue *, struct request *,
				  struct request *);
extern int blk_integrity_merge_bio(struct request_queue *, struct request *,
				   struct bio *);

static inline
struct blk_integrity *bdev_get_integrity(struct block_device *bdev)
{
	return bdev->bd_disk->integrity;
}

static inline struct blk_integrity *blk_get_integrity(struct gendisk *disk)
{
	return disk->integrity;
}

static inline int blk_integrity_rq(struct request *rq)
{
	if (rq->bio == NULL)
		return 0;

	return bio_integrity(rq->bio);
}

static inline void blk_queue_max_integrity_segments(struct request_queue *q,
						    unsigned int segs)
{
	q->limits.max_integrity_segments = segs;
}

static inline unsigned short
queue_max_integrity_segments(struct request_queue *q)
{
	return q->limits.max_integrity_segments;
}

#else /* CONFIG_BLK_DEV_INTEGRITY */

struct bio;
struct block_device;
struct gendisk;
struct blk_integrity;

static inline int blk_integrity_rq(struct request *rq)
{
	return 0;
}
static inline int blk_rq_count_integrity_sg(struct request_queue *q,
					    struct bio *b)
{
	return 0;
}
static inline int blk_rq_map_integrity_sg(struct request_queue *q,
					  struct bio *b,
					  struct scatterlist *s)
{
	return 0;
}
static inline struct blk_integrity *bdev_get_integrity(struct block_device *b)
{
	return 0;
}
static inline struct blk_integrity *blk_get_integrity(struct gendisk *disk)
{
	return NULL;
}
static inline int blk_integrity_compare(struct gendisk *a, struct gendisk *b)
{
	return 0;
}
static inline int blk_integrity_register(struct gendisk *d,
					 struct blk_integrity *b)
{
	return 0;
}
static inline void blk_integrity_unregister(struct gendisk *d)
{
}
static inline void blk_queue_max_integrity_segments(struct request_queue *q,
						    unsigned int segs)
{
}
static inline unsigned short queue_max_integrity_segments(struct request_queue *q)
{
	return 0;
}
static inline int blk_integrity_merge_rq(struct request_queue *rq,
					 struct request *r1,
					 struct request *r2)
{
	return 0;
}
static inline int blk_integrity_merge_bio(struct request_queue *rq,
					  struct request *r,
					  struct bio *b)
{
	return 0;
}
static inline bool blk_integrity_is_initialized(struct gendisk *g)
{
	return 0;
}

#endif /* CONFIG_BLK_DEV_INTEGRITY */

struct block_device_operations {
	int (*open) (struct block_device *, fmode_t);
	int (*release) (struct gendisk *, fmode_t);
	int (*ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
	int (*compat_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
	int (*direct_access) (struct block_device *, sector_t,
						void **, unsigned long *);
	unsigned int (*check_events) (struct gendisk *disk,
				      unsigned int clearing);
	/* ->media_changed() is DEPRECATED, use ->check_events() instead */
	int (*media_changed) (struct gendisk *);
	void (*unlock_native_capacity) (struct gendisk *);
	int (*revalidate_disk) (struct gendisk *);
	int (*getgeo)(struct block_device *, struct hd_geometry *);
	/* this callback is with swap_lock and sometimes page table lock held */
	void (*swap_slot_free_notify) (struct block_device *, unsigned long);
	struct module *owner;
};

extern int __blkdev_driver_ioctl(struct block_device *, fmode_t, unsigned int,
				 unsigned long);
#else /* CONFIG_BLOCK */
/*
 * stubs for when the block layer is configured out
 */
#define buffer_heads_over_limit 0

static inline long nr_blockdev_pages(void)
{
	return 0;
}

struct blk_plug {
};

static inline void blk_start_plug(struct blk_plug *plug)
{
}

static inline void blk_finish_plug(struct blk_plug *plug)
{
}

static inline void blk_flush_plug(struct task_struct *task)
{
}

static inline void blk_schedule_flush_plug(struct task_struct *task)
{
}


static inline bool blk_needs_flush_plug(struct task_struct *tsk)
{
	return false;
}

#endif /* CONFIG_BLOCK */

#endif

--=_4fd91c3f.R4ms68f5hejM12e5zdJOlaXCA5NYIvmvSlWnmiraoFWGO1Xb
Content-Type: text/x-chdr;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="elevator.h"

#ifndef _LINUX_ELEVATOR_H
#define _LINUX_ELEVATOR_H

#include <linux/percpu.h>

#ifdef CONFIG_BLOCK

struct io_cq;
struct blk_queue_ctx;

typedef int (elevator_merge_fn) (struct blk_queue_ctx *, struct request **,
				 struct bio *);

typedef void (elevator_merge_req_fn) (struct blk_queue_ctx *, struct request *, struct request *);

typedef void (elevator_merged_fn) (struct blk_queue_ctx *, struct request *, int);

typedef int (elevator_allow_merge_fn) (struct blk_queue_ctx *, struct request *, struct bio *);

typedef void (elevator_bio_merged_fn) (struct blk_queue_ctx *,
						struct request *, struct bio *);

typedef int (elevator_dispatch_fn) (struct request_queue *, int);

typedef void (elevator_add_req_fn) (struct blk_queue_ctx *, struct request *);
typedef struct request *(elevator_request_list_fn) (struct blk_queue_ctx *, struct request *);
typedef void (elevator_completed_req_fn) (struct blk_queue_ctx *, struct request *);
typedef int (elevator_may_queue_fn) (struct request_queue *, int);

typedef void (elevator_init_icq_fn) (struct io_cq *);
typedef void (elevator_exit_icq_fn) (struct io_cq *);
typedef int (elevator_set_req_fn) (struct blk_queue_ctx *, struct request *, gfp_t);
typedef void (elevator_put_req_fn) (struct request *);
typedef void (elevator_activate_req_fn) (struct request_queue *, struct request *);
typedef void (elevator_deactivate_req_fn) (struct request_queue *, struct request *);

typedef int (elevator_init_fn) (struct request_queue *, unsigned int);
typedef void (elevator_exit_fn) (struct request_queue *, struct elevator_queue *);

struct elevator_ops
{
	elevator_merge_fn *elevator_merge_fn;
	elevator_merged_fn *elevator_merged_fn;
	elevator_merge_req_fn *elevator_merge_req_fn;
	elevator_allow_merge_fn *elevator_allow_merge_fn;
	elevator_bio_merged_fn *elevator_bio_merged_fn;

	elevator_dispatch_fn *elevator_dispatch_fn;
	elevator_add_req_fn *elevator_add_req_fn;
	elevator_activate_req_fn *elevator_activate_req_fn;
	elevator_deactivate_req_fn *elevator_deactivate_req_fn;

	elevator_completed_req_fn *elevator_completed_req_fn;

	elevator_request_list_fn *elevator_former_req_fn;
	elevator_request_list_fn *elevator_latter_req_fn;

	elevator_init_icq_fn *elevator_init_icq_fn;	/* see iocontext.h */
	elevator_exit_icq_fn *elevator_exit_icq_fn;	/* ditto */

	elevator_set_req_fn *elevator_set_req_fn;
	elevator_put_req_fn *elevator_put_req_fn;

	elevator_may_queue_fn *elevator_may_queue_fn;

	elevator_init_fn *elevator_init_fn;
	elevator_exit_fn *elevator_exit_fn;
};

#define ELV_NAME_MAX	(16)

struct elv_fs_entry {
	struct attribute attr;
	ssize_t (*show)(struct elevator_queue *, char *);
	ssize_t (*store)(struct elevator_queue *, const char *, size_t);
};

/*
 * identifies an elevator type, such as AS or deadline
 */
struct elevator_type
{
	/* managed by elevator core */
	struct kmem_cache *icq_cache;

	/* fields provided by elevator implementation */
	struct elevator_ops ops;
	size_t icq_size;	/* see iocontext.h */
	size_t icq_align;	/* ditto */
	struct elv_fs_entry *elevator_attrs;
	char elevator_name[ELV_NAME_MAX];
	struct module *elevator_owner;

	/* managed by elevator core */
	char icq_cache_name[ELV_NAME_MAX + 5];	/* elvname + "_io_cq" */
	struct list_head list;
};

/*
 * each queue has an elevator_queue associated with it
 */
struct elevator_queue
{
	struct elevator_type *type;
	struct kobject kobj;
	struct mutex sysfs_lock;
	unsigned int registered:1;
};

/*
 * block elevator interface
 */
extern void elv_dispatch_sort(struct request_queue *, struct blk_queue_ctx *, struct request *);
extern void elv_dispatch_add_tail(struct request_queue *, struct blk_queue_ctx *, struct request *);
extern void elv_add_request(struct request *, int);
extern void __elv_add_request(struct request *, int);
extern void elv_insert(struct request *, int);
extern int elv_merge(struct blk_queue_ctx *, struct request **, struct bio *);
extern void elv_merge_requests(struct blk_queue_ctx *, struct request *,
			       struct request *);
extern void elv_merged_request(struct blk_queue_ctx *, struct request *, int);
extern void elv_bio_merged(struct blk_queue_ctx *q, struct request *,
				struct bio *);
extern void elv_requeue_request(struct request_queue *, struct request *);
extern struct request *elv_former_request(struct blk_queue_ctx *, struct request *);
extern struct request *elv_latter_request(struct blk_queue_ctx *, struct request *);
extern int elv_register_queue(struct request_queue *q);
extern void elv_unregister_queue(struct request_queue *q);
extern int elv_may_queue(struct request_queue *, int);
extern void elv_abort_queue(struct request_queue *);
extern void elv_completed_request(struct request *);
extern int elv_set_request(struct blk_queue_ctx *, struct request *, gfp_t);
extern void elv_put_request(struct blk_queue_ctx *, struct request *);
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
extern void elevator_exit(struct request_queue *, struct elevator_queue *);
extern int elevator_change(struct request_queue *, const char *);
extern bool elv_rq_merge_ok(struct request *, struct bio *);

/*
 * Helper functions.
 */
extern struct request *elv_rb_former_request(struct request *);
extern struct request *elv_rb_latter_request(struct request *);

/*
 * rb support functions.
 */
extern void elv_rb_add(struct rb_root *, struct request *);
extern void elv_rb_del(struct rb_root *, struct request *);
extern struct request *elv_rb_find(struct rb_root *, sector_t);

/*
 * Return values from elevator merger
 */
#define ELEVATOR_NO_MERGE	0
#define ELEVATOR_FRONT_MERGE	1
#define ELEVATOR_BACK_MERGE	2

/*
 * Insertion selection
 */
#define ELEVATOR_INSERT_FRONT	1
#define ELEVATOR_INSERT_BACK	2
#define ELEVATOR_INSERT_SORT	3
#define ELEVATOR_INSERT_REQUEUE	4
#define ELEVATOR_INSERT_FLUSH	5
#define ELEVATOR_INSERT_SORT_MERGE	6

/*
 * return values from elevator_may_queue_fn
 */
enum {
	ELV_MQUEUE_MAY,
	ELV_MQUEUE_NO,
	ELV_MQUEUE_MUST,
};

#define rq_end_sector(rq)	(blk_rq_pos(rq) + blk_rq_sectors(rq))
#define rb_entry_rq(node)	rb_entry((node), struct request, rb_node)

/*
 * Hack to reuse the csd.list list_head as the fifo time holder while
 * the request is in the io scheduler. Saves an unsigned long in rq.
 */
#define rq_fifo_time(rq)	((unsigned long) (rq)->csd.list.next)
#define rq_set_fifo_time(rq,exp)	((rq)->csd.list.next = (void *) (exp))
#define rq_entry_fifo(ptr)	list_entry((ptr), struct request, queuelist)
#define rq_fifo_clear(rq)	do {		\
	list_del_init(&(rq)->queuelist);	\
	INIT_LIST_HEAD(&(rq)->csd.list);	\
	} while (0)

#endif /* CONFIG_BLOCK */
#endif

--=_4fd91c3f.R4ms68f5hejM12e5zdJOlaXCA5NYIvmvSlWnmiraoFWGO1Xb
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=".config"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.4.0-rc3 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_KTIME_SCALAR=y
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
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
CONFIG_AUDIT_LOGINUID_IMMUTABLE=y
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_EXACT=y
CONFIG_RCU_FAST_NO_HZ=y
CONFIG_TREE_RCU_TRACE=y
CONFIG_IKCONFIG=m
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_CGROUP_MEM_RES_CTLR=y
CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED=y
CONFIG_CGROUP_MEM_RES_CTLR_KMEM=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
CONFIG_MM_OWNER=y
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
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
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
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
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_PERF_COUNTERS is not set
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=m
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
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
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_MQ is not set
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_THROTTLING=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
CONFIG_ACORN_PARTITION_EESOX=y
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
CONFIG_ACORN_PARTITION_POWERTEC=y
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
CONFIG_LDM_DEBUG=y
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y

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
CONFIG_X86_MPPARSE=y
CONFIG_X86_BIGSMP=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_WANT_INTEL_MID=y
CONFIG_X86_INTEL_MID=y
CONFIG_X86_MDFLD=y
CONFIG_X86_RDC321X=y
CONFIG_X86_32_NON_STANDARD=y
CONFIG_X86_NUMAQ=y
CONFIG_X86_SUMMIT=y
CONFIG_X86_ES7000=y
CONFIG_X86_32_IRIS=m
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_LGUEST_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_PARAVIRT_CLOCK=y
CONFIG_PARAVIRT_DEBUG=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
CONFIG_X86_SUMMIT_NUMA=y
CONFIG_X86_CYCLONE_TIMER=y
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_APB_TIMER=y
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_ANCIENT_MCE=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_VM86=y
CONFIG_TOSHIBA=m
CONFIG_I8K=m
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_HIGHMEM64G=y
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_NUMA=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=4
CONFIG_HAVE_ARCH_BOOTMEM=y
CONFIG_HAVE_ARCH_ALLOC_REMAP=y
CONFIG_ARCH_HAVE_MEMORY_PRESENT=y
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
CONFIG_ARCH_DISCONTIGMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_DISCONTIGMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_DISCONTIGMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
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
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CLEANCACHE=y
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
CONFIG_CMDLINE_BOOL=y
CONFIG_CMDLINE=""
CONFIG_CMDLINE_OVERRIDE=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
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
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_EC_DEBUGFS=m
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_DEBUG_FUNC_TRACE=y
CONFIG_ACPI_PCI_SLOT=m
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=m
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=m
CONFIG_ACPI_BGRT=m
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_EINJ=m
CONFIG_ACPI_APEI_ERST_DEBUG=m
CONFIG_SFI=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=m
CONFIG_APM_IGNORE_USER_SUSPEND=y
CONFIG_APM_DO_ENABLE=y
CONFIG_APM_CPU_IDLE=y
CONFIG_APM_DISPLAY_BLANK=y
CONFIG_APM_ALLOW_INTS=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=m
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_PCC_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_POWERNOW_K6=m
CONFIG_X86_POWERNOW_K7=m
CONFIG_X86_POWERNOW_K7_ACPI=y
CONFIG_X86_POWERNOW_K8=m
CONFIG_X86_GX_SUSPMOD=m
CONFIG_X86_SPEEDSTEP_CENTRINO=m
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=m
CONFIG_X86_SPEEDSTEP_SMI=m
CONFIG_X86_P4_CLOCKMOD=m
CONFIG_X86_CPUFREQ_NFORCE2=m
CONFIG_X86_LONGRUN=m
CONFIG_X86_LONGHAUL=m
CONFIG_X86_E_POWERSAVER=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
CONFIG_INTEL_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=m
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_DEBUG=y
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=m
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_IOAPIC=m
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
CONFIG_EISA=y
CONFIG_EISA_VLB_PRIMING=y
CONFIG_EISA_PCI_EISA=y
CONFIG_EISA_VIRTUAL_ROOT=y
CONFIG_EISA_NAMES=y
# CONFIG_MCA is not set
CONFIG_SCx200=m
CONFIG_SCx200HR_TIMER=m
CONFIG_ALIX=y
CONFIG_NET5501=y
CONFIG_GEOS=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=m
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=m
CONFIG_I82092=m
CONFIG_I82365=m
CONFIG_TCIC=m
CONFIG_PCMCIA_PROBE=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=m
CONFIG_HOTPLUG_PCI_FAKE=m
CONFIG_HOTPLUG_PCI_COMPAQ=m
CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM=y
CONFIG_HOTPLUG_PCI_IBM=m
CONFIG_HOTPLUG_PCI_ACPI=m
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=m
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=m
CONFIG_HOTPLUG_PCI_SHPC=m
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_TSI721=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_TSI57X=y
CONFIG_RAPIDIO_CPS_XX=y
CONFIG_RAPIDIO_TSI568=y
CONFIG_RAPIDIO_CPS_GEN2=y
CONFIG_RAPIDIO_TSI500=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=m
CONFIG_BINFMT_MISC=m
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_UNIX=m
CONFIG_UNIX_DIAG=m
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
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
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_ARPD=y
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=m
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_INET_UDP_DIAG=m
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=m
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_DEFAULT_RENO=y
CONFIG_DEFAULT_TCP_CONG="reno"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_ACCT=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CONNTRACK_TIMEOUT=y
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CT_PROTO_DCCP=m
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_SNMP=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NF_CT_NETLINK_TIMEOUT=m
CONFIG_NETFILTER_TPROXY=m
CONFIG_NETFILTER_XTABLES=m

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m
CONFIG_NETFILTER_XT_SET=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=m
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
CONFIG_NETFILTER_XT_TARGET_LED=m
CONFIG_NETFILTER_XT_TARGET_LOG=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_IPVS=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_NFACCT=m
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
CONFIG_IP_SET_HASH_NET=m
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
CONFIG_IP_VS_DEBUG=y
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
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_RPFILTER=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_DCCP=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_CONNTRACK_IPV6=m
# CONFIG_IP6_NF_QUEUE is not set
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RPFILTER=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=m
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_ULOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
CONFIG_IP_DCCP_CCID2_DEBUG=y
CONFIG_IP_DCCP_CCID3=y
CONFIG_IP_DCCP_CCID3_DEBUG=y
CONFIG_IP_DCCP_TFRC_LIB=y
CONFIG_IP_DCCP_TFRC_DEBUG=y

#
# DCCP Kernel Hacking
#
CONFIG_IP_DCCP_DEBUG=y
CONFIG_NET_DCCPPROBE=m
CONFIG_IP_SCTP=m
CONFIG_NET_SCTPPROBE=m
CONFIG_SCTP_DBG_MSG=y
CONFIG_SCTP_DBG_OBJCNT=y
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
CONFIG_RDS=m
CONFIG_RDS_RDMA=m
CONFIG_RDS_TCP=m
CONFIG_RDS_DEBUG=y
CONFIG_TIPC=m
CONFIG_TIPC_ADVANCED=y
CONFIG_TIPC_PORTS=8191
CONFIG_TIPC_LOG=0
CONFIG_TIPC_DEBUG=y
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
CONFIG_ATM_CLIP_NO_ICMP=y
CONFIG_ATM_LANE=m
CONFIG_ATM_MPOA=m
CONFIG_ATM_BR2684=m
CONFIG_ATM_BR2684_IPFILTER=y
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
CONFIG_L2TP_ETH=m
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_NET_DSA=m
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_DECNET=m
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=m
CONFIG_LLC2=m
CONFIG_IPX=m
CONFIG_IPX_INTERN=y
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
CONFIG_LTPC=m
CONFIG_COPS=m
CONFIG_COPS_DAYNA=y
CONFIG_COPS_TANGENT=y
CONFIG_IPDDP=m
CONFIG_IPDDP_ENCAP=y
CONFIG_IPDDP_DECAP=y
CONFIG_X25=m
CONFIG_LAPB=m
# CONFIG_ECONET is not set
CONFIG_WAN_ROUTER=m
CONFIG_PHONET=m
CONFIG_IEEE802154=m
CONFIG_IEEE802154_6LOWPAN=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_MQPRIO=m
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_INGRESS=m
CONFIG_NET_SCH_PLUG=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
CONFIG_BATMAN_ADV=m
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=m
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NETPRIO_CGROUP=m
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_NET_TCPPROBE=m
CONFIG_NET_DROP_MONITOR=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=m
CONFIG_AX25_DAMA_SLAVE=y
CONFIG_NETROM=m
CONFIG_ROSE=m

#
# AX.25 network device drivers
#
CONFIG_MKISS=m
CONFIG_6PACK=m
CONFIG_BPQETHER=m
CONFIG_SCC=m
CONFIG_SCC_DELAY=y
CONFIG_SCC_TRXECHO=y
CONFIG_BAYCOM_SER_FDX=m
CONFIG_BAYCOM_SER_HDX=m
CONFIG_BAYCOM_PAR=m
CONFIG_BAYCOM_EPP=m
CONFIG_YAM=m
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=m

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
CONFIG_CAN_SLCAN=m
CONFIG_CAN_DEV=m
CONFIG_CAN_CALC_BITTIMING=y
CONFIG_CAN_MCP251X=m
CONFIG_CAN_JANZ_ICAN3=m
CONFIG_PCH_CAN=m
CONFIG_CAN_SJA1000=m
CONFIG_CAN_SJA1000_ISA=m
CONFIG_CAN_SJA1000_PLATFORM=m
CONFIG_CAN_EMS_PCMCIA=m
CONFIG_CAN_EMS_PCI=m
CONFIG_CAN_PEAK_PCMCIA=m
CONFIG_CAN_PEAK_PCI=m
CONFIG_CAN_PEAK_PCIEC=y
CONFIG_CAN_KVASER_PCI=m
CONFIG_CAN_PLX_PCI=m
CONFIG_CAN_TSCAN1=m
CONFIG_CAN_C_CAN=m
CONFIG_CAN_C_CAN_PLATFORM=m
CONFIG_CAN_CC770=m
CONFIG_CAN_CC770_ISA=m
CONFIG_CAN_CC770_PLATFORM=m

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=m
CONFIG_CAN_ESD_USB2=m
CONFIG_CAN_PEAK_USB=m
CONFIG_CAN_SOFTING=m
CONFIG_CAN_SOFTING_CS=m
CONFIG_CAN_DEBUG_DEVICES=y
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRNET=m
CONFIG_IRCOMM=m
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
CONFIG_IRDA_DEBUG=y

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=m

#
# Dongle support
#
CONFIG_DONGLE=y
CONFIG_ESI_DONGLE=m
CONFIG_ACTISYS_DONGLE=m
CONFIG_TEKRAM_DONGLE=m
CONFIG_TOIM3232_DONGLE=m
CONFIG_LITELINK_DONGLE=m
CONFIG_MA600_DONGLE=m
CONFIG_GIRBIL_DONGLE=m
CONFIG_MCP2120_DONGLE=m
CONFIG_OLD_BELKIN_DONGLE=m
CONFIG_ACT200L_DONGLE=m
CONFIG_KINGSUN_DONGLE=m
CONFIG_KSDAZZLE_DONGLE=m
CONFIG_KS959_DONGLE=m

#
# FIR device drivers
#
CONFIG_USB_IRDA=m
CONFIG_SIGMATEL_FIR=m
CONFIG_NSC_FIR=m
CONFIG_WINBOND_FIR=m
CONFIG_TOSHIBA_FIR=m
CONFIG_SMC_IRCC_FIR=m
CONFIG_ALI_FIR=m
CONFIG_VLSI_FIR=m
CONFIG_VIA_FIR=m
CONFIG_MCS_FIR=m
CONFIG_BT=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_CMTP=m
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_ATH3K=y
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIDTL1=m
CONFIG_BT_HCIBT3C=m
CONFIG_BT_HCIBLUECARD=m
CONFIG_BT_HCIBTUART=m
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=m
CONFIG_BT_MRVL_SDIO=m
CONFIG_BT_ATH3K=m
CONFIG_BT_WILINK=m
CONFIG_AF_RXRPC=m
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=m
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=m
CONFIG_NL80211_TESTMODE=y
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
CONFIG_CFG80211_REG_DEBUG=y
CONFIG_CFG80211_DEFAULT_PS=y
CONFIG_CFG80211_DEBUGFS=y
CONFIG_CFG80211_INTERNAL_REGDB=y
CONFIG_CFG80211_WEXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=m
CONFIG_LIB80211_CRYPT_WEP=m
CONFIG_LIB80211_CRYPT_CCMP=m
CONFIG_LIB80211_CRYPT_TKIP=m
CONFIG_LIB80211_DEBUG=y
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_PID=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
CONFIG_MAC80211_DEBUG_MENU=y
CONFIG_MAC80211_NOINLINE=y
CONFIG_MAC80211_VERBOSE_DEBUG=y
CONFIG_MAC80211_HT_DEBUG=y
CONFIG_MAC80211_TKIP_DEBUG=y
CONFIG_MAC80211_IBSS_DEBUG=y
CONFIG_MAC80211_VERBOSE_PS_DEBUG=y
CONFIG_MAC80211_VERBOSE_MPL_DEBUG=y
CONFIG_MAC80211_VERBOSE_MPATH_DEBUG=y
CONFIG_MAC80211_VERBOSE_MHWMP_DEBUG=y
CONFIG_MAC80211_VERBOSE_TDLS_DEBUG=y
CONFIG_MAC80211_DEBUG_COUNTERS=y
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_REGULATOR=m
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_NET_9P_RDMA=m
CONFIG_NET_9P_DEBUG=y
CONFIG_CAIF=m
CONFIG_CAIF_DEBUG=y
CONFIG_CAIF_NETDEV=m
CONFIG_CAIF_USB=m
CONFIG_CEPH_LIB=m
CONFIG_CEPH_LIB_PRETTYDEBUG=y
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
CONFIG_NFC=m
CONFIG_NFC_NCI=m
CONFIG_NFC_LLCP=y

#
# Near Field Communication (NFC) devices
#
CONFIG_PN544_NFC=m
CONFIG_NFC_PN533=m
CONFIG_NFC_WILINK=m

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=m
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_CONNECTOR=m
CONFIG_MTD=m
CONFIG_MTD_TESTS=m
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_CHAR=m
CONFIG_HAVE_MTD_OTP=y
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
CONFIG_MTD_BLOCK_RO=m
CONFIG_FTL=m
CONFIG_NFTL=m
CONFIG_NFTL_RW=y
CONFIG_INFTL=m
CONFIG_RFD_FTL=m
CONFIG_SSFDC=m
CONFIG_SM_FTL=m
CONFIG_MTD_OOPS=m
CONFIG_MTD_SWAP=m

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
CONFIG_MTD_CFI_ADV_OPTIONS=y
CONFIG_MTD_CFI_NOSWAP=y
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
CONFIG_MTD_CFI_GEOMETRY=y
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
CONFIG_MTD_MAP_BANK_WIDTH_8=y
CONFIG_MTD_MAP_BANK_WIDTH_16=y
CONFIG_MTD_MAP_BANK_WIDTH_32=y
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
CONFIG_MTD_CFI_I4=y
CONFIG_MTD_CFI_I8=y
CONFIG_MTD_OTP=y
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=m
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
CONFIG_MTD_SC520CDP=m
CONFIG_MTD_NETSC520=m
CONFIG_MTD_TS5500=m
CONFIG_MTD_SBC_GXX=m
CONFIG_MTD_SCx200_DOCFLASH=m
CONFIG_MTD_AMD76XROM=m
CONFIG_MTD_ICHXROM=m
CONFIG_MTD_ESB2ROM=m
CONFIG_MTD_CK804XROM=m
CONFIG_MTD_SCB2_FLASH=m
CONFIG_MTD_NETtel=m
CONFIG_MTD_L440GX=m
CONFIG_MTD_PCI=m
CONFIG_MTD_PCMCIA=m
CONFIG_MTD_PCMCIA_ANONYMOUS=y
CONFIG_MTD_GPIO_ADDR=m
CONFIG_MTD_INTEL_VR_NOR=m
CONFIG_MTD_PLATRAM=m
CONFIG_MTD_LATCH_ADDR=m

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=m
CONFIG_MTD_PMC551_BUGFIX=y
CONFIG_MTD_PMC551_DEBUG=y
CONFIG_MTD_DATAFLASH=m
CONFIG_MTD_DATAFLASH_WRITE_VERIFY=y
CONFIG_MTD_DATAFLASH_OTP=y
CONFIG_MTD_M25P80=m
CONFIG_M25PXX_USE_FAST_READ=y
CONFIG_MTD_SST25L=m
CONFIG_MTD_SLRAM=m
CONFIG_MTD_PHRAM=m
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTD_BLOCK2MTD=m

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOC2000=m
CONFIG_MTD_DOC2001=m
CONFIG_MTD_DOC2001PLUS=m
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_DOCPROBE=m
CONFIG_MTD_DOCECC=m
CONFIG_MTD_DOCPROBE_ADVANCED=y
CONFIG_MTD_DOCPROBE_ADDRESS=0x0
CONFIG_MTD_DOCPROBE_HIGH=y
CONFIG_MTD_DOCPROBE_55AA=y
CONFIG_MTD_NAND_ECC=m
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=m
CONFIG_MTD_NAND_VERIFY_WRITE=y
CONFIG_MTD_NAND_BCH=m
CONFIG_MTD_NAND_ECC_BCH=y
CONFIG_MTD_SM_COMMON=m
CONFIG_MTD_NAND_MUSEUM_IDS=y
CONFIG_MTD_NAND_DENALI=m
CONFIG_MTD_NAND_DENALI_SCRATCH_REG_ADDR=0xFF108018
CONFIG_MTD_NAND_IDS=m
CONFIG_MTD_NAND_RICOH=m
CONFIG_MTD_NAND_DISKONCHIP=m
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH=y
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
CONFIG_MTD_NAND_DOCG4=m
CONFIG_MTD_NAND_CAFE=m
CONFIG_MTD_NAND_CS553X=m
CONFIG_MTD_NAND_NANDSIM=m
CONFIG_MTD_NAND_PLATFORM=m
CONFIG_MTD_ALAUDA=m
CONFIG_MTD_ONENAND=m
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=m
CONFIG_MTD_ONENAND_OTP=y
CONFIG_MTD_ONENAND_2X_PROGRAM=y
CONFIG_MTD_ONENAND_SIM=m

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_RESERVE=1
CONFIG_MTD_UBI_GLUEBI=m
# CONFIG_MTD_UBI_DEBUG is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
CONFIG_PARPORT_PC_PCMCIA=m
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_ISAPNP=y
CONFIG_PNPBIOS=y
CONFIG_PNPBIOS_PROC_FS=y
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
CONFIG_BLK_DEV_XD=m
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
CONFIG_PARIDE_BPCK6=m
CONFIG_PARIDE_COMM=m
CONFIG_PARIDE_DSTR=m
CONFIG_PARIDE_FIT2=m
CONFIG_PARIDE_FIT3=m
CONFIG_PARIDE_EPAT=m
CONFIG_PARIDE_EPATC8=y
CONFIG_PARIDE_EPIA=m
CONFIG_PARIDE_FRIQ=m
CONFIG_PARIDE_FRPW=m
CONFIG_PARIDE_KBIC=m
CONFIG_PARIDE_KTTI=m
CONFIG_PARIDE_ON20=m
CONFIG_PARIDE_ON26=m
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=m
CONFIG_BLK_CPQ_DA=m
CONFIG_BLK_CPQ_CISS_DA=m
CONFIG_CISS_SCSI_TAPE=y
CONFIG_BLK_DEV_DAC960=m
CONFIG_BLK_DEV_UMEM=m
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_DRBD=m
CONFIG_DRBD_FAULT_INJECTION=y
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_NVME=m
CONFIG_BLK_DEV_OSD=m
CONFIG_BLK_DEV_SX8=m
CONFIG_BLK_DEV_UB=m
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
CONFIG_ATA_OVER_ETH=m
CONFIG_VIRTIO_BLK=y
CONFIG_BLK_DEV_HD=y
CONFIG_BLK_DEV_RBD=m

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
CONFIG_AD525X_DPOT=m
CONFIG_AD525X_DPOT_I2C=m
CONFIG_AD525X_DPOT_SPI=m
CONFIG_IBM_ASM=m
CONFIG_PHANTOM=m
CONFIG_INTEL_MID_PTI=m
CONFIG_SGI_IOC4=m
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
CONFIG_ICS932S401=m
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_CS5535_MFGPT=m
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
CONFIG_CS5535_CLOCK_EVENT_SRC=m
CONFIG_HP_ILO=m
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1780=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=m
CONFIG_DS1682=m
CONFIG_TI_DAC7512=m
CONFIG_VMWARE_BALLOON=m
# CONFIG_BMP085 is not set
CONFIG_PCH_PHUB=m
CONFIG_USB_SWITCH_FSA9480=m
# CONFIG_MAX8997_MUIC is not set
CONFIG_C2PORT=m
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
CONFIG_EEPROM_AT25=m
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
CONFIG_EEPROM_93XX46=m
CONFIG_CB710_CORE=m
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y
CONFIG_IWMC3200TOP=m
CONFIG_IWMC3200TOP_DEBUG=y
CONFIG_IWMC3200TOP_DEBUGFS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=m
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_IDE_LEGACY=y
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=m
CONFIG_IDE_GD_ATA=y
CONFIG_IDE_GD_ATAPI=y
CONFIG_BLK_DEV_IDECS=m
CONFIG_BLK_DEV_DELKIN=m
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=m
CONFIG_BLK_DEV_IDEACPI=y
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
CONFIG_BLK_DEV_PLATFORM=m
CONFIG_BLK_DEV_CMD640=m
CONFIG_BLK_DEV_CMD640_ENHANCED=y
CONFIG_BLK_DEV_IDEPNP=m
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
CONFIG_BLK_DEV_OFFBOARD=y
CONFIG_BLK_DEV_GENERIC=m
CONFIG_BLK_DEV_OPTI621=m
CONFIG_BLK_DEV_RZ1000=m
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=m
CONFIG_BLK_DEV_ALI15X3=m
CONFIG_BLK_DEV_AMD74XX=m
CONFIG_BLK_DEV_ATIIXP=m
CONFIG_BLK_DEV_CMD64X=m
CONFIG_BLK_DEV_TRIFLEX=m
CONFIG_BLK_DEV_CS5520=m
CONFIG_BLK_DEV_CS5530=m
CONFIG_BLK_DEV_CS5535=m
CONFIG_BLK_DEV_CS5536=m
CONFIG_BLK_DEV_HPT366=m
CONFIG_BLK_DEV_JMICRON=m
CONFIG_BLK_DEV_SC1200=m
CONFIG_BLK_DEV_PIIX=m
CONFIG_BLK_DEV_IT8172=m
CONFIG_BLK_DEV_IT8213=m
CONFIG_BLK_DEV_IT821X=m
CONFIG_BLK_DEV_NS87415=m
CONFIG_BLK_DEV_PDC202XX_OLD=m
CONFIG_BLK_DEV_PDC202XX_NEW=m
CONFIG_BLK_DEV_SVWKS=m
CONFIG_BLK_DEV_SIIMAGE=m
CONFIG_BLK_DEV_SIS5513=m
CONFIG_BLK_DEV_SLC90E66=m
CONFIG_BLK_DEV_TRM290=m
CONFIG_BLK_DEV_VIA82CXXX=m
CONFIG_BLK_DEV_TC86C001=m

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
CONFIG_BLK_DEV_4DRIVES=m
CONFIG_BLK_DEV_ALI14XX=m
CONFIG_BLK_DEV_DTC2278=m
CONFIG_BLK_DEV_HT6560B=m
CONFIG_BLK_DEV_QD65XX=m
CONFIG_BLK_DEV_UMC8672=m
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=m
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
CONFIG_ISCSI_BOOT_SYSFS=m
CONFIG_SCSI_CXGB3_ISCSI=m
CONFIG_SCSI_CXGB4_ISCSI=m
CONFIG_SCSI_BNX2_ISCSI=m
CONFIG_SCSI_BNX2X_FCOE=m
CONFIG_BE2ISCSI=m
CONFIG_BLK_DEV_3W_XXXX_RAID=m
CONFIG_SCSI_HPSA=m
CONFIG_SCSI_3W_9XXX=m
CONFIG_SCSI_3W_SAS=m
CONFIG_SCSI_7000FASST=m
CONFIG_SCSI_ACARD=m
CONFIG_SCSI_AHA152X=m
CONFIG_SCSI_AHA1542=m
CONFIG_SCSI_AHA1740=m
CONFIG_SCSI_AACRAID=m
CONFIG_SCSI_AIC7XXX=m
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC7XXX_OLD=m
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC94XX=m
CONFIG_AIC94XX_DEBUG=y
CONFIG_SCSI_MVSAS=m
CONFIG_SCSI_MVSAS_DEBUG=y
CONFIG_SCSI_MVSAS_TASKLET=y
CONFIG_SCSI_MVUMI=m
CONFIG_SCSI_DPT_I2O=m
CONFIG_SCSI_ADVANSYS=m
CONFIG_SCSI_IN2000=m
CONFIG_SCSI_ARCMSR=m
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=m
CONFIG_MEGARAID_MAILBOX=m
CONFIG_MEGARAID_LEGACY=m
CONFIG_MEGARAID_SAS=m
CONFIG_SCSI_MPT2SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS_LOGGING=y
CONFIG_SCSI_UFSHCD=m
CONFIG_SCSI_HPTIOP=m
CONFIG_SCSI_BUSLOGIC=m
CONFIG_SCSI_FLASHPOINT=y
CONFIG_VMWARE_PVSCSI=m
CONFIG_HYPERV_STORAGE=m
CONFIG_LIBFC=m
CONFIG_LIBFCOE=m
CONFIG_FCOE=m
CONFIG_FCOE_FNIC=m
CONFIG_SCSI_DMX3191D=m
CONFIG_SCSI_DTC3280=m
CONFIG_SCSI_EATA=m
CONFIG_SCSI_EATA_TAGGED_QUEUE=y
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=m
CONFIG_SCSI_GDTH=m
CONFIG_SCSI_ISCI=m
CONFIG_SCSI_GENERIC_NCR5380=m
CONFIG_SCSI_GENERIC_NCR5380_MMIO=m
CONFIG_SCSI_GENERIC_NCR53C400=y
CONFIG_SCSI_IPS=m
CONFIG_SCSI_INITIO=m
CONFIG_SCSI_INIA100=m
CONFIG_SCSI_PPA=m
CONFIG_SCSI_IMM=m
CONFIG_SCSI_IZIP_EPP16=y
CONFIG_SCSI_IZIP_SLOW_CTR=y
CONFIG_SCSI_NCR53C406A=m
CONFIG_SCSI_STEX=m
CONFIG_SCSI_SYM53C8XX_2=m
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
CONFIG_SCSI_IPR=m
CONFIG_SCSI_IPR_TRACE=y
CONFIG_SCSI_IPR_DUMP=y
CONFIG_SCSI_PAS16=m
CONFIG_SCSI_QLOGIC_FAS=m
CONFIG_SCSI_QLOGIC_1280=m
CONFIG_SCSI_QLA_FC=m
CONFIG_SCSI_QLA_ISCSI=m
# CONFIG_SCSI_LPFC is not set
CONFIG_SCSI_SIM710=m
CONFIG_SCSI_SYM53C416=m
CONFIG_SCSI_DC395x=m
CONFIG_SCSI_DC390T=m
CONFIG_SCSI_T128=m
CONFIG_SCSI_U14_34F=m
CONFIG_SCSI_U14_34F_TAGGED_QUEUE=y
CONFIG_SCSI_U14_34F_LINKED_COMMANDS=y
CONFIG_SCSI_U14_34F_MAX_TAGS=8
CONFIG_SCSI_ULTRASTOR=m
CONFIG_SCSI_NSP32=m
CONFIG_SCSI_DEBUG=m
CONFIG_SCSI_PMCRAID=m
CONFIG_SCSI_PM8001=m
CONFIG_SCSI_SRP=m
CONFIG_SCSI_BFA_FC=m
CONFIG_SCSI_VIRTIO=m
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_PCMCIA_AHA152X=m
CONFIG_PCMCIA_FDOMAIN=m
CONFIG_PCMCIA_NINJA_SCSI=m
CONFIG_PCMCIA_QLOGIC=m
CONFIG_PCMCIA_SYM53C500=m
CONFIG_SCSI_DH=m
CONFIG_SCSI_DH_RDAC=m
CONFIG_SCSI_DH_HP_SW=m
CONFIG_SCSI_DH_EMC=m
CONFIG_SCSI_DH_ALUA=m
CONFIG_SCSI_OSD_INITIATOR=m
CONFIG_SCSI_OSD_ULD=m
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
CONFIG_SATA_AHCI_PLATFORM=m
CONFIG_SATA_INIC162X=m
CONFIG_SATA_ACARD_AHCI=m
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=m
CONFIG_SATA_SX4=m
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=m
CONFIG_SATA_MV=m
CONFIG_SATA_NV=m
CONFIG_SATA_PROMISE=m
CONFIG_SATA_SIL=m
CONFIG_SATA_SIS=m
CONFIG_SATA_SVW=m
CONFIG_SATA_ULI=m
CONFIG_SATA_VIA=m
CONFIG_SATA_VITESSE=m

#
# PATA SFF controllers with BMDMA
#
CONFIG_PATA_ALI=m
CONFIG_PATA_AMD=m
CONFIG_PATA_ARASAN_CF=m
CONFIG_PATA_ARTOP=m
CONFIG_PATA_ATIIXP=m
CONFIG_PATA_ATP867X=m
CONFIG_PATA_CMD64X=m
CONFIG_PATA_CS5520=m
CONFIG_PATA_CS5530=m
CONFIG_PATA_CS5535=m
CONFIG_PATA_CS5536=m
CONFIG_PATA_CYPRESS=m
CONFIG_PATA_EFAR=m
CONFIG_PATA_HPT366=m
CONFIG_PATA_HPT37X=m
CONFIG_PATA_HPT3X2N=m
CONFIG_PATA_HPT3X3=m
CONFIG_PATA_HPT3X3_DMA=y
CONFIG_PATA_IT8213=m
CONFIG_PATA_IT821X=m
CONFIG_PATA_JMICRON=m
CONFIG_PATA_MARVELL=m
CONFIG_PATA_NETCELL=m
CONFIG_PATA_NINJA32=m
CONFIG_PATA_NS87415=m
CONFIG_PATA_OLDPIIX=m
CONFIG_PATA_OPTIDMA=m
CONFIG_PATA_PDC2027X=m
CONFIG_PATA_PDC_OLD=m
CONFIG_PATA_RADISYS=m
CONFIG_PATA_RDC=m
CONFIG_PATA_SC1200=m
CONFIG_PATA_SCH=m
CONFIG_PATA_SERVERWORKS=m
CONFIG_PATA_SIL680=m
CONFIG_PATA_SIS=m
CONFIG_PATA_TOSHIBA=m
CONFIG_PATA_TRIFLEX=m
CONFIG_PATA_VIA=m
CONFIG_PATA_WINBOND=m

#
# PIO-only SFF controllers
#
CONFIG_PATA_CMD640_PCI=m
CONFIG_PATA_ISAPNP=m
CONFIG_PATA_MPIIX=m
CONFIG_PATA_NS87410=m
CONFIG_PATA_OPTI=m
CONFIG_PATA_PCMCIA=m
CONFIG_PATA_PLATFORM=m
CONFIG_PATA_QDI=m
CONFIG_PATA_RZ1000=m
CONFIG_PATA_WINBOND_VLB=m

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_ACPI=m
CONFIG_ATA_GENERIC=m
CONFIG_PATA_LEGACY=m
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MULTICORE_RAID456=y
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=m
CONFIG_DM_PERSISTENT_DATA=m
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_THIN_PROVISIONING=m
CONFIG_DM_DEBUG_BLOCK_STACK_TRACING=y
CONFIG_DM_DEBUG_SPACE_MAPS=y
CONFIG_DM_MIRROR=m
CONFIG_DM_RAID=m
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
CONFIG_DM_DELAY=m
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_LOOPBACK_TARGET=m
CONFIG_TCM_FC=m
CONFIG_ISCSI_TARGET=m
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
CONFIG_FUSION_FC=m
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=m
CONFIG_FUSION_LAN=m
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
CONFIG_FIREWIRE_NOSY=m
CONFIG_I2O=m
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
CONFIG_I2O_CONFIG=m
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=m
CONFIG_I2O_BLOCK=m
CONFIG_I2O_SCSI=m
CONFIG_I2O_PROC=m
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=m
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
CONFIG_BONDING=m
CONFIG_DUMMY=m
CONFIG_EQUALIZER=m
CONFIG_NET_FC=y
CONFIG_MII=m
CONFIG_IEEE802154_DRIVERS=m
CONFIG_IEEE802154_FAKEHARD=m
CONFIG_IFB=m
CONFIG_NET_TEAM=m
CONFIG_NET_TEAM_MODE_ROUNDROBIN=m
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=m
CONFIG_MACVLAN=m
CONFIG_MACVTAP=m
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_RIONET=m
CONFIG_RIONET_TX_SIZE=128
CONFIG_RIONET_RX_SIZE=128
CONFIG_TUN=m
CONFIG_VETH=m
CONFIG_VIRTIO_NET=y
CONFIG_SUNGEM_PHY=m
CONFIG_ARCNET=m
CONFIG_ARCNET_1201=m
CONFIG_ARCNET_1051=m
CONFIG_ARCNET_RAW=m
CONFIG_ARCNET_CAP=m
CONFIG_ARCNET_COM90xx=m
CONFIG_ARCNET_COM90xxIO=m
CONFIG_ARCNET_RIM_I=m
CONFIG_ARCNET_COM20020=m
CONFIG_ARCNET_COM20020_ISA=m
CONFIG_ARCNET_COM20020_PCI=m
CONFIG_ARCNET_COM20020_CS=m
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=m
CONFIG_ATM_TCP=m
CONFIG_ATM_LANAI=m
CONFIG_ATM_ENI=m
CONFIG_ATM_ENI_DEBUG=y
CONFIG_ATM_ENI_TUNE_BURST=y
CONFIG_ATM_ENI_BURST_TX_16W=y
CONFIG_ATM_ENI_BURST_TX_8W=y
CONFIG_ATM_ENI_BURST_TX_4W=y
CONFIG_ATM_ENI_BURST_TX_2W=y
CONFIG_ATM_ENI_BURST_RX_16W=y
CONFIG_ATM_ENI_BURST_RX_8W=y
CONFIG_ATM_ENI_BURST_RX_4W=y
CONFIG_ATM_ENI_BURST_RX_2W=y
CONFIG_ATM_FIRESTREAM=m
CONFIG_ATM_ZATM=m
CONFIG_ATM_ZATM_DEBUG=y
CONFIG_ATM_NICSTAR=m
CONFIG_ATM_NICSTAR_USE_SUNI=y
CONFIG_ATM_NICSTAR_USE_IDT77105=y
CONFIG_ATM_IDT77252=m
CONFIG_ATM_IDT77252_DEBUG=y
CONFIG_ATM_IDT77252_RCV_ALL=y
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_AMBASSADOR=m
CONFIG_ATM_AMBASSADOR_DEBUG=y
CONFIG_ATM_HORIZON=m
CONFIG_ATM_HORIZON_DEBUG=y
CONFIG_ATM_IA=m
CONFIG_ATM_IA_DEBUG=y
CONFIG_ATM_FORE200E=m
CONFIG_ATM_FORE200E_USE_TASKLET=y
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
CONFIG_ATM_HE=m
CONFIG_ATM_HE_USE_SUNI=y
CONFIG_ATM_SOLOS=m

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=m
CONFIG_CAIF_SPI_SLAVE=m
CONFIG_CAIF_SPI_SYNC=y
CONFIG_CAIF_HSI=m

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=m
CONFIG_NET_DSA_MV88E6060=m
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=m
CONFIG_NET_DSA_MV88E6123_61_65=m
CONFIG_ETHERNET=y
CONFIG_MDIO=m
CONFIG_NET_VENDOR_3COM=y
CONFIG_EL1=m
CONFIG_EL3=m
CONFIG_3C515=m
CONFIG_PCMCIA_3C574=m
CONFIG_PCMCIA_3C589=m
CONFIG_VORTEX=m
CONFIG_TYPHOON=m
CONFIG_NET_VENDOR_ADAPTEC=y
CONFIG_ADAPTEC_STARFIRE=m
CONFIG_NET_VENDOR_ALTEON=y
CONFIG_ACENIC=m
CONFIG_ACENIC_OMIT_TIGON_I=y
CONFIG_NET_VENDOR_AMD=y
CONFIG_AMD8111_ETH=m
CONFIG_LANCE=m
CONFIG_PCNET32=m
CONFIG_DEPCA=m
CONFIG_PCMCIA_NMCLAN=m
CONFIG_NI65=m
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=m
CONFIG_ATL1=m
CONFIG_ATL1E=m
CONFIG_ATL1C=m
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BNX2=m
CONFIG_CNIC=m
CONFIG_TIGON3=m
CONFIG_BNX2X=m
CONFIG_NET_VENDOR_BROCADE=y
CONFIG_BNA=m
CONFIG_NET_CALXEDA_XGMAC=m
CONFIG_NET_VENDOR_CHELSIO=y
CONFIG_CHELSIO_T1=m
CONFIG_CHELSIO_T1_1G=y
CONFIG_CHELSIO_T3=m
CONFIG_CHELSIO_T4=m
CONFIG_CHELSIO_T4VF=m
CONFIG_NET_VENDOR_CIRRUS=y
CONFIG_CS89x0=m
CONFIG_CS89x0_PLATFORM=y
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=m
CONFIG_DNET=m
CONFIG_NET_VENDOR_DEC=y
CONFIG_EWRK3=m
CONFIG_NET_TULIP=y
CONFIG_DE2104X=m
CONFIG_DE2104X_DSL=0
CONFIG_TULIP=m
CONFIG_TULIP_MWI=y
CONFIG_TULIP_MMIO=y
CONFIG_TULIP_NAPI=y
CONFIG_TULIP_NAPI_HW_MITIGATION=y
CONFIG_DE4X5=m
CONFIG_WINBOND_840=m
CONFIG_DM9102=m
CONFIG_ULI526X=m
CONFIG_PCMCIA_XIRCOM=m
CONFIG_NET_VENDOR_DLINK=y
CONFIG_DE600=m
CONFIG_DE620=m
CONFIG_DL2K=m
CONFIG_SUNDANCE=m
CONFIG_SUNDANCE_MMIO=y
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=m
CONFIG_NET_VENDOR_EXAR=y
CONFIG_S2IO=m
CONFIG_VXGE=m
CONFIG_VXGE_DEBUG_TRACE_ALL=y
CONFIG_NET_VENDOR_FUJITSU=y
CONFIG_AT1700=m
CONFIG_PCMCIA_FMVJ18X=m
CONFIG_ETH16I=m
CONFIG_NET_VENDOR_HP=y
CONFIG_HP100=m
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=m
CONFIG_E1000=m
CONFIG_E1000E=m
CONFIG_IGB=m
CONFIG_IGB_DCA=y
CONFIG_IGBVF=m
CONFIG_IXGB=m
CONFIG_IXGBE=m
CONFIG_IXGBE_DCA=y
CONFIG_IXGBE_DCB=y
CONFIG_IXGBEVF=m
CONFIG_NET_VENDOR_I825XX=y
CONFIG_ELPLUS=m
CONFIG_EL16=m
CONFIG_APRICOT=m
CONFIG_EEXPRESS=m
CONFIG_EEXPRESS_PRO=m
CONFIG_LP486E=m
CONFIG_NI52=m
CONFIG_ZNET=m
CONFIG_IP1000=m
CONFIG_JME=m
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_SKGE=m
CONFIG_SKGE_DEBUG=y
CONFIG_SKGE_GENESIS=y
CONFIG_SKY2=m
CONFIG_SKY2_DEBUG=y
CONFIG_NET_VENDOR_MELLANOX=y
CONFIG_MLX4_EN=m
CONFIG_MLX4_CORE=m
CONFIG_MLX4_DEBUG=y
CONFIG_NET_VENDOR_MICREL=y
CONFIG_KS8842=m
CONFIG_KS8851=m
CONFIG_KS8851_MLL=m
CONFIG_KSZ884X_PCI=m
CONFIG_NET_VENDOR_MICROCHIP=y
CONFIG_ENC28J60=m
CONFIG_ENC28J60_WRITEVERIFY=y
CONFIG_NET_VENDOR_MYRI=y
CONFIG_MYRI10GE=m
CONFIG_MYRI10GE_DCA=y
CONFIG_FEALNX=m
CONFIG_NET_VENDOR_NATSEMI=y
CONFIG_NATSEMI=m
CONFIG_NS83820=m
CONFIG_NET_VENDOR_8390=y
CONFIG_EL2=m
CONFIG_AC3200=m
CONFIG_PCMCIA_AXNET=m
CONFIG_E2100=m
CONFIG_ES3210=m
CONFIG_HPLAN_PLUS=m
CONFIG_HPLAN=m
CONFIG_LNE390=m
CONFIG_NE2000=m
CONFIG_NE2K_PCI=m
CONFIG_NE3210=m
CONFIG_PCMCIA_PCNET=m
CONFIG_ULTRA=m
CONFIG_ULTRA32=m
CONFIG_WD80x3=m
CONFIG_NET_VENDOR_NVIDIA=y
CONFIG_FORCEDETH=m
CONFIG_NET_VENDOR_OKI=y
CONFIG_PCH_GBE=m
CONFIG_PCH_PTP=y
CONFIG_ETHOC=m
CONFIG_NET_PACKET_ENGINE=y
CONFIG_HAMACHI=m
CONFIG_YELLOWFIN=m
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=m
CONFIG_QLCNIC=m
CONFIG_QLGE=m
CONFIG_NETXEN_NIC=m
CONFIG_NET_VENDOR_RACAL=y
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_ATP=m
CONFIG_8139CP=m
CONFIG_8139TOO=m
CONFIG_8139TOO_PIO=y
CONFIG_8139TOO_TUNE_TWISTER=y
CONFIG_8139TOO_8129=y
CONFIG_8139_OLD_RX_RESET=y
CONFIG_R8169=m
CONFIG_NET_VENDOR_RDC=y
CONFIG_R6040=m
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_SEEQ8005=m
CONFIG_NET_VENDOR_SILAN=y
CONFIG_SC92031=m
CONFIG_NET_VENDOR_SIS=y
CONFIG_SIS900=m
CONFIG_SIS190=m
CONFIG_SFC=m
CONFIG_SFC_MTD=y
CONFIG_SFC_MCDI_MON=y
CONFIG_SFC_SRIOV=y
CONFIG_NET_VENDOR_SMSC=y
CONFIG_SMC9194=m
CONFIG_PCMCIA_SMC91C92=m
CONFIG_EPIC100=m
CONFIG_SMSC9420=m
CONFIG_NET_VENDOR_STMICRO=y
CONFIG_STMMAC_ETH=m
CONFIG_STMMAC_PLATFORM=m
CONFIG_STMMAC_PCI=m
CONFIG_STMMAC_DEBUG_FS=y
CONFIG_STMMAC_DA=y
CONFIG_STMMAC_RING=y
# CONFIG_STMMAC_CHAINED is not set
CONFIG_NET_VENDOR_SUN=y
CONFIG_HAPPYMEAL=m
CONFIG_SUNGEM=m
CONFIG_CASSINI=m
CONFIG_NIU=m
CONFIG_NET_VENDOR_TEHUTI=y
CONFIG_TEHUTI=m
CONFIG_NET_VENDOR_TI=y
CONFIG_TLAN=m
CONFIG_NET_VENDOR_VIA=y
CONFIG_VIA_RHINE=m
CONFIG_VIA_RHINE_MMIO=y
CONFIG_VIA_VELOCITY=m
CONFIG_NET_VENDOR_XIRCOM=y
CONFIG_PCMCIA_XIRC2PS=m
CONFIG_FDDI=m
CONFIG_DEFXX=m
CONFIG_DEFXX_MMIO=y
CONFIG_SKFP=m
CONFIG_HIPPI=y
CONFIG_ROADRUNNER=m
CONFIG_ROADRUNNER_LARGE_RINGS=y
CONFIG_NET_SB1000=m
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
CONFIG_AMD_PHY=m
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=m
CONFIG_ICPLUS_PHY=m
CONFIG_REALTEK_PHY=m
CONFIG_NATIONAL_PHY=m
CONFIG_STE10XP=m
CONFIG_LSI_ET1011C_PHY=m
CONFIG_MICREL_PHY=m
CONFIG_MDIO_BITBANG=m
CONFIG_MDIO_GPIO=m
CONFIG_MICREL_KS8995MA=m
CONFIG_PLIP=m
CONFIG_PPP=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=m
CONFIG_PPPOE=m
CONFIG_PPTP=m
CONFIG_PPPOL2TP=m
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_SLIP=m
CONFIG_SLHC=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLIP_SMART=y
CONFIG_SLIP_MODE_SLIP6=y
# CONFIG_TR is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_CDC_EEM=m
CONFIG_USB_NET_CDC_NCM=m
CONFIG_USB_NET_DM9601=m
CONFIG_USB_NET_SMSC75XX=m
CONFIG_USB_NET_SMSC95XX=m
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=m
CONFIG_USB_NET_CX82310_ETH=m
CONFIG_USB_NET_KALMIA=m
CONFIG_USB_NET_QMI_WWAN=m
CONFIG_USB_HSO=m
CONFIG_USB_NET_INT51X1=m
CONFIG_USB_CDC_PHONET=m
CONFIG_USB_IPHETH=m
CONFIG_USB_SIERRA_NET=m
CONFIG_USB_VL600=m
CONFIG_WLAN=y
CONFIG_PCMCIA_RAYCS=m
CONFIG_LIBERTAS_THINFIRM=m
CONFIG_LIBERTAS_THINFIRM_DEBUG=y
CONFIG_LIBERTAS_THINFIRM_USB=m
CONFIG_AIRO=m
CONFIG_ATMEL=m
CONFIG_PCI_ATMEL=m
CONFIG_PCMCIA_ATMEL=m
CONFIG_AT76C50X_USB=m
CONFIG_AIRO_CS=m
CONFIG_PCMCIA_WL3501=m
CONFIG_PRISM54=m
CONFIG_USB_ZD1201=m
CONFIG_USB_NET_RNDIS_WLAN=m
CONFIG_RTL8180=m
CONFIG_RTL8187=m
CONFIG_RTL8187_LEDS=y
CONFIG_ADM8211=m
CONFIG_MAC80211_HWSIM=m
CONFIG_MWL8K=m
CONFIG_ATH_COMMON=m
CONFIG_ATH_DEBUG=y
CONFIG_ATH5K=m
CONFIG_ATH5K_DEBUG=y
CONFIG_ATH5K_TRACER=y
CONFIG_ATH5K_PCI=y
CONFIG_ATH9K_HW=m
CONFIG_ATH9K_COMMON=m
CONFIG_ATH9K_DFS_DEBUGFS=y
CONFIG_ATH9K_BTCOEX_SUPPORT=y
CONFIG_ATH9K=m
CONFIG_ATH9K_PCI=y
CONFIG_ATH9K_AHB=y
CONFIG_ATH9K_DEBUGFS=y
CONFIG_ATH9K_DFS_CERTIFIED=y
CONFIG_ATH9K_MAC_DEBUG=y
CONFIG_ATH9K_RATE_CONTROL=y
CONFIG_ATH9K_HTC=m
CONFIG_ATH9K_HTC_DEBUGFS=y
CONFIG_CARL9170=m
CONFIG_CARL9170_LEDS=y
CONFIG_CARL9170_DEBUGFS=y
CONFIG_CARL9170_WPC=y
CONFIG_CARL9170_HWRNG=y
CONFIG_ATH6KL=m
CONFIG_ATH6KL_SDIO=m
CONFIG_ATH6KL_USB=m
CONFIG_ATH6KL_DEBUG=y
CONFIG_B43=m
CONFIG_B43_BCMA=y
CONFIG_B43_BCMA_EXTRA=y
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
CONFIG_B43_DEBUG=y
CONFIG_B43LEGACY=m
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
CONFIG_BRCMUTIL=m
CONFIG_BRCMSMAC=m
CONFIG_BRCMFMAC=m
CONFIG_BRCMFMAC_SDIO=y
CONFIG_BRCMFMAC_USB=y
CONFIG_BRCMDBG=y
CONFIG_HOSTAP=m
CONFIG_HOSTAP_FIRMWARE=y
CONFIG_HOSTAP_FIRMWARE_NVRAM=y
CONFIG_HOSTAP_PLX=m
CONFIG_HOSTAP_PCI=m
CONFIG_HOSTAP_CS=m
CONFIG_IPW2100=m
CONFIG_IPW2100_MONITOR=y
CONFIG_IPW2100_DEBUG=y
CONFIG_IPW2200=m
CONFIG_IPW2200_MONITOR=y
CONFIG_IPW2200_RADIOTAP=y
CONFIG_IPW2200_PROMISCUOUS=y
CONFIG_IPW2200_QOS=y
CONFIG_IPW2200_DEBUG=y
CONFIG_LIBIPW=m
CONFIG_LIBIPW_DEBUG=y
CONFIG_IWLWIFI=m

#
# Debugging Options
#
CONFIG_IWLWIFI_DEBUG=y
CONFIG_IWLWIFI_DEBUGFS=y
CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE=y
CONFIG_IWLWIFI_DEVICE_TRACING=y
CONFIG_IWLWIFI_DEVICE_TESTMODE=y
CONFIG_IWLWIFI_P2P=y
CONFIG_IWLWIFI_EXPERIMENTAL_MFP=y
CONFIG_IWLEGACY=m
CONFIG_IWL4965=m
CONFIG_IWL3945=m

#
# iwl3945 / iwl4965 Debugging Options
#
CONFIG_IWLEGACY_DEBUG=y
CONFIG_IWLEGACY_DEBUGFS=y
CONFIG_IWM=m
CONFIG_IWM_DEBUG=y
CONFIG_IWM_TRACING=y
CONFIG_LIBERTAS=m
CONFIG_LIBERTAS_USB=m
CONFIG_LIBERTAS_CS=m
CONFIG_LIBERTAS_SDIO=m
CONFIG_LIBERTAS_SPI=m
CONFIG_LIBERTAS_DEBUG=y
CONFIG_LIBERTAS_MESH=y
CONFIG_HERMES=m
CONFIG_HERMES_PRISM=y
CONFIG_HERMES_CACHE_FW_ON_INIT=y
CONFIG_PLX_HERMES=m
CONFIG_TMD_HERMES=m
CONFIG_NORTEL_HERMES=m
CONFIG_PCI_HERMES=m
CONFIG_PCMCIA_HERMES=m
CONFIG_PCMCIA_SPECTRUM=m
CONFIG_ORINOCO_USB=m
CONFIG_P54_COMMON=m
CONFIG_P54_USB=m
CONFIG_P54_PCI=m
CONFIG_P54_SPI=m
CONFIG_P54_SPI_DEFAULT_EEPROM=y
CONFIG_P54_LEDS=y
CONFIG_RT2X00=m
CONFIG_RT2400PCI=m
CONFIG_RT2500PCI=m
CONFIG_RT61PCI=m
CONFIG_RT2800PCI=m
CONFIG_RT2800PCI_RT33XX=y
CONFIG_RT2800PCI_RT35XX=y
CONFIG_RT2800PCI_RT53XX=y
CONFIG_RT2500USB=m
CONFIG_RT73USB=m
CONFIG_RT2800USB=m
CONFIG_RT2800USB_RT33XX=y
CONFIG_RT2800USB_RT35XX=y
CONFIG_RT2800USB_RT53XX=y
CONFIG_RT2800USB_UNKNOWN=y
CONFIG_RT2800_LIB=m
CONFIG_RT2X00_LIB_PCI=m
CONFIG_RT2X00_LIB_USB=m
CONFIG_RT2X00_LIB=m
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_RT2X00_LIB_LEDS=y
CONFIG_RT2X00_LIB_DEBUGFS=y
CONFIG_RT2X00_DEBUG=y
CONFIG_RTL8192CE=m
CONFIG_RTL8192SE=m
CONFIG_RTL8192DE=m
CONFIG_RTL8192CU=m
CONFIG_RTLWIFI=m
CONFIG_RTLWIFI_DEBUG=y
CONFIG_RTL8192C_COMMON=m
# CONFIG_WL1251 is not set
# CONFIG_WL12XX_MENU is not set
CONFIG_ZD1211RW=m
CONFIG_ZD1211RW_DEBUG=y
CONFIG_MWIFIEX=m
CONFIG_MWIFIEX_SDIO=m
CONFIG_MWIFIEX_PCIE=m

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=m
CONFIG_WIMAX_I2400M_USB=m
CONFIG_WIMAX_I2400M_SDIO=m
CONFIG_WIMAX_IWMC3200_SDIO=y
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
CONFIG_WAN=y
CONFIG_HOSTESS_SV11=m
CONFIG_COSA=m
CONFIG_LANMEDIA=m
CONFIG_SEALEVEL_4021=m
CONFIG_HDLC=m
CONFIG_HDLC_RAW=m
CONFIG_HDLC_RAW_ETH=m
CONFIG_HDLC_CISCO=m
CONFIG_HDLC_FR=m
CONFIG_HDLC_PPP=m
CONFIG_HDLC_X25=m
CONFIG_PCI200SYN=m
CONFIG_WANXL=m
CONFIG_PC300TOO=m
CONFIG_N2=m
CONFIG_C101=m
CONFIG_FARSYNC=m
CONFIG_DSCC4=m
CONFIG_DSCC4_PCISYNC=y
CONFIG_DSCC4_PCI_RST=y
CONFIG_DLCI=m
CONFIG_DLCI_MAX=8
CONFIG_SDLA=m
CONFIG_WAN_ROUTER_DRIVERS=m
CONFIG_CYCLADES_SYNC=m
CONFIG_CYCLOMX_X25=y
CONFIG_LAPBETHER=m
CONFIG_X25_ASY=m
CONFIG_SBNI=m
CONFIG_SBNI_MULTILINE=y
CONFIG_VMXNET3=m
CONFIG_HYPERV_NET=m
CONFIG_ISDN=y
CONFIG_ISDN_I4L=m
CONFIG_ISDN_PPP=y
CONFIG_ISDN_PPP_VJ=y
CONFIG_ISDN_MPP=y
CONFIG_IPPP_FILTER=y
CONFIG_ISDN_PPP_BSDCOMP=m
CONFIG_ISDN_AUDIO=y
CONFIG_ISDN_TTY_FAX=y
CONFIG_ISDN_X25=y

#
# ISDN feature submodules
#
CONFIG_ISDN_DIVERSION=m

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=m

#
# D-channel protocol features
#
CONFIG_HISAX_EURO=y
CONFIG_DE_AOC=y
CONFIG_HISAX_NO_SENDCOMPLETE=y
CONFIG_HISAX_NO_LLC=y
CONFIG_HISAX_NO_KEYPAD=y
CONFIG_HISAX_1TR6=y
CONFIG_HISAX_NI1=y
CONFIG_HISAX_MAX_CARDS=8

#
# HiSax supported cards
#
CONFIG_HISAX_16_0=y
CONFIG_HISAX_16_3=y
CONFIG_HISAX_TELESPCI=y
CONFIG_HISAX_S0BOX=y
CONFIG_HISAX_AVM_A1=y
CONFIG_HISAX_FRITZPCI=y
CONFIG_HISAX_AVM_A1_PCMCIA=y
CONFIG_HISAX_ELSA=y
CONFIG_HISAX_IX1MICROR2=y
CONFIG_HISAX_DIEHLDIVA=y
CONFIG_HISAX_ASUSCOM=y
CONFIG_HISAX_TELEINT=y
CONFIG_HISAX_HFCS=y
CONFIG_HISAX_SEDLBAUER=y
CONFIG_HISAX_SPORTSTER=y
CONFIG_HISAX_MIC=y
CONFIG_HISAX_NETJET=y
CONFIG_HISAX_NETJET_U=y
CONFIG_HISAX_NICCY=y
CONFIG_HISAX_ISURF=y
CONFIG_HISAX_HSTSAPHIR=y
CONFIG_HISAX_BKM_A4T=y
CONFIG_HISAX_SCT_QUADRO=y
CONFIG_HISAX_GAZEL=y
CONFIG_HISAX_HFC_PCI=y
CONFIG_HISAX_W6692=y
CONFIG_HISAX_HFC_SX=y
CONFIG_HISAX_ENTERNOW_PCI=y
CONFIG_HISAX_DEBUG=y

#
# HiSax PCMCIA card service modules
#
CONFIG_HISAX_SEDLBAUER_CS=m
CONFIG_HISAX_ELSA_CS=m
CONFIG_HISAX_AVM_A1_CS=m
CONFIG_HISAX_TELES_CS=m

#
# HiSax sub driver modules
#
CONFIG_HISAX_ST5481=m
CONFIG_HISAX_HFCUSB=m
CONFIG_HISAX_HFC4S8S=m
CONFIG_HISAX_FRITZ_PCIPNP=m

#
# Active cards
#
CONFIG_ISDN_DRV_ICN=m
CONFIG_ISDN_DRV_PCBIT=m
CONFIG_ISDN_DRV_SC=m
CONFIG_ISDN_DRV_ACT2000=m
CONFIG_ISDN_CAPI=m
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
CONFIG_CAPI_TRACE=y
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPI20=m
CONFIG_ISDN_CAPI_CAPIDRV=m

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
CONFIG_ISDN_DRV_AVMB1_B1ISA=m
CONFIG_ISDN_DRV_AVMB1_B1PCI=m
CONFIG_ISDN_DRV_AVMB1_B1PCIV4=y
CONFIG_ISDN_DRV_AVMB1_T1ISA=m
CONFIG_ISDN_DRV_AVMB1_B1PCMCIA=m
CONFIG_ISDN_DRV_AVMB1_AVM_CS=m
CONFIG_ISDN_DRV_AVMB1_T1PCI=m
CONFIG_ISDN_DRV_AVMB1_C4=m
# CONFIG_CAPI_EICON is not set
CONFIG_ISDN_DRV_GIGASET=m
CONFIG_GIGASET_CAPI=y
# CONFIG_GIGASET_I4L is not set
# CONFIG_GIGASET_DUMMYLL is not set
CONFIG_GIGASET_BASE=m
CONFIG_GIGASET_M105=m
CONFIG_GIGASET_M101=m
CONFIG_GIGASET_DEBUG=y
CONFIG_HYSDN=m
CONFIG_HYSDN_CAPI=y
CONFIG_MISDN=m
CONFIG_MISDN_DSP=m
CONFIG_MISDN_L1OIP=m

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=m
CONFIG_MISDN_HFCMULTI=m
CONFIG_MISDN_HFCUSB=m
CONFIG_MISDN_AVMFRITZ=m
CONFIG_MISDN_SPEEDFAX=m
CONFIG_MISDN_INFINEON=m
CONFIG_MISDN_W6692=m
CONFIG_MISDN_NETJET=m
CONFIG_MISDN_IPAC=m
CONFIG_MISDN_ISAR=m
CONFIG_ISDN_HDLC=m

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5520=m
CONFIG_KEYBOARD_ADP5588=m
CONFIG_KEYBOARD_ADP5589=m
CONFIG_KEYBOARD_ATKBD=m
CONFIG_KEYBOARD_QT1070=m
CONFIG_KEYBOARD_QT2160=m
CONFIG_KEYBOARD_LKKBD=m
CONFIG_KEYBOARD_GPIO=m
CONFIG_KEYBOARD_GPIO_POLLED=m
CONFIG_KEYBOARD_TCA6416=m
CONFIG_KEYBOARD_TCA8418=m
CONFIG_KEYBOARD_MATRIX=m
CONFIG_KEYBOARD_LM8323=m
CONFIG_KEYBOARD_MAX7359=m
CONFIG_KEYBOARD_MCS=m
CONFIG_KEYBOARD_MPR121=m
CONFIG_KEYBOARD_NEWTON=m
CONFIG_KEYBOARD_OPENCORES=m
CONFIG_KEYBOARD_STOWAWAY=m
CONFIG_KEYBOARD_SUNKBD=m
CONFIG_KEYBOARD_STMPE=m
CONFIG_KEYBOARD_OMAP4=m
CONFIG_KEYBOARD_TC3589X=m
CONFIG_KEYBOARD_TWL4030=m
CONFIG_KEYBOARD_XTKBD=m
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
CONFIG_MOUSE_PS2_TOUCHKIT=y
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=m
CONFIG_MOUSE_BCM5974=m
CONFIG_MOUSE_INPORT=m
CONFIG_MOUSE_ATIXL=y
CONFIG_MOUSE_LOGIBM=m
CONFIG_MOUSE_PC110PAD=m
CONFIG_MOUSE_VSXXXAA=m
CONFIG_MOUSE_GPIO=m
CONFIG_MOUSE_SYNAPTICS_I2C=m
CONFIG_MOUSE_SYNAPTICS_USB=m
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=m
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=m
CONFIG_JOYSTICK_GF2K=m
CONFIG_JOYSTICK_GRIP=m
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=m
CONFIG_JOYSTICK_SIDEWINDER=m
CONFIG_JOYSTICK_TMDC=m
CONFIG_JOYSTICK_IFORCE=m
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=m
CONFIG_JOYSTICK_MAGELLAN=m
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=m
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
CONFIG_JOYSTICK_ZHENHUA=m
CONFIG_JOYSTICK_DB9=m
CONFIG_JOYSTICK_GAMECON=m
CONFIG_JOYSTICK_TURBOGRAFX=m
CONFIG_JOYSTICK_AS5011=m
CONFIG_JOYSTICK_JOYDUMP=m
CONFIG_JOYSTICK_XPAD=m
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
CONFIG_JOYSTICK_WALKERA0701=m
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=m
CONFIG_TABLET_USB_HANWANG=m
CONFIG_TABLET_USB_KBTAB=m
CONFIG_TABLET_USB_WACOM=m
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=m
CONFIG_TOUCHSCREEN_ADS7846=m
CONFIG_TOUCHSCREEN_AD7877=m
CONFIG_TOUCHSCREEN_AD7879=m
CONFIG_TOUCHSCREEN_AD7879_I2C=m
CONFIG_TOUCHSCREEN_AD7879_SPI=m
CONFIG_TOUCHSCREEN_ATMEL_MXT=m
CONFIG_TOUCHSCREEN_AUO_PIXCIR=m
CONFIG_TOUCHSCREEN_BU21013=m
CONFIG_TOUCHSCREEN_CY8CTMG110=m
CONFIG_TOUCHSCREEN_CYTTSP_CORE=m
CONFIG_TOUCHSCREEN_CYTTSP_I2C=m
CONFIG_TOUCHSCREEN_CYTTSP_SPI=m
CONFIG_TOUCHSCREEN_DA9034=m
CONFIG_TOUCHSCREEN_DYNAPRO=m
CONFIG_TOUCHSCREEN_HAMPSHIRE=m
CONFIG_TOUCHSCREEN_EETI=m
CONFIG_TOUCHSCREEN_EGALAX=m
CONFIG_TOUCHSCREEN_FUJITSU=m
CONFIG_TOUCHSCREEN_ILI210X=m
CONFIG_TOUCHSCREEN_GUNZE=m
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_WACOM_W8001=m
CONFIG_TOUCHSCREEN_MAX11801=m
CONFIG_TOUCHSCREEN_MCS5000=m
CONFIG_TOUCHSCREEN_MTOUCH=m
CONFIG_TOUCHSCREEN_INEXIO=m
CONFIG_TOUCHSCREEN_INTEL_MID=m
CONFIG_TOUCHSCREEN_MK712=m
CONFIG_TOUCHSCREEN_HTCPEN=m
CONFIG_TOUCHSCREEN_PENMOUNT=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
CONFIG_TOUCHSCREEN_TOUCHWIN=m
CONFIG_TOUCHSCREEN_UCB1400=m
CONFIG_TOUCHSCREEN_PIXCIR=m
CONFIG_TOUCHSCREEN_WM831X=m
CONFIG_TOUCHSCREEN_WM97XX=m
CONFIG_TOUCHSCREEN_WM9705=y
CONFIG_TOUCHSCREEN_WM9712=y
CONFIG_TOUCHSCREEN_WM9713=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
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
CONFIG_TOUCHSCREEN_TOUCHIT213=m
CONFIG_TOUCHSCREEN_TSC_SERIO=m
CONFIG_TOUCHSCREEN_TSC2005=m
CONFIG_TOUCHSCREEN_TSC2007=m
CONFIG_TOUCHSCREEN_PCAP=m
CONFIG_TOUCHSCREEN_ST1232=m
CONFIG_TOUCHSCREEN_STMPE=m
CONFIG_TOUCHSCREEN_TPS6507X=m
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM860X_ONKEY=m
CONFIG_INPUT_AD714X=m
CONFIG_INPUT_AD714X_I2C=m
CONFIG_INPUT_AD714X_SPI=m
CONFIG_INPUT_BMA150=m
CONFIG_INPUT_PCSPKR=m
CONFIG_INPUT_MAX8925_ONKEY=m
CONFIG_INPUT_MMA8450=m
CONFIG_INPUT_MPU3050=m
CONFIG_INPUT_APANEL=m
CONFIG_INPUT_GP2A=m
CONFIG_INPUT_GPIO_TILT_POLLED=m
CONFIG_INPUT_WISTRON_BTNS=m
CONFIG_INPUT_ATLAS_BTNS=m
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
CONFIG_INPUT_KXTJ9=m
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=m
CONFIG_INPUT_TWL4030_PWRBUTTON=m
CONFIG_INPUT_TWL4030_VIBRA=m
CONFIG_INPUT_TWL6040_VIBRA=m
CONFIG_INPUT_UINPUT=m
CONFIG_INPUT_PCF50633_PMU=m
CONFIG_INPUT_PCF8574=m
CONFIG_INPUT_GPIO_ROTARY_ENCODER=m
CONFIG_INPUT_DA9052_ONKEY=m
CONFIG_INPUT_WM831X_ON=m
CONFIG_INPUT_PCAP=m
CONFIG_INPUT_ADXL34X=m
CONFIG_INPUT_ADXL34X_I2C=m
CONFIG_INPUT_ADXL34X_SPI=m
CONFIG_INPUT_CMA3000=m
CONFIG_INPUT_CMA3000_I2C=m

#
# Hardware I/O ports
#
CONFIG_SERIO=m
CONFIG_SERIO_I8042=m
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PARKBD=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=m
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
CONFIG_SERIO_PS2MULT=m
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=m
CONFIG_GAMEPORT_EMU10K1=m
CONFIG_GAMEPORT_FM801=m

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
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=m
CONFIG_CYCLADES=m
CONFIG_CYZ_INTR=y
CONFIG_MOXA_INTELLIO=m
CONFIG_MOXA_SMARTIO=m
CONFIG_SYNCLINK=m
CONFIG_SYNCLINKMP=m
CONFIG_SYNCLINK_GT=m
CONFIG_NOZOMI=m
CONFIG_ISI=m
CONFIG_N_HDLC=m
CONFIG_N_GSM=m
CONFIG_TRACE_ROUTER=m
CONFIG_TRACE_SINK=m
CONFIG_DEVKMEM=y
CONFIG_STALDRV=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=m
CONFIG_SERIAL_8250_PNP=m
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_FOURPORT=m
CONFIG_SERIAL_8250_ACCENT=m
CONFIG_SERIAL_8250_BOCA=m
CONFIG_SERIAL_8250_EXAR_ST16C554=m
CONFIG_SERIAL_8250_HUB6=m
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=m
CONFIG_SERIAL_MAX3107=m
CONFIG_SERIAL_MRST_MAX3110=m
CONFIG_SERIAL_MFD_HSU=m
CONFIG_SERIAL_UARTLITE=m
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_CONSOLE_POLL=y
CONFIG_SERIAL_JSM=m
CONFIG_SERIAL_TIMBERDALE=m
CONFIG_SERIAL_ALTERA_JTAGUART=m
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_IFX6X60=m
CONFIG_SERIAL_PCH_UART=m
CONFIG_SERIAL_XILINX_PS_UART=m
CONFIG_TTY_PRINTK=y
CONFIG_PRINTER=m
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_GEODE=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_NVRAM=m
CONFIG_DTLK=m
CONFIG_R3964=m
CONFIG_APPLICOM=m
CONFIG_SONYPI=m

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
CONFIG_IPWIRELESS=m
CONFIG_MWAVE=m
CONFIG_SCx200_GPIO=m
CONFIG_PC8736x_GPIO=m
CONFIG_NSC_GPIO=m
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
# CONFIG_RAMOOPS is not set
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=m
CONFIG_I2C_MUX_PCA9541=m
CONFIG_I2C_MUX_PCA954x=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=m
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
CONFIG_I2C_SIS5595=m
CONFIG_I2C_SIS630=m
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_DESIGNWARE_PCI=m
CONFIG_I2C_EG20T=m
CONFIG_I2C_GPIO=m
CONFIG_I2C_INTEL_MID=m
CONFIG_I2C_OCORES=m
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=m
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_TAOS_EVM=m
CONFIG_I2C_TINY_USB=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_ISA=m
CONFIG_I2C_STUB=m
CONFIG_SCx200_I2C=m
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
CONFIG_SCx200_ACB=m
CONFIG_I2C_DEBUG_CORE=y
CONFIG_I2C_DEBUG_ALGO=y
CONFIG_I2C_DEBUG_BUS=y
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=m
CONFIG_SPI_BITBANG=m
CONFIG_SPI_BUTTERFLY=m
CONFIG_SPI_GPIO=m
CONFIG_SPI_LM70_LLP=m
CONFIG_SPI_OC_TINY=m
CONFIG_SPI_PXA2XX=m
CONFIG_SPI_PXA2XX_PCI=y
CONFIG_SPI_TOPCLIFF_PCH=m
CONFIG_SPI_XILINX=m
CONFIG_SPI_DESIGNWARE=m
CONFIG_SPI_DW_PCI=m
CONFIG_SPI_DW_MID_DMA=y

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=m
CONFIG_SPI_TLE62X0=m
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=m
CONFIG_PPS_DEBUG=y

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=m
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=m
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=m
CONFIG_DP83640_PHY=m
CONFIG_PTP_1588_CLOCK_PCH=m
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=m
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=m
CONFIG_GPIO_IT8761E=m
CONFIG_GPIO_SCH=m
CONFIG_GPIO_VX855=m

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX7300=m
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCF857X=m
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_STMPE=y
CONFIG_GPIO_TC3589X=y
CONFIG_GPIO_TPS65912=m
CONFIG_GPIO_TWL4030=m
CONFIG_GPIO_WM831X=m
CONFIG_GPIO_WM8350=m
CONFIG_GPIO_WM8994=m
CONFIG_GPIO_ADP5520=m
CONFIG_GPIO_ADP5588=m

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=m
CONFIG_GPIO_LANGWELL=y
CONFIG_GPIO_PCH=m
CONFIG_GPIO_ML_IOH=m
CONFIG_GPIO_TIMBERDALE=y
CONFIG_GPIO_RDC321X=m

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=m
CONFIG_GPIO_MCP23S08=m
CONFIG_GPIO_MC33880=m
CONFIG_GPIO_74X164=m

#
# AC97 GPIO expanders:
#
CONFIG_GPIO_UCB1400=y

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=m
CONFIG_GPIO_TPS65910=y
CONFIG_W1=m
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=m
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_DS1WM=m
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2408=m
CONFIG_W1_SLAVE_DS2423=m
CONFIG_W1_SLAVE_DS2431=m
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=m
CONFIG_W1_SLAVE_DS2780=m
CONFIG_W1_SLAVE_DS2781=m
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=m
CONFIG_MAX8925_POWER=m
CONFIG_WM831X_BACKUP=m
CONFIG_WM831X_POWER=m
CONFIG_WM8350_POWER=m
CONFIG_TEST_POWER=m
CONFIG_BATTERY_DS2760=m
CONFIG_BATTERY_DS2780=m
CONFIG_BATTERY_DS2781=m
CONFIG_BATTERY_DS2782=m
CONFIG_BATTERY_SBS=m
CONFIG_BATTERY_BQ27x00=m
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9030=m
CONFIG_BATTERY_MAX17040=m
CONFIG_BATTERY_MAX17042=m
CONFIG_CHARGER_PCF50633=m
CONFIG_BATTERY_INTEL_MID=m
CONFIG_CHARGER_ISP1704=m
CONFIG_CHARGER_MAX8903=m
CONFIG_CHARGER_TWL4030=m
CONFIG_CHARGER_LP8727=m
CONFIG_CHARGER_GPIO=m
CONFIG_CHARGER_MANAGER=y
CONFIG_CHARGER_MAX8997=m
CONFIG_CHARGER_MAX8998=m
CONFIG_CHARGER_SMB347=m
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
CONFIG_SENSORS_AD7314=m
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADCXX=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_GPIO_FAN=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
CONFIG_SENSORS_LINEAGE=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM70=m
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
CONFIG_SENSORS_LTC4245=m
CONFIG_SENSORS_LTC4261=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_MAX1111=m
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MCP3021=m
CONFIG_SENSORS_NTC_THERMISTOR=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
CONFIG_SENSORS_ADM1275=m
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
CONFIG_SENSORS_MAX16064=m
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
CONFIG_SENSORS_ZL6100=m
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_SMM665=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_SCH5636=m
CONFIG_SENSORS_ADS1015=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_ADS7871=m
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_TWL4030_MADC=m
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_WM831X=m
CONFIG_SENSORS_WM8350=m
CONFIG_SENSORS_APPLESMC=m

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_SENSORS_ATK0110=m
CONFIG_THERMAL=m
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_WM831X_WATCHDOG=m
CONFIG_WM8350_WATCHDOG=m
CONFIG_TWL4030_WATCHDOG=m
CONFIG_ACQUIRE_WDT=m
CONFIG_ADVANTECH_WDT=m
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
CONFIG_F71808E_WDT=m
CONFIG_SP5100_TCO=m
CONFIG_GEODE_WDT=m
CONFIG_SC520_WDT=m
CONFIG_SBC_FITPC2_WATCHDOG=m
CONFIG_EUROTECH_WDT=m
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
CONFIG_WAFER_WDT=m
CONFIG_I6300ESB_WDT=m
CONFIG_ITCO_WDT=m
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=m
CONFIG_IT87_WDT=m
CONFIG_HP_WATCHDOG=m
CONFIG_HPWDT_NMI_DECODING=y
CONFIG_SC1200_WDT=m
CONFIG_SCx200_WDT=m
CONFIG_PC87413_WDT=m
CONFIG_NV_TCO=m
CONFIG_RDC321X_WDT=m
CONFIG_60XX_WDT=m
CONFIG_SBC8360_WDT=m
CONFIG_SBC7240_WDT=m
CONFIG_CPU5_WDT=m
CONFIG_SMSC_SCH311X_WDT=m
CONFIG_SMSC37B787_WDT=m
CONFIG_VIA_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83697HF_WDT=m
CONFIG_W83697UG_WDT=m
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
CONFIG_SBC_EPX_C3_WATCHDOG=m

#
# ISA-based Watchdog Cards
#
CONFIG_PCWATCHDOG=m
CONFIG_MIXCOMWD=m
CONFIG_WDT=m

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_BLOCKIO=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=m
CONFIG_BCMA_BLOCKIO=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_88PM860X=y
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
CONFIG_HTC_PASIC3=m
CONFIG_HTC_I2CPLD=y
CONFIG_UCB1400_CORE=m
CONFIG_TPS6105X=m
CONFIG_TPS65010=m
CONFIG_TPS6507X=m
CONFIG_MFD_TPS65217=m
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_MFD_TPS65912_SPI=y
CONFIG_TWL4030_CORE=y
CONFIG_TWL4030_MADC=m
CONFIG_MFD_TWL4030_AUDIO=y
CONFIG_TWL6030_PWM=m
CONFIG_TWL6040_CORE=y
CONFIG_MFD_STMPE=y

#
# STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
CONFIG_STMPE_SPI=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
CONFIG_MFD_S5M_CORE=y
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_MFD_PCF50633=m
CONFIG_PCF50633_ADC=m
CONFIG_PCF50633_GPIO=m
# CONFIG_MFD_MC13XXX is not set
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=m
CONFIG_EZX_PCAP=y
# CONFIG_AB8500_CORE is not set
CONFIG_MFD_CS5535=m
CONFIG_MFD_TIMBERDALE=m
CONFIG_LPC_SCH=m
CONFIG_MFD_RDC321X=m
CONFIG_MFD_JANZ_CMODIO=m
CONFIG_MFD_VX855=m
CONFIG_MFD_WL1273_CORE=m
CONFIG_MFD_TPS65090=y
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_INTEL_MSIC=y
CONFIG_MFD_RC5T583=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=m
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
CONFIG_REGULATOR_GPIO=m
CONFIG_REGULATOR_AD5398=m
CONFIG_REGULATOR_AAT2870=m
CONFIG_REGULATOR_DA903X=m
CONFIG_REGULATOR_DA9052=m
CONFIG_REGULATOR_ISL6271A=m
CONFIG_REGULATOR_88PM8607=y
CONFIG_REGULATOR_MAX1586=m
CONFIG_REGULATOR_MAX8649=m
CONFIG_REGULATOR_MAX8660=m
CONFIG_REGULATOR_MAX8925=m
CONFIG_REGULATOR_MAX8952=m
CONFIG_REGULATOR_MAX8997=m
CONFIG_REGULATOR_MAX8998=m
CONFIG_REGULATOR_PCAP=m
CONFIG_REGULATOR_LP3971=m
CONFIG_REGULATOR_LP3972=m
CONFIG_REGULATOR_PCF50633=m
CONFIG_REGULATOR_S5M8767=m
CONFIG_REGULATOR_AB3100=m
CONFIG_REGULATOR_TPS6105X=m
CONFIG_REGULATOR_TPS62360=m
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=m
CONFIG_REGULATOR_TPS65217=m
CONFIG_REGULATOR_TPS6524X=m
CONFIG_REGULATOR_TPS6586X=m
CONFIG_REGULATOR_TPS65910=m
CONFIG_REGULATOR_TPS65912=m
CONFIG_REGULATOR_TWL4030=y
CONFIG_REGULATOR_WM831X=m
CONFIG_REGULATOR_WM8350=m
CONFIG_REGULATOR_WM8994=m
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_V4L2_SUBDEV_API=y
CONFIG_DVB_CORE=m
CONFIG_DVB_NET=y
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
CONFIG_RC_CORE=m
CONFIG_LIRC=m
CONFIG_RC_MAP=m
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_SONY_DECODER=m
CONFIG_IR_RC5_SZ_DECODER=m
CONFIG_IR_SANYO_DECODER=m
CONFIG_IR_MCE_KBD_DECODER=m
CONFIG_IR_LIRC_CODEC=m
CONFIG_RC_ATI_REMOTE=m
CONFIG_IR_ENE=m
CONFIG_IR_IMON=m
CONFIG_IR_MCEUSB=m
CONFIG_IR_ITE_CIR=m
CONFIG_IR_FINTEK=m
CONFIG_IR_NUVOTON=m
CONFIG_IR_REDRAT3=m
CONFIG_IR_STREAMZAP=m
CONFIG_IR_WINBOND_CIR=m
CONFIG_RC_LOOPBACK=m
CONFIG_IR_GPIO_CIR=m
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_CUSTOMISE=y

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2063=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_MEDIA_TUNER_MAX2165=m
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_MEDIA_TUNER_TDA18212=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEOBUF_DMA_CONTIG=m
CONFIG_VIDEOBUF_DVB=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_V4L2_MEM2MEM_DEV=m
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_DMA_CONTIG=m
CONFIG_VIDEOBUF2_VMALLOC=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=m

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9840=m
CONFIG_VIDEO_TEA6415C=m
CONFIG_VIDEO_TEA6420=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=m

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=m
CONFIG_VIDEO_BT819=m
CONFIG_VIDEO_BT856=m
CONFIG_VIDEO_BT866=m
CONFIG_VIDEO_KS0127=m
CONFIG_VIDEO_SAA7110=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_TVP5150=m
CONFIG_VIDEO_VPX3220=m

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_CX25840=m

#
# MPEG video encoders
#
CONFIG_VIDEO_CX2341X=m

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m
CONFIG_VIDEO_SAA7185=m
CONFIG_VIDEO_ADV7170=m
CONFIG_VIDEO_ADV7175=m

#
# Camera sensor devices
#
CONFIG_VIDEO_OV7670=m
CONFIG_VIDEO_MT9V011=m

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m

#
# Miscelaneous helper chips
#
CONFIG_VIDEO_M52790=m
CONFIG_VIDEO_VIVI=m
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=m
CONFIG_USB_M5602=m
CONFIG_USB_STV06XX=m
CONFIG_USB_GL860=m
CONFIG_USB_GSPCA_BENQ=m
CONFIG_USB_GSPCA_CONEX=m
CONFIG_USB_GSPCA_CPIA1=m
CONFIG_USB_GSPCA_ETOMS=m
CONFIG_USB_GSPCA_FINEPIX=m
CONFIG_USB_GSPCA_JEILINJ=m
CONFIG_USB_GSPCA_JL2005BCD=m
CONFIG_USB_GSPCA_KINECT=m
CONFIG_USB_GSPCA_KONICA=m
CONFIG_USB_GSPCA_MARS=m
CONFIG_USB_GSPCA_MR97310A=m
CONFIG_USB_GSPCA_NW80X=m
CONFIG_USB_GSPCA_OV519=m
CONFIG_USB_GSPCA_OV534=m
CONFIG_USB_GSPCA_OV534_9=m
CONFIG_USB_GSPCA_PAC207=m
CONFIG_USB_GSPCA_PAC7302=m
CONFIG_USB_GSPCA_PAC7311=m
CONFIG_USB_GSPCA_SE401=m
CONFIG_USB_GSPCA_SN9C2028=m
CONFIG_USB_GSPCA_SN9C20X=m
CONFIG_USB_GSPCA_SONIXB=m
CONFIG_USB_GSPCA_SONIXJ=m
CONFIG_USB_GSPCA_SPCA500=m
CONFIG_USB_GSPCA_SPCA501=m
CONFIG_USB_GSPCA_SPCA505=m
CONFIG_USB_GSPCA_SPCA506=m
CONFIG_USB_GSPCA_SPCA508=m
CONFIG_USB_GSPCA_SPCA561=m
CONFIG_USB_GSPCA_SPCA1528=m
CONFIG_USB_GSPCA_SQ905=m
CONFIG_USB_GSPCA_SQ905C=m
CONFIG_USB_GSPCA_SQ930X=m
CONFIG_USB_GSPCA_STK014=m
CONFIG_USB_GSPCA_STV0680=m
CONFIG_USB_GSPCA_SUNPLUS=m
CONFIG_USB_GSPCA_T613=m
CONFIG_USB_GSPCA_TOPRO=m
CONFIG_USB_GSPCA_TV8532=m
CONFIG_USB_GSPCA_VC032X=m
CONFIG_USB_GSPCA_VICAM=m
CONFIG_USB_GSPCA_XIRLINK_CIT=m
CONFIG_USB_GSPCA_ZC3XX=m
CONFIG_VIDEO_PVRUSB2=m
CONFIG_VIDEO_PVRUSB2_SYSFS=y
CONFIG_VIDEO_PVRUSB2_DVB=y
CONFIG_VIDEO_PVRUSB2_DEBUGIFC=y
CONFIG_VIDEO_HDPVR=m
CONFIG_VIDEO_EM28XX=m
CONFIG_VIDEO_EM28XX_ALSA=m
CONFIG_VIDEO_EM28XX_DVB=m
CONFIG_VIDEO_EM28XX_RC=y
CONFIG_VIDEO_TLG2300=m
CONFIG_VIDEO_CX231XX=m
CONFIG_VIDEO_CX231XX_RC=y
CONFIG_VIDEO_CX231XX_ALSA=m
CONFIG_VIDEO_CX231XX_DVB=m
CONFIG_VIDEO_TM6000=m
CONFIG_VIDEO_TM6000_ALSA=m
CONFIG_VIDEO_TM6000_DVB=m
CONFIG_VIDEO_USBVISION=m
# CONFIG_USB_ET61X251 is not set
CONFIG_USB_SN9C102=m
CONFIG_USB_PWC=m
CONFIG_USB_PWC_DEBUG=y
CONFIG_USB_PWC_INPUT_EVDEV=y
CONFIG_VIDEO_CPIA2=m
CONFIG_USB_ZR364XX=m
CONFIG_USB_STKWEBCAM=m
CONFIG_USB_S2255=m
CONFIG_V4L_PCI_DRIVERS=y
CONFIG_VIDEO_AU0828=m
CONFIG_VIDEO_BT848=m
CONFIG_VIDEO_BT848_DVB=y
CONFIG_VIDEO_CX18=m
CONFIG_VIDEO_CX18_ALSA=m
CONFIG_VIDEO_CX23885=m
CONFIG_MEDIA_ALTERA_CI=m
CONFIG_VIDEO_CX25821=m
CONFIG_VIDEO_CX25821_ALSA=m
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_VP3054=m
CONFIG_VIDEO_CX88_MPEG=m
CONFIG_VIDEO_HEXIUM_GEMINI=m
CONFIG_VIDEO_HEXIUM_ORION=m
CONFIG_VIDEO_IVTV=m
CONFIG_VIDEO_FB_IVTV=m
CONFIG_VIDEO_MEYE=m
CONFIG_VIDEO_MXB=m
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_ALSA=m
CONFIG_VIDEO_SAA7134_RC=y
CONFIG_VIDEO_SAA7134_DVB=m
CONFIG_VIDEO_SAA7164=m
CONFIG_VIDEO_ZORAN=m
CONFIG_VIDEO_ZORAN_DC30=m
CONFIG_VIDEO_ZORAN_ZR36060=m
CONFIG_VIDEO_ZORAN_BUZ=m
CONFIG_VIDEO_ZORAN_DC10=m
CONFIG_VIDEO_ZORAN_LML33=m
CONFIG_VIDEO_ZORAN_LML33R10=m
CONFIG_VIDEO_ZORAN_AVS6EYES=m
CONFIG_V4L_ISA_PARPORT_DRIVERS=y
CONFIG_VIDEO_BWQCAM=m
CONFIG_VIDEO_CQCAM=m
CONFIG_VIDEO_PMS=m
CONFIG_VIDEO_W9966=m
CONFIG_V4L_PLATFORM_DRIVERS=y
CONFIG_VIDEO_CAFE_CCIC=m
CONFIG_VIDEO_VIA_CAMERA=m
CONFIG_VIDEO_TIMBERDALE=m
CONFIG_SOC_CAMERA=m
CONFIG_SOC_CAMERA_IMX074=m
CONFIG_SOC_CAMERA_MT9M001=m
CONFIG_SOC_CAMERA_MT9M111=m
CONFIG_SOC_CAMERA_MT9T031=m
CONFIG_SOC_CAMERA_MT9T112=m
CONFIG_SOC_CAMERA_MT9V022=m
CONFIG_SOC_CAMERA_RJ54N1=m
CONFIG_SOC_CAMERA_TW9910=m
CONFIG_SOC_CAMERA_PLATFORM=m
CONFIG_SOC_CAMERA_OV2640=m
CONFIG_SOC_CAMERA_OV5642=m
CONFIG_SOC_CAMERA_OV6650=m
CONFIG_SOC_CAMERA_OV772X=m
CONFIG_SOC_CAMERA_OV9640=m
CONFIG_SOC_CAMERA_OV9740=m
CONFIG_V4L_MEM2MEM_DRIVERS=y
CONFIG_VIDEO_MEM2MEM_TESTDEV=m
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_SI470X=y
CONFIG_USB_SI470X=m
CONFIG_I2C_SI470X=m
CONFIG_USB_MR800=m
CONFIG_USB_DSBR=m
CONFIG_RADIO_MAXIRADIO=m
CONFIG_I2C_SI4713=m
CONFIG_RADIO_SI4713=m
CONFIG_USB_KEENE=m
CONFIG_RADIO_TEA5764=m
CONFIG_RADIO_SAA7706H=m
CONFIG_RADIO_TEF6862=m
CONFIG_RADIO_TIMBERDALE=m
CONFIG_RADIO_WL1273=m

#
# Texas Instruments WL128x FM driver (ST based)
#
CONFIG_RADIO_WL128X=m
CONFIG_V4L_RADIO_ISA_DRIVERS=y
CONFIG_RADIO_ISA=m
CONFIG_RADIO_CADET=m
CONFIG_RADIO_RTRACK=m
CONFIG_RADIO_RTRACK2=m
CONFIG_RADIO_AZTECH=m
CONFIG_RADIO_GEMTEK=m
CONFIG_RADIO_MIROPCM20=m
CONFIG_RADIO_SF16FMI=m
CONFIG_RADIO_SF16FMR2=m
CONFIG_RADIO_TERRATEC=m
CONFIG_RADIO_TRUST=m
CONFIG_RADIO_TYPHOON=m
CONFIG_RADIO_ZOLTRIX=m
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
CONFIG_TTPCI_EEPROM=m
CONFIG_DVB_AV7110=m
CONFIG_DVB_AV7110_OSD=y
CONFIG_DVB_BUDGET_CORE=m
CONFIG_DVB_BUDGET=m
CONFIG_DVB_BUDGET_CI=m
CONFIG_DVB_BUDGET_AV=m
CONFIG_DVB_BUDGET_PATCH=m

#
# Supported USB Adapters
#
CONFIG_DVB_USB=m
CONFIG_DVB_USB_DEBUG=y
CONFIG_DVB_USB_A800=m
CONFIG_DVB_USB_DIBUSB_MB=m
CONFIG_DVB_USB_DIBUSB_MB_FAULTY=y
CONFIG_DVB_USB_DIBUSB_MC=m
CONFIG_DVB_USB_DIB0700=m
CONFIG_DVB_USB_UMT_010=m
CONFIG_DVB_USB_CXUSB=m
CONFIG_DVB_USB_M920X=m
CONFIG_DVB_USB_GL861=m
CONFIG_DVB_USB_AU6610=m
CONFIG_DVB_USB_DIGITV=m
CONFIG_DVB_USB_VP7045=m
CONFIG_DVB_USB_VP702X=m
CONFIG_DVB_USB_GP8PSK=m
CONFIG_DVB_USB_NOVA_T_USB2=m
CONFIG_DVB_USB_TTUSB2=m
CONFIG_DVB_USB_DTT200U=m
CONFIG_DVB_USB_OPERA1=m
CONFIG_DVB_USB_AF9005=m
CONFIG_DVB_USB_AF9005_REMOTE=m
CONFIG_DVB_USB_PCTV452E=m
CONFIG_DVB_USB_DW2102=m
CONFIG_DVB_USB_CINERGY_T2=m
CONFIG_DVB_USB_ANYSEE=m
CONFIG_DVB_USB_DTV5100=m
CONFIG_DVB_USB_AF9015=m
CONFIG_DVB_USB_CE6230=m
CONFIG_DVB_USB_FRIIO=m
CONFIG_DVB_USB_EC168=m
CONFIG_DVB_USB_AZ6007=m
CONFIG_DVB_USB_AZ6027=m
CONFIG_DVB_USB_LME2510=m
CONFIG_DVB_USB_TECHNISAT_USB2=m
CONFIG_DVB_USB_IT913X=m
CONFIG_DVB_USB_MXL111SF=m
CONFIG_DVB_USB_RTL28XXU=m
CONFIG_DVB_TTUSB_BUDGET=m
CONFIG_DVB_TTUSB_DEC=m
CONFIG_SMS_SIANO_MDTV=m

#
# Siano module components
#
CONFIG_SMS_USB_DRV=m
CONFIG_SMS_SDIO_DRV=m

#
# Supported FlexCopII (B2C2) Adapters
#
CONFIG_DVB_B2C2_FLEXCOP=m
CONFIG_DVB_B2C2_FLEXCOP_PCI=m
CONFIG_DVB_B2C2_FLEXCOP_USB=m
CONFIG_DVB_B2C2_FLEXCOP_DEBUG=y

#
# Supported BT878 Adapters
#
CONFIG_DVB_BT8XX=m

#
# Supported Pluto2 Adapters
#
CONFIG_DVB_PLUTO2=m

#
# Supported SDMC DM1105 Adapters
#
CONFIG_DVB_DM1105=m

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=m
CONFIG_DVB_FIREDTV_INPUT=y

#
# Supported Earthsoft PT1 Adapters
#
CONFIG_DVB_PT1=m

#
# Supported Mantis Adapters
#
CONFIG_MANTIS_CORE=m
CONFIG_DVB_MANTIS=m
CONFIG_DVB_HOPPER=m

#
# Supported nGene Adapters
#
CONFIG_DVB_NGENE=m

#
# Supported ddbridge ('Octopus') Adapters
#
CONFIG_DVB_DDBRIDGE=m

#
# Supported DVB Frontends
#
CONFIG_DVB_FE_CUSTOMISE=y

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=m
CONFIG_DVB_STB6100=m
CONFIG_DVB_STV090x=m
CONFIG_DVB_STV6110x=m

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=m
CONFIG_DVB_TDA18271C2DD=m

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
CONFIG_DVB_ZL10036=m
CONFIG_DVB_ZL10039=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_STV6110=m
CONFIG_DVB_STV0900=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA8261=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TUNER_CX24113=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_SI21XX=m
CONFIG_DVB_DS3000=m
CONFIG_DVB_MB86A16=m
CONFIG_DVB_TDA10071=m

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
CONFIG_DVB_S5H1432=m
CONFIG_DVB_DRXD=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_DIB9000=m
CONFIG_DVB_TDA10048=m
CONFIG_DVB_AF9013=m
CONFIG_DVB_EC100=m
CONFIG_DVB_HD29L2=m
CONFIG_DVB_STV0367=m
CONFIG_DVB_CXD2820R=m
CONFIG_DVB_RTL2830=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_LGDT3305=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_S5H1411=m

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=m
CONFIG_DVB_DIB8000=m
CONFIG_DVB_MB86A20S=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=m
CONFIG_DVB_LNBP22=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
CONFIG_DVB_ISL6423=m
CONFIG_DVB_A8293=m
CONFIG_DVB_LGS8GL5=m
CONFIG_DVB_LGS8GXX=m
CONFIG_DVB_ATBM8830=m
CONFIG_DVB_TDA665x=m
CONFIG_DVB_IX2505V=m
CONFIG_DVB_IT913X_FE=m
CONFIG_DVB_M88RS2000=m

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=m

#
# Graphics support
#
CONFIG_AGP=m
CONFIG_AGP_ALI=m
CONFIG_AGP_ATI=m
CONFIG_AGP_AMD=m
CONFIG_AGP_AMD64=m
CONFIG_AGP_INTEL=m
CONFIG_AGP_NVIDIA=m
CONFIG_AGP_SIS=m
CONFIG_AGP_SWORKS=m
CONFIG_AGP_VIA=m
CONFIG_AGP_EFFICEON=m
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=m
CONFIG_DRM_USB=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=m
CONFIG_DRM_TDFX=m
CONFIG_DRM_R128=m
CONFIG_DRM_RADEON=m
CONFIG_DRM_RADEON_KMS=y
CONFIG_DRM_NOUVEAU=m
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
CONFIG_DRM_NOUVEAU_DEBUG=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
CONFIG_DRM_I810=m
CONFIG_DRM_I915=m
CONFIG_DRM_I915_KMS=y
CONFIG_DRM_MGA=m
CONFIG_DRM_SIS=m
CONFIG_DRM_VIA=m
CONFIG_DRM_SAVAGE=m
CONFIG_DRM_VMWGFX=m
CONFIG_DRM_GMA500=m
CONFIG_DRM_GMA600=y
CONFIG_DRM_GMA3600=y
CONFIG_DRM_MEDFIELD=y
CONFIG_DRM_UDL=m
CONFIG_STUB_POULSBO=m
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=m
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=m
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
# CONFIG_FB_WMT_GE_ROPS is not set
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=m
CONFIG_FB_PM2=m
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=m
CONFIG_FB_CYBER2000_DDC=y
CONFIG_FB_ARC=m
CONFIG_FB_VGA16=m
CONFIG_FB_UVESA=m
CONFIG_FB_N411=m
CONFIG_FB_HGA=m
CONFIG_FB_S1D13XXX=m
CONFIG_FB_NVIDIA=m
CONFIG_FB_NVIDIA_I2C=y
CONFIG_FB_NVIDIA_DEBUG=y
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=m
CONFIG_FB_RIVA_I2C=y
CONFIG_FB_RIVA_DEBUG=y
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_I740=m
CONFIG_FB_I810=m
CONFIG_FB_I810_GTF=y
CONFIG_FB_I810_I2C=y
CONFIG_FB_LE80578=m
CONFIG_FB_CARILLO_RANCH=m
CONFIG_FB_INTEL=m
CONFIG_FB_INTEL_DEBUG=y
CONFIG_FB_INTEL_I2C=y
CONFIG_FB_MATROX=m
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=m
CONFIG_FB_MATROX_MAVEN=m
CONFIG_FB_RADEON=m
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
CONFIG_FB_RADEON_DEBUG=y
CONFIG_FB_ATY128=m
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=m
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=m
CONFIG_FB_S3_DDC=y
CONFIG_FB_SAVAGE=m
CONFIG_FB_SAVAGE_I2C=y
CONFIG_FB_SAVAGE_ACCEL=y
CONFIG_FB_SIS=m
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
CONFIG_FB_VIA=m
CONFIG_FB_VIA_DIRECT_PROCFS=y
CONFIG_FB_VIA_X_COMPATIBILITY=y
CONFIG_FB_NEOMAGIC=m
CONFIG_FB_KYRO=m
CONFIG_FB_3DFX=m
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=m
CONFIG_FB_VT8623=m
CONFIG_FB_TRIDENT=m
CONFIG_FB_ARK=m
CONFIG_FB_PM3=m
CONFIG_FB_CARMINE=m
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=m
CONFIG_FB_GEODE_GX=m
CONFIG_FB_GEODE_GX1=m
CONFIG_FB_TMIO=m
CONFIG_FB_TMIO_ACCELL=y
CONFIG_FB_SM501=m
CONFIG_FB_SMSCUFX=m
CONFIG_FB_UDL=m
CONFIG_FB_VIRTUAL=m
CONFIG_FB_METRONOME=m
CONFIG_FB_MB862XX=m
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
CONFIG_FB_BROADSHEET=m
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_L4F00242T03=m
CONFIG_LCD_LMS283GF05=m
CONFIG_LCD_LTV350QV=m
CONFIG_LCD_ILI9320=m
CONFIG_LCD_TDO24M=m
CONFIG_LCD_VGG2432A4=m
CONFIG_LCD_PLATFORM=m
CONFIG_LCD_S6E63M0=m
CONFIG_LCD_LD9040=m
CONFIG_LCD_AMS369FG06=m
CONFIG_BACKLIGHT_CLASS_DEVICE=m
CONFIG_BACKLIGHT_GENERIC=m
CONFIG_BACKLIGHT_PROGEAR=m
CONFIG_BACKLIGHT_CARILLO_RANCH=m
CONFIG_BACKLIGHT_DA903X=m
# CONFIG_BACKLIGHT_DA9052 is not set
CONFIG_BACKLIGHT_MAX8925=m
CONFIG_BACKLIGHT_APPLE=m
CONFIG_BACKLIGHT_SAHARA=m
CONFIG_BACKLIGHT_WM831X=m
CONFIG_BACKLIGHT_ADP5520=m
CONFIG_BACKLIGHT_ADP8860=m
CONFIG_BACKLIGHT_ADP8870=m
CONFIG_BACKLIGHT_88PM860X=m
CONFIG_BACKLIGHT_PCF50633=m
CONFIG_BACKLIGHT_AAT2870=m
CONFIG_BACKLIGHT_LP855X=m
CONFIG_BACKLIGHT_OT200=m
CONFIG_BACKLIGHT_PANDORA=m

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_MDA_CONSOLE=m
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=m
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
CONFIG_FONTS=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_FONT_6x11=y
CONFIG_FONT_7x14=y
CONFIG_FONT_PEARL_8x8=y
CONFIG_FONT_ACORN_8x8=y
CONFIG_FONT_MINI_4x6=y
CONFIG_FONT_SUN8x16=y
CONFIG_FONT_SUN12x22=y
CONFIG_FONT_10x18=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
CONFIG_SND_DEBUG_VERBOSE=y
CONFIG_SND_PCM_XRUN_DEBUG=y
CONFIG_SND_VMASTER=y
CONFIG_SND_KCTL_JACK=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
CONFIG_SND_OPL3_LIB_SEQ=m
CONFIG_SND_OPL4_LIB_SEQ=m
CONFIG_SND_SBAWE_SEQ=m
CONFIG_SND_EMU10K1_SEQ=m
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_OPL4_LIB=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=m
CONFIG_SND_DUMMY=m
CONFIG_SND_ALOOP=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
CONFIG_SND_MTS64=m
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
CONFIG_SND_PORTMAN2X4=m
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0
CONFIG_SND_WSS_LIB=m
CONFIG_SND_SB_COMMON=m
CONFIG_SND_SB8_DSP=m
CONFIG_SND_SB16_DSP=m
CONFIG_SND_ISA=y
CONFIG_SND_ADLIB=m
CONFIG_SND_AD1816A=m
CONFIG_SND_AD1848=m
CONFIG_SND_ALS100=m
CONFIG_SND_AZT1605=m
CONFIG_SND_AZT2316=m
CONFIG_SND_AZT2320=m
CONFIG_SND_CMI8330=m
CONFIG_SND_CS4231=m
CONFIG_SND_CS4236=m
CONFIG_SND_ES1688=m
CONFIG_SND_ES18XX=m
CONFIG_SND_SC6000=m
CONFIG_SND_GUSCLASSIC=m
CONFIG_SND_GUSEXTREME=m
CONFIG_SND_GUSMAX=m
CONFIG_SND_INTERWAVE=m
CONFIG_SND_INTERWAVE_STB=m
CONFIG_SND_JAZZ16=m
CONFIG_SND_OPL3SA2=m
CONFIG_SND_OPTI92X_AD1848=m
CONFIG_SND_OPTI92X_CS4231=m
CONFIG_SND_OPTI93X=m
CONFIG_SND_MIRO=m
CONFIG_SND_SB8=m
CONFIG_SND_SB16=m
CONFIG_SND_SBAWE=m
CONFIG_SND_SB16_CSP=y
CONFIG_SND_SSCAPE=m
CONFIG_SND_WAVEFRONT=m
CONFIG_SND_MSND_PINNACLE=m
CONFIG_SND_MSND_CLASSIC=m
CONFIG_SND_TEA575X=m
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=m
CONFIG_SND_ALS300=m
CONFIG_SND_ALS4000=m
CONFIG_SND_ALI5451=m
CONFIG_SND_ASIHPI=m
CONFIG_SND_ATIIXP=m
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
CONFIG_SND_AU8820=m
CONFIG_SND_AU8830=m
CONFIG_SND_AW2=m
CONFIG_SND_AZT3328=m
CONFIG_SND_BT87X=m
CONFIG_SND_BT87X_OVERCLOCK=y
CONFIG_SND_CA0106=m
CONFIG_SND_CMIPCI=m
CONFIG_SND_OXYGEN_LIB=m
CONFIG_SND_OXYGEN=m
CONFIG_SND_CS4281=m
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
CONFIG_SND_CS5530=m
CONFIG_SND_CS5535AUDIO=m
CONFIG_SND_CTXFI=m
CONFIG_SND_DARLA20=m
CONFIG_SND_GINA20=m
CONFIG_SND_LAYLA20=m
CONFIG_SND_DARLA24=m
CONFIG_SND_GINA24=m
CONFIG_SND_LAYLA24=m
CONFIG_SND_MONA=m
CONFIG_SND_MIA=m
CONFIG_SND_ECHO3G=m
CONFIG_SND_INDIGO=m
CONFIG_SND_INDIGOIO=m
CONFIG_SND_INDIGODJ=m
CONFIG_SND_INDIGOIOX=m
CONFIG_SND_INDIGODJX=m
CONFIG_SND_EMU10K1=m
CONFIG_SND_EMU10K1X=m
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=m
CONFIG_SND_ES1938=m
CONFIG_SND_ES1968=m
CONFIG_SND_ES1968_INPUT=y
CONFIG_SND_ES1968_RADIO=y
CONFIG_SND_FM801=m
CONFIG_SND_FM801_TEA575X_BOOL=y
CONFIG_SND_HDA_INTEL=m
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
CONFIG_SND_HDSP=m
CONFIG_SND_HDSPM=m
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
CONFIG_SND_KORG1212=m
CONFIG_SND_LOLA=m
CONFIG_SND_LX6464ES=m
CONFIG_SND_MAESTRO3=m
CONFIG_SND_MAESTRO3_INPUT=y
CONFIG_SND_MIXART=m
CONFIG_SND_NM256=m
CONFIG_SND_PCXHR=m
CONFIG_SND_RIPTIDE=m
CONFIG_SND_RME32=m
CONFIG_SND_RME96=m
CONFIG_SND_RME9652=m
CONFIG_SND_SIS7019=m
CONFIG_SND_SONICVIBES=m
CONFIG_SND_TRIDENT=m
CONFIG_SND_VIA82XX=m
CONFIG_SND_VIA82XX_MODEM=m
CONFIG_SND_VIRTUOSO=m
CONFIG_SND_VX222=m
CONFIG_SND_YMFPCI=m
CONFIG_SND_SPI=y
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_UA101=m
CONFIG_SND_USB_USX2Y=m
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_USB_US122L=m
CONFIG_SND_USB_6FIRE=m
CONFIG_SND_FIREWIRE=y
CONFIG_SND_FIREWIRE_LIB=m
CONFIG_SND_FIREWIRE_SPEAKERS=m
CONFIG_SND_ISIGHT=m
CONFIG_SND_PCMCIA=y
CONFIG_SND_VXPOCKET=m
CONFIG_SND_PDAUDIOCF=m
CONFIG_SND_SOC=m
CONFIG_SND_MFLD_MACHINE=m
CONFIG_SND_SST_PLATFORM=m
CONFIG_SND_SOC_I2C_AND_SPI=m
CONFIG_SND_SOC_ALL_CODECS=m
CONFIG_SND_SOC_88PM860X=m
CONFIG_SND_SOC_WM_HUBS=m
CONFIG_SND_SOC_AD1836=m
CONFIG_SND_SOC_AD193X=m
CONFIG_SND_SOC_AD73311=m
CONFIG_SND_SOC_ADAU1373=m
CONFIG_SND_SOC_ADAV80X=m
CONFIG_SND_SOC_ADS117X=m
CONFIG_SND_SOC_AK4104=m
CONFIG_SND_SOC_AK4535=m
CONFIG_SND_SOC_AK4641=m
CONFIG_SND_SOC_AK4642=m
CONFIG_SND_SOC_AK4671=m
CONFIG_SND_SOC_ALC5623=m
CONFIG_SND_SOC_ALC5632=m
CONFIG_SND_SOC_CS42L51=m
CONFIG_SND_SOC_CS42L73=m
CONFIG_SND_SOC_CS4270=m
CONFIG_SND_SOC_CS4271=m
CONFIG_SND_SOC_CX20442=m
CONFIG_SND_SOC_JZ4740_CODEC=m
CONFIG_SND_SOC_L3=m
CONFIG_SND_SOC_DA7210=m
CONFIG_SND_SOC_DFBMCS320=m
CONFIG_SND_SOC_MAX98088=m
CONFIG_SND_SOC_MAX98095=m
CONFIG_SND_SOC_MAX9850=m
CONFIG_SND_SOC_PCM3008=m
CONFIG_SND_SOC_RT5631=m
CONFIG_SND_SOC_SGTL5000=m
CONFIG_SND_SOC_SN95031=m
CONFIG_SND_SOC_SPDIF=m
CONFIG_SND_SOC_SSM2602=m
CONFIG_SND_SOC_STA32X=m
CONFIG_SND_SOC_TLV320AIC23=m
CONFIG_SND_SOC_TLV320AIC26=m
CONFIG_SND_SOC_TLV320AIC32X4=m
CONFIG_SND_SOC_TLV320AIC3X=m
CONFIG_SND_SOC_TLV320DAC33=m
CONFIG_SND_SOC_TWL4030=m
CONFIG_SND_SOC_TWL6040=m
CONFIG_SND_SOC_UDA134X=m
CONFIG_SND_SOC_UDA1380=m
CONFIG_SND_SOC_WL1273=m
CONFIG_SND_SOC_WM1250_EV1=m
CONFIG_SND_SOC_WM2000=m
CONFIG_SND_SOC_WM2200=m
CONFIG_SND_SOC_WM5100=m
CONFIG_SND_SOC_WM8350=m
CONFIG_SND_SOC_WM8510=m
CONFIG_SND_SOC_WM8523=m
CONFIG_SND_SOC_WM8580=m
CONFIG_SND_SOC_WM8711=m
CONFIG_SND_SOC_WM8727=m
CONFIG_SND_SOC_WM8728=m
CONFIG_SND_SOC_WM8731=m
CONFIG_SND_SOC_WM8737=m
CONFIG_SND_SOC_WM8741=m
CONFIG_SND_SOC_WM8750=m
CONFIG_SND_SOC_WM8753=m
CONFIG_SND_SOC_WM8770=m
CONFIG_SND_SOC_WM8776=m
CONFIG_SND_SOC_WM8782=m
CONFIG_SND_SOC_WM8804=m
CONFIG_SND_SOC_WM8900=m
CONFIG_SND_SOC_WM8903=m
CONFIG_SND_SOC_WM8904=m
CONFIG_SND_SOC_WM8940=m
CONFIG_SND_SOC_WM8955=m
CONFIG_SND_SOC_WM8960=m
CONFIG_SND_SOC_WM8961=m
CONFIG_SND_SOC_WM8962=m
CONFIG_SND_SOC_WM8971=m
CONFIG_SND_SOC_WM8974=m
CONFIG_SND_SOC_WM8978=m
CONFIG_SND_SOC_WM8983=m
CONFIG_SND_SOC_WM8985=m
CONFIG_SND_SOC_WM8988=m
CONFIG_SND_SOC_WM8990=m
CONFIG_SND_SOC_WM8991=m
CONFIG_SND_SOC_WM8993=m
CONFIG_SND_SOC_WM8994=m
CONFIG_SND_SOC_WM8995=m
CONFIG_SND_SOC_WM8996=m
CONFIG_SND_SOC_WM9081=m
CONFIG_SND_SOC_WM9090=m
CONFIG_SND_SOC_LM4857=m
CONFIG_SND_SOC_MAX9768=m
CONFIG_SND_SOC_MAX9877=m
CONFIG_SND_SOC_TPA6130A2=m
CONFIG_SOUND_PRIME=m
# CONFIG_SOUND_MSNDCLAS is not set
# CONFIG_SOUND_MSNDPIN is not set
CONFIG_SOUND_OSS=m
CONFIG_SOUND_TRACEINIT=y
CONFIG_SOUND_DMAP=y
CONFIG_SOUND_VMIDI=m
CONFIG_SOUND_TRIX=m
CONFIG_SOUND_MSS=m
CONFIG_SOUND_MPU401=m
CONFIG_SOUND_PAS=m
CONFIG_SOUND_PSS=m
CONFIG_PSS_MIXER=y
CONFIG_SOUND_SB=m
CONFIG_SOUND_YM3812=m
CONFIG_SOUND_UART6850=m
CONFIG_SOUND_AEDSP16=m
CONFIG_SC6600=y
CONFIG_SC6600_JOY=y
CONFIG_SC6600_CDROM=4
CONFIG_SC6600_CDROMBASE=0
CONFIG_SOUND_KAHLUA=m
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=m
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=m
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
CONFIG_USB_MOUSE=m

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
CONFIG_HID_ACRUX=m
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=m
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_PRODIKEYS=m
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=m
CONFIG_HID_ELECOM=m
CONFIG_HID_EZKEY=m
CONFIG_HID_HOLTEK=m
CONFIG_HOLTEK_FF=y
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
CONFIG_HID_LOGITECH=m
CONFIG_HID_LOGITECH_DJ=m
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=m
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
CONFIG_HID_NTRIG=m
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PRIMAX=m
CONFIG_HID_ROCCAT=m
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
CONFIG_HID_SPEEDLINK=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_GREENASIA=m
CONFIG_GREENASIA_FF=y
CONFIG_HID_HYPERV_MOUSE=m
CONFIG_HID_SMARTJOYPLUS=m
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
CONFIG_HID_THRUSTMASTER=m
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=m
# CONFIG_HID_WACOM_POWER_SUPPLY is not set
CONFIG_HID_WIIMOTE=m
CONFIG_HID_WIIMOTE_EXT=y
CONFIG_HID_ZEROPLUS=m
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=m
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=m
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=m
CONFIG_USB_DEBUG=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICEFS is not set
CONFIG_USB_DEVICE_CLASS=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
CONFIG_USB_OTG=y
CONFIG_USB_OTG_WHITELIST=y
CONFIG_USB_OTG_BLACKLIST_HUB=y
CONFIG_USB_DWC3=m
CONFIG_USB_DWC3_DEBUG=y
CONFIG_USB_DWC3_VERBOSE=y
CONFIG_USB_MON=m
CONFIG_USB_WUSB=m
CONFIG_USB_WUSB_CBAF=m
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
CONFIG_USB_XHCI_HCD=m
CONFIG_USB_XHCI_PLATFORM=m
CONFIG_USB_XHCI_HCD_DEBUGGING=y
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_OXU210HP_HCD=m
CONFIG_USB_ISP116X_HCD=m
CONFIG_USB_ISP1760_HCD=m
CONFIG_USB_ISP1362_HCD=m
CONFIG_USB_OHCI_HCD=m
CONFIG_USB_OHCI_HCD_SSB=y
CONFIG_USB_OHCI_HCD_PLATFORM=y
CONFIG_USB_EHCI_HCD_PLATFORM=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=m
CONFIG_USB_U132_HCD=m
CONFIG_USB_SL811_HCD=m
CONFIG_USB_SL811_HCD_ISO=y
CONFIG_USB_SL811_CS=m
CONFIG_USB_R8A66597_HCD=m
CONFIG_USB_RENESAS_USBHS_HCD=m
CONFIG_USB_WHCI_HCD=m
CONFIG_USB_HWA_HCD=m
CONFIG_USB_MUSB_HDRC=m
CONFIG_USB_MUSB_TUSB6010=m
CONFIG_MUSB_PIO_ONLY=y
CONFIG_USB_RENESAS_USBHS=m

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
CONFIG_USB_STORAGE_DEBUG=y
CONFIG_USB_STORAGE_REALTEK=m
CONFIG_REALTEK_AUTOPM=y
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
CONFIG_USB_STORAGE_ENE_UB6250=m
CONFIG_USB_UAS=m
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=m
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_FUNSOFT=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_F81232=m
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KEYSPAN_MPR=y
CONFIG_USB_SERIAL_KEYSPAN_USA28=y
CONFIG_USB_SERIAL_KEYSPAN_USA28X=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XA=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XB=y
CONFIG_USB_SERIAL_KEYSPAN_USA19=y
CONFIG_USB_SERIAL_KEYSPAN_USA18X=y
CONFIG_USB_SERIAL_KEYSPAN_USA19W=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QW=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QI=y
CONFIG_USB_SERIAL_KEYSPAN_USA49W=y
CONFIG_USB_SERIAL_KEYSPAN_USA49WLC=y
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_METRO=m
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7715_PARPORT=y
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_MOTOROLA=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_QCAUX=m
CONFIG_USB_SERIAL_QUALCOMM=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIEMENS_MPI=m
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_SYMBOL=m
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_OPTICON=m
CONFIG_USB_SERIAL_VIVOPAY_SERIAL=m
CONFIG_USB_SERIAL_ZIO=m
CONFIG_USB_SERIAL_SSU100=m
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=m
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=m
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=m
CONFIG_USB_TEST=m
CONFIG_USB_ISIGHTFW=m
CONFIG_USB_YUREX=m
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m
CONFIG_USB_GADGET=m
CONFIG_USB_GADGET_DEBUG=y
CONFIG_USB_GADGET_DEBUG_FILES=y
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2
CONFIG_USB_R8A66597=m
CONFIG_USB_RENESAS_USBHS_UDC=m
CONFIG_USB_MV_UDC=m
CONFIG_USB_GADGET_MUSB_HDRC=m
CONFIG_USB_M66592=m
CONFIG_USB_AMD5536UDC=m
# CONFIG_USB_CI13XXX_PCI is not set
CONFIG_USB_NET2272=m
CONFIG_USB_NET2272_DMA=y
CONFIG_USB_NET2280=m
CONFIG_USB_GOKU=m
CONFIG_USB_EG20T=m
CONFIG_USB_DUMMY_HCD=m
CONFIG_USB_GADGET_DUALSPEED=y
CONFIG_USB_GADGET_SUPERSPEED=y
CONFIG_USB_ZERO=m
CONFIG_USB_ZERO_HNPTEST=y
CONFIG_USB_AUDIO=m
CONFIG_GADGET_UAC1=y
CONFIG_USB_ETH=m
CONFIG_USB_ETH_RNDIS=y
CONFIG_USB_ETH_EEM=y
CONFIG_USB_G_NCM=m
CONFIG_USB_GADGETFS=m
CONFIG_USB_FUNCTIONFS=m
CONFIG_USB_FUNCTIONFS_ETH=y
CONFIG_USB_FUNCTIONFS_RNDIS=y
CONFIG_USB_FUNCTIONFS_GENERIC=y
CONFIG_USB_FILE_STORAGE=m
CONFIG_USB_FILE_STORAGE_TEST=y
CONFIG_USB_MASS_STORAGE=m
CONFIG_USB_G_SERIAL=m
CONFIG_USB_MIDI_GADGET=m
CONFIG_USB_G_PRINTER=m
CONFIG_USB_CDC_COMPOSITE=m
CONFIG_USB_G_NOKIA=m
CONFIG_USB_G_ACM_MS=m
CONFIG_USB_G_MULTI=m
CONFIG_USB_G_MULTI_RNDIS=y
CONFIG_USB_G_MULTI_CDC=y
CONFIG_USB_G_HID=m
CONFIG_USB_G_DBGP=m
# CONFIG_USB_G_DBGP_PRINTK is not set
CONFIG_USB_G_DBGP_SERIAL=y
CONFIG_USB_G_WEBCAM=m

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=m
CONFIG_TWL4030_USB=m
CONFIG_TWL6030_USB=m
CONFIG_NOP_USB_XCEIV=m
CONFIG_UWB=m
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=m
CONFIG_UWB_I1480U=m
CONFIG_MMC=m
CONFIG_MMC_DEBUG=y
CONFIG_MMC_UNSAFE_RESUME=y
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
CONFIG_MMC_TEST=m

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_PLTFM=m
CONFIG_MMC_WBSD=m
CONFIG_MMC_TIFM_SD=m
CONFIG_MMC_SDRICOH_CS=m
CONFIG_MMC_CB710=m
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MMC_VUB300=m
CONFIG_MMC_USHC=m
CONFIG_MEMSTICK=m
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_MEMSTICK_R592=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
CONFIG_LEDS_88PM860X=m
CONFIG_LEDS_LM3530=m
CONFIG_LEDS_NET48XX=m
CONFIG_LEDS_WRAP=m
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_PCA9532_GPIO=y
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_CLEVO_MAIL=m
CONFIG_LEDS_PCA955X=m
CONFIG_LEDS_PCA9633=m
CONFIG_LEDS_WM831X_STATUS=m
CONFIG_LEDS_WM8350=m
CONFIG_LEDS_DA903X=m
CONFIG_LEDS_DAC124S085=m
CONFIG_LEDS_REGULATOR=m
CONFIG_LEDS_BD2802=m
CONFIG_LEDS_INTEL_SS4200=m
CONFIG_LEDS_LT3593=m
CONFIG_LEDS_ADP5520=m
CONFIG_LEDS_DELL_NETBOOKS=m
CONFIG_LEDS_TCA6507=m
CONFIG_LEDS_MAX8997=m
CONFIG_LEDS_OT200=m
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_IDE_DISK=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
CONFIG_INFINIBAND_AMSO1100=m
CONFIG_INFINIBAND_AMSO1100_DEBUG=y
CONFIG_INFINIBAND_CXGB3=m
CONFIG_INFINIBAND_CXGB3_DEBUG=y
CONFIG_INFINIBAND_CXGB4=m
CONFIG_MLX4_INFINIBAND=m
CONFIG_INFINIBAND_NES=m
CONFIG_INFINIBAND_NES_DEBUG=y
CONFIG_INFINIBAND_IPOIB=m
CONFIG_INFINIBAND_IPOIB_CM=y
CONFIG_INFINIBAND_IPOIB_DEBUG=y
CONFIG_INFINIBAND_IPOIB_DEBUG_DATA=y
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_SRPT=m
CONFIG_INFINIBAND_ISER=m
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_DECODE_MCE=m
CONFIG_EDAC_MCE_INJ=m
CONFIG_EDAC_MM_EDAC=m
CONFIG_EDAC_AMD76X=m
CONFIG_EDAC_E7XXX=m
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82875P=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
CONFIG_EDAC_I7CORE=m
CONFIG_EDAC_I82860=m
CONFIG_EDAC_R82600=m
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM860X=m
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1374=m
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_DS3232=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_MAX8925=m
CONFIG_RTC_DRV_MAX8998=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=m
CONFIG_RTC_DRV_TWL4030=m
CONFIG_RTC_DRV_S35390A=m
CONFIG_RTC_DRV_FM3130=m
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=m
CONFIG_RTC_DRV_EM3027=m
CONFIG_RTC_DRV_RV3029C2=m

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=m
CONFIG_RTC_DRV_M41T94=m
CONFIG_RTC_DRV_DS1305=m
CONFIG_RTC_DRV_DS1390=m
CONFIG_RTC_DRV_MAX6902=m
CONFIG_RTC_DRV_R9701=m
CONFIG_RTC_DRV_RS5C348=m
CONFIG_RTC_DRV_DS3234=m
CONFIG_RTC_DRV_PCF2123=m

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
CONFIG_RTC_DRV_VRTC=m
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_DA9052=m
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=m
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_MSM6242=m
CONFIG_RTC_DRV_BQ4802=m
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=m
CONFIG_RTC_DRV_WM831X=m
CONFIG_RTC_DRV_WM8350=m
CONFIG_RTC_DRV_PCF50633=m
CONFIG_RTC_DRV_AB3100=m

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_PCAP=m
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=m
CONFIG_INTEL_IOATDMA=m
CONFIG_TIMB_DMA=m
CONFIG_PCH_DMA=m
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=m
CONFIG_DCA=m
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=m
CONFIG_CFAG12864B_RATE=20
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV=m
CONFIG_UIO_PDRV_GENIRQ=m
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
CONFIG_UIO_NETX=m
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MMIO=m

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=m
CONFIG_HYPERV_UTILS=m
CONFIG_STAGING=y
CONFIG_ET131X=m
CONFIG_SLICOSS=m
CONFIG_USBIP_CORE=m
CONFIG_USBIP_VHCI_HCD=m
CONFIG_USBIP_HOST=m
CONFIG_USBIP_DEBUG=y
CONFIG_W35UND=m
CONFIG_PRISM2_USB=m
CONFIG_ECHO=m
CONFIG_COMEDI=m
CONFIG_COMEDI_DEBUG=y
CONFIG_COMEDI_MISC_DRIVERS=m
CONFIG_COMEDI_KCOMEDILIB=m
CONFIG_COMEDI_BOND=m
CONFIG_COMEDI_TEST=m
CONFIG_COMEDI_PARPORT=m
CONFIG_COMEDI_SERIAL2002=m
CONFIG_COMEDI_SKEL=m
CONFIG_COMEDI_ISA_DRIVERS=m
CONFIG_COMEDI_ACL7225B=m
CONFIG_COMEDI_PCL711=m
CONFIG_COMEDI_PCL724=m
CONFIG_COMEDI_PCL725=m
CONFIG_COMEDI_PCL726=m
CONFIG_COMEDI_PCL730=m
CONFIG_COMEDI_PCL812=m
CONFIG_COMEDI_PCL816=m
CONFIG_COMEDI_PCL818=m
CONFIG_COMEDI_PCM3724=m
CONFIG_COMEDI_PCM3730=m
CONFIG_COMEDI_RTI800=m
CONFIG_COMEDI_RTI802=m
CONFIG_COMEDI_DAS16M1=m
CONFIG_COMEDI_DAS16=m
CONFIG_COMEDI_DAS800=m
CONFIG_COMEDI_DAS1800=m
CONFIG_COMEDI_DAS6402=m
CONFIG_COMEDI_DT2801=m
CONFIG_COMEDI_DT2811=m
CONFIG_COMEDI_DT2814=m
CONFIG_COMEDI_DT2815=m
CONFIG_COMEDI_DT2817=m
CONFIG_COMEDI_DT282X=m
CONFIG_COMEDI_DMM32AT=m
CONFIG_COMEDI_FL512=m
CONFIG_COMEDI_AIO_AIO12_8=m
CONFIG_COMEDI_AIO_IIRO_16=m
CONFIG_COMEDI_C6XDIGIO=m
CONFIG_COMEDI_MPC624=m
CONFIG_COMEDI_ADQ12B=m
CONFIG_COMEDI_NI_AT_A2150=m
CONFIG_COMEDI_NI_AT_AO=m
CONFIG_COMEDI_NI_ATMIO=m
CONFIG_COMEDI_NI_ATMIO16D=m
CONFIG_COMEDI_PCMAD=m
CONFIG_COMEDI_PCMDA12=m
CONFIG_COMEDI_PCMMIO=m
CONFIG_COMEDI_PCMUIO=m
CONFIG_COMEDI_MULTIQ3=m
CONFIG_COMEDI_POC=m
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
CONFIG_COMEDI_ADL_PCI7230=m
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
CONFIG_COMEDI_DYNA_PCI10XX=m
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
CONFIG_COMEDI_USBDUXSIGMA=m
CONFIG_COMEDI_VMK80XX=m
CONFIG_COMEDI_NI_COMMON=m
CONFIG_COMEDI_MITE=m
CONFIG_COMEDI_NI_TIO=m
CONFIG_COMEDI_NI_LABPC=m
CONFIG_COMEDI_8255=m
CONFIG_COMEDI_DAS08=m
CONFIG_COMEDI_FC=m
CONFIG_ASUS_OLED=m
CONFIG_PANEL=m
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
CONFIG_PANEL_CHANGE_MESSAGE=y
CONFIG_PANEL_BOOT_MESSAGE=""
CONFIG_R8187SE=m
CONFIG_RTL8192U=m
CONFIG_RTLLIB=m
CONFIG_RTLLIB_CRYPTO_CCMP=m
CONFIG_RTLLIB_CRYPTO_TKIP=m
CONFIG_RTLLIB_CRYPTO_WEP=m
CONFIG_RTL8192E=m
CONFIG_R8712U=m
CONFIG_RTS_PSTOR=m
CONFIG_RTS_PSTOR_DEBUG=y
CONFIG_RTS5139=m
CONFIG_RTS5139_DEBUG=y
CONFIG_TRANZPORT=m
CONFIG_IDE_PHISON=m
CONFIG_LINE6_USB=m
CONFIG_LINE6_USB_DEBUG=y
CONFIG_LINE6_USB_DUMP_CTRL=y
CONFIG_LINE6_USB_DUMP_MIDI=y
CONFIG_LINE6_USB_DUMP_PCM=y
CONFIG_LINE6_USB_RAW=y
CONFIG_LINE6_USB_IMPULSE_RESPONSE=y
CONFIG_USB_SERIAL_QUATECH2=m
# CONFIG_USB_SERIAL_QUATECH_USB2 is not set
CONFIG_VT6655=m
CONFIG_VT6656=m
CONFIG_VME_BUS=m

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=m
CONFIG_VME_TSI148=m

#
# VME Device Drivers
#
CONFIG_VME_USER=m
CONFIG_VME_PIO2=m

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=m
CONFIG_DX_SEP=m
CONFIG_IIO=m
CONFIG_IIO_ST_HWMON=m
CONFIG_IIO_BUFFER=y
CONFIG_IIO_SW_RING=m
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
CONFIG_ADIS16201=m
CONFIG_ADIS16203=m
CONFIG_ADIS16204=m
CONFIG_ADIS16209=m
CONFIG_ADIS16220=m
CONFIG_ADIS16240=m
CONFIG_KXSD9=m
CONFIG_LIS3L02DQ=m
CONFIG_LIS3L02DQ_BUF_KFIFO=y
# CONFIG_LIS3L02DQ_BUF_RING_SW is not set
CONFIG_SCA3000=m

#
# Analog to digital converters
#
CONFIG_AD7291=m
CONFIG_AD7298=m
CONFIG_AD7606=m
CONFIG_AD7606_IFACE_PARALLEL=m
CONFIG_AD7606_IFACE_SPI=m
CONFIG_AD799X=m
CONFIG_AD799X_RING_BUFFER=y
CONFIG_AD7476=m
CONFIG_AD7887=m
CONFIG_AD7780=m
CONFIG_AD7793=m
CONFIG_AD7816=m
CONFIG_AD7192=m
CONFIG_ADT7310=m
CONFIG_ADT7410=m
CONFIG_AD7280=m
CONFIG_MAX1363=m
CONFIG_MAX1363_RING_BUFFER=y

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=m
CONFIG_ADT7316_SPI=m
CONFIG_ADT7316_I2C=m

#
# Capacitance to digital converters
#
CONFIG_AD7150=m
CONFIG_AD7152=m
CONFIG_AD7746=m

#
# Digital to analog converters
#
CONFIG_AD5064=m
CONFIG_AD5360=m
CONFIG_AD5380=m
CONFIG_AD5421=m
CONFIG_AD5624R_SPI=m
CONFIG_AD5446=m
CONFIG_AD5504=m
CONFIG_AD5764=m
CONFIG_AD5791=m
CONFIG_AD5686=m
CONFIG_MAX517=m

#
# Direct Digital Synthesis
#
CONFIG_AD5930=m
CONFIG_AD9832=m
CONFIG_AD9834=m
CONFIG_AD9850=m
CONFIG_AD9852=m
CONFIG_AD9910=m
CONFIG_AD9951=m

#
# Digital gyroscope sensors
#
CONFIG_ADIS16060=m
CONFIG_ADIS16080=m
CONFIG_ADIS16130=m
CONFIG_ADIS16260=m
CONFIG_ADXRS450=m

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=m

#
# Inertial measurement units
#
CONFIG_ADIS16400=m

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=m
CONFIG_SENSORS_TSL2563=m
CONFIG_TSL2583=m

#
# Magnetometer sensors
#
CONFIG_SENSORS_AK8975=m
CONFIG_SENSORS_HMC5843=m

#
# Active energy metering IC
#
CONFIG_ADE7753=m
CONFIG_ADE7754=m
CONFIG_ADE7758=m
CONFIG_ADE7759=m
CONFIG_ADE7854=m
CONFIG_ADE7854_I2C=m
CONFIG_ADE7854_SPI=m

#
# Resolver to digital converters
#
CONFIG_AD2S90=m
CONFIG_AD2S1200=m
CONFIG_AD2S1210=m

#
# Triggers - standalone
#
CONFIG_IIO_PERIODIC_RTC_TRIGGER=m
CONFIG_IIO_GPIO_TRIGGER=m
CONFIG_IIO_SYSFS_TRIGGER=m
CONFIG_IIO_DUMMY_EVGEN=m
CONFIG_IIO_SIMPLE_DUMMY=m
CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
CONFIG_ZRAM=m
CONFIG_ZRAM_DEBUG=y
CONFIG_ZCACHE=y
CONFIG_ZSMALLOC=y
CONFIG_WLAGS49_H2=m
CONFIG_WLAGS49_H25=m
CONFIG_FB_SM7XX=m
CONFIG_CRYSTALHD=m
CONFIG_CXT1E1=m
CONFIG_SBE_PMCC4_NCOMM=y
CONFIG_FB_XGI=m
CONFIG_ACPI_QUICKSTART=m
CONFIG_SBE_2T3E3=m
CONFIG_USB_ENESTORAGE=m
CONFIG_BCM_WIMAX=m
CONFIG_FT1000=m
CONFIG_FT1000_USB=m
CONFIG_FT1000_PCMCIA=m

#
# Speakup console speech
#
CONFIG_SPEAKUP=m
CONFIG_SPEAKUP_SYNTH_ACNTSA=m
CONFIG_SPEAKUP_SYNTH_ACNTPC=m
CONFIG_SPEAKUP_SYNTH_APOLLO=m
CONFIG_SPEAKUP_SYNTH_AUDPTR=m
CONFIG_SPEAKUP_SYNTH_BNS=m
CONFIG_SPEAKUP_SYNTH_DECTLK=m
CONFIG_SPEAKUP_SYNTH_DECEXT=m
CONFIG_SPEAKUP_SYNTH_DECPC=m
CONFIG_SPEAKUP_SYNTH_DTLK=m
CONFIG_SPEAKUP_SYNTH_KEYPC=m
CONFIG_SPEAKUP_SYNTH_LTLK=m
CONFIG_SPEAKUP_SYNTH_SOFT=m
CONFIG_SPEAKUP_SYNTH_SPKOUT=m
CONFIG_SPEAKUP_SYNTH_TXPRT=m
CONFIG_SPEAKUP_SYNTH_DUMMY=m
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=m
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=m
CONFIG_INTEL_MEI=m
CONFIG_STAGING_MEDIA=y
CONFIG_DVB_AS102=m
CONFIG_DVB_CXD2099=m
CONFIG_VIDEO_DT3155=m
CONFIG_DT3155_CCIR=y
CONFIG_DT3155_STREAMING=y
CONFIG_EASYCAP=m
CONFIG_EASYCAP_DEBUG=y
CONFIG_VIDEO_GO7007=m
CONFIG_VIDEO_GO7007_USB=m
CONFIG_VIDEO_GO7007_USB_S2250_BOARD=m
CONFIG_VIDEO_GO7007_OV7640=m
CONFIG_VIDEO_GO7007_SAA7113=m
CONFIG_VIDEO_GO7007_SAA7115=m
CONFIG_VIDEO_GO7007_TW9903=m
CONFIG_VIDEO_GO7007_UDA1342=m
CONFIG_VIDEO_GO7007_SONY_TUNER=m
CONFIG_VIDEO_GO7007_TW2804=m
CONFIG_SOLO6X10=m
CONFIG_LIRC_STAGING=y
CONFIG_LIRC_BT829=m
CONFIG_LIRC_IGORPLUGUSB=m
CONFIG_LIRC_IMON=m
CONFIG_LIRC_PARALLEL=m
CONFIG_LIRC_SASEM=m
CONFIG_LIRC_SERIAL=m
CONFIG_LIRC_SERIAL_TRANSMITTER=y
CONFIG_LIRC_SIR=m
CONFIG_LIRC_TTUSBIR=m
CONFIG_LIRC_ZILOG=m

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
CONFIG_ASHMEM=y
CONFIG_ANDROID_LOGGER=m
# CONFIG_ANDROID_RAM_CONSOLE is not set
CONFIG_ANDROID_TIMED_OUTPUT=y
CONFIG_ANDROID_TIMED_GPIO=m
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
# CONFIG_ANDROID_SWITCH is not set
# CONFIG_ANDROID_INTF_ALARM is not set
CONFIG_PHONE=m
CONFIG_PHONE_IXJ=m
CONFIG_PHONE_IXJ_PCMCIA=m
CONFIG_USB_WPAN_HCD=m
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=m
CONFIG_ACERHDF=m
CONFIG_ASUS_LAPTOP=m
CONFIG_DELL_LAPTOP=m
CONFIG_DELL_WMI=m
CONFIG_DELL_WMI_AIO=m
CONFIG_FUJITSU_LAPTOP=m
CONFIG_FUJITSU_LAPTOP_DEBUG=y
CONFIG_FUJITSU_TABLET=m
CONFIG_AMILO_RFKILL=m
CONFIG_TC1100_WMI=m
CONFIG_HP_ACCEL=m
CONFIG_HP_WMI=m
CONFIG_MSI_LAPTOP=m
CONFIG_PANASONIC_LAPTOP=m
CONFIG_COMPAL_LAPTOP=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
CONFIG_IDEAPAD_LAPTOP=m
CONFIG_THINKPAD_ACPI=m
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
CONFIG_THINKPAD_ACPI_DEBUGFACILITIES=y
CONFIG_THINKPAD_ACPI_DEBUG=y
CONFIG_THINKPAD_ACPI_UNSAFE_LEDS=y
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_SENSORS_HDAPS=m
CONFIG_INTEL_MENLOW=m
CONFIG_EEEPC_LAPTOP=m
CONFIG_ASUS_WMI=m
CONFIG_ASUS_NB_WMI=m
CONFIG_EEEPC_WMI=m
CONFIG_ACPI_WMI=m
CONFIG_MSI_WMI=m
CONFIG_TOPSTAR_LAPTOP=m
CONFIG_ACPI_TOSHIBA=m
CONFIG_TOSHIBA_BT_RFKILL=m
CONFIG_ACPI_CMPC=m
CONFIG_INTEL_SCU_IPC=y
CONFIG_INTEL_SCU_IPC_UTIL=m
CONFIG_GPIO_INTEL_PMIC=y
CONFIG_INTEL_MID_POWER_BUTTON=m
CONFIG_INTEL_MFLD_THERMAL=m
CONFIG_INTEL_IPS=m
CONFIG_IBM_RTL=m
CONFIG_XO15_EBOOK=m
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_MXM_WMI=m
CONFIG_INTEL_OAKTRAIL=m
CONFIG_SAMSUNG_Q10=m
CONFIG_APPLE_GMUX=m

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_DW_APB_TIMER=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
CONFIG_INTEL_IOMMU_DEFAULT_ON=y
CONFIG_INTEL_IOMMU_FLOPPY_WA=y

#
# Remoteproc drivers (EXPERIMENTAL)
#

#
# Rpmsg drivers (EXPERIMENTAL)
#
CONFIG_VIRT_DRIVERS=y
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#

#
# Firmware Drivers
#
CONFIG_EDD=m
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=m
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=m
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=m
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=m
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
CONFIG_GOOGLE_SMI=m
CONFIG_GOOGLE_MEMCONSOLE=m

#
# File systems
#
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=m
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=m
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_EXT4_DEBUG=y
CONFIG_FS_XIP=y
CONFIG_JBD=m
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=m
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=m
CONFIG_REISERFS_FS=m
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_DEBUG=y
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
CONFIG_OCFS2_DEBUG_FS=y
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
CONFIG_NILFS2_FS=m
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=m
CONFIG_QFMT_V1=m
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
CONFIG_FSCACHE_DEBUG=y
CONFIG_FSCACHE_OBJECT_LIST=y
CONFIG_CACHEFILES=m
CONFIG_CACHEFILES_DEBUG=y
CONFIG_CACHEFILES_HISTOGRAM=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=m
CONFIG_ADFS_FS_RW=y
CONFIG_AFFS_FS=m
CONFIG_ECRYPT_FS=m
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=m
CONFIG_BEFS_FS=m
CONFIG_BEFS_DEBUG=y
CONFIG_BFS_FS=m
CONFIG_EFS_FS=m
CONFIG_JFFS2_FS=m
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
CONFIG_JFFS2_FS_WBUF_VERIFY=y
CONFIG_JFFS2_SUMMARY=y
CONFIG_JFFS2_FS_XATTR=y
CONFIG_JFFS2_FS_POSIX_ACL=y
CONFIG_JFFS2_FS_SECURITY=y
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
CONFIG_JFFS2_LZO=y
CONFIG_JFFS2_RTIME=y
CONFIG_JFFS2_RUBIN=y
# CONFIG_JFFS2_CMODE_NONE is not set
CONFIG_JFFS2_CMODE_PRIORITY=y
# CONFIG_JFFS2_CMODE_SIZE is not set
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
CONFIG_UBIFS_FS=m
# CONFIG_UBIFS_FS_XATTR is not set
CONFIG_UBIFS_FS_ADVANCED_COMPR=y
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_UBIFS_FS_DEBUG is not set
CONFIG_LOGFS=m
CONFIG_CRAMFS=m
CONFIG_SQUASHFS=m
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=m
CONFIG_MINIX_FS=m
CONFIG_OMFS_FS=m
CONFIG_HPFS_FS=m
CONFIG_QNX4FS_FS=m
CONFIG_QNX6FS_FS=m
CONFIG_QNX6FS_DEBUG=y
CONFIG_ROMFS_FS=m
CONFIG_ROMFS_BACKED_BY_BLOCK=y
# CONFIG_ROMFS_BACKED_BY_MTD is not set
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
CONFIG_UFS_FS_WRITE=y
CONFIG_UFS_DEBUG=y
CONFIG_EXOFS_FS=m
CONFIG_EXOFS_DEBUG=y
CONFIG_ORE=m
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_NFS_V4_1=y
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_PNFS_OBJLAYOUT=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
CONFIG_NFS_FSCACHE=y
CONFIG_NFS_USE_LEGACY_DNS=y
CONFIG_NFS_DEBUG=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_NFSD_FAULT_INJECTION=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_SUNRPC_XPRT_RDMA=m
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_SUNRPC_DEBUG=y
CONFIG_CEPH_FS=m
CONFIG_CIFS=m
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_DEBUG2=y
CONFIG_CIFS_DFS_UPCALL=y
CONFIG_CIFS_FSCACHE=y
CONFIG_CIFS_ACL=y
CONFIG_NCP_FS=m
CONFIG_NCPFS_PACKET_SIGNING=y
CONFIG_NCPFS_IOCTL_LOCKING=y
CONFIG_NCPFS_STRONG=y
CONFIG_NCPFS_NFS_NS=y
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
CONFIG_NCPFS_EXTRAS=y
CONFIG_CODA_FS=m
CONFIG_AFS_FS=m
CONFIG_AFS_DEBUG=y
CONFIG_AFS_FSCACHE=y
CONFIG_9P_FS=y
CONFIG_9P_FS_POSIX_ACL=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y
CONFIG_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=400
CONFIG_DEBUG_KMEMLEAK_TEST=m
CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_HIGHMEM=y
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
CONFIG_LKDTM=m
CONFIG_CPU_NOTIFIER_ERROR_INJECT=m
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
CONFIG_FAIL_IO_TIMEOUT=y
CONFIG_FAIL_MMC_REQUEST=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_FAULT_INJECTION_STACKTRACE_FILTER=y
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
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_STACK_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_EVENT_TRACE_TEST_SYSCALLS=y
CONFIG_MMIOTRACE=y
CONFIG_MMIOTRACE_TEST=m
CONFIG_RING_BUFFER_BENCHMARK=m
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_FIREWIRE_OHCI_REMOTE_DMA=y
CONFIG_BUILD_DOCSRC=y
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DMA_API_DEBUG=y
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_ASYNC_RAID6_TEST=m
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
CONFIG_KGDB_TESTS=y
CONFIG_KGDB_TESTS_ON_BOOT=y
CONFIG_KGDB_TESTS_BOOT_STRING="V1F100"
CONFIG_KGDB_LOW_LEVEL_TRAP=y
CONFIG_KGDB_KDB=y
CONFIG_KDB_KEYBOARD=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_KSTRTOX=m
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_INTEL_MID=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
CONFIG_DOUBLEFAULT=y
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
CONFIG_CPA_DEBUG=y
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_TRUSTED_KEYS=m
CONFIG_ENCRYPTED_KEYS=m
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_INTEL_TXT=y
CONFIG_LSM_MMAP_MIN_ADDR=65536
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX=y
CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX_VALUE=19
CONFIG_SECURITY_SMACK=y
CONFIG_SECURITY_TOMOYO=y
CONFIG_SECURITY_TOMOYO_MAX_ACCEPT_ENTRY=2048
CONFIG_SECURITY_TOMOYO_MAX_AUDIT_LOG=1024
CONFIG_SECURITY_TOMOYO_OMIT_USERSPACE_LOADER=y
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
CONFIG_SECURITY_YAMA=y
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_AUDIT=y
CONFIG_IMA_LSM_RULES=y
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_SMACK is not set
# CONFIG_DEFAULT_SECURITY_TOMOYO is not set
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
# CONFIG_DEFAULT_SECURITY_YAMA is not set
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="selinux"
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_586=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_586=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_586=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_USER_API=m
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=m
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
CONFIG_CRYPTO_DEV_GEODE=m
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
CONFIG_KVM_AMD=m
CONFIG_KVM_MMU_AUDIT=y
CONFIG_VHOST_NET=m
CONFIG_LGUEST=m
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_CRC8=m
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
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
CONFIG_XZ_DEC_TEST=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_LRU_CACHE=m
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=m
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y

--=_4fd91c3f.R4ms68f5hejM12e5zdJOlaXCA5NYIvmvSlWnmiraoFWGO1Xb
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Virtualization mailing list
Virtualization@lists.linux-foundation.org
https://lists.linuxfoundation.org/mailman/listinfo/virtualization
--=_4fd91c3f.R4ms68f5hejM12e5zdJOlaXCA5NYIvmvSlWnmiraoFWGO1Xb--
