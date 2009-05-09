From: Tejun Heo <tj@kernel.org>
Subject: [GIT PATCH] block,scsi,libata: implement alt_size, take#2
Date: Sat,  9 May 2009 09:13:19 +0900
Message-ID: <1241828002-12742-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, Mauelshagen@RedHat.c
List-Id: linux-scsi@vger.kernel.org

Hello,

Upon ack, please pull from the following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-alt_size

This is the second take of implement-alt_size patchset.  Other than
being refreshed to apply on the current block tree, there's no real
change from the last take[L].

Jeff reluctantly acked it and Dan Williams is gonna handle mdadm part
of userland, so I guess it's about time to push this in.

This patchset is on top of the current block#for-2.6.31(f68adec3) and
can be automatically merged with block-peek-fetch branch by pulling.
diffstat follows.

 block/genhd.c              |   26 ++++++++++++++++++++++++++
 drivers/ata/libata-core.c  |    2 ++
 drivers/ata/libata-scsi.c  |    2 ++
 drivers/scsi/sd.c          |    1 +
 include/linux/genhd.h      |   13 ++++++++++++-
 include/linux/libata.h     |    1 +
 include/scsi/scsi_device.h |    1 +
 7 files changed, 45 insertions(+), 1 deletion(-)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/7235
