From: Christoph Hellwig <hch@lst.de>
Subject: fix data transfer size caculation for special payload requests
Date: Fri, 13 Jan 2017 12:29:09 +0100
Message-ID: <1484306953-3194-1-git-send-email-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Dexuan Cui <decui@microsoft.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

Hi all,

the first two fixes fix a regression in 4.10-rc1 where the data transfer
size for discard commands wasn't set properly, leading to hangs with
Hyper-V VMs.  The use the new data transfer size helper added in patch 1
more widely.
