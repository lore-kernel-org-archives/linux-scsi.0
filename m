From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V4 00/16] scsi-mq support for ZBC disks
Date: Sun, 24 Sep 2017 17:02:34 +0200
Message-ID: <20170924150234.GE14806@lst.de>
References: <20170924070247.25560-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170924070247.25560-1-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

>  Documentation/block/zoned-iosched.txt |  48 ++
>  block/Kconfig.iosched                 |  12 +
>  block/Makefile                        |   1 +
>  block/blk-mq-debugfs.h                |  14 +-
>  block/blk-mq-sched.h                  |  11 +-
>  block/zoned-iosched.c                 | 925 ++++++++++++++++++++++++++++++++++
>  drivers/scsi/scsi_lib.c               |   5 +-
>  drivers/scsi/sd_zbc.c                 | 267 +++++++---
>  include/linux/blk-mq-debugfs.h        |  23 +
>  include/linux/blk-mq-sched.h          |  14 +
>  include/linux/blkdev.h                |  24 +
>  include/scsi/scsi_proto.h             |  45 +-
>  12 files changed, 1283 insertions(+), 106 deletions(-)
>  create mode 100644 Documentation/block/zoned-iosched.txt
>  create mode 100644 block/zoned-iosched.c
>  create mode 100644 include/linux/blk-mq-debugfs.h
>  create mode 100644 include/linux/blk-mq-sched.h

This still seems to document the previous version.  Did it get
any smaller by merging the zoned schedule into mq-deadline?
