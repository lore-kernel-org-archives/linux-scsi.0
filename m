From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 0/6] blk-mq: initialize pdu of flush req explicitly
Date: Sun,  7 Sep 2014 16:39:16 +0800
Message-ID: <1410079162-9872-1-git-send-email-ming.lei@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Hi,

This patchset introduces init_flush_rq and its pair callback to
initialize pdu of flush request explicitly, instead of using
copying from request which is inefficient and buggy, and implements
them in virtio-blk and scsi-lib.

 block/blk-flush.c          |   22 +++++++++++++++++++++-
 block/blk-mq.c             |   23 ++++++++---------------
 block/blk-mq.h             |    3 ++-
 drivers/block/virtio_blk.c |   15 ++++++++++++++-
 drivers/scsi/scsi_lib.c    |   32 +++++++++++++++++++++++++++-----
 include/linux/blk-mq.h     |    9 +++++++++
 6 files changed, 81 insertions(+), 23 deletions(-)

Thanks,
--
Ming Lei
