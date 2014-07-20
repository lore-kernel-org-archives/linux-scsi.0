From: Christoph Hellwig <hch@lst.de>
Subject: support > 16 byte CDBs for blocklayer SG_IO
Date: Sun, 20 Jul 2014 12:23:22 +0200
Message-ID: <1405851804-29096-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Follow the bsg and sg drivers to support large CDBs by allocation
the larger than 16 byte CDB array if nessecary.
