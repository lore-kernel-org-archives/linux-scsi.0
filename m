From: Christoph Hellwig <hch@lst.de>
Subject: RFC: drop the T10 OSD code and its users
Date: Wed, 12 Apr 2017 18:01:05 +0200
Message-ID: <20170412160109.10598-1-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: ooo@electrozaur.com, martin.petersen@oracle.com, trond.myklebust@primarydata.com, axboe@kernel.dk
Cc: osd-dev@open-osd.org, linux-nfs@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The only real user of the T10 OSD protocol, the pNFS object layout
driver never went to the point of having shipping products, and the
other two users (osdblk and exofs) were simple example of it's usage.

The code has been mostly unmaintained for years and is getting in the
way of block / SCSI changes, so I think it's finally time to drop it.

These patches are against Jens' block for-next tree as that already
has various modifications of the SCSI code.
