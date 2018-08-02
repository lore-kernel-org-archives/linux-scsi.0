From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 0/2] blk-mq: fix fix blk_mq_tagset_busy_iter
Date: Fri,  3 Aug 2018 01:49:35 +0800
Message-ID: <20180802174937.15444-1-ming.lei@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, Guenter Roeck <linux@roeck-us.net>, Mark Brown <broonie@kernel.org>, Matt Hart <matthew.hart@linaro.org>, Johannes Thumshirn <jthumshirn@suse.de>, John Garry <john.garry@huawei.com>, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Jens,

The two patches fixes boot hang issue in lots of test vm system.
And the cause is in blk_mq_tagset_busy_iter().

V2:
	- move blk_mq_request_started() into header file as suggested by
	  James

Ming Lei (2):
  blk-mq: move blk_mq_request_started() into header file
  blk-mq: fix blk_mq_tagset_busy_iter

 block/blk-mq-tag.c     |  2 +-
 block/blk-mq.c         |  6 ------
 block/blk-mq.h         |  9 ---------
 include/linux/blk-mq.h | 15 ++++++++++++++-
 4 files changed, 15 insertions(+), 17 deletions(-)

Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matt Hart <matthew.hart@linaro.org>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: John Garry <john.garry@huawei.com>
Cc: Hannes Reinecke <hare@suse.com>,
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

-- 
2.9.5
