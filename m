From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 3/7] blk_end_request: changing "normal"
	drivers
Date: Wed, 05 Sep 2007 09:54:15 -0400 (EDT)
Message-ID: <20070905.095415.74754238.k-ueda@ct.jp.nec.com>
References: <20070831.184219.95065632.k-ueda@ct.jp.nec.com>
	<46DE5EB2.4050505@panasas.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46DE5EB2.4050505@panasas.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: bharrosh@panasas.com
Cc: linux-scsi@vger.kernel.org, mike.miller@hp.com, linux-kernel@vger.kernel.org, grant.likely@secretlab.ca, linux-ide@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com
List-Id: linux-scsi@vger.kernel.org

Hi Benny,

Thank you for the comments.

On Wed, 05 Sep 2007 10:45:54 +0300, Boaz Harrosh <bharrosh@panasas.com> wrote:
> On Sat, Sep 01 2007 at 1:42 +0300, Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> >  arch/arm/plat-omap/mailbox.c    |    9 ++++++---
> >  arch/um/drivers/ubd_kern.c      |   10 +---------
> >  block/elevator.c                |    4 ++--
> >  block/ll_rw_blk.c               |   15 +++++----------
> >  drivers/block/DAC960.c          |    6 ++----
> >  drivers/block/floppy.c          |    8 +++-----
> >  drivers/block/lguest_blk.c      |    5 +----
> >  drivers/block/nbd.c             |    4 +---
> >  drivers/block/ps3disk.c         |    6 +-----
> >  drivers/block/sunvdc.c          |    5 +----
> >  drivers/block/sx8.c             |    4 +---
> >  drivers/block/ub.c              |    4 ++--
> >  drivers/block/viodasd.c         |    5 +----
> >  drivers/block/xen-blkfront.c    |    5 ++---
> >  drivers/cdrom/viocd.c           |    5 +----
> >  drivers/ide/ide-cd.c            |    6 +++---
> >  drivers/ide/ide-io.c            |   22 +++++++---------------
> >  drivers/message/i2o/i2o_block.c |    8 ++------
> >  drivers/mmc/card/block.c        |   24 +++++-------------------
> >  drivers/mmc/card/queue.c        |    4 ++--
> >  drivers/s390/block/dasd.c       |    4 +---
> >  drivers/s390/char/tape_block.c  |    3 +--
> >  drivers/scsi/ide-scsi.c         |    8 ++++----
> >  drivers/scsi/scsi_lib.c         |   13 ++-----------
> >  24 files changed, 57 insertions(+), 130 deletions(-)
> 
> Please Separate this patch to at least three patches.
> 1. Block layer - block/elevator.c block/ll_rw_blk.c
> 2. SCSI-ML - drivers/scsi/scsi_lib.c
> 3. Normal drivers, can also be separated into logical
>    groups like scsi/block etc..
> 
> This is because these patches introduce conflicts
> to lots of queued work I have, and if you separate
> them it will help me with my giting. Also I think
> that this is logical. Block-layer and scsi_lib are
> not drivers, the Subject of the patch does not match.

I see.
OK, I will separate this patch for each driver so that
driver maintainers and developers can apply them easily.

Thanks,
Kiyoshi Ueda
