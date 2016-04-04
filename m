From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/4] libata: ZAC support
Date: Mon,  4 Apr 2016 11:47:47 +0200
Message-ID: <1459763271-125856-1-git-send-email-hare@suse.de>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Hi all,

here's a patchset implementing ZAC support for libata.

This is the second part of a larger patchset for ZAC/ZBC support;
it requires the scsi trace fixes queued for in mkp/4.7/scsi-queue and
the patchset 'libata: SATL update' I've posted earlier.
The full patchset can be found at:

git.kernel.org/hare/scsi-devel/h/zbc.v3

As usual, comments and reviews are welcome.

Hannes Reinecke (4):
  libata: implement ZBC IN translation
  libata: Implement ZBC OUT translation
  libata: support device-managed ZAC devices
  libata: support host-aware and host-managed ZAC devices

 drivers/ata/libata-core.c     |  50 ++++++++
 drivers/ata/libata-eh.c       |   2 +
 drivers/ata/libata-scsi.c     | 274 ++++++++++++++++++++++++++++++++++++++++--
 include/linux/ata.h           |  17 +++
 include/linux/libata.h        |   7 ++
 include/trace/events/libata.h |   2 +
 6 files changed, 341 insertions(+), 11 deletions(-)

-- 
1.8.5.6

